#-----terraform.tfvars---

ami_id           = ami-0ceecbb0f30a902a6
public_sn_count  = 2
private_sn_count = 4
#public_cidrs     = ["10.0.2.0/24, 10.0.4.0/24, 10.0.6.0/24"]
db_identifier = "mysql"
access_ip     = "0.0.0.0/0"

#--db vars --
dbname     = "rds_mysql"
dbuser     = "TK2007"
dbpassword = "t4b1e_th1s"



