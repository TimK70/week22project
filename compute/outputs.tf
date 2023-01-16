#--- compute/outputs.tf---
output "instance" {
  value     = aws_instance.two_tier_node[*]
  sensitive = true
}
