locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # Bucket names fall back to account-scoped defaults when not set via variables,
  # guaranteeing global uniqueness without requiring explicit configuration.
  source_bucket_name      = var.source_bucket_name != null ? var.source_bucket_name : "s3-source-${local.account_id}"
  destination_bucket_name = var.destination_bucket_name != null ? var.destination_bucket_name : "s3-destination-${local.account_id}"

  # Names derived from var.lambda_function_name so they remain consistent.
  dlq_name       = "${var.lambda_function_name}-dlq"
  log_group_name = "/aws/lambda/${var.lambda_function_name}"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project
  }
}
