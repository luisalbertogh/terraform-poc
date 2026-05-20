output "dlq_arn" {
  description = "ARN of the Lambda Dead-Letter Queue"
  value       = aws_sqs_queue.lambda_dlq.arn
}

output "dlq_url" {
  description = "URL of the Lambda Dead-Letter Queue"
  value       = aws_sqs_queue.lambda_dlq.url
}
