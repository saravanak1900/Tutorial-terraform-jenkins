provider "aws" {
    region 		= var.region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc_endpoint" "prodecs" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         	= var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-ecs-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "devecs" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-ecs-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "DR-ecs" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "dr-${var.resource_tags}-ecs-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}

resource "aws_vpc_endpoint" "prodecs-agent" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecs-agent"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-ecs-agent-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "devecs-agent" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecs-agent"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-ecs-agent-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "DR-ecs-agent" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecs-agent"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "dr-${var.resource_tags}-ecs-agent-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}

resource "aws_vpc_endpoint" "prod-ecr-dkr" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecr.dkr"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-ecr-dkr-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dev-ecr-dkr" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecr.dkr"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-ecr-dkr-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dr-ecr-dkr" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecr.dkr"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "dr-${var.resource_tags}-ecr-dkr-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}

resource "aws_vpc_endpoint" "prod-ecr-api" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecr.api"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-ecr-api.endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}

resource "aws_vpc_endpoint" "dev-ecr-api" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecr.api"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-ecr-api-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}

resource "aws_vpc_endpoint" "dr-ecr-api" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.ecr.api"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "dr-${var.resource_tags}-ecr-api-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dev-s3-es" {
    count 				= var.vpc_name == "dev" ? 1 : 0 
    vpc_id 				= var.vpc_id
    service_name 			= "com.amazonaws.${var.region}.s3"
    route_table_ids      		= var.route_tables
	tags = merge(
    {
      Name   				= "${var.resource_tags}-s3-endpoint",
      client      			= var.client,
      environment		  		= var.vpc ["environment"],
      environment-purpose 			= var.vpc ["environment-purpose"],
      category    			= var.vpc ["category"],
      costcode     			= var.vpc ["costcode"], 
      terraform 			= path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "prod-s3-es" {
    count 				= var.vpc_name == "prod" ? 1 : 0 
    vpc_id 				= var.vpc_id
    service_name 			= "com.amazonaws.${var.region}.s3"
    route_table_ids     		= var.route_tables
    tags = merge(
    {
      Name   				= "${var.resource_tags}-s3-endpoint",
      client      			= var.client,
      environment		  		= var.vpc ["environment"],
      environment-purpose 			= var.vpc ["environment-purpose"],
      category    			= var.vpc ["category"],
      costcode     			= var.vpc ["costcode"], 
      terraform 			= path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "dr-s3-es" {
    count 				= var.vpc_name == "dr" ? 1 : 0 
    vpc_id 				= var.vpc_id
    service_name 			= "com.amazonaws.${var.region}.s3"
    route_table_ids     		= var.route_tables
    tags = merge(
    {
      Name   				= "dr-${var.resource_tags}-s3-endpoint",
      client      			= var.client,
      environment		  		= var.vpc ["environment"],
      environment-purpose 			= var.vpc ["environment-purpose"],
      category    			= var.vpc ["category"],
      costcode     			= var.vpc ["costcode"], 
      terraform 			= path.cwd
    }
    
  )
}
#This elasticbeanstalk-health endpoints is not supported in ca-central-1 Canada Region
resource "aws_vpc_endpoint" "prod-elasticbeanstalk-health" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.elasticbeanstalk-health"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
   tags = merge(
    {
      Name   			= "${var.resource_tags}-elasticbeanstalk-health-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "dr-elasticbeanstalk-health" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.elasticbeanstalk-health"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
   tags = merge(
    {
      Name   			= "dr-${var.resource_tags}-elasticbeanstalk-health-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "dev-elasticbeanstalk-health" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.elasticbeanstalk-health"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
   subnet_ids         = var.subnet_ids

    tags = merge(
        {
        Name   			= "${var.resource_tags}-elasticbeanstalk-health-endpoint",
        client      	= var.client,
        environment          	= var.vpc ["environment"],
        environment-purpose 	= var.vpc ["environment-purpose"],
        category    	= var.vpc ["category"],
        costcode     	= var.vpc ["costcode"], 
        terraform 		= path.cwd
        }
    )
}


resource "aws_vpc_endpoint" "prod-sqs" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.sqs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-sqs-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dev-sqs" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.sqs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-sqs-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dr-sqs" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.sqs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "dr-${var.resource_tags}-sqs-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
/*
# Endpoints  Security group  ---------------------------------------->

resource "aws_security_group" "ep_sg" {
  name 					= "${var.resource_tags}-${var.vpc_name}-vpce-security-group"
  description 			= "${var.resource_tags} ${var.vpc_name}  vpc endpoints security group"
  vpc_id 				= var.vpc_id
  tags = {
      Name         		= "${var.resource_tags}-${var.vpc_name}-vpce-security-group"
      client          	= var.client,
      environment        		= var.vpc ["environment"],
      environment-purpose     	= var.vpc ["environment-purpose"],
      category        	= var.vpc ["category"],
      costcode         	= var.vpc ["costcode"], 
      terraform     	= path.cwd
  }
}
#Please uncomment this inbound rule for VPCE security groups 443 access only if needed

resource "aws_security_group_rule" "VPCE-rule01" {
    type            	= "ingress"
    from_port           = 443
    to_port             = 443
    protocol            = "tcp"
    cidr_blocks         = [var.vpc.cidr]
    security_group_id   = aws_security_group.ep_sg.id
}*/

resource "aws_vpc_endpoint" "prod-secret-eps" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.secretsmanager"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
    subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-secretmanager-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"],
      terraform 		= path.cwd
    }
   
  )
}
resource "aws_vpc_endpoint" "dev-secret-eps" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.secretsmanager"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
  tags = merge(
    {
      Name   			= "${var.resource_tags}-secretmanager-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"],
      terraform 		= path.cwd
    }
   
  )
}
resource "aws_vpc_endpoint" "dr-secret-eps" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.secretsmanager"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
  tags = merge(
    {
      Name   			= "dr-${var.resource_tags}-secretmanager-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"],
      terraform 		= path.cwd
    }
   
  )
}
resource "aws_vpc_endpoint" "prod-sns-eps" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.sns"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-sns-endpoint",
	  client      		= var.client,
	  environment		  		= var.vpc ["environment"],
	  environment-purpose 		= var.vpc ["environment-purpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "dev-sns-eps" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.sns"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
  tags = merge(
    {
      Name   			= "${var.resource_tags}-sns-endpoint",
	  client      		= var.client,
	  environment		  		= var.vpc ["environment"],
	  environment-purpose 		= var.vpc ["environment-purpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "dr-sns-eps" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.sns"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
  tags = merge(
    {
      Name   			= "dr-${var.resource_tags}-sns-endpoint",
	  client      		= var.client,
	  environment		  		= var.vpc ["environment"],
	  environment-purpose 		= var.vpc ["environment-purpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )
}

resource "aws_vpc_endpoint" "prod-logs-eps" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.logs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
    subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-logs-endpoint",
	  client      		= var.client,
	  environment		  		= var.vpc ["environment"],
	  environment-purpose 		= var.vpc ["environment-purpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}

resource "aws_vpc_endpoint" "dev-logs-eps" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.logs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-logs-endpoint",
	  client      		= var.client,
	  environment		  		= var.vpc ["environment"],
	  environment-purpose 		= var.vpc ["environment-purpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}
resource "aws_vpc_endpoint" "dr-logs-eps" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.logs"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "dr-${var.resource_tags}-logs-endpoint",
	  client      		= var.client,
	  environment		  		= var.vpc ["environment"],
	  environment-purpose 		= var.vpc ["environment-purpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}

resource "aws_vpc_endpoint" "prod-elasticbeanstalk-eps" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.elasticbeanstalk"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
   tags = merge(
    {
      Name   			= "${var.resource_tags}-elasticbeanstalk-endpoint",
	  client      		= var.client,
	  environment		  		= var.vpc ["environment"],
	  environment-purpose 		= var.vpc ["environment-purpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}
resource "aws_vpc_endpoint" "prod-rds" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.rds"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         	= var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-rds-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dev-rds" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.rds"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-rds-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "prod-ses" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.email-smtp"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         	= var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-email-smtp-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dev-ses" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.email-smtp"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-email-smtp-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}


resource "aws_vpc_endpoint" "prod-git" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.git-codecommit"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         	= var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-git-codecommit-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dev-git" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.git-codecommit"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-git-codecommit-endpoint",
      client      		= var.client,
      environment          		= var.vpc ["environment"],
      environment-purpose 		= var.vpc ["environment-purpose"],
      category    		= var.vpc ["category"],
      costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dev-elasticbeanstalk-eps" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.elasticbeanstalk"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
	tags = merge(
		{
		Name   			= "${var.resource_tags}-elasticbeanstalk-endpoint",
		client      	= var.client,
		environment		  		= var.vpc ["environment"],
		environment-purpose 	= var.vpc ["environment-purpose"],
		category    	= var.vpc ["category"],
		costcode     	= var.vpc ["costcode"], 
		terraform 		= path.cwd
		}
	)
}

resource "aws_vpc_endpoint" "dr-elasticbeanstalk-eps" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.elasticbeanstalk"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
	tags = merge(
		{
		Name   			= "dr-${var.resource_tags}-elasticbeanstalk-endpoint",
		client      	= var.client,
		environment		  		= var.vpc ["environment"],
		environment-purpose 	= var.vpc ["environment-purpose"],
		category    	= var.vpc ["category"],
		costcode     	= var.vpc ["costcode"], 
		terraform 		= path.cwd
		}
	)
}

resource "aws_vpc_endpoint" "prod-cloudformation-eps" {
    count 				= var.vpc_name == "prod" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 		= "com.amazonaws.${var.region}.cloudformation"
    vpc_endpoint_type 	= "Interface"
    private_dns_enabled = true
    security_group_ids 	= [
       var.vpce_sg
    ]
	subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-cloudformation-endpoint",
	  client      		= var.client,
	  environment		  		= var.vpc ["environment"],
	  environment-purpose 		= var.vpc ["environment-purpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}

resource "aws_vpc_endpoint" "dev-cloudformation-eps" {
    count 				= var.vpc_name == "dev" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 			= "com.amazonaws.${var.region}.cloudformation"
    vpc_endpoint_type 			= "Interface"
    private_dns_enabled 		= true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "${var.resource_tags}-cloudformation-endpoint",
	  client      		= var.client,
	  environment		  		= var.vpc ["environment"],
	  environment-purpose 		= var.vpc ["environment-purpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}
resource "aws_vpc_endpoint" "dr-cloudformation-eps" {
    count 				= var.vpc_name == "dr" ? 1 : 0
    vpc_id 				= var.vpc_id
    service_name 			= "com.amazonaws.${var.region}.cloudformation"
    vpc_endpoint_type 			= "Interface"
    private_dns_enabled 		= true
    security_group_ids 	= [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   			= "dr-${var.resource_tags}-cloudformation-endpoint",
	  client      		= var.client,
	  environment		  		= var.vpc ["environment"],
	  environment-purpose 		= var.vpc ["environment-purpose"],
	  category    		= var.vpc ["category"],
	  costcode     		= var.vpc ["costcode"], 
      terraform 		= path.cwd
    }
    
  )

}
resource "aws_vpc_endpoint" "prod-ec2-eps" {
    count = var.vpc_name == "prod" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ec2"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   = "${var.resource_tags}-ec2-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "dev-ec2-eps" {
    count = var.vpc_name == "dev" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ec2"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids      = var.subnet_ids
   tags = merge(
    {
      Name   = "${var.resource_tags}-ec2-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"], 
          terraform = path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "dr-ec2-eps" {
    count = var.vpc_name == "dr" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ec2"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids      = var.subnet_ids
   tags = merge(
    {
      Name   = "dr-${var.resource_tags}-ec2-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"], 
          terraform = path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "prod-monitoring-eps" {
    count = var.vpc_name == "prod" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.monitoring"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   = "${var.resource_tags}-monitoring-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"], 
            terraform = path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "dev-monitoring-eps" {
    count = var.vpc_name == "dev" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.monitoring"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids      = var.subnet_ids
     tags = merge(
    {
      Name   = "${var.resource_tags}-monitoring-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}
resource "aws_vpc_endpoint" "dr-monitoring-eps" {
    count = var.vpc_name == "dr" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.monitoring"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids      = var.subnet_ids
     tags = merge(
    {
      Name   = "dr-${var.resource_tags}-monitoring-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"], 
      terraform = path.cwd
    }
    
  )
}

resource "aws_vpc_endpoint" "prod-ssm-eps" {
    count = var.vpc_name == "prod" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ssm"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   = "${var.resource_tags}-ssm-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
            terraform = path.cwd
    }

  )
}
resource "aws_vpc_endpoint" "dev-ssm-eps" {
    count = var.vpc_name == "dev" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ssm"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids      = var.subnet_ids
     tags = merge(
    {
      Name   = "${var.resource_tags}-ssm-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
      terraform = path.cwd
    }

  )
}
resource "aws_vpc_endpoint" "dr-ssm-eps" {
    count = var.vpc_name == "dr" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ssm"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids      = var.subnet_ids
     tags = merge(
    {
      Name   = "dr-${var.resource_tags}-ssm-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
      terraform = path.cwd
    }

  )
}
resource "aws_vpc_endpoint" "prod-ec2messagess-eps" {
    count = var.vpc_name == "prod" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ec2messages"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   = "${var.resource_tags}-ec2messages-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
            terraform = path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dev-ec2messages-eps" {
    count = var.vpc_name == "dev" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ec2messages"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids      = var.subnet_ids
     tags = merge(
    {
      Name   = "${var.resource_tags}-ec2messages-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
      terraform = path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dr-ec2messages-eps" {
    count = var.vpc_name == "dr" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ec2messages"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids      = var.subnet_ids
     tags = merge(
    {
      Name   = "${var.resource_tags}-ec2messages-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
      terraform = path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "prod-ssmmessages-eps" {
    count = var.vpc_name == "prod" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ssmmessages"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids         = var.subnet_ids
     tags = merge(
    {
      Name   = "${var.resource_tags}-ssmmessages-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
            terraform = path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dev-ssmmessages-eps" {
    count = var.vpc_name == "dev" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ssmmessages"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids      = var.subnet_ids
     tags = merge(
    {
      Name   = "${var.resource_tags}-ssmmessages-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
      terraform = path.cwd
    }
  )
}
resource "aws_vpc_endpoint" "dr-ssmmessages-eps" {
    count = var.vpc_name == "dr" ? 1 : 0
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.ssmmessages"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [
       var.vpce_sg
  ]
  subnet_ids      = var.subnet_ids
     tags = merge(
    {
      Name   = "dr-${var.resource_tags}-ssmmessages-endpoint",
      client      = var.client,
      environment          = var.vpc ["environment"],
      environment-purpose = var.vpc ["environment-purpose"],
      category    = var.vpc ["category"],
      costcode     = var.vpc ["costcode"],
      terraform = path.cwd
    }
  )
}
