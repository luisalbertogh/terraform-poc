# S3 Lambda File Processor — Terraform

Provisions the serverless file processing infrastructure defined in the [S3Lambda Architecture document](../docs/S3Lambda_Architecture.md).

Deploys two private S3 buckets (source and destination), a Python 3.12 Lambda function, the supporting IAM role and least-privilege policy, an SQS Dead-Letter Queue, a CloudWatch log group, and three CloudWatch alarms.

## Architecture

```
Upload → S3 Source Bucket → S3 Event Notification → Lambda (Python 3.12) → S3 Destination Bucket
                                                              │
                                                    CloudWatch Logs / SQS DLQ (on failure)
```

## Requirements

| Name               | Version  |
|--------------------|----------|
| Terraform          | >= 1.15  |
| hashicorp/aws      | ~> 6.0   |
| hashicorp/archive  | ~> 2.0   |

## Resources

| Resource | Description |
|----------|-------------|
| `aws_s3_bucket.source` | Private source bucket that receives incoming files |
| `aws_s3_bucket.destination` | Private destination bucket for processed output |
| `aws_s3_bucket_versioning` (×2) | Versioning enabled on both buckets |
| `aws_s3_bucket_server_side_encryption_configuration` (×2) | SSE-S3 (AES-256) on both buckets |
| `aws_s3_bucket_public_access_block` (×2) | All public access blocked on both buckets |
| `aws_s3_bucket_policy` (×2) | HTTPS-only access policy enforced on both buckets |
| `aws_s3_bucket_notification.source` | `s3:ObjectCreated:*` event notification → Lambda |
| `aws_iam_role.lambda_execution` | `lambda-s3-execution-role` assumed by the Lambda service |
| `aws_iam_policy.lambda_s3_access` | `lambda-s3-access-policy` — `s3:GetObject`, `s3:PutObject`, `s3:ListBucket`, `sqs:SendMessage`, CloudWatch Logs |
| `aws_iam_role_policy_attachment` | Attaches the managed policy to the execution role |
| `aws_sqs_queue.lambda_dlq` | Dead-Letter Queue for failed Lambda invocations (14-day retention) |
| `aws_lambda_function.file_processor` | Python 3.12, 512 MB, 5 min timeout, reserved concurrency 10 |
| `aws_lambda_permission.allow_s3` | Resource-based policy: S3 may invoke the Lambda function |
| `aws_cloudwatch_log_group.lambda` | `/aws/lambda/file-processor` — 30-day retention |
| `aws_cloudwatch_metric_alarm.lambda_errors` | Alarm: Errors > 0 in any 5-minute window |
| `aws_cloudwatch_metric_alarm.lambda_duration` | Alarm: Duration > 80 % of configured timeout |
| `aws_cloudwatch_metric_alarm.lambda_throttles` | Alarm: Throttles > 0 in any 5-minute window |

## Usage

### Minimal — use all defaults

```hcl
module "file_processor" {
  source = "./infra"
}
```

### Custom region and AWS profile

```hcl
module "file_processor" {
  source      = "./infra"
  aws_region  = "us-east-1"
  aws_profile = "my-aws-profile"
  environment = "prod"
}
```

### Production configuration with SNS alarm notifications

```hcl
module "file_processor" {
  source      = "./infra"
  aws_region  = "eu-central-1"
  aws_profile = "production-profile"
  environment = "prod"

  lambda_memory_mb            = 1024
  lambda_reserved_concurrency = 20
  lambda_timeout_seconds      = 300
  log_retention_days          = 90

  alarm_actions = [
    "arn:aws:sns:eu-central-1:123456789012:ops-alerts",
  ]
}
```

## Arguments Reference

### Required inputs

None — all variables have defaults.

### Optional inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `alarm_actions` | SNS topic ARNs notified when a CloudWatch alarm changes state | `list(string)` | `[]` |
| `aws_profile` | AWS CLI named profile used for authentication | `string` | `"default"` |
| `aws_region` | AWS region where all resources will be deployed | `string` | `"eu-west-1"` |
| `environment` | Deployment environment (`dev`, `staging`, `prod`) | `string` | `"dev"` |
| `lambda_memory_mb` | Memory allocated to the Lambda function in megabytes | `number` | `512` |
| `lambda_reserved_concurrency` | Reserved concurrency (`-1` = unreserved, `0` = disabled) | `number` | `10` |
| `lambda_timeout_seconds` | Maximum execution duration in seconds (max 900) | `number` | `300` |
| `log_retention_days` | CloudWatch log retention in days | `number` | `30` |
| `project` | Project name used in resource naming and tagging | `string` | `"s3lambda"` |

## Attributes Reference

| Name | Description |
|------|-------------|
| `destination_bucket_arn` | ARN of the S3 destination bucket |
| `destination_bucket_name` | Name of the S3 destination bucket |
| `dlq_arn` | ARN of the Lambda Dead-Letter Queue |
| `dlq_url` | URL of the Lambda Dead-Letter Queue |
| `lambda_arn` | ARN of the file-processor Lambda function |
| `lambda_function_name` | Name of the file-processor Lambda function |
| `lambda_iam_role_arn` | ARN of the Lambda execution IAM role |
| `log_group_name` | CloudWatch log group name |
| `source_bucket_arn` | ARN of the S3 source bucket |
| `source_bucket_name` | Name of the S3 source bucket |

## Implementing Business Logic

Edit `src/handler.py` and replace the body of `_transform()` with the actual file processing logic for your use case. The handler already wires the S3 `GetObject` / `PutObject` calls; only the transformation step needs implementing.

The handler **must be idempotent** — S3 event notifications have at-least-once delivery semantics.

## Authentication

Ensure the target AWS profile is configured before running Terraform:

```bash
aws configure --profile my-aws-profile
```

Override the profile at runtime without editing variables:

```bash
terraform plan -var="aws_profile=my-aws-profile"
```

## Generated files

`lambda_function.zip` is auto-generated by the `archive_file` data source on every `terraform plan` / `terraform apply` run. It should not be committed to source control.
