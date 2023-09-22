resource "aws_nat_gateway" "app_nat_gw" {
  count         = length(var.availability_zones)
  allocation_id = element(aws_eip.app_nat_eips.*.id, count.index)
  subnet_id     = element(aws_subnet.app_public_subnets.*.id, count.index)

  depends_on = [
    aws_internet_gateway.app_igw,
    aws_eip.app_nat_eips
  ]

  tags = {
    Name      = "[app]nat-gateway-${trimprefix(var.availability_zones[count.index], var.region)}"
    component = "network"
  }
}