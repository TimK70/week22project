#---networking/variables.tf---

variable "vpc_cidr" {
  type = string
}
variable "public_cidrs" {
  type = list(any)
}
variable "private_cidrs" {
  type = list(any)
}
variable "public_sn_count" {}
variable "private_sn_count" {}
variable "max_subnets" {}
variable "access_ip" {}
variable "security_groups" {}
variable "db_subnet_group" {
  type = string
}
variable "two_tier_natgateway" {}

