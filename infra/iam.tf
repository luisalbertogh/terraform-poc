# ─── Trust policy: allows the Lambda service to assume this role ──────────────

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    sid    = "AllowLambdaAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# ─── Execution policy: least-privilege S3, SQS, and CloudWatch Logs ──────────

data "aws_iam_policy_document" "lambda_s3_access" {
  # Read uploaded objects from the source bucket.
  statement {
    sid       = "AllowGetObjectFromSourceBucket"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.source.arn}/*"]
  }

  # Write processed objects to the destination bucket.
  statement {
    sid       = "AllowPutObjectToDestinationBucket"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.destination.arn}/*"]
  }

  # List both buckets (bucket-level ARN — no trailing /*).
  statement {
    sid     = "AllowListBuckets"
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      aws_s3_bucket.source.arn,
      aws_s3_bucket.destination.arn,
    ]
  }

  # Send failed-invocation payloads to the Dead-Letter Queue.
  statement {
    sid       = "AllowSendMessageToDLQ"
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.lambda_dlq.arn]
  }

  # CloudWatch Logs — scoped to the specific log group and its log streams.
  statement {
    sid    = "AllowCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:${local.log_group_name}",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:${local.log_group_name}:*",
    ]
  }
}

# ─── IAM Role ─────────────────────────────────────────────────────────────────

resource "aws_iam_role" "lambda_execution" {
  name               = local.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = merge(local.common_tags, {
    Name = local.iam_role_name
  })
}

# ─── IAM Managed Policy ───────────────────────────────────────────────────────

resource "aws_iam_policy" "lambda_s3_access" {
  name        = local.iam_policy_name
  description = "Least-privilege policy for the file-processor Lambda: S3 read/write on specific buckets, SQS DLQ, and CloudWatch Logs"
  policy      = data.aws_iam_policy_document.lambda_s3_access.json

  tags = merge(local.common_tags, {
    Name = local.iam_policy_name
  })
}

# ─── Policy Attachment ────────────────────────────────────────────────────────

resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = aws_iam_policy.lambda_s3_access.arn
}
