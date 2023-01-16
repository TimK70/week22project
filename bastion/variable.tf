#---bastion/variable.tf

variable "bastion_ami" {
  default = "ami-0cf1dfc38e4c28f7d"
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "bastion_key_name" {
  default = "two_tier_bastion_key"
}

variable "bastion_security_group_name" {
  default = "my-bastion-sg"
}

variable "bastion_instance_profile_name" {
  default = "my-bastion-profile"
}

# variable "aws_subnet_two_tier_public_subnet" {}
