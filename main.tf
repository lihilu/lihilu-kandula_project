
module "instance" {
  source     = "./modules/"
  consul_security_group_id= module.consul_cluster.consul_security_group_id
  bastion_private_ip = module.instance.bastion_private_ip
#   aws_vpc =  var.vpc
#   sg_pub_id = var.sg_pub_id
#   sg_priv_id  = var.sg_priv_id
  key_name   = module.ssh-key.key_name
}

module"consul_cluster" {
  source = "./modules/consul"
  my_vpc_id              = module.instance.my_vpc_id
  key_name               = module.ssh-key.key_name
  target_group_arns      = module.instance.target_group_arns
  private_subnet_id      = module.instance.private_subnet_id
  lb_security_group      = module.instance.lb_security_group
}

module "ansible_server"{
  source = "./modules/ansible"
  key_name = module.ssh-key.key_name
  security_group_db_id=module.instance.security_group_db_id
  private_subnet_id_for_ansible      = module.instance.private_subnet_id_for_ansible
  data_ubuntu_ami_id     = module.instance.data_ubuntu_ami_id
}

module "ssh-key" {
  source = "./modules/ssh-key"
}