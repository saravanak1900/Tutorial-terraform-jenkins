variable "vpc_id"    			{ default = "" }
variable "region"  			{ default = "" }
variable "vpc_name"  		{ default = "" }
variable "client"  			{ default = "" }
variable "subnet_ids"		{ default = "" }
variable "route_tables"		{ default = "" }
variable "resource_tags"		{ default = "" }
variable "vpce_sg"		{ default = "" }
variable "vpc" {
  type = map
  default = {
    name          = ""
    costcode		  = ""
    environment			  = ""
    environment-purpose	  = ""
    category      = ""
  }
}




