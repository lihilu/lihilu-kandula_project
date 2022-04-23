
resource "tls_private_key" "project_instance_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "project_instance_key" {
  key_name   = "project_instance_key"
  public_key = tls_private_key.project_instance_key.public_key_openssh
}
# Save generated key pair locally
resource "local_file" "server_key" {
  sensitive_content  = tls_private_key.project_instance_key.private_key_pem
  filename           = "project_instance_key.pem"
}
