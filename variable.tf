variable "public_subnet_cidrs" {
  type          = list(string)
  description = "Public Subnet"
  default       = [ "10.0.1.0/24","10.0.2.0/24" ]
}
variable "cide_b" {
  type = string
  default = "10.0.0.0/16"
}
variable "azs" {
  type          = list(string)
  description   = "Available Zone"
  default       = ["us-east-1a", "us-east-1b"]
}
variable "aws_rt_cb" {
  type = string
  default = "0.0.0.0/0"
}
variable "sg_self" {
  type = string
  default = "false"
}
variable "sg_prt" {
  type = string
  default = "-1"
}
variable "aws_tg_type" {
  type = string
  default = "ip"
}
variable "aws_tg_mat" {
  type = string
  default = "200"
}
variable "aws_tg_path" {
  type = string
  default = "/"
}
variable "ralb_name" {
  type = string
  default = "React-Load-Balancer"
}
variable "nalb_name" {
  type = string
  default = "Node-Load-Balancer"
}
variable "alb_type" {
  type = string
  default = "application"
}
variable "alb_protocol" {
  type = string
  default = "HTTP"
}
variable "ralb_tg_name" {
  type = string
  default = "react-test-tg"
}
variable "nalb_tg_name" {
  type = string
  default = "node-test-tg"
}
variable "cluster_name" {
  type = string
  default = "Cluster"
}
variable "asg_name" {
  type = string
  default = "MY-security-group"
}
variable "asg_dsc" {
  type = string
  default = "All Traffic"
}
variable "alb_tg_prt" {
  type = string
  default = "HTTP"
}
variable "alb_tg_port" {
  type = string
  default = "3000"
}
variable "alb_tg_hc_port" {
  type = string
  default = "traffic-port"
}
variable "alb_lc_type" {
  type = string
  default = "forward"
}
variable "lt_name" {
  type = string
  default = "React_Launch_Tamplet"
}
variable "lt_ami" {
  type = string
  default = "ami-0182f373e66f89c85"
}
variable "lt_type" {
  type = string
  default = "t3.medium"
}
variable "ecs_se_name" {
  type = string
  default = "containerInsights"
}
variable "ecs_se_value" {
  type = string
  default = "disabled"
}
variable "ecs_td" {
  type = string
  default = "REACT"
}
variable "ecs_td_role" {
  type = string
  default = "arn:aws:iam::975050059495:role/ecsTaskExecutionRole"
}
variable "td_nm" {
  type = string
  default = "awsvcp"
}
variable "td_rc" {
  type = string
  default = "FARGATE"
}
variable "td_cpu" {
  type = string
  default = "1024"
}
variable "td_mem" {
  type = string
  default = "3072"
}
variable "td_file" {
  type = string
  default = "REACT-task-definition.json"
}
variable "td_rp_cpu" {
  type = string
  default = "X86_64"
}
variable "td_rp_osf" {
  type = string
  default = "LINUX"
}
variable "ecs_s" {
  type = string
}
variable "ecs_lt" {
  type = string
  default = "FARGATE"
}
variable "ecs_ss" {
  type = string
  default = "REPLICA"
}
variable "ecs_lb_name" {
  type = string
  default = "REACT"
}
variable "region" {
  type = string
  default = "us-east-1"
}
variable "ecr_name" {
  type = string
  default = "mihirv21/react"
}
variable "Service" {
  typr = string
  default = $Service
}
variable "Cluster" {
  type = string
  default = $Cluster
}
