
output "public_ips" {
  value       =  module.instance.public_ip
  description = "The public IP address of server instance."
}