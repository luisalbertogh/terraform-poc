# Input variables are declared alphabetically.

variable "alarm_actions" {
  description = "List of SNS topic ARNs to notify when a CloudWatch alarm changes state"
  type        = list(string)
  default     = []
}

variable "aws_profile" {
  description = "AWS CLI named profile used for authentication"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region where all resources will be deployed"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "lambda_memory_mb" {
  description = "Memory allocated to the Lambda function in megabytes"
  type        = number
  default     = 512
}

variable "lambda_reserved_concurrency" {
  description = "Reserved concurrent executions for the Lambda function (-1 = unreserved, 0 = disabled)"
  type        = number
  default     = -1
}

variable "lambda_timeout_seconds" {
  description = "Maximum execution duration for the Lambda function in seconds (max 900)"
  type        = number
  default     = 300
}

variable "log_retention_days" {
  description = "Number of days to retain Lambda execution logs in CloudWatch"
  type        = number
  default     = 30
}

variable "project" {
  description = "Project name used in resource naming and tagging"
  type        = string
  default     = "s3lambda"
}
