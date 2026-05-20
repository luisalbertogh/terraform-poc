variable "source_bucket_name" {
  description = "Name of the S3 source bucket"
  type        = string
}

variable "destination_bucket_name" {
  description = "Name of the S3 destination bucket"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
