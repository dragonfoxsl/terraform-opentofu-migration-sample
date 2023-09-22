# S3

resource "aws_vpc_endpoint" "app_s3_vpce" {
  vpc_id       = aws_vpc.app_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"

  tags = {
    Name      = "[app]s3-vpce"
    component = "network"
  }
}

resource "aws_vpc_endpoint_route_table_association" "app_s3_vpce_assoc_private_rt" {
  count           = length(var.availability_zones)
  vpc_endpoint_id = aws_vpc_endpoint.app_s3_vpce.id
  route_table_id  = element(aws_route_table.app_private_rt.*.id, count.index)
}