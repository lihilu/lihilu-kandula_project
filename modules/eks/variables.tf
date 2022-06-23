
variable "cluster_version" {
  default = "1.22"
}

variable "default_tags" {}
variable "my_vpc_id" {}
variable "private_subnet_ids_list" {}

locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "opsschool-sa"
  k8s_service_account_name_lihi = "lihikandulasa"
  cluster_name                  = "kandula-project-eks"
}

variable "sg_node_exporter_id"{}

variable "consul_security_group_id" {}

variable "monitor_security_group_id" {}

variable "jenkins_agent" {}

variable "jenkins_agent_role_arn" {}

variable "consul_join_tag_key" {}

variable "consul_join_tag_value" {}
