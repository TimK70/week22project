#---database/variables.tf---

variable "db_instance_class" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}
variable "vpc_security_group_ids" {}
variable "db_subnet_group_name" {}
variable "db_engine_version" {}
#variable "db_identifier" {}
variable "skip_db_snapshot" {}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "access_ip" {
  default = "0.0.0.0/0"
}
variable "db_identifier" {
  default = "two-tier-db"
}
# variable "aws_subnet" {}


