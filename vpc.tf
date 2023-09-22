resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "${var.vpc_name}"
    component = "network"
  }
}

resource "aws_default_route_table" "app_vpc_default_rt" {
  default_route_table_id = aws_vpc.app_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name      = "[app]default-rt"
    component = "network"
  }
}

resource "aws_default_network_acl" "app_vpc_default_acl" {
  default_network_acl_id = aws_vpc.app_vpc.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }

  tags = {
    Name      = "[app]default-nacl"
    component = "network"
  }
}

resource "aws_default_security_group" "app_vpc_default_sg" {
  vpc_id = aws_vpc.app_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.app_vpc.cidr_block]
  }

  tags = {
    Name      = "[app]default-sg"
    component = "network"
  }
}
