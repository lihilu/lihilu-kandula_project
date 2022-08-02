
module "instance" {
  source                   = "./modules/"
  consul_security_group_id = module.consul_cluster.consul_security_group_id
  jenkins_server_id        = module.jenkins.jenkins_server_id
  key_name                 = module.ssh-key.key_name
  default_tags             = var.default_tags
  consul_join_tag_key      = var.consul_join_tag_key
  consul_join_tag_value    = var.consul_join_tag_value
}

module "consul_cluster" {
  source                = "./modules/consul"
  my_vpc_id             = module.instance.my_vpc_id
  key_name              = module.ssh-key.key_name
  target_group_arns     = module.instance.target_group_arns
  private_subnet_id     = module.instance.private_subnet_id
  alb_security_group    = module.instance.alb_security_group
  default_tags          = var.default_tags
  consul_join_tag_key   = var.consul_join_tag_key
  consul_join_tag_value = var.consul_join_tag_value
}

module "ansible_server" {
  source                        = "./modules/ansible"
  key_name                      = module.ssh-key.key_name
  security_group_db_id          = module.instance.security_group_db_id
  private_subnet_id_for_ansible = module.instance.private_subnet_id_for_ansible
  data_ubuntu_ami_id            = module.instance.data_ubuntu_ami_id
  aws_iam_instance_profile_name = module.consul_cluster.aws_iam_instance_profile_name
  bastion_public_ip             = module.instance.bastion_public_ip
  default_tags                  = var.default_tags
  key_local                     = module.ssh-key.key_local
}

module "eks_cluster" {
  source                  = "./modules/eks"
  my_vpc_id               = module.instance.my_vpc_id
  private_subnet_ids_list = module.instance.private_subnet_ids_list
  default_tags            = var.default_tags
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
}

module "ssh-key" {
  source = "./modules/ssh-key"
}
