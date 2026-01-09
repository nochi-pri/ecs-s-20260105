# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-ecs-s"
    key     = "terraform-backend-ecs-s.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}

# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

provider "aws" {
  alias   = "virginia"
  profile = "terraform"
  region  = "us-east-1"
}

# ---------------------------------------------
# Variables
# ---------------------------------------------
variable "project" {
  type    = string
  default = "tastylog"
}

variable "environment" {
  type    = string
  default = "dev"
}

# variable "username" {
#   type      = string
#   default   = "admin"
#   sensitive = true
# }

# variable "password" {
#   type      = string
#   sensitive = true
# }