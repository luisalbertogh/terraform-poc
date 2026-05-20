variable "iam_role_name" {
  description = "Name of the Lambda IAM execution role"
  type        = string
}

variable "iam_policy_name" {
  description = "Name of the Lambda IAM managed policy"
  type        = string
}

variable "source_bucket_arn" {
  description = "ARN of the S3 source bucket"
  type        = string
}

variable "destination_bucket_arn" {
  description = "ARN of the S3 destination bucket"
  type        = string
}

variable "dlq_arn" {
  description = "ARN of the Lambda Dead-Letter Queue"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name scoped to the Lambda function"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
