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

  backend "s3" {
    bucket  = "terraform-poc-tfstate-1234"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
