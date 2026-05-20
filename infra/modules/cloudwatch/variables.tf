variable "lambda_function_name" {
  description = "Name of the Lambda function to monitor"
  type        = string
}

variable "lambda_timeout_seconds" {
  description = "Configured Lambda timeout (seconds); used to derive the duration alarm threshold"
  type        = number
}

variable "alarm_actions" {
  description = "List of SNS topic ARNs to notify when an alarm changes state"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
