#---networking/outputs.tf---

output "vpc_id" {
  value = aws_vpc.two_tier_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.two_tier_rds_subnetgroup.*.name
}

output "db_security_group" {
  value = [aws_security_group.two_tier_sg["mysql"].id]
}

output "public_sg" {
  value = aws_security_group.two_tier_sg["public"].id
}

output "public_subnets" {
  value = aws_subnet.two_tier_public_subnet.*.id
}

output "two_tier_private_subnet" {
  value = aws_subnet.two_tier_private_subnet[*].id
}