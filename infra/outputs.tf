# Outputs are declared alphabetically.

output "destination_bucket_arn" {
  description = "ARN of the S3 destination bucket"
  value       = aws_s3_bucket.destination.arn
}

output "destination_bucket_name" {
  description = "Name of the S3 destination bucket"
  value       = aws_s3_bucket.destination.id
}

output "dlq_arn" {
  description = "ARN of the Lambda Dead-Letter Queue"
  value       = aws_sqs_queue.lambda_dlq.arn
}

output "dlq_url" {
  description = "URL of the Lambda Dead-Letter Queue"
  value       = aws_sqs_queue.lambda_dlq.url
}

output "lambda_arn" {
  description = "ARN of the file-processor Lambda function"
  value       = aws_lambda_function.file_processor.arn
}

output "lambda_function_name" {
  description = "Name of the file-processor Lambda function"
  value       = aws_lambda_function.file_processor.function_name
}

output "lambda_iam_role_arn" {
  description = "ARN of the Lambda execution IAM role"
  value       = aws_iam_role.lambda_execution.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda.name
}

output "source_bucket_arn" {
  description = "ARN of the S3 source bucket"
  value       = aws_s3_bucket.source.arn
}

output "source_bucket_name" {
  description = "Name of the S3 source bucket"
  value       = aws_s3_bucket.source.id
}
