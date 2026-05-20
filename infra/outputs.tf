# Outputs are declared alphabetically.

output "destination_bucket_arn" {
  description = "ARN of the S3 destination bucket"
  value       = module.s3.destination_bucket_arn
}

output "destination_bucket_name" {
  description = "Name of the S3 destination bucket"
  value       = module.s3.destination_bucket_id
}

output "dlq_arn" {
  description = "ARN of the Lambda Dead-Letter Queue"
  value       = module.sqs.dlq_arn
}

output "dlq_url" {
  description = "URL of the Lambda Dead-Letter Queue"
  value       = module.sqs.dlq_url
}

output "lambda_arn" {
  description = "ARN of the file-processor Lambda function"
  value       = module.lambda.lambda_function_arn
}

output "lambda_function_name" {
  description = "Name of the file-processor Lambda function"
  value       = module.lambda.lambda_function_name
}

output "lambda_iam_role_arn" {
  description = "ARN of the Lambda execution IAM role"
  value       = module.iam.lambda_execution_role_arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group for the Lambda function"
  value       = module.lambda.log_group_name
}

output "source_bucket_arn" {
  description = "ARN of the S3 source bucket"
  value       = module.s3.source_bucket_arn
}

output "source_bucket_name" {
  description = "Name of the S3 source bucket"
  value       = module.s3.source_bucket_id
}
