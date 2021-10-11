
vpc_name            = "apple-prod-vpc"
region              = "ap-south-1"
cidr                = ""
client              = "NEWCLIENT"
#This LOG GROUP SHOULD GOES TO PROD terraform.tfvars
log_group_name ="/aws/vpcflowlogs/apple"
traffic_type = "ALL"
log_dest            = "arn:aws:s3:::apple-flowlogs-bucket"
vpc = {
    name                  = "-production-vpc"
    cidr                  = "0..0/18"
    domain_name           = "ec2.internal"
    enable_dns_hostnames  = true
    enable_dns_support    = true
    enable_igw            = true
    enable_vgw            = true
    domain_name_servers   = "AmazonProvidedDNS"
    ntp_servers           = ""
    manage_default_sg     = "true"
    manage_default_nacl   = "true"
    costcode               = "-m99"
    environment                   = "not-applicable"
    environmentpurpose           = "network"
    category              = "support"
}
propagating_vgws  = " "
gateway           = " "
nat_gateway       = " "
s3_vpc_endpoint   = "com.amazonaws.ap-south-1.s3"
destination_cidr_block = "0.0.0.0/0"
dhcp_options  = {
    domain_name           = "global.internal_hosted_zone_name"

}
name        = ""
prefix        = ""
suffix         = ""
account        = "apple-production-cloud" 
instance_size    = "t3.small"
ha_gw        = ""
insane_mode    = ""
az1        = ""
az2        = ""
transit_gw    = "aviatrix-appleprod-transit" 
active_mesh    = ""
attached    = ""
security_domain = ""
single_az_ha    = ""
single_ip_snat    = ""
customized_spoke_vpc_routes    = ""
filtered_spoke_vpc_routes    = ""
included_advertised_spoke_routes    = ""
locals = {
  lower_name        = ""
  prefix            = ""
  suffix            = ""
  name              = ""
  subnet            = ""
  ha_subnet         = ""
  insane_mode_az    = ""
  ha_insane_mode_az = ""
}

######
