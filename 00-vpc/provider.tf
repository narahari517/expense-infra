terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.66.0"
    }
  }

  backend "s3" {
    bucket = "aws-remote-state1-dev"
    key    = "expense-vpc-dev"
    region = "us-east-1"
    dynamodb_table = "devops-locking-dev"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}