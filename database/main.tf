#---database/main.tf---


resource "aws_db_instance" "two_tier_db" {
  allocated_storage = 20
  engine            = "mysql"
  #vpc_id            = var.two_tier_vpc
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  name              = var.dbname
  username          = var.dbuser
  password          = var.dbpassword
  # db_subnet_group_name   = aws_db_subnet_group.two_tier_rds_subnetgroup.id
  vpc_security_group_ids = [aws_security_group.two_tier_private_sg.id]
  #identifier          = var.name
  skip_final_snapshot = var.skip_db_snapshot
  tags = {
    Name = "two_tier_db"
  }
}

# resource "aws_db_subnet_group" "two_tier_rds_subnetgroup" {
#   name        = "${var.db_identifier}-subnet-group"
#   description = "mysql subnet group"
#   subnet_ids  = ["172.31.0.0/20", "172.31.16.0/20"]
# }

resource "aws_security_group" "two_tier_private_sg" {
  name        = "database_two_tier_sg"
  description = "Allows inbound SSH traffic from Bastion"
  vpc_id      = aws_vpc.two_tier_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.two_tier_public_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "two_tier_public_sg" {
  name   = "two_tier_bastion_sg"
  vpc_id = aws_vpc.two_tier_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "two_tier_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "two_tier_vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "random_integer" "random" {
  min = 1
  max = 100
}
