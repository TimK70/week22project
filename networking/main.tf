# --- networking/main.tf----

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
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

resource "aws_subnet" "two_tier_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.two_tier_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "two_tier_public_${count.index + 1}"
  }
}

resource "aws_route_table_association" "two_tier_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.two_tier_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.two_tier_public_rt.id
}

resource "aws_subnet" "two_tier_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.two_tier_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "two_tier_private_${count.index + 1}"
  }
}

resource "aws_route_table_association" "two_tier_private_assoc" {
  count          = length(var.private_cidrs)
  subnet_id      = aws_subnet.two_tier_private_subnet.*.id[count.index]
  route_table_id = aws_default_route_table.two_tier_private_rt.id
}

resource "aws_route_table" "default_private_route" {
  vpc_id = aws_vpc.two_tier_vpc.id
}

resource "aws_internet_gateway" "two_tier_igw" {
  vpc_id = aws_vpc.two_tier_vpc.id

  tags = {
    Name = "two_tier_igw"
  }
}

resource "aws_nat_gateway" "two_tier_natgateway" {
  allocation_id = aws_eip.two_tier_eip.id
  subnet_id     = aws_subnet.two_tier_public_subnet[1].id
}

resource "aws_eip" "two_tier_eip" {

}

resource "aws_route_table" "two_tier_public_rt" {
  vpc_id = aws_vpc.two_tier_vpc.id

  tags = {
    Name = "two_tier_public"
  }
}

resource "aws_route" "default_route_public" {
  route_table_id         = aws_route_table.two_tier_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.two_tier_igw.id
}

resource "aws_default_route_table" "two_tier_private_rt" {
  default_route_table_id = aws_vpc.two_tier_vpc.default_route_table_id

  tags = {
    Name = "two_tier_private"
  }
}

# resource "aws_route" "default_private_route" {
#   route_table_id         = aws_route_table.default_private_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.two_tier_natgateway.id

#   tags = {
#     Name = "two_tier_private_route"
#   }
# }

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
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "two_tier_web_sg" {
  name        = "two_tier_web_sg"
  description = "Allows inbound HTTP traffic"
  vpc_id      = aws_vpc.two_tier_vpc.id
}

resource "aws_db_subnet_group" "two_tier_rds_subnetgroup" {
  count      = var.db_subnet_group == true ? 1 : 0
  name       = "two_tier_rds_subnetgroup"
  subnet_ids = aws_subnet.two_tier_private_subnet.*.id
  tags = {
    Name = "two_tier_rds_sng"
  }
}

