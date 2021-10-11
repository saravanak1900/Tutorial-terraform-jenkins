provider "aws" {
    region 		= var.region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "vpc0" {
  cidr_block 		= var.vpc.cidr
  enable_dns_hostnames 	=  var.vpc ["enable_dns_hostnames"]
  enable_dns_support 	=    var.vpc ["enable_dns_support"]
  tags = merge(
    {
      Name        	= var.vpc ["name"],
      client      	= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 	= var.vpc ["envpurpose"],
      category    	= var.vpc ["category"],
      costcode     	= var.vpc ["costcode"], 
      terraform 	= path.cwd,
      shared 		= "yes"
    }
    
  )
}
resource "aws_internet_gateway" "vpc0" {
  vpc_id = aws_vpc.vpc0.id
  count = var.vpc ["enable_igw"] ? 1 : 0
  tags = merge(
    {
      Name        = var.vpc ["name"],
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
resource "aws_vpc_dhcp_options" "vpc0" {
  domain_name = var.vpc ["domain_name"]
  domain_name_servers = [var.vpc ["domain_name_servers"]]
  tags = merge(
    {
      Name        = var.vpc ["name"],
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}

resource "aws_vpc_dhcp_options_association" "vpc0" {
  vpc_id = aws_vpc.vpc0.id
  dhcp_options_id = aws_vpc_dhcp_options.vpc0.id
}

resource "aws_default_security_group" "vpc0" {
  count = var.vpc ["manage_default_sg"] ? 1 : 0
  vpc_id = aws_vpc.vpc0.id
  tags = merge(
    {
      Name = "${var.vpc ["name"]}-default-group",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# route table 
resource "aws_route_table" "devdataroutetablea" {
  count = var.vpc_name == "dev" ? 1 : 0 
  vpc_id = aws_vpc.vpc0.id
  #propagating_vgws  =  ["var.propagating_vgws"]
  tags = merge(
    {
      Name   = "${var.client}-dev-priv-rt",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}

# route table 
resource "aws_route_table" "devdataroutetableb" {
  count = var.vpc_name == "dev" ? 1 : 0 
  vpc_id = aws_vpc.vpc0.id
  #propagating_vgws  =  [var.propagating_vgws]
  tags = merge(
    {
      Name   = "${var.client}-dev-pub-rt",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}

# default route
resource "aws_route" "default_route" {
	count = var.vpc_name == "dev" ? 1 : 0     
	depends_on      = [aws_route_table.devdataroutetableb]
    route_table_id  =   aws_route_table.devdataroutetableb[0].id #aws_route_table.devdataroutetableb[count.index]
    destination_cidr_block = var.destination_cidr_block
    gateway_id      =  aws_internet_gateway.vpc0[0].id
}
# production  route tables starts here 
resource "aws_route_table" "proddataroutetablea" {
  count = var.vpc_name == "prod" ? 1 : 0 
  vpc_id = aws_vpc.vpc0.id
  #propagating_vgws  =  [var.propagating_vgws]
  tags = merge(
    {
      Name   = "${var.client}-data-rtb-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}

# route table 
resource "aws_route_table" "proddataroutetableb" {
  count = var.vpc_name == "prod" ? 1 : 0 
  vpc_id = aws_vpc.vpc0.id
  #propagating_vgws  =  [var.propagating_vgws]
  tags = merge(
    {
      Name   = "${var.client}-data-rtb-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}

# route table 
resource "aws_route_table" "prodelboutetable" {
  count = var.vpc_name == "prod" ? 1 : 0 
  vpc_id = aws_vpc.vpc0.id
  #propagating_vgws  =  [var.propagating_vgws]
  tags = merge(
    {
      Name   = "${var.client}-elb-rtb",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}

# default route
resource "aws_route" "prodelb_route" {
    count = var.vpc_name == "prod" ? 1 : 0 
    depends_on      = [aws_route_table.prodelboutetable]
    route_table_id  =  aws_route_table.prodelboutetable[0].id
    destination_cidr_block = var.destination_cidr_block
    gateway_id      = aws_internet_gateway.vpc0[0].id
}
# route table 
resource "aws_route_table" "prodilboutetable" {
  count = var.vpc_name == "prod" ? 1 : 0 
  vpc_id = aws_vpc.vpc0.id
  #propagating_vgws  =  [var.propagating_vgws]
  tags = merge(
    {
      Name   = "${var.client}-ilb-rtb",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "devs3es" {
    count 				= var.vpc_name == "dev" ? 1 : 0 
    vpc_id 				= aws_vpc.vpc0.id
    service_name 			= var.s3_vpc_endpoint
    route_table_ids      		= flatten(["${aws_route_table.devdataroutetablea[0].id}"])
	tags = merge(
    {
      Name   				= "${var.client}-s3-endpoint",
      client      			= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 			= var.vpc ["envpurpose"],
      category    			= var.vpc ["category"],
      costcode     			= var.vpc ["costcode"], 
      terraform 			= path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "prods3es" {
    count 				= var.vpc_name == "prod" ? 1 : 0 
    vpc_id 				= aws_vpc.vpc0.id
    service_name 			= var.s3_vpc_endpoint
    route_table_ids     		= ["$aws_route_table.proddataroutetablea[0].id}?","$aws_route_table.proddataroutetableb[0].id}?"]
    tags = merge(
    {
      Name   				= "${var.client}-s3-endpoint",
      client      			= var.client,
      environment		    = var.vpc ["environment"],
      envpurpose 			= var.vpc ["envpurpose"],
      category    			= var.vpc ["category"],
      costcode     			= var.vpc ["costcode"], 
      terraform 			= path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "prodecs" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.ecs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-ecs-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "devecs" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.ecs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
    ]
	subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-ecs-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "prodecs-agent" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.ecs-agent"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-ecs-agent-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "devecs-agent" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.ecs-agent"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
    ]
	subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-ecs-agent-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "prodecr-dkr" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.ecr.dkr"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-ecr-dkr-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "devecr-dkr" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.ecr.dkr"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
    ]
	subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-ecr-dkr-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "prodecr-api" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.ecr.api"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-ecr-api-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "devecr-api" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.ecr.api"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
    ]
	subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-ecr-api-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
#This elasticbeanstalk-health endpoints is not supported in ca-central-1 Canada Region
resource "aws_vpc_endpoint" "prodelasticbeanstalkhealth" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.elasticbeanstalk-health"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
   tags = merge(
    {
      Name   			= "${var.client}-elasticbeanstalk-health-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "develasticbeanstalkhealth" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.elasticbeanstalk-health"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
   subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]

    tags = merge(
        {
        Name   			= "${var.client}-elasticbeanstalk-health-endpoint",
        client      	= var.client,
        environment		= var.vpc ["environment"],
        envpurpose 	= var.vpc ["envpurpose"],
        category    	= var.vpc ["category"],
        costcode     	= var.vpc ["costcode"], 
        terraform 		= path.cwd
        }
    )
}


resource "aws_vpc_endpoint" "prodsqs" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.sqs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-sqs-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "devsqs" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.sqs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
    ]
	subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-sqs-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}


# Endpoints  Security group  ---------------------------------------->

resource "aws_security_group" "ep_sg" {
  name 					= "${var.client}-${var.vpc_name}-vpce-sg"
  description 			= "${var.client} ${var.vpc_name}  vpc endpoints security groups"
  vpc_id 				= aws_vpc.vpc0.id
  tags = {
      Name         		= "${var.client}-${var.vpc_name}-vpce-sg"
      client          	= var.client,
      environment		= var.vpc ["environment"],
      envpurpose     	= var.vpc ["envpurpose"],
      category        	= var.vpc ["category"],
      costcode         	= var.vpc ["costcode"], 
      terraform     	= path.cwd
  }
}
#Please uncomment this inbound rule for VPCE security groups 443 access only if needed

resource "aws_security_group_rule" "vpce-rule01" {
    type            	= "ingress"
    from_port           = 443
    to_port             = 443
    protocol            = "tcp"
    cidr_blocks         = [var.vpc.cidr]
    security_group_id   = aws_security_group.ep_sg.id
}

resource "aws_vpc_endpoint" "prodsecreteps" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.secretsmanager"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
    ]
    subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-secretmanager-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"],
      terraform 		= path.cwd
    }
   
  )
}
resource "aws_vpc_endpoint" "devsecreteps" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.secretsmanager"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
  tags = merge(
    {
      Name   			= "${var.client}-secretmanager-endpoint",
      client      		= var.client,
      environment		= var.vpc ["environment"],
      envpurpose 		= var.vpc ["envpurpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"],
      terraform 		= path.cwd
    }
   
  )
}
resource "aws_vpc_endpoint" "prodsnseps" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.sns"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-sns-endpoint",
	  client      		= var.client,
      environment		= var.vpc ["environment"],
	  envpurpose 		= var.vpc ["envpurpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "devsnseps" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.sns"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
  tags = merge(
    {
      Name   			= "${var.client}-sns-endpoint",
	  client      		= var.client,
      environment		= var.vpc ["environment"],
	  envpurpose 		= var.vpc ["envpurpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )
}

resource "aws_vpc_endpoint" "prodlogseps" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.logs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
    ]
    subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-logs-endpoint",
	  client      		= var.client,
      environment		= var.vpc ["environment"],
	  envpurpose 		= var.vpc ["envpurpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}

resource "aws_vpc_endpoint" "devlogseps" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.logs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-logs-endpoint",
	  client      		= var.client,
      environment		= var.vpc ["environment"],
	  envpurpose 		= var.vpc ["envpurpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}


resource "aws_vpc_endpoint" "prodelasticbeanstalkeps" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.elasticbeanstalk"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
    ]
	subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
   tags = merge(
    {
      Name   			= "${var.client}-elasticbeanstalk-endpoint",
	  client      		= var.client,
      environment		= var.vpc ["environment"],
	  envpurpose 		= var.vpc ["envpurpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}

resource "aws_vpc_endpoint" "develasticbeanstalkeps" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.elasticbeanstalk"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
	tags = merge(
		{
		Name   			= "${var.client}-elasticbeanstalk-endpoint",
		client      	= var.client,
		environment		= var.vpc ["environment"],
		envpurpose 	= var.vpc ["envpurpose"],
		category    	= var.vpc ["category"],
		costcode     	= var.vpc ["costcode"], 
		terraform 		= path.cwd
		}
	)
}


resource "aws_vpc_endpoint" "prodcloudformationeps" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 		= "com.amazonaws.${var.region}.cloudformation"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
    ]
	subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-cloudformation-endpoint",
	  client      		= var.client,
      environment		= var.vpc ["environment"],
	  envpurpose 		= var.vpc ["envpurpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}

resource "aws_vpc_endpoint" "devcloudformationeps" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= aws_vpc.vpc0.id
    service_name 			= "com.amazonaws.${var.region}.cloudformation"
    vpc_endpoint_type 			= "Interface"
    private_dns_enabled 		= true
    security_group_ids 	= [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   			= "${var.client}-cloudformation-endpoint",
	  client      		= var.client,
     environment		= var.vpc ["environment"],
	  envpurpose 		= var.vpc ["envpurpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}
resource "aws_vpc_endpoint" "prodec2eps" {
    count = var.vpc_name == "prod" ? 1 : 0
    vpc_id = aws_vpc.vpc0.id
    service_name = "com.amazonaws.${var.region}.ec2"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   = "${var.client}-ec2-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      envpurpose = var.vpc ["envpurpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "devec2eps" {
    count = var.vpc_name == "dev" ? 1 : 0
    vpc_id = aws_vpc.vpc0.id
    service_name = "com.amazonaws.${var.region}.ec2"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids      = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
   tags = merge(
    {
      Name   = "${var.client}-ec2-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      envpurpose = var.vpc ["envpurpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"], 
          terraform = path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "prodmonitoringeps" {
    count = var.vpc_name == "prod" ? 1 : 0
    vpc_id = aws_vpc.vpc0.id
    service_name = "com.amazonaws.${var.region}.monitoring"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   = "${var.client}-monitoring-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      envpurpose = var.vpc ["envpurpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"], 
            terraform = path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "devmonitoringeps" {
    count = var.vpc_name == "dev" ? 1 : 0
    vpc_id = aws_vpc.vpc0.id
    service_name = "com.amazonaws.${var.region}.monitoring"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids      = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   = "${var.client}-monitoring-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      envpurpose = var.vpc ["envpurpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}

resource "aws_vpc_endpoint" "prodssmeps" {
    count = var.vpc_name == "prod" ? 1 : 0
    vpc_id = aws_vpc.vpc0.id
    service_name = "com.amazonaws.${var.region}.ssm"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   = "${var.client}-ssm-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      envpurpose = var.vpc ["envpurpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
            terraform = path.cwd
    }

  )
}
resource "aws_vpc_endpoint" "devssmeps" {
    count = var.vpc_name == "dev" ? 1 : 0
    vpc_id = aws_vpc.vpc0.id
    service_name = "com.amazonaws.${var.region}.ssm"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids      = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   = "${var.client}-ssm-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      envpurpose = var.vpc ["envpurpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
      terraform = path.cwd
    }

  )
}
resource "aws_vpc_endpoint" "prodec2messagesseps" {
    count = var.vpc_name == "prod" ? 1 : 0
    vpc_id = aws_vpc.vpc0.id
    service_name = "com.amazonaws.${var.region}.ec2messages"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   = "${var.client}-ec2messages-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      envpurpose = var.vpc ["envpurpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
            terraform = path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "devec2messageseps" {
    count = var.vpc_name == "dev" ? 1 : 0
    vpc_id = aws_vpc.vpc0.id
    service_name = "com.amazonaws.${var.region}.ec2messages"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids      = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   = "${var.client}-ec2messages-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      envpurpose = var.vpc ["envpurpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
      terraform = path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "prodssmmessageseps" {
    count = var.vpc_name == "prod" ? 1 : 0
    vpc_id = aws_vpc.vpc0.id
    service_name = "com.amazonaws.${var.region}.ssmmessages"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids         = ["${aws_subnet.PRODDataSubnetA[0].id}","${aws_subnet.PRODDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   = "${var.client}-ssmmessages-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      envpurpose = var.vpc ["envpurpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
            terraform = path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "devssmmessageseps" {
    count = var.vpc_name == "dev" ? 1 : 0
    vpc_id = aws_vpc.vpc0.id
    service_name = "com.amazonaws.${var.region}.ssmmessages"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       "${aws_security_group.ep_sg.id}"
  ]
  subnet_ids      = ["${aws_subnet.DevDataSubnetA[0].id}","${aws_subnet.DevDataSubnetB[0].id}"]
     tags = merge(
    {
      Name   = "${var.client}-ssmmessages-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      envpurpose = var.vpc ["envpurpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
      terraform = path.cwd
    }
  )
}


#Dev subnet creations starts here
#DevDataSubnetA
resource "aws_subnet" "DevDataSubnetA" {
   count = var.vpc_name == "dev" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = (var.dev ["ilb_a"])
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-dev-priv-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}


# Route table association
resource "aws_route_table_association" "dev_data_rta" {
  count = var.vpc_name == "dev" ? 1 : 0 
  depends_on      = [aws_subnet.DevDataSubnetA]
  subnet_id      = aws_subnet.DevDataSubnetA[0].id 
  route_table_id  = aws_route_table.devdataroutetablea[0].id
}
#DevDataSubnetB
resource "aws_subnet" "DevDataSubnetB" {
   count = var.vpc_name == "dev" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = (var.dev ["elb_a"])
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-dev-priv-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}


# Route table association
resource "aws_route_table_association" "dev_data_rtb" {
  count = var.vpc_name == "dev" ? 1 : 0 
  depends_on      = [aws_subnet.DevDataSubnetB]
  subnet_id      = aws_subnet.DevDataSubnetB[0].id
  route_table_id  =  aws_route_table.devdataroutetablea[0].id
}
#DevELBSubnetA
resource "aws_subnet" "DevELBSubnetA" {
   count = var.vpc_name == "dev" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.dev ["data_a"]
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-dev-pub-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
 }


# Route table association
resource "aws_route_table_association" "dev_elb_rta" {
  count = var.vpc_name == "dev" ? 1 : 0 
  depends_on      = [aws_subnet.DevELBSubnetA]
  subnet_id      = aws_subnet.DevELBSubnetA[0].id
  route_table_id  = aws_route_table.devdataroutetableb[0].id
}
#DevELBSubnetB
resource "aws_subnet" "DevILBSubnetA" {
   count = var.vpc_name == "dev" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.dev ["data_b"]
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-dev-pub-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}


# Route table association
resource "aws_route_table_association" "dev_elb_rtb" {
  count = var.vpc_name == "dev" ? 1 : 0 
  depends_on      = [aws_subnet.DevILBSubnetA]
  subnet_id      = aws_subnet.DevILBSubnetA[0].id
  route_table_id  = aws_route_table.devdataroutetableb[0].id
}
#Prod Subnet Creation Starts Here
#UATDataSubnetA
resource "aws_subnet" "UATDataSubnetA" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.uat ["data_a"]
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-uat-data-sub-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "uat_data_rta" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.UATDataSubnetA]
  subnet_id      = aws_subnet.UATDataSubnetA[0].id
  route_table_id  = aws_route_table.proddataroutetablea[0].id
}
#UATDataSubnetB
resource "aws_subnet" "UATDataSubnetB" {
   count = var.vpc_name == "prod" ? 1 : 0  
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.uat ["data_b"]
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-uat-data-sub-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "uat_data_rtb" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.UATDataSubnetB]
  subnet_id      = aws_subnet.UATDataSubnetB[0].id
  route_table_id  = aws_route_table.proddataroutetableb[0].id
}

#UATElbSubnetA
resource "aws_subnet" "UATElbSubnetA" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.uat ["elb_a"]
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-uat-elb-sub-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "uat_elb_rta" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.UATElbSubnetA]
  subnet_id      = aws_subnet.UATElbSubnetA[0].id
  route_table_id  = aws_route_table.prodelboutetable[0].id
}

#UATElbSubnetB
resource "aws_subnet" "UATElbSubnetB" {
  count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.uat ["elb_b"]
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-uat-elb-sub-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "uat_elb_rtb" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.UATElbSubnetB]
  subnet_id      = aws_subnet.UATElbSubnetB[0].id
  route_table_id  = aws_route_table.prodelboutetable[0].id
}

#UATIlbSubnetA
resource "aws_subnet" "UATIlbSubnetA" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.uat ["ilb_a"]
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-uat-ilb-sub-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "uat_ilb_rta" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.UATIlbSubnetA]
  subnet_id      = aws_subnet.UATIlbSubnetA[0].id
  route_table_id  = aws_route_table.prodilboutetable[0].id
}
#UATIlbSubnetB
resource "aws_subnet" "UATIlbSubnetB" {
   count =var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.uat ["ilb_b"]
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-uat-ilb-sub-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "uat_ilb_rtb" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.UATIlbSubnetB]
  subnet_id      = aws_subnet.UATIlbSubnetB[0].id
  route_table_id  = aws_route_table.prodilboutetable[0].id
}
#QADataSubnetA
resource "aws_subnet" "QADataSubnetA" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.qa ["data_a"]
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-qa-data-sub-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "qa_data_rta" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.QADataSubnetA]
  subnet_id      = aws_subnet.QADataSubnetA[0].id
  route_table_id  = aws_route_table.proddataroutetablea[0].id
}
#QADataSubnetB
resource "aws_subnet" "QADataSubnetB" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.qa ["data_b"]
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-qa-data-sub-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "qa_data_rtb" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.QADataSubnetB]
  subnet_id      = aws_subnet.QADataSubnetB[0].id
  route_table_id  = aws_route_table.proddataroutetableb[0].id
}

#QAElbSubnetA
resource "aws_subnet" "QAElbSubnetA" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.qa ["elb_a"]
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-qa-elb-sub-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "QA_elb_rta" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.QAElbSubnetA]
  subnet_id      = aws_subnet.QAElbSubnetA[0].id
  route_table_id  = aws_route_table.prodelboutetable[0].id
}
#QAElbSubnetB
resource "aws_subnet" "QAElbSubnetB" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.qa ["elb_b"]
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-qa-elb-sub-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "QA_elb_rtb" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.QAElbSubnetB]
  subnet_id      = aws_subnet.QAElbSubnetB[0].id
  route_table_id  = aws_route_table.prodelboutetable[0].id
}

#QAIlbSubnetA
resource "aws_subnet" "QAIlbSubnetA" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.qa ["ilb_a"]
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-qa-ilb-sub-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "QA_ilb_rta" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.QAIlbSubnetA]
  subnet_id      = aws_subnet.QAIlbSubnetA[0].id
  route_table_id  = aws_route_table.prodilboutetable[0].id
}
#QAIlbSubnetB
resource "aws_subnet" "QAIlbSubnetB" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.qa ["ilb_b"]
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-qa-ilb-sub-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "QA_ilb_rtb" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.QAIlbSubnetB]
  subnet_id      = aws_subnet.QAIlbSubnetB[0].id
  route_table_id  = aws_route_table.prodilboutetable[0].id
}
#PRODDataSubnetA
resource "aws_subnet" "PRODDataSubnetA" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.prod ["data_a"]
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-prod-data-sub-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "PROD_data_rta" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.PRODDataSubnetA]
  subnet_id      = aws_subnet.PRODDataSubnetA[0].id
  route_table_id  = aws_route_table.proddataroutetablea[0].id
}
#PRODDataSubnetB
resource "aws_subnet" "PRODDataSubnetB" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.prod ["data_b"]
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-prod-data-sub-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "PROD_data_rtb" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.PRODDataSubnetB]
  subnet_id      = aws_subnet.PRODDataSubnetB[0].id
  route_table_id  = aws_route_table.proddataroutetableb[0].id
}

#PRODElbSubnetA
resource "aws_subnet" "PRODElbSubnetA" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.prod ["elb_a"]
   #availability_zone = var.region "c"
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-prod-elb-sub-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "PROD_elb_rta" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.PRODElbSubnetA]
  subnet_id      = aws_subnet.PRODElbSubnetA[0].id
  route_table_id  = aws_route_table.prodelboutetable[0].id
}
#PRODElbSubnetB
resource "aws_subnet" "PRODElbSubnetB" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.prod ["elb_b"]
   #availability_zone = var.regiond
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-prod-elb-sub-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "PROD_elb_rtb" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.PRODElbSubnetB]
  subnet_id      = aws_subnet.PRODElbSubnetB[0].id
  route_table_id  = aws_route_table.prodelboutetable[0].id
}

#PRODIlbSubnetA
resource "aws_subnet" "PRODIlbSubnetA" {
   count = var.vpc_name == "prod" ? 1 : 0  
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.prod ["ilb_a"]
   availability_zone = "${var.region}d"
   tags = merge(
    {
      Name        = "${var.client}-prod-ilb-sub-a",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "PROD_ilb_rta" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.PRODIlbSubnetA]
  subnet_id      = aws_subnet.PRODIlbSubnetA[0].id
  route_table_id  = aws_route_table.prodilboutetable[0].id
}
#PRODIlbSubnetB
resource "aws_subnet" "PRODIlbSubnetB" {
   count = var.vpc_name == "prod" ? 1 : 0   
   vpc_id            = aws_vpc.vpc0.id
   cidr_block        = var.prod ["ilb_b"]
  # availability_zone = var.regiond
   availability_zone = "${var.region}b"
   tags = merge(
    {
      Name        = "${var.client}-prod-ilb-sub-b",
	  client      = var.client,
	  environment		= var.vpc ["environment"],
	  envpurpose = var.vpc ["envpurpose"],
	  category    = var.vpc ["category"],
	  costcode     = var.vpc ["costcode"],
      terraform = path.cwd
    }
    
  )
}
# Route table association
resource "aws_route_table_association" "PROD_ilb_rtb" {
  count = var.vpc_name == "prod" ? 1 : 0 
  depends_on      = [aws_subnet.PRODIlbSubnetB]
  subnet_id      = aws_subnet.PRODIlbSubnetB[0].id
  route_table_id  = aws_route_table.prodilboutetable[0].id
}

