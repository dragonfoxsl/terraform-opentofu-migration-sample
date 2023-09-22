resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name      = "[app]igw"
    component = "network"
  }
}
