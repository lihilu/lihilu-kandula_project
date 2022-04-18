
module "instance" {
  source     = "./modules/"
#   subnet_public_id= [var.subnet_public_id]
#   subnet_private_id = [var.subnet_private_id]
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
}

module "ssh-key" {
  source = "./modules/ssh-key"
}