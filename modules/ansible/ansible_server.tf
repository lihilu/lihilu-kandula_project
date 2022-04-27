// Configure the ansible server in a private subnet
resource "aws_instance" "ansible_server" {
  ami                         = var.data_ubuntu_ami_id
  count                       = var.ansible_server
  associate_public_ip_address = false
  instance_type               = var.instance_type_ansible
  key_name                    = var.key_name
  subnet_id                   = var.private_subnet_id_for_ansible
  vpc_security_group_ids      = [var.security_group_db_id]
  user_data                   = local.ansible_server-userdata
  iam_instance_profile        = var.aws_iam_instance_profile_name
  tags = {
    "Name" = "ansible-server"
    "purpose" = var.default_tags
  }
}
