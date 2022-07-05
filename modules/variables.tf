
variable "default_tags" {}

variable "key_name" {
  type = string
}

variable "num_web_server" {
  default     = "1"
  description = "Num of web servers connected to public subbnet with ngnix"
}

variable "num_db_server" {
  default     = "2"
  description = "Num of db servers connected to public subbnet with ngnix"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "volume_size" {
  type    = number
  default = "10"
}

variable "volume_type" {
  default = "gp2"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR ranges for private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for public subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "global_name_prefix" {
  default     = "final-project"
  type        = string
  description = "1st prefix in the resources' Name tags"
}

variable "route_tables_names" {
  type    = list(string)
  default = ["public", "private-a", "private-b"]
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "route53_host_zone_name" {
  default = "ops.club"
}

variable "monitor_private_ip"{}

variable "consul_security_group_id" {}
variable "jenkins_server_id" {}
variable "monitor_server_id" {}
variable "consul_join_tag_key" {}
variable "consul_join_tag_value" {}
variable "elk_alb_dns_name"{}