
variable "cluster_version" {
  default = "1.22"
}

variable "default_tags" {}
variable "my_vpc_id" {}
variable "private_subnet_ids_list" {}

locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "opsschool-sa"
  cluster_name                  = "kandula-project-eks"
}