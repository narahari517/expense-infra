terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.66.0"
    }
  }

  backend "s3" {
    bucket = "my-s3-bucket-8080"
    key    = "expense-ecr"
    region = "us-east-1"
    dynamodb_table = "my-state-locking"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}