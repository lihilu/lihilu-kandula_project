resource "aws_instance" "elk" {
  ami                         = var.data_ubuntu_ami_id
  instance_type               = var.elk_instance_type
  key_name                    = var.key_name
  iam_instance_profile        = var.aws_iam_instance_profile_name
  subnet_id                   = var.private_subnet_id_for_ansible
  associate_public_ip_address = false

  vpc_security_group_ids = [
    var.aws_security_group_common_id,
    var.consul_security_group_id,
    var.sg_node_exporter_id,
    aws_security_group.elk_sg.id
  ]

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name                = "elk"
    elk_server          = "elk_true"
    consul_join   = var.consul_join_tag_value
    consul          = "agent"
    monitor = "node_exporter"
  }
}