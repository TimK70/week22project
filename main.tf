#--- project root/main.tf

module "compute" {
  source          = "./compute"
  ami_id          = "ami-0ceecbb0f30a902a6"
  public_sg       = module.networking.two_tier_public_sg
  public_subnets  = module.networking.public_subnets
  instance_count  = 2
  instance_type   = "t2.micro"
  vol_size        = "20"
  public_key_path = "/home/ec2-user/.ssh/two_tierkey.pub"
  key_name        = "two_tierkey"
  dbname          = var.dbname
  dbuser          = var.dbuser
  dbpassword      = var.dbpassword
  db_endpoint     = module.database.db_endpoint
  user_data_path  = "${path.root}/userdata.tpl"
  two_tier_public_sg = "two_tier_public_sg"

  # lb_target_group_arn = module.loadbalancing.lb_target_group_arn
  # tg_port             = 8000
  # private_key_path = "/home/ec2-user/.ssh/two_tierkey"
}

module "bastion" {
  source   = "./bastion"
  vpc_id   = module.networking.vpc_id
  vpc_cidr = "10.0.0.0/16"
}


module "networking" {
  source               = "./networking"
  max_subnets          = 5
  vpc_cidr             = "10.0.0.0/16"
  access_ip            = var.access_ip
  security_groups      = module.networking.two_tier_public_sg
  db_subnet_group      = var.db_subnet_group
  #db_subnet_group_name = "two_tier_rds_sng"
  # count               = var.private_sn_count
  public_cidrs        = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
  private_cidrs       = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24", "10.0.7.0/24"]
  public_sn_count     = var.public_sn_count
  two_tier_natgateway = var.two_tier_natgateway
  private_sn_count    = var.private_sn_count
}

module "database" {
  source            = "./database"
  dbname            = var.dbname
  dbuser            = var.dbuser
  dbpassword        = var.dbpassword
  db_instance_class = "db.t2.micro"
  skip_db_snapshot  = true
  db_subnet_group_name = "mysql"
  db_engine_version = "5.7"
  #  identifier          = "rds mysql"
  db_identifier          = var.db_identifier
  vpc_security_group_ids = [module.networking.db_security_group]
  #aws_subnet             = module.networking.two_tier_rds_subnetgroup
  #vpc_id                    = var.two_tier_vpc
}

# resource "aws_route_table" "two_tier_private_rt" {
#   vpc_id = var.two_tier_vpc.id
# }

