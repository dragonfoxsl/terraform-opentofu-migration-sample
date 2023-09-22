resource "aws_route_table" "app_private_rt" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.app_nat_gw.*.id, count.index)
  }


  tags = {
    Name      = "[app]private-rt-${trimprefix(var.availability_zones[count.index], var.region)}"
    component = "network"
  }
}

resource "aws_route_table" "app_public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name      = "[app]public-rt"
    component = "network"
  }
}
