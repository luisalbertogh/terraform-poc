terraform {
  required_version = ">= 1.15"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Local backend — state is stored in terraform.tfstate in this directory.
  # Switch to a remote backend (e.g. S3 + DynamoDB locking) for team workflows.
  backend "local" {}
}
