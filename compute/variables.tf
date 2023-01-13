#--- compute/variables.tf----

variable "instance_count" {}
variable "instance_type" {}
variable "public_sg" {}
variable "public_subnets" {}
variable "key_name" {}
variable "user_data_path" {}
variable "dbuser" {}
variable "dbname" {}
variable "dbpassword" {}
variable "db_endpoint" {}
variable "public_subnet_id" {}
variable "ami_id" {}
variable "bastion_instance_type" {
  type    = string
  default = "t2.micro"
}
variable "database_instance_type" {
  type    = string
  default = "t2.micro"
}
variable "vol_size" {}
variable "public_key_path" {}