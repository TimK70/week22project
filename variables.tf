#---root/variables.tf

variable "aws_region" {
  default = "us-west-2"
}

variable "access_ip" {}

#-------database variables

variable "dbname" {
  type = string
}
variable "dbuser" {
  type = string
}
variable "dbpassword" {
  type      = string
  sensitive = true
}
variable "public_sn_count" {}
variable "private_sn_count" {}
variable "db_subnet_group" {
  default = "two-tier-sng"
}
variable "two_tier_natgateway" {
  default = "two-tier-ngw"
}
variable "db_identifier" {}
variable "vpc_id" {
  default = "two_tier_vpc"
}
variable "db_subnet_group_name" {
  default = "two_tier_rds_sng"
}