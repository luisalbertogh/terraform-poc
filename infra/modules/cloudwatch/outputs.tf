output "lambda_errors_alarm_arn" {
  description = "ARN of the Lambda errors CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.lambda_errors.arn
}

output "lambda_duration_alarm_arn" {
  description = "ARN of the Lambda duration CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.lambda_duration.arn
}

output "lambda_throttles_alarm_arn" {
  description = "ARN of the Lambda throttles CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.lambda_throttles.arn
}
