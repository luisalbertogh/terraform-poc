# Infrastructure Manifest

## Technology Stack

| Component          | Version  | Purpose                                  |
|--------------------|----------|------------------------------------------|
| Terraform          | >= 1.15  | Infrastructure as Code runtime           |
| hashicorp/aws      | ~> 6.0   | AWS resource provisioning                |
| hashicorp/archive  | ~> 2.0   | Lambda deployment package (ZIP) creation |
| Python             | 3.12     | Lambda function runtime                  |

## Architecture Reference

[S3Lambda Architecture Plan](../docs/S3Lambda_Architecture.md)

## State Backend

**Local** — state is stored in `infra/terraform.tfstate`.  
For team or production environments, migrate to a remote backend (S3 bucket + DynamoDB state locking) and enable encryption at rest and in transit.

## Authentication

Authentication uses a named **AWS CLI profile** configured in `~/.aws/config`.  
The profile name is controlled by the `aws_profile` variable (default: `"default"`).
