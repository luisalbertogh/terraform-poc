output "source_bucket_arn" {
  description = "ARN of the S3 source bucket"
  value       = aws_s3_bucket.source.arn
}

output "source_bucket_id" {
  description = "Name (ID) of the S3 source bucket"
  value       = aws_s3_bucket.source.id
}

output "destination_bucket_arn" {
  description = "ARN of the S3 destination bucket"
  value       = aws_s3_bucket.destination.arn
}

output "destination_bucket_id" {
  description = "Name (ID) of the S3 destination bucket"
  value       = aws_s3_bucket.destination.id
}
