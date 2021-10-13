
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}


#vpc state files

#vpc state files
data "terraform_remote_state" "vpc_info" {
    backend = "local"
    config = {
        path     = "/ftp/${var.tf_state_bucket}/${var.client}/vpc/terraform.tfstate"
    }
}

# Database Monitoring Security group  ---------------------------------------->

resource "aws_security_group" "dbs" {
  name = "${var.resource-tag}-${var.vpc_name}-db-sg"
  description = "${var.resource-tag} ${var.vpc_name}  database monitoring sg"
  vpc_id = data.terraform_remote_state.vpc_info.outputs.vpc_id
  tags = {
      Name = "${var.resource-tag}-${var.vpc_name}-db-sg"
      client = var.client
	  environment = var.environment 
	  environment_purpose = var.env-purpose
	  category = "db"
	  costcode = var.costcode
          terraform = "${path.cwd}/${var.vpc_name}-${var.region}"
  }
}

### Uncomment this rule02 and 03 once the windows jb is deloyed and try to apply again to get the jump host IP's
/*
resource "aws_security_group_rule" "dbs-rule01" {
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.host_info.output.private_ip/32)[0]]
        security_group_id	= aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule02" {
        type    = "ingress"
        from_port               = 22
        to_port                 = 22
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.host_info.output.private_ip/32)[0]]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule22" {
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.host_info.output.private_ip/32)[1]]
        security_group_id    = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule23" {
        type    = "ingress"
        from_port               = 22
        to_port                 = 22
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.host_info.output.private_ip/32)[1]]
        security_group_id       = aws_security_group.dbs.id
}


*/
resource "aws_security_group_rule" "dbs-rule03" {
    count = var.vpc_name == "prod" ? 1 : 0
    type    = "ingress"
    from_port        = 5432
    to_port            = 5432
    protocol        = "tcp"
    cidr_blocks             = [flatten(data.terraform_remote_state.vpc_info.outputs.prod_subnet_cidr_a)[0]]
    security_group_id    = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule04" {
    type    = "egress"
    from_port    = 0
    to_port        = 0
    protocol    = -1
    cidr_blocks        = [var.public] 
    security_group_id    = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule06" {
        count = var.vpc_name == "prod" ? 1 : 0
        type    = "ingress"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks             = [var.ansible]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule08" {
        count = var.vpc_name == "prod" ? 1 : 0
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.vpc_info.outputs.prod_subnet_cidr_b)[0]]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule09" {
        count = var.vpc_name == "dev" ? 1 : 0
        type    = "ingress"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks             =   [var.corp]
        security_group_id       = aws_security_group.dbs.id
}

resource "aws_security_group_rule" "dbs-rule10" {
        count = var.vpc_name == "dev" ? 1 : 0
        type    = "ingress"
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        cidr_blocks             = [var.corp]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule11" {
        count = var.vpc_name == "dev" ? 1 : 0
        type    = "ingress"
        from_port       = 1521
        to_port         = 1521
        protocol        = "tcp"
        cidr_blocks             = [var.corp]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule12" {
        count = var.vpc_name == "dev" ? 1 : 0
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.vpc_info.outputs.dev_data_subnet_a_cidr)[0]]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule13" {
        count = var.vpc_name == "dev" ? 1 : 0
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.vpc_info.outputs.dev_data_subnet_b_cidr)[0]]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule15" {
	count = var.vpc_name == "prod" ? 1 : 0
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.vpc_info.outputs.uat_subnet_cidr_b)[0]]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule16" {
	count = var.vpc_name == "prod" ? 1 : 0
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.vpc_info.outputs.uat_subnet_cidr_a)[0]]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule17" {
	count = var.vpc_name == "prod" ? 1 : 0
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.vpc_info.outputs.qa_subnet_cidr_b)[0]]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule18" {
	count = var.vpc_name == "prod" ? 1 : 0
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.vpc_info.outputs.qa_subnet_cidr_a)[0]]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule19" {
        count = var.vpc_name == "dev" ? 1 : 0
        type    = "ingress"
        from_port               = 22
        to_port                 = 22
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.vpc_info.outputs.dev_data_subnet_a_cidr)[0]]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule20" {
        count = var.vpc_name == "dev" ? 1 : 0
        type    = "ingress"
        from_port               = 22
        to_port                 = 22
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.vpc_info.outputs.dev_data_subnet_b_cidr)[0]]
        security_group_id       = aws_security_group.dbs.id
}
resource "aws_security_group_rule" "dbs-rule21" {
	count = var.vpc_name == "dev" ? 1 : 0
        type    = "ingress"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks             = [var.ansibledev]
        security_group_id       = aws_security_group.dbs.id
}

# Rapid-7 vulnerability Scanner Security group ===================================================================================>

