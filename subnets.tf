resource "aws_subnet" "app_public_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = cidrsubnet(local.public_subnet_cidr, 1, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name      = "[app]public-${trimprefix(var.availability_zones[count.index], var.region)}"
    type      = "Public Subnet"
    component = "network"
  }
}

resource "aws_route_table_association" "app_public_subnets_association" {
  count = length(var.availability_zones)

  subnet_id      = element(aws_subnet.app_public_subnets.*.id, count.index)
  route_table_id = aws_route_table.app_public_rt.id

  depends_on = [
    aws_subnet.app_public_subnets
  ]
}

resource "aws_subnet" "app_private_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = cidrsubnet(local.private_subnet_cidr, 1, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name      = "[app]private-${trimprefix(var.availability_zones[count.index], var.region)}"
    type      = "Private Subnet"
    component = "network"
  }
}

resource "aws_route_table_association" "app_private_subnets_association" {
  count = length(var.availability_zones)

  subnet_id      = element(aws_subnet.app_private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.app_private_rt.*.id, count.index)

  depends_on = [
    aws_subnet.app_private_subnets,
    aws_route_table.app_private_rt
  ]
}