

module "instance" {
  source     = "./modules/"
#   subnet_public_id= [var.subnet_public_id]
#   subnet_private_id = [var.subnet_private_id]
#   aws_vpc =  var.vpc
#   sg_pub_id = var.sg_pub_id
#   sg_priv_id  = var.sg_priv_id
  key_name   = module.ssh-key.key_name
}


module "ssh-key" {
  source    = "./modules/ssh-key"
}