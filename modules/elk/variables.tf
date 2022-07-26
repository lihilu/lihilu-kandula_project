variable "elk_instance_type" {
  type        = string
  description = "instance type for elk hosting"
  default     = "t3.medium"    
}

variable "data_ubuntu_ami_id" {}
variable "key_name" {}
variable "aws_iam_instance_profile_name"{}
variable "private_subnet_id_for_ansible" {}
variable "sg_node_exporter_id"{}
variable "consul_security_group_id" {}
variable "aws_security_group_common_id" {}
variable "default_tags" {}
variable "consul_join_tag_value" {}
variable "my_vpc_id" {}
variable "finalproject_tls_arn" {}
variable "private_subnet_ids_list" {}

