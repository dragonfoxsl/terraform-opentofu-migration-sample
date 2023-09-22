output "app_vpc" {
  value = aws_vpc.app_vpc
}

output "app_public_subnets" {
  value = aws_subnet.app_public_subnets
}

output "app_private_subnets" {
  value = aws_subnet.app_private_subnets
}
