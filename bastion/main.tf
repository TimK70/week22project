#--- Bastion Host/main.tf -----
resource "aws_instance" "bastion" {
  ami           = var.bastion_ami
  instance_type = var.bastion_instance_type
  #subnet_id                   = var.aws_subnet_two_tier_public_subnet_id
  associate_public_ip_address = true
  #key_name                    = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
}

# resource "aws_eip" "bastion_eip" {
#   vpc      = true
#   instance = aws_instance.bastion.id
# }

# resource "aws_subnet" "two_tier_public_subnet" {
#   vpc_id = aws_vpc.two_tier_vpc.id
# }

resource "aws_vpc" "two_tier_vpc" {
  vpc_id = "vpc-0813d96f9095c0532"
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for the bastion host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}