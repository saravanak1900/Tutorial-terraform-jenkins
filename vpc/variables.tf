variable "cidr"    { default = "" }
variable "region"  { default = "" }
variable "vpc_name"  { default = "" }
variable "client"  { default = "" }
variable "tf_state_bucket"	   { default = "" }
variable "log_dest" {}
#This variable declaration goes to variables.tf
variable "traffic_type" {}
variable "log_group_name" {}
variable "destination_cidr_block"  { default = "" } 
variable "vpc" {
  type = map
  default = {
    name                  = ""
    cidr                  = ""
    domain_name           = "ec2.internal"
    enable_dns_hostnames  = true
    enable_dns_support    = true
    enable_igw            = true
    enable_vgw            = true
    domain_name_servers   = ""
    ntp_servers           = ""
    manage_default_sg     = "true"
    manage_default_nacl   = "true"
    costcode		  = ""
    environment			  = ""
    environment-purpose 		  = ""
    category    	  = ""
  }
}
variable "propagating_vgws" { default = "existing" }
variable "gateway"          { default = "existing" }
variable "nat_gateway"      { default = "existing" }
variable "s3_vpc_endpoint" { }
variable "dhcp_options" { type = map }
variable "uat" { 
  type = map
  default = {
  	data_a = ""
	ilb_a  = ""
	elb_a  = ""
	data_b = ""
	ilb_b  = ""
	elb_b  = ""
  }
}
variable "qa" { 
  type = map
  default = {
  	data_a = ""
	ilb_a  = ""
	elb_a  = ""
	data_b = ""
	ilb_b  = ""
	elb_b  = ""
  }
}
variable "dev" { 
  type = map
  default = {
  	data_a = ""
	ilb_a  = ""
	elb_a  = ""
	data_b = ""
	ilb_b  = ""
	elb_b  = ""
  }
}
variable "prod" { 
  type = map
  default = {
  	data_a = ""
	ilb_a  = ""
	elb_a  = ""
	data_b = ""
	ilb_b  = ""
	elb_b  = ""
  }
}
variable "subnets" {
  type = map
  default = {
    cidrs		  = ""
    azs			  = ""
    costcode		  = ""
    environment			  = ""
    envpurpose 		  = ""
    category    	  = ""
  }
}
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the VPC resources"
}
variable "account" {
  description = "AWS account name, registered in Aviatrix controller / the aws account know known to aviatrix controller"
  type        = string
}

 

variable "instance_size" {
  description = "AWS Instance size for the Aviatrix gateways"
  type        = string
  default     = "t3.medium"
}

 

variable "ha_gw" {
  default     = true
}

 

variable "insane_mode" {
  default     = false
}

 

variable "az1" {
  description = "Concatenates with region to form az names. e.g. ap-south-1a. Only used for insane mode"
  type        = string
  default     = "a"
}

 

variable "az2" {
  description = "Concatenates with region to form az names. e.g. ap-south-1b. Only used for insane mode"
  type        = string
  default     = "b"
}

 

variable "transit_gw" {
  description = "Name of the transit gateway to attach this spoke to"
  type        = string
}

 

variable "active_mesh" {
  default     = true
}

 

variable "attached" {
  default     = true
}

 

variable "security_domain" {
  description = "Provide security domain name to which spoke needs to be deployed. Transit gateway mus tbe attached and have segmentation enabled."
  type        = string
  default     = ""
}

 

variable "single_az_ha" {
  default     = true
}

 

variable "single_ip_snat" {
  default     = false
}

 

variable "customized_spoke_vpc_routes" {
  description = "A list of comma separated CIDRs to be customized for the spoke VPC routes. When configured, it will replace all learned routes in VPC routing tables, including RFC1918 and non-RFC1918 CIDRs. It applies to this spoke gateway only?"
  type        = string
  default     = ""
}
variable "filtered_spoke_vpc_routes" {
  type = string
}
variable "included_advertised_spoke_routes" {
  type        = string
}



