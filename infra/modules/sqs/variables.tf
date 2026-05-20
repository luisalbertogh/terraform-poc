variable "dlq_name" {
  description = "Name of the Dead-Letter Queue"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
