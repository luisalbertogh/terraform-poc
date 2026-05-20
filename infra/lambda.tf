# ─── Lambda Function ──────────────────────────────────────────────────────────

resource "aws_lambda_function" "file_processor" {
  function_name = local.lambda_function_name
  role          = aws_iam_role.lambda_execution.arn
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
      DESTINATION_BUCKET = local.destination_bucket_name
      SOURCE_BUCKET      = local.source_bucket_name
    }
  }

  # Route failed asynchronous invocations to the Dead-Letter Queue.
  dead_letter_config {
    target_arn = aws_sqs_queue.lambda_dlq.arn
  }

  # Pre-create the log group so that Terraform controls its retention policy
  # and prevents a race condition where Lambda might auto-create it.
  depends_on = [aws_cloudwatch_log_group.lambda]

  tags = merge(local.common_tags, {
    Name = local.lambda_function_name
  })
}

# ─── Resource-based Policy: allow S3 to invoke the function ──────────────────
# Without this permission the S3 event notification cannot trigger the function.

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source.arn
}
