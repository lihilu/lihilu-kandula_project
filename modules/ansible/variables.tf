variable "ansible_server"{
  default = "1"  
}

variable "instance_type_ansible"{
  type        = string
  default     = "t2.micro"
}

variable "key_name" {}

variable "security_group_db_id" {}

variable "private_subnet_id_for_ansible" {}

variable "data_ubuntu_ami_id" {}