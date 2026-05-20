# ─── Deployment environment ───────────────────────────────────────────────────
environment = "dev"

# ─── AWS provider ─────────────────────────────────────────────────────────────
aws_profile = "default"
aws_region  = "eu-west-1"

# ─── Project metadata (used in resource tags) ────────────────────────────────
project = "s3lambda"

# ─── Lambda ───────────────────────────────────────────────────────────────────
lambda_function_name        = "file-processor"
lambda_memory_mb            = 512
lambda_timeout_seconds      = 300
lambda_reserved_concurrency = -1

# ─── IAM ──────────────────────────────────────────────────────────────────────
iam_role_name   = "lambda-s3-execution-role"
iam_policy_name = "lambda-s3-access-policy"

# ─── S3 bucket names ──────────────────────────────────────────────────────────
# When omitted (or set to null), both names default to "s3-{source|destination}-<account_id>".
# Uncomment and set explicit names to override.
# source_bucket_name      = "s3-source-123456789012"
# destination_bucket_name = "s3-destination-123456789012"

# ─── CloudWatch ───────────────────────────────────────────────────────────────
log_retention_days = 30
# alarm_actions = ["arn:aws:sns:eu-west-1:123456789012:my-topic"]
