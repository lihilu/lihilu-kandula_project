variable "aws_region" {
  default = "us-east-1"
  type    = string
}
variable "default_tags" {
  default = "kandula_project"
  type    = string
}

variable "consul_join_tag_key" {
  description = "The key of the tag to auto-jon on EC2."
  default     = "consul_join"
}

variable "consul_join_tag_value" {
  description = "The value of the tag to auto-join on EC2."
  default     = "training"
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