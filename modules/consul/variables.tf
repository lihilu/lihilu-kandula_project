
variable "consul_servers" {
  default     = "3"
  description = "Num of consul servers"
}

variable "consul_clients" {
  default     = "1"
  description = "Num of consul agents"
}

variable "my_vpc_id" {}

variable "consul_join_tag_key" {}

variable "consul_join_tag_value" {}


variable "consul_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type for Consul instances"
}

variable "consul_version" {
  default     = "1.8.5"
  description = "Consul version"
}

variable "key_name" {}

variable "target_group_arns" {}

variable "private_subnet_id" {}

variable "alb_security_group" {}

variable "default_tags" {}

variable "ami_name_filter_consul" {
  description = "Filter to use to find the AMI by name"
  default     = "consul_server"
}

variable "ami_owner" {
  description = "Filter for the AMI owner"
  default     = "314452776120"
}

variable "ansible_server_private_ip"{}