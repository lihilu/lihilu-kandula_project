variable "consul_servers"{
    default ="3"
    description = "Num of consul servers"
}

variable "consul_clients" {
    default ="1"
    description = "Num of consul agents" 
}

variable "my_vpc_id" {}

variable "consul_join_tag_key" {
  description = "The key of the tag to auto-jon on EC2."
  default     = "consul_join" 
}

variable "consul_join_tag_value" {
  description = "The value of the tag to auto-join on EC2."
  default     = "training"
}


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

variable "target_group_arns"{}

variable "private_subnet_id" {}

variable "lb_security_group" {}