# Dead-Letter Queue — captures event payloads from failed Lambda invocations
# for later inspection or re-processing. Messages are retained for 14 days.

resource "aws_sqs_queue" "lambda_dlq" {
  name = local.dlq_name

  # Maximum retention period: 14 days (1 209 600 s).
  message_retention_seconds = 1209600

  # Server-side encryption with SQS-managed keys.
  sqs_managed_sse_enabled = true

  tags = merge(local.common_tags, {
    Name = local.dlq_name
  })
}
