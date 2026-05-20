# ─── S3 Module ────────────────────────────────────────────────────────────────

module "s3" {
  source = "./modules/s3"

  source_bucket_name      = local.source_bucket_name
  destination_bucket_name = local.destination_bucket_name
  common_tags             = local.common_tags
}

# ─── SQS Module ───────────────────────────────────────────────────────────────

module "sqs" {
  source = "./modules/sqs"

  dlq_name    = local.dlq_name
  common_tags = local.common_tags
}

# ─── IAM Module ───────────────────────────────────────────────────────────────

module "iam" {
  source = "./modules/iam"

  iam_role_name          = var.iam_role_name
  iam_policy_name        = var.iam_policy_name
  source_bucket_arn      = module.s3.source_bucket_arn
  destination_bucket_arn = module.s3.destination_bucket_arn
  dlq_arn                = module.sqs.dlq_arn
  log_group_name         = local.log_group_name
  account_id             = local.account_id
  region                 = local.region
  common_tags            = local.common_tags
}

# ─── Lambda Module ────────────────────────────────────────────────────────────

module "lambda" {
  source = "./modules/lambda"

  lambda_function_name        = var.lambda_function_name
  iam_role_arn                = module.iam.lambda_execution_role_arn
  dlq_arn                     = module.sqs.dlq_arn
  source_bucket_arn           = module.s3.source_bucket_arn
  source_bucket_name          = local.source_bucket_name
  destination_bucket_name     = local.destination_bucket_name
  lambda_memory_mb            = var.lambda_memory_mb
  lambda_timeout_seconds      = var.lambda_timeout_seconds
  lambda_reserved_concurrency = var.lambda_reserved_concurrency
  log_group_name              = local.log_group_name
  log_retention_days          = var.log_retention_days
  common_tags                 = local.common_tags
}

# ─── CloudWatch Module ────────────────────────────────────────────────────────

module "cloudwatch" {
  source = "./modules/cloudwatch"

  lambda_function_name   = module.lambda.lambda_function_name
  lambda_timeout_seconds = var.lambda_timeout_seconds
  alarm_actions          = var.alarm_actions
  common_tags            = local.common_tags
}

# ─── S3 → Lambda Event Notification ──────────────────────────────────────────
# Defined at the root module level to break the cross-module dependency between
# the s3 module (which holds the bucket) and the lambda module (which holds the
# function ARN and resource-based permission). Terraform resolves the ordering
# through the explicit depends_on on the lambda module.

resource "aws_s3_bucket_notification" "source" {
  bucket = module.s3.source_bucket_id

  lambda_function {
    lambda_function_arn = module.lambda.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [module.lambda]
}
