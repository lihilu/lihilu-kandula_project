

output "bastion_public_ip" {
  value       =  module.instance.bastion_public_ip
  description = "bastion public ip"
}

output "bastion_private_ip" {
  value       =  module.instance.bastion_private_ip
  description = "bastion private ip"
}

output "alb_dns"{
  value = module.instance.alb_dns
  description = "LB DNS"
  }

output "ansible_server_private_ip" {
  value       =  module.ansible_server.ansible_server_private_ip
  description = "ansible private ip"
}