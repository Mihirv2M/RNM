terraform {
  required_providers {
    aws             = {
        source      = "hashicorp/aws"
        version     = ">= 3.0"
        }
    }
}

//===== AWS CONFIG HERE =====\\

provider "aws" {

    region          = var.region

}

//===== ELASTIC IP CREATE =====\\
resource "aws_eip" "Elastic_ip" {  
}

//===== VPC CREATE HERE ======\\  

resource "aws_vpc" "My_VPC" {

    cidr_block    = var.cide_b
    
    tags          = {
    Name          = "My_VPC"
  }
}

//===== INTERNET GATEWAY CREATE =====\\

resource "aws_internet_gateway" "new_igw" {
    
    vpc_id      = aws_vpc.My_VPC.id

    tags        = {
    Name        = "new_igw"

    }

}


//===== NAT GATWAY PUBLIC ACCESS =====\\

resource "aws_nat_gateway" "Nat_GW" {
    allocation_id = aws_eip.Elastic_ip.id
    subnet_id             = aws_subnet.Public_Subnet[0].id
    
    tags                  = {
    Name                  = "Nat_GW"

  }

}

//----- PUBLIC SUBNET CREATE ------\\

resource "aws_subnet" "Public_Subnet" {
    
    count       = length(var.public_subnet_cidrs)
    cidr_block  = var.public_subnet_cidrs[count.index]
    vpc_id      = aws_vpc.My_VPC.id
    availability_zone =var.azs[count.index]
  
    tags        = {
    Name        = "Public_subnet ${count.index +1}"
    
    }
}

//===== PUBLIC ROUTE TABLE =====\\

resource "aws_route_table" "public_route_table" { 

    vpc_id      = aws_vpc.My_VPC.id
    route       {
    cidr_block  = var.aws_rt_cb
    gateway_id  = aws_internet_gateway.new_igw.id 

    } 

}

//===== PUBLIC ROUTE ASSOCIATION  =====\\

resource "aws_route_table_association" "public_subnet_asso" {

    count               = length(aws_subnet.Public_Subnet)
    subnet_id           = aws_subnet.Public_Subnet[count.index].id
    route_table_id      = aws_route_table.public_route_table.id

}

//===== PUBLIC SECURITY GROUP CREATE =====\\

resource "aws_security_group" "Public_SG" {
    name = var.asg_name
    vpc_id                = aws_vpc.My_VPC.id

    ingress               {

    from_port             = 0
    to_port               = 0
    protocol              = var.sg_prt
    self                  = var.sg_self
    cidr_blocks           = [var.aws_rt_cb]
    description           = var.asg_dsc 
    } 


    egress                {

    from_port               = 0
    to_port                 = 0
    protocol                = var.sg_prt
    cidr_blocks             = [var.aws_rt_cb]

    }
    tags = {
      Name = var.asg_name
    }
}

//===== REACT LOAD BALANCER CREATE =====\\

resource "aws_lb" "React_lb" {

    name                    =  var.ralb_name
    internal                =  false
    load_balancer_type      =  var.alb_type
    security_groups         = [aws_security_group.Public_SG.id]
    subnets                 =  aws_subnet.Public_Subnet[*].id
  
    tags                    = {
    Name                    = "React-Load-Balancer"
   
    }
}

//===== REACT LOAD BALANCER LISTENER =====\\

resource "aws_lb_listener" "React_Listener" {
      
    load_balancer_arn = aws_lb.React_lb.arn
    port              = 80
    protocol          = var.alb_tg_prt
    
    default_action {
    
      target_group_arn = aws_lb_target_group.React_TG.arn
      type             = var.alb_lc_type
      
    }
    tags = {
      Name="React_listener"
    }
}


//===== TARGET GROUP CREATE =====\\

resource "aws_lb_target_group" "React_TG" {
    
    name     = var.ralb_tg_name
    port     = var.alb_tg_port
    protocol = var.alb_tg_prt
    vpc_id   = aws_vpc.My_VPC.id
    target_type = var.aws_tg_type
    
    health_check {
        
        enabled             = true
        healthy_threshold   = 3
        matcher             = var.aws_tg_mat
        path                = var.aws_tg_path
        port                = var.alb_tg_hc_port
        protocol            = var.alb_tg_prt
        timeout             = 5
        unhealthy_threshold = 10
       
        }
        
        tags                ={
        Name                = "React-Target-Group"
    }
     
}

//===== REACT ELASTIC CONTAINER REGISTRY CREATE =====\\

resource "aws_ecr_repository" "REACT" {
  
    name = var.ecr_name
    force_delete = true

    
}

//===== REACT LAUNCH TAMPLATE =====\\

resource "aws_launch_template" "React_Lt" {
    
    name = var.lt_name
    image_id = var.lt_ami
    instance_type = var.lt_type
    vpc_security_group_ids = [aws_security_group.Public_SG.id]
    
    network_interfaces {
    
      associate_public_ip_address = true
      security_groups = [aws_security_group.Public_SG.id]
      subnet_id = aws_subnet.Public_Subnet[0].id
      
    }
    
}


//===== ECS CLUSTER CREATE =====\\

resource "aws_ecs_cluster" "Cluster" {
    
    name = "${TF_VAR_Cluster}"

    
    setting {

      name  = var.ecs_se_name
      value = var.ecs_se_value
       
    }
}


//===== REACT TASK DEFINITION CREATE =====\\

resource "aws_ecs_task_definition"  "REACT" {
    family                          = var.ecs_td
    execution_role_arn              = var.ecs_td_role
    network_mode                    = "awsvpc"
    requires_compatibilities        = [var.td_rc]
    cpu                             = var.td_cpu
    memory                          = var.td_mem
    container_definitions           = file(var.td_file)
    
    runtime_platform {
    
      cpu_architecture              = var.td_rp_cpu
      operating_system_family       = var.td_rp_osf
    
    }
}    

//===== REACT ECS SERVICE CREATE =====\\

resource "aws_ecs_service" "REACT" {
   #${var.ecs_s}
    name                    = "${TF_VAR_Service}"
    cluster                 = aws_ecs_cluster.Cluster.id
    task_definition         = aws_ecs_task_definition.REACT.arn
    launch_type             = var.ecs_lt
    scheduling_strategy     = var.ecs_ss
    desired_count           = 1
    
    
    network_configuration {
      
      security_groups       = [aws_security_group.Public_SG.id]
      subnets               = aws_subnet.Public_Subnet[*].id
      assign_public_ip      = true
      
    }
    

    load_balancer {
      target_group_arn = aws_lb_target_group.React_TG.arn
      container_name = var.ecs_lb_name
      container_port = 3000
      
    }
    
    depends_on = [ aws_lb_listener.React_Listener ]
}
