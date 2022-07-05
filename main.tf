
module "instance" {
  source                   = "./modules/"
  consul_security_group_id = module.consul_cluster.consul_security_group_id
  jenkins_server_id        = module.jenkins.jenkins_server_id
  monitor_server_id       = module.monitor_system.monitor_server_id
  key_name                 = module.ssh-key.key_name
  default_tags             = var.default_tags
  consul_join_tag_key      = var.consul_join_tag_key
  consul_join_tag_value    = var.consul_join_tag_value
  monitor_private_ip      = module.monitor_system.monitor_private_ip
  elk_alb_dns_name        = module.elk.elk_alb_dns_name
}

module "db" {
  source                        = "./modules/db"
  my_vpc_id             = module.instance.my_vpc_id
  private_subnet_id = module.instance.private_subnet_ids_list
  source_security_group_id_common = module.instance.aws_security_group_common_id
  source_security_group_id_kube = module.eks_cluster.sg_all_worker_managment_id
 # default_tags          = var.default_tags
  consul_join_tag_key   = var.consul_join_tag_key
  consul_join_tag_value = var.consul_join_tag_value
}

module "consul_cluster" {
  source                = "./modules/consul"
  my_vpc_id             = module.instance.my_vpc_id
  key_name              = module.ssh-key.key_name
  target_group_arns     = module.instance.target_group_arns
  private_subnet_id     = module.instance.private_subnet_id
  alb_security_group    = module.instance.alb_security_group
  sg_node_exporter_id           = module.monitor_system.sg_node_exporter_id
  default_tags          = var.default_tags
  consul_join_tag_key   = var.consul_join_tag_key
  consul_join_tag_value = var.consul_join_tag_value
  ansible_server_private_ip = module.ansible_server.ansible_server_private_ip[0]
}

module "ansible_server" {
  source                        = "./modules/ansible"
  key_name                      = module.ssh-key.key_name
  private_subnet_id_for_ansible = module.instance.private_subnet_id_for_ansible
  data_ubuntu_ami_id            = module.instance.data_ubuntu_ami_id
  aws_iam_instance_profile_name = module.consul_cluster.aws_iam_instance_profile_name
  bastion_public_ip             = module.instance.bastion_public_ip
  default_tags                  = var.default_tags
  consul_security_group_id = module.consul_cluster.consul_security_group_id
  sg_node_exporter_id           = module.monitor_system.sg_node_exporter_id
  key_local                     = module.ssh-key.key_local
  consul_join_tag_value        = var.consul_join_tag_value
  aws_security_group_common_id = module.instance.aws_security_group_common_id
  db_sg_id = module.db.db_sg_id
}

module "eks_cluster" {
  source                  = "./modules/eks"
  my_vpc_id               = module.instance.my_vpc_id
  consul_security_group_id = module.consul_cluster.consul_security_group_id
  private_subnet_ids_list = module.instance.private_subnet_ids_list
  default_tags            = var.default_tags
  sg_node_exporter_id           = module.monitor_system.sg_node_exporter_id
  monitor_security_group_id = module.monitor_system.monitor_security_group_id
  jenkins_agent = module.jenkins.jenkins_agent
  jenkins_agent_role_arn  = module.jenkins.jenkins_agent_role_arn
  consul_join_tag_key          = var.consul_join_tag_key
  consul_join_tag_value        = var.consul_join_tag_value
}

module "jenkins" {
  source                       = "./modules/jenkins"
  key_name                     = module.ssh-key.key_name
  my_vpc_id                    = module.instance.my_vpc_id
  default_tags                 = var.default_tags
  subnet_id                    = module.instance.private_subnet_ids_list
  sg_all_worker_managment_id   = module.eks_cluster.sg_all_worker_managment_id
  consul_security_group_id     = module.consul_cluster.consul_security_group_id
  aws_security_group_common_id = module.instance.aws_security_group_common_id
  alb_security_group           = module.instance.alb_security_group
  consul_join_tag_key          = var.consul_join_tag_key
  consul_join_tag_value        = var.consul_join_tag_value
  sg_node_exporter_id           = module.monitor_system.sg_node_exporter_id

}

module "monitor_system"{
  source                       ="./modules/monitor"
  # data_ubuntu_ami_id            = module.instance.data_ubuntu_ami_id
  private_subnet_ids_list = module.instance.private_subnet_ids_list
  my_vpc_id               = module.instance.my_vpc_id
  key_name                      = module.ssh-key.key_name
  sg_all_worker_managment_id   = module.eks_cluster.sg_all_worker_managment_id
  consul_security_group_id     = module.consul_cluster.consul_security_group_id
  aws_security_group_common_id = module.instance.aws_security_group_common_id
  alb_security_group           = module.instance.alb_security_group
  default_tags            = var.default_tags
   consul_join_tag_key          = var.consul_join_tag_key
  consul_join_tag_value        = var.consul_join_tag_value
}

module "elk" {
  source                   = "./modules/elk/"
  data_ubuntu_ami_id        = module.instance.data_ubuntu_ami_id
  key_name                      = module.ssh-key.key_name
  aws_iam_instance_profile_name = module.consul_cluster.aws_iam_instance_profile_name
  private_subnet_id_for_ansible = module.instance.private_subnet_id_for_ansible
  consul_security_group_id     = module.consul_cluster.consul_security_group_id
  aws_security_group_common_id = module.instance.aws_security_group_common_id
  sg_node_exporter_id           = module.monitor_system.sg_node_exporter_id
  default_tags            = var.default_tags
  consul_join_tag_value        = var.consul_join_tag_value
  my_vpc_id             = module.instance.my_vpc_id
  finalproject_tls_arn = module.instance.finalproject_tls_arn
  private_subnet_ids_list = module.instance.private_subnet_ids_list
}

module "ssh-key" {
  source = "./modules/ssh-key"
}
