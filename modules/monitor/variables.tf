variable "monitor_servers" {
  default = "1"
}

variable "monitor_instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  type = string
}

variable "private_subnet_ids_list"{}

# variable "ami_id" {
#     value = "ami-0a344028b53526a79"
# }
variable "my_vpc_id" {}
variable "default_tags" {}
variable "consul_join_tag_key" {}
variable "consul_join_tag_value" {}
variable "sg_all_worker_managment_id" {}
variable "aws_security_group_common_id" {}
variable "consul_security_group_id" {}
variable "alb_security_group" {}