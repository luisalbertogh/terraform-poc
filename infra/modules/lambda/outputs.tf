output "lambda_function_name" {
  description = "Name of the file-processor Lambda function"
  value       = aws_lambda_function.file_processor.function_name
}

output "lambda_function_arn" {
  description = "ARN of the file-processor Lambda function"
  value       = aws_lambda_function.file_processor.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda.name
}
