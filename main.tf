#--- project root/main.tf

module "compute" {
  source           = "./compute"
  public_sg        = module.networking.public_sg
  public_subnets   = module.networking.public_subnets
  public_subnet_id = module.compute.public_subnet_id
  ami_id           = module.compute.ami_id
  instance_count   = 2
  instance_type    = "t2.micro"
  vol_size         = 10
  key_name         = "two_tierkey"
  public_key_path  = "/home/ec2-user/.ssh/two_tierkey.pub"
  user_data_path   = "${path.root}/userdata.tpl"
  db_endpoint      = module.database.db_endpoint
  dbuser           = var.dbuser
  dbpassword       = var.dbpassword
  dbname           = var.dbname
}

module "week22_bastion" {
  source = "./bastion"
  public_sg        = module.networking.public_sg
  public_subnets   = module.networking.public_subnets
  public_subnet_id = module.compute.public_subnet_id
  ami_id           = module.compute.ami_id
  instance_count   = 2
  instance_type    = "t2.micro"
  vol_size         = 10
  key_name         = "two_tierkey"
  public_key_path  = "/home/ec2-user/.ssh/two_tierkey.pub"
  user_data_path   = "${path.root}/userdata.tpl"
  db_endpoint      = module.database.db_endpoint
  dbuser           = var.dbuser
  dbpassword       = var.dbpassword
  dbname           = var.dbname
}


module "networking" {
  source         = "./networking"
  max_subnets    = 5
  vpc_cidr       = "10.0.0.0/16"
  access_ip      = var.access_ip
  security_groups = module.networking.two_tier_public_sg
  db_subnet_group = var.db_subnet_group_name
  count           = var.private_sn_count
  #nat_gateway_id = aws_nat_gateway.two_tier_natgateway
  #public_sg      = module.networking.public_sg
  #private_sg     = module.networking.private_sg
  #public_subnet  = module.networking.public_subnet
  #private_subnet = module.networking.private_subnet
  public_cidrs   = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
  private_cidrs  = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24", "10.0.7.0/24"]

}



resource "aws_route_table" "two_tier_private_rt" {
  vpc_id = var.two_tier_vpc.id
}

# resource "aws_nat_gateway" "two_tier_natgateway" {
#   subnet_id = 
# }

# resource "aws_security_group" "two_tier_sg" {
  
# }