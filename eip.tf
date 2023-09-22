resource "aws_eip" "app_nat_eips" {
  count  = length(var.availability_zones)
  domain = "vpc"

  depends_on = [
    aws_internet_gateway.app_igw
  ]

  tags = {
    Name      = "[app]nat-eip-${trimprefix(var.availability_zones[count.index], var.region)}"
    component = "network"
  }
}