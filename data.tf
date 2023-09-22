# Subnet CIDRS

locals {
  all_ciders = cidrsubnets(var.vpc_cidr, 2, 2)

  public_subnet_cidr  = local.all_ciders[0]
  private_subnet_cidr = local.all_ciders[1]
}

# EC2 Instance AMI

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# ACM Certificate

data "aws_acm_certificate" "app_amazon_issued" {
  domain      = "*.sauron.vetstoria.space"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}