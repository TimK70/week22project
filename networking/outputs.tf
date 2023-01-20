# --- networking/outputs.tf ---

output "private_sg" {
  value = aws_security_group.two_tier_private_sg.id
}

output "private_subnet" {
  value = aws_subnet.two_tier_private_subnet[*].id
}

output "public_sg" {
  value = aws_security_group.two_tier_public_sg.id
}

output "public_subnet" {
  value = aws_subnet.two_tier_public_subnet[*].id
}

output "vpc_id" {
  value = aws_vpc.two_tier_vpc.id
}

output "web_sg" {
  value = aws_security_group.two_tier_web_sg.id
}
