provider "aws" {
   region = var.region
}

terraform {
  backend "s3" {}
}
module "hosting" {
    source = "../../sourcefolder/"
    region          		= var.region
    vpc_name        		= var.vpc_name
    tetris_zone     		= var.zone
    ami_name        		= var.ami_name
    r53_domain_name 		= var.zone_name
    
}
#kms state files
data "terraform_remote_state" "kms_info" {
    backend = "local"
    config = {
	path     		= "/ftp/${var.tf_state_bucket}/${var.client}/kms/terraform.tfstate"

    }
}
#security-group state files
data "terraform_remote_state" "sg_info" {
    backend = "local"
    config = {
	path     		= "/ftp/${var.tf_state_bucket}/${var.client}/security-groups/terraform.tfstate"
    }
}
#key-pair state files
data "terraform_remote_state" "key_info" {
    backend = "local"
    config = {
	path     		= "/ftp/${var.tf_state_bucket}/${var.client}/key-pair/terraform.tfstate"
    }
}
#vpc state files
data "terraform_remote_state" "vpc_info" {
    backend = "local"
    config = {
        path     		= "/ftp/${var.tf_state_bucket}/${var.client}/vpc/terraform.tfstate"
    }
}

#--------------------------------------  Database Management Server Ec2 instance -----------------------------------------
#building dbs Instance
resource "aws_instance" "instance1" {

    subnet_id 			= flatten(data.terraform_remote_state.vpc_info.outputs.prod_data_subnet_a)[0]
    ami 			= module.hosting.ami_id
    instance_type 		= var.type
    iam_instance_profile 	= var.instance_profile
    key_name		 	= data.terraform_remote_state.key_info.outputs.key_name
    count 			= var.instance_count
    disable_api_termination 	= false
    vpc_security_group_ids 	= [
       	data.terraform_remote_state.sg_info.outputs.dbs_group_id
    ]
     root_block_device {
    	volume_size 		=  var.root_size
	volume_type 		= var.root_type
        encrypted 		= "true"
    	kms_key_id 		= data.terraform_remote_state.kms_info.outputs.kms_key_id[0]
	delete_on_termination 	= "true"
    }
    volume_tags = {
		Name 		= "${var.resource-tag}-${var.node_type}-root",
		client 		= var.client,
		tag-env 		= var.tag-env,
		tag-purpose 	= var.tag-purpose,
		tag-category 	= "db",
		tag-costcode 	= var.tag-costcode,
        	node 		= var.node_type,
        	terraform 	= path.cwd,
                route53     	= "${var.resource-tag}-${element(split(",", var.r53_name), count.index)}.${var.zone_name}"

    }  
    tags  = {
        Name 			= "${var.resource-tag}-${var.node_type}-monitoring",
        client 			= var.client,
	tag-env 			= var.tag-env,
	tag-purpose 		= var.tag-purpose,
	tag-category 		= "db",
	costcode 		= var.costcode,
        terraform 		= path.cwd,
        route53     		= "${var.resource-tag}-${element(split(",", var.r53_name), count.index)}.${var.zone_name}"

    }
}

#Following Section is to add additional disk as per client requirement
#--------------------------------------  EBS Vol 1 -----------------------------------------

###create encrypted ebs volume###
 
resource "aws_ebs_volume" "vol1" {
    	availability_zone 	= var.az
    	count 			= var.instance_count
    	size 			= var.data_size
	type 			= var.data_type
        encrypted 		= "true"
    	kms_key_id 		= data.terraform_remote_state.kms_info.outputs.kms_key_arn[0]
	tags = {
        	Name 		= "${var.resource-tag}-${var.node_type}-data-volume-${count.index+1}"
        	client 		= var.client,
		tag-env 		= var.tag-env,
		tag-purpose 	= var.tag-purpose,
		tag-category 	= "dbs",
		costcode 	= var.costcode,
        	terraform 	= path.cwd,
        	route53     	= "${var.resource-tag}-${element(split(",", var.r53_name), count.index)}.${var.zone_name}"
    	}
}


##attach ebs volumes for First Drive
resource "aws_volume_attachment" "vol1_att" {
   device_name 			= "/dev/sdb"
   count 			= var.instance_count
   volume_id 			= aws_ebs_volume.vol1[0].id
   instance_id 			= aws_instance.instance1[0].id
}



#create instance r53 records
resource "aws_route53_record" "instance1" {
    count   			= var.instance_count
    zone_id 			= var.r53_zone_id
    name    			= "${var.resource-tag}-${element(split(",", var.r53_name), count.index)}.${var.zone_name}"
    type    			= "A"
    ttl     			= "300"
    records 			= ["${element(aws_instance.instance1.*.private_ip, count.index)}"]
}

output "linux_dbs_id" {
  value = aws_instance.instance1.*.id
}
output "linux_dbs_ip" {
  value = aws_instance.instance1.*.private_ip
}


