variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "iam_role_arn" {
  description = "ARN of the IAM execution role for the Lambda function"
  type        = string
}

variable "dlq_arn" {
  description = "ARN of the Dead-Letter Queue for failed async invocations"
  type        = string
}

variable "source_bucket_arn" {
  description = "ARN of the S3 source bucket (used to scope the resource-based policy)"
  type        = string
}

variable "source_bucket_name" {
  description = "Name of the S3 source bucket injected as an environment variable"
  type        = string
}

variable "destination_bucket_name" {
  description = "Name of the S3 destination bucket injected as an environment variable"
  type        = string
}

variable "lambda_memory_mb" {
  description = "Memory allocated to the Lambda function in megabytes"
  type        = number
  default     = 512
}

variable "lambda_timeout_seconds" {
  description = "Maximum execution duration for the Lambda function in seconds"
  type        = number
  default     = 300
}

variable "lambda_reserved_concurrency" {
  description = "Reserved concurrent executions (-1 = unreserved, 0 = disabled)"
  type        = number
  default     = -1
}

variable "log_group_name" {
  description = "Name of the CloudWatch log group for the Lambda function"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain Lambda execution logs in CloudWatch"
  type        = number
  default     = 30
}

variable "common_tags" {
  description = "Tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
