

output "bastion_public_ip" {
  value       = module.instance.bastion_public_ip
  description = "bastion public ip"
}

# output "bastion_private_ip" {
#   value       = module.instance.bastion_private_ip
#   description = "bastion private ip"
# }

output "alb_dns" {
  value       = module.instance.alb_dns
  description = "LB DNS"
}

output "ansible_server_private_ip" {
  value       = module.ansible_server.ansible_server_private_ip
  description = "ansible private ip"
}

output "jenkins_server_ip" {
  value       = module.jenkins.jenkins_server_ip
  description = "jenkins server ip"
}

output "jenkins_agent_ips" {
  value       = module.jenkins.jenkins_agent_ips
  description = "bastion agent ips"
}

output "finalproject_tls_arn"{
  value = module.instance.finalproject_tls_arn
  description = "arn for kubernetes yaml file"
}

output "certificate_id" {
  value = "${split("/",module.instance.finalproject_tls_arn)[1]}"
  description = "Certificate id for kubernetes yaml file"
}

output "db_endpoint" {
  value = module.db.db_endpoint
  description = "Database endpoint"
}

output "monitor_server_ip" {
  value = module.monitor_system.monitor_server_ip
  description = "monitor private ip"
}

# output "db_admin" {
#     sensitive = true
#     value = module.db.db_admin
# }

# output "db_pass" {
#     sensitive = true
#     value = module.db.db_pass
# }

