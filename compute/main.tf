#--- compute/main.tf---

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "random_id" "two_tier_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "key_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "two_tier_node" {
  count         = var.instance_count # 1
  instance_type = var.instance_type  # t2.micro
  ami           = data.aws_ami.server_ami.id
  tags = {
    Name = "two_tier_node-${random_id.two_tier_node_id[count.index].dec}"
  }

  key_name               = aws_key_pair.key_auth.id
  vpc_security_group_ids = [var.two_tier_public_sg]
  subnet_id              = "var.public_subnets[count.index]"
  user_data = templatefile(var.user_data_path,
    {
      nodename    = "two-tier-${random_id.two_tier_node_id[count.index].dec}"
      db_endpoint = var.db_endpoint
      dbuser      = var.dbuser
      dbpass      = var.dbpassword
      db_name     = var.dbname
    }
  )
  root_block_device {
    volume_size = var.vol_size # 10
  }
}

