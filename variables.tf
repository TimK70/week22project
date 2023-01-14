#---root/variables.tf
variable "public_sn_count" {
         value = number
}
variable "private_sn_count" {
         value = list(any)
}
variable "public_cidrs" {
         value = list(any)
}
variable "dbuser" {
         value = string
}
variable "dbpassword" {
         value = string
}
variable "dbname" {
         value = string
}
variable "ami_id" {
         value = string
}
variable "public_subnet_id" {
         value = string
}
variable "key_name" {
         value = string
}