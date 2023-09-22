variable "environment_type" {
  description = "Deployment Environment"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["staging", "production"], var.environment_type)
    error_message = "Invalid input, options: \"staging\", \"production\""
  }
}

variable "application_type" {
  description = "Application Type"
  type        = string
}

variable "account_number" {
  description = "AWS Account Number"
  type        = string

  validation {
    condition     = can(regex("[1-9]", var.account_number))
    error_message = "Account number must be a numerical value"
  }
}

variable "region" {
  description = "AWS Deployment Region"
  type        = string
  default     = "eu-west-1"

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be valid AWS Region names"
  }
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) > 1
    error_message = "Must Contain more than 1 availabilty zone"
  }
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be valid IPv4 CIDR"
  }
}

variable "ec2_instance_key" {
  description = "EC2 Instance Key"
  type        = string
  default     = "frankfurt-test-servers-common"
}