
variable "ansible_server" {
  default = "1"
}

variable "instance_type_ansible" {
  type    = string
  default = "t2.micro"
}

variable "sg_node_exporter_id" {}

variable "consul_join_tag_value"{}

variable "key_name" {}

variable "private_subnet_id_for_ansible" {}

variable "data_ubuntu_ami_id" {}

variable "aws_iam_instance_profile_name" {}

variable "default_tags" {}

variable "bastion_public_ip" {}

variable "key_local" {}

variable "consul_security_group_id" {}

variable "aws_security_group_common_id"{}

variable "db_sg_id" {}
