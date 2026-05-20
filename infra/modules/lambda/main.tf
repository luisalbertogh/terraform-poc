# ─── Lambda Deployment Package ────────────────────────────────────────────────
# Packages all files under src/ into a ZIP archive for Lambda deployment.

data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/lambda_function.zip"
}

# ─── Log Group ────────────────────────────────────────────────────────────────
# Pre-created so Terraform owns the retention policy; prevents Lambda from
# auto-creating an unmanaged log group on first invocation.

resource "aws_cloudwatch_log_group" "lambda" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_days

  tags = merge(var.common_tags, {
    Name = var.log_group_name
  })
}

# ─── Lambda Function ──────────────────────────────────────────────────────────

resource "aws_lambda_function" "file_processor" {
  function_name = var.lambda_function_name
  role          = var.iam_role_arn
  handler       = "handler.handler"
  runtime       = "python3.12"

  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  memory_size                    = var.lambda_memory_mb
  timeout                        = var.lambda_timeout_seconds
  reserved_concurrent_executions = var.lambda_reserved_concurrency

  # Inject bucket names as environment variables so the handler never has
  # hard-coded resource names.
  environment {
    variables = {
      DESTINATION_BUCKET = var.destination_bucket_name
      SOURCE_BUCKET      = var.source_bucket_name
    }
  }

  # Route failed asynchronous invocations to the Dead-Letter Queue.
  dead_letter_config {
    target_arn = var.dlq_arn
  }

  # Pre-create the log group so that Terraform controls its retention policy
  # and prevents a race condition where Lambda might auto-create it.
  depends_on = [aws_cloudwatch_log_group.lambda]

  tags = merge(var.common_tags, {
    Name = var.lambda_function_name
  })
}

# ─── Resource-based Policy: allow S3 to invoke the function ──────────────────
# Without this permission the S3 event notification cannot trigger the function.

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.source_bucket_arn
}
