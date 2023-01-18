#--- Bastion Host/main.tf -----
resource "aws_instance" "bastion" {
  ami           = var.bastion_ami
  instance_type = var.bastion_instance_type
  #subnet_id    = var.aws_subnet_two_tier_public_subnet_id
  associate_public_ip_address = true
  #key_name     = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
}

# resource "aws_subnet" "two_tier_public_subnet" {
#   vpc_id    = var.vpc_id
# }

resource "aws_subnet" "two_tier_public_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.0/24"
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