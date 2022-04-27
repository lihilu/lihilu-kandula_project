variable "aws_region" {
  default = "us-east-1"
  type    = string
}
 variable "default_tags"{
   default ="kandula_project"
   type    = string
 }

# variable "sg_pub_id" {
#   default = module.sg_pub_id
# }

# variable "sg_priv_id" {
#   default = module.sg_priv_id
# }


# variable "subnet_public_id" {
#   default = [module.subnet_public_id]
# }

# variable "subnet_private_id" {
#   default = [module.subnet_private_id]
# }