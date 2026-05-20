locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # Resource names — defined centrally to guarantee naming consistency across
  # all .tf files.
  destination_bucket_name = "s3-destination-${local.account_id}"
  dlq_name                = "${local.lambda_function_name}-dlq"
  iam_policy_name         = "lambda-s3-access-policy"
  iam_role_name           = "lambda-s3-execution-role"
  lambda_function_name    = "file-processor"
  log_group_name          = "/aws/lambda/${local.lambda_function_name}"
  source_bucket_name      = "s3-source-${local.account_id}"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project
  }
}