resource "aws_security_group" "rapid_sev" {
  name = "${var.resource-tag}-${var.vpc_name}-rapid7vn-scanner-sg"
  description = "${var.resource-tag} ${var.vpc_name}  rapid7vn scanner"
  vpc_id = data.terraform_remote_state.vpc_info.outputs.vpc_id
  
  tags = {
      name = "${var.resource-tag}-${var.vpc_name}-rapid7vn-scanner-sg"
      client = var.client
	  environment = var.environment 
	  environment_purpose = var.env-purpose
	  category = var.category
	  costcode = var.costcode
          terraform = "${path.cwd}/${var.vpc_name}-${var.region}"
  }
}

resource "aws_security_group_rule" "rapid_sev-rule01" {
	type	= "ingress"
	from_port	= 40814
	to_port		= 40814
	protocol	= "tcp"
	cidr_blocks		= [var.r7_console] 
	security_group_id	= aws_security_group.rapid_sev.id
}

resource "aws_security_group_rule" "rapid_sev-rule02" {
	type	= "ingress"
	from_port	= 3389
	to_port		= 3389
	protocol	= "tcp"
	cidr_blocks		= [var.r7_console]
	security_group_id	= aws_security_group.rapid_sev.id
}

resource "aws_security_group_rule" "rapid_sev-rule03" {
	type	= "ingress"
	from_port	= 443
	to_port		= 443
	protocol	= "tcp"
	#cidr_blocks		= flatten(["${split(",", var.rapid_sev)}"]) 
	cidr_blocks		= flatten(var.rapid_sev)
	security_group_id	= aws_security_group.rapid_sev.id
}

resource "aws_security_group_rule" "rapid_sev-rule04" {
	type	= "egress"
	from_port	= 40814
	to_port		= 40814
	protocol	= "tcp"
	cidr_blocks		= [var.r7_console] 
	security_group_id	= aws_security_group.rapid_sev.id
}

resource "aws_security_group_rule" "rapid_sev-rule05" {
	type	= "egress"
	from_port	= 3389
	to_port		= 3389
	protocol	= "tcp"
	cidr_blocks		= [var.r7_console] 
	security_group_id	= aws_security_group.rapid_sev.id
}

resource "aws_security_group_rule" "rapid_sev-rule06" {
	type	= "egress"
	from_port	= 443
	to_port		= 443
	protocol	= "tcp"
	#cidr_blocks		= flatten(["${split(",", var.rapid_sev)}"])
	cidr_blocks		= flatten(var.rapid_sev)
	security_group_id	= aws_security_group.rapid_sev.id
}

resource "aws_security_group_rule" "rapid_sev-rule08" {
        count = var.vpc_name == "dev" ? 1 : 0
        type    = "ingress"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks             = [var.ansibledev]
        security_group_id       = aws_security_group.rapid_sev.id
}

resource "aws_security_group_rule" "rapid_sev-rule09" {
        type    = "egress"
        from_port       = 0
        to_port         = 0
        protocol        = -1
        cidr_blocks             = [var.public]
        security_group_id       = aws_security_group.rapid_sev.id

}
/*
resource "aws_security_group_rule" "rapid_sev-rule10" {
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.host_info.output.private_ip/32)[0]]
        security_group_id	= aws_security_group.rapid_sev.id
}
resource "aws_security_group_rule" "rapid_sev-rule11" {
        type    = "ingress"
        from_port               = 22
        to_port                 = 22
        protocol                = "tcp"
        #cidr_blocks            = [flatten(data.terraform_remote_state.host_info.output.private_ip/32)[0])
        cidr_blocks             = [flatten(data.terraform_remote_state.host_info.output.private_ip/32)[0]] 
        security_group_id	= aws_security_group.rapid_sev.id
}
*/
resource "aws_security_group_rule" "rapid_sev-rule12" {
        count = var.vpc_name == "prod" ? 1 : 0
        type    = "ingress"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks             = [var.ansible]
        security_group_id       = aws_security_group.rapid_sev.id
}
resource "aws_security_group_rule" "rapid_sev-rule12" {
        type    = "ingress"
        from_port               = 5432
        to_port                 = 5432
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.host_info.output.private_ip/32)[1]]
        security_group_id    = aws_security_group.rapid_sev.id
}
resource "aws_security_group_rule" "rapid_sev-rule13" {
        type    = "ingress"
        from_port               = 22
        to_port                 = 22
        protocol                = "tcp"
        cidr_blocks             = [flatten(data.terraform_remote_state.host_info.output.private_ip/32)[1]]
        security_group_id    = aws_security_group.rapid_sev.id
}
output "rapid_group_id" {
	value  = aws_security_group.rapid_sev.id
}


output "dbm_group_id" {
	value  = aws_security_group.dbs.id
}
