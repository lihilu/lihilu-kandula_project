output "ansible_server_private_ip" {
  value = aws_instance.ansible_server.*.private_ip
}