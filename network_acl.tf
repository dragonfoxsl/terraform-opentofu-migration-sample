resource "aws_network_acl" "app_public_nacl" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name      = "[app]public-nacl"
    component = "network"
  }
}

resource "aws_network_acl_association" "app_public_nacl_assoc_public_subnets" {
  count = length(var.availability_zones)

  network_acl_id = aws_network_acl.app_public_nacl.id
  subnet_id      = element(aws_subnet.app_public_subnets.*.id, count.index)

  depends_on = [
    aws_network_acl.app_public_nacl
  ]
}

resource "aws_network_acl" "app_private_nacl" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name      = "[app]private-nacl"
    component = "network"
  }
}

resource "aws_network_acl_association" "app_public_nacl_assoc_private_subnets" {
  count = length(var.availability_zones)

  network_acl_id = aws_network_acl.app_private_nacl.id
  subnet_id      = element(aws_subnet.app_private_subnets.*.id, count.index)

  depends_on = [
    aws_network_acl.app_private_nacl
  ]
}
