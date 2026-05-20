# ─── Source Bucket ────────────────────────────────────────────────────────────

resource "aws_s3_bucket" "source" {
  bucket = local.source_bucket_name

  tags = merge(local.common_tags, {
    Name = local.source_bucket_name
    Role = "source"
  })
}

resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source" {
  bucket = aws_s3_bucket.source.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "source" {
  bucket = aws_s3_bucket.source.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Deny any request that does not use HTTPS (aws:SecureTransport = false).
data "aws_iam_policy_document" "source_bucket_https_only" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.source.arn,
      "${aws_s3_bucket.source.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "source" {
  bucket = aws_s3_bucket.source.id
  policy = data.aws_iam_policy_document.source_bucket_https_only.json

  # Public access block must be configured before the bucket policy is applied.
  depends_on = [aws_s3_bucket_public_access_block.source]
}

# ─── Destination Bucket ───────────────────────────────────────────────────────

resource "aws_s3_bucket" "destination" {
  bucket = local.destination_bucket_name

  tags = merge(local.common_tags, {
    Name = local.destination_bucket_name
    Role = "destination"
  })
}

resource "aws_s3_bucket_versioning" "destination" {
  bucket = aws_s3_bucket.destination.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "destination" {
  bucket = aws_s3_bucket.destination.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "destination" {
  bucket = aws_s3_bucket.destination.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "destination_bucket_https_only" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.destination.arn,
      "${aws_s3_bucket.destination.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "destination" {
  bucket = aws_s3_bucket.destination.id
  policy = data.aws_iam_policy_document.destination_bucket_https_only.json

  depends_on = [aws_s3_bucket_public_access_block.destination]
}

# ─── Event Notification: source bucket → Lambda ───────────────────────────────
# Fires on every s3:ObjectCreated:* event and asynchronously invokes the
# file-processor Lambda function. The Lambda resource-based permission must
# exist before this notification is created (see aws_lambda_permission.allow_s3
# in lambda.tf).

resource "aws_s3_bucket_notification" "source" {
  bucket = aws_s3_bucket.source.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.file_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
