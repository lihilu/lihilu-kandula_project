// Configure the ansible server in a private subnet
resource "aws_instance" "ansible_server" {
  ami                         = var.data_ubuntu_ami_id
  count                       = var.ansible_server
  associate_public_ip_address = false
  instance_type               = var.instance_type_ansible
  key_name                    = var.key_name
  subnet_id                   = var.private_subnet_id_for_ansible
  vpc_security_group_ids      = [var.sg_node_exporter_id,var.consul_security_group_id]
  user_data                   = local.ansible_server-userdata
  iam_instance_profile        = aws_iam_instance_profile.ansible.name
  tags = {
    Name    = "ansible-server"
    ansible = "server"
    purpose = var.default_tags
    monitor = "node_exporter"
    consul_join = var.consul_join_tag_value
    consul= "agent"
  }

  provisioner "file" {
    source      = "~/Documents/GitHub/kandula_project/lihilu-kandula_project/project_instance_key.pem"
    destination = "/tmp/"

    connection {
      user                = "ubuntu"
      private_key         = file(var.key_local)
      bastion_host        = var.bastion_public_ip[0]
      bastion_private_key = file(var.key_local)
      agent               = false
      host                = aws_instance.ansible_server[count.index].private_ip
    }
  }
  connection {
    user                = "ubuntu"
    private_key         = file(var.key_local)
    bastion_host        = var.bastion_public_ip[0]
    bastion_private_key = file(var.key_local)
    agent               = false
    host                = aws_instance.ansible_server[count.index].private_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/tmp ~/.ssh/project_instance_key.pem",
      "sudo chown ubuntu:ubuntu ~/.ssh/project_instance_key.pem",
      "sudo chmod 400 ~/.ssh/project_instance_key.pem",
    ]
  }
}
