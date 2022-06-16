variable "ami_name_filter" {
  description = "Filter to use to find the AMI by name"
  default     = "jenkins_server_image"
}

variable "ami_name_filter_agent" {
  description = "Filter to use to find the AMI by name"
  default     = "jenkins_agent_image"
}


variable "ami_owner" {
  description = "Filter for the AMI owner"
  default     = "314452776120"
}

variable "num_of_jenkins_agent"{
  default = "2"
}

variable "sg_node_exporter_id"{}

variable "key_name" {}
variable "default_tags" {}
variable "my_vpc_id" {}
variable "subnet_id" {}
variable "sg_all_worker_managment_id" {}
variable "aws_security_group_common_id" {}
variable "consul_security_group_id" {}
variable "alb_security_group" {}

variable "consul_join_tag_key" {}
variable "consul_join_tag_value" {}

variable "private_public_concat_subnet_cidrs" {
  description = "CIDR ranges for private subnets"
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
