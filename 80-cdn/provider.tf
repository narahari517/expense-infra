terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.66.0"
    }
  }

  backend "s3" {
    bucket = "aws-remote-state2-dev"
    key    = "expense-dev-cdn"
    region = "us-east-1"
    dynamodb_table = "devops-locking-dev"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}