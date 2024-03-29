data "aws_ami" "jenkins_server_ami" {
  most_recent = true
  owners      = ["${var.ami_owner}"]

  filter {
    name   = "name"
    values = ["${var.ami_name_filter}*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_ami" "jenkins_agent_ami" {
  most_recent = true
  owners      = ["${var.ami_owner}"]

  filter {
    name   = "name"
    values = ["${var.ami_name_filter_agent}*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.jenkins_server_ami.id
  instance_type               = "t2.medium"
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  subnet_id                   = var.subnet_id[0]
  associate_public_ip_address = false
  user_data                   = local.jenkins_server_userdata

  vpc_security_group_ids = [
    var.aws_security_group_common_id,
    var.consul_security_group_id,
    var.sg_all_worker_managment_id,
    var.sg_node_exporter_id,
    aws_security_group.jenkins_sg.id
  ]

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name           = "jenkins_server"
    jenkins        = "server"
    consul_join   = var.consul_join_tag_value
    consul          = "agent"
    monitor = "node_exporter"
  }
}


resource "aws_instance" "jenkins_agent" {
  ami                         = data.aws_ami.jenkins_agent_ami.id
  count                       = var.num_of_jenkins_agent
  instance_type               = "t2.medium"
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  subnet_id                   = var.subnet_id[count.index]
  associate_public_ip_address = false
  user_data                   = local.jenkins_agent_userdata

  vpc_security_group_ids = [
    var.aws_security_group_common_id,
    var.consul_security_group_id,
    var.sg_all_worker_managment_id,
    aws_security_group.jenkins_sg.id,
    var.sg_node_exporter_id
  ]

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name           = "jenkins_agent-${count.index}"
    jenkins = "agent"
    consul_join = var.consul_join_tag_value
    consul      = "agent"
    monitor = "node_exporter"
  }
}
