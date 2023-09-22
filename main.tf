terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket               = "terraform-staging-environment"
    workspace_key_prefix = "bisina/test_vpc"
    key                  = "test_vpc.tfstate"
    region               = "eu-central-1"
    dynamodb_table       = "eu-central-1-terraform-locks"
    encrypt              = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "environment"                = "${var.environment_type}"
      "application"                = "${var.application_type}"
      "vetstoria:environment"      = "staging"
      "vetstoria:resource-manager" = "Terraform"
      "vetstoria:resource-group"   = "test"
      "vetstoria:team"             = "devops"
      "vetstoria:application"      = "test"
      "vetstoria:component"        = "test"
    }
  }
}

resource "null_resource" "workspace_name_check" {
  lifecycle {
    precondition {
      condition     = (terraform.workspace == "staging" || terraform.workspace == "production")
      error_message = "Workspace name does not match a valid environment."
    }
  }
}

resource "null_resource" "workspace_variable_file_check" {
  lifecycle {
    precondition {
      condition     = terraform.workspace == var.environment_type
      error_message = "Variables file refers to a different workspace."
    }
  }
}
