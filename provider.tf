terraform {
  required_version = ">= 0.14.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.72.0"
    }
    random = "~> 2.3.0"
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = ">=2.7.1"
    # }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 3.1.0"
    # }
    # local = {
    #   source  = "hashicorp/local"
    #   version = "~> 2.1.0"
    # }
    # null = {
    #   source  = "hashicorp/null"
    #   version = "~> 3.1.0"
    # }
    # template = {
    #   source  = "hashicorp/template"
    #   version = "~> 2.2.0"
    # }
  }
   backend "s3" {
     bucket = "lihi-opsschool-mid-project-state"
     key    = "mid_project_state/mid_project.tfstate"
     region = "us-east-1"
   }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "lihi-opsschool-mid-project-state"
}

resource "aws_s3_bucket" "loggingb" {
  bucket = "loggingb"
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "dynmodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


##################################################################################
# PROVIDERS
##################################################################################
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      owner   = "lihi reisman"
      purpose = "kandula_project"
      context = "opsschool"
    }
  }
}
