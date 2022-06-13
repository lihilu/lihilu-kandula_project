# data source for vanilla Ubuntu AWS AMI as base image for cluster
data "aws_ami" "ubuntu_16_consul" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# creates Consul autoscaling group for servers
resource "aws_autoscaling_group" "consul_servers" {
  name                 = aws_launch_configuration.consul_servers.name
  launch_configuration = aws_launch_configuration.consul_servers.name
  #availability_zones        = data.aws_availability_zones.available.zone_ids
  min_size                  = var.consul_servers
  max_size                  = var.consul_servers
  desired_capacity          = var.consul_servers
  wait_for_capacity_timeout = "480s"
  health_check_grace_period = 15
  health_check_type         = "EC2"
  vpc_zone_identifier       = ["${var.private_subnet_id}"]
  target_group_arns         = ["${var.target_group_arns}"]

  tags = [
    {
      key                 = "Name"
      value               = "consul-server"
      propagate_at_launch = true
    },
    {
      key                 = "consul"
      value               = "server"
      propagate_at_launch = true
    },
    {
      key                 = var.consul_join_tag_key
      value               = var.consul_join_tag_value
      propagate_at_launch = true
    },
    {
      key                 = "purpose"
      value               = var.default_tags
      propagate_at_launch = true
    },
  ]
  lifecycle {
    create_before_destroy = true
  }
}

# provides a resource for a new autoscaling group launch configuration
resource "aws_launch_configuration" "consul_servers" {
  name            = "consul-servers"
  image_id        = data.aws_ami.ubuntu_16_consul.id
  instance_type   = var.consul_instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.consul_security_group.id, var.alb_security_group]
  user_data       = local.consul_run_ansible_remote
  #associate_public_ip_address = var.public_ip
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  root_block_device {
    volume_type = "gp2"
    volume_size = 10
    #  iops        = "2500"
  }

  lifecycle {
    create_before_destroy = true
  }

}




#  # creates Consul autoscaling group for clients
# resource "aws_autoscaling_group" "consul_clients" {
#   name                 = aws_launch_configuration.consul_clients.name
#   launch_configuration = aws_launch_configuration.consul_clients.name
#   #availability_zones        = data.aws_availability_zones.available.zone_ids
#   min_size                  = var.consul_clients
#   max_size                  = var.consul_clients
#   desired_capacity          = var.consul_clients
#   wait_for_capacity_timeout = "480s"
#   health_check_grace_period = 15
#   health_check_type         = "EC2"
#   vpc_zone_identifier       = ["${var.private_subnet_id}"]
#   target_group_arns         = ["${var.target_group_arns}"]

#   tags = [
#     {
#       key                 = "Name"
#       value               = "consul-agent"
#       propagate_at_launch = true
#     },
#     {
#       key                 = var.consul_join_tag_key
#       value               = var.consul_join_tag_value
#       propagate_at_launch = true
#     },
#     {
#       key                 = "consul"
#       value               = "agent"
#       propagate_at_launch = true
#     },
#     {
#       key                 = "purpose"
#       value               = var.default_tags
#       propagate_at_launch = true
#     },

#   ]

#   depends_on = [aws_autoscaling_group.consul_servers]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # provides a resource for a new autoscaling group launch configuration
# resource "aws_launch_configuration" "consul_clients" {
#   name            = "consul-clients"
#   image_id        = data.aws_ami.ubuntu_16_consul.id
#   instance_type   = var.consul_instance_type
#   key_name        = var.key_name
#   security_groups = [aws_security_group.consul_security_group.id, var.alb_security_group]
#  # user_data       = local.consul_agent_userdata_hostname
#   # associate_public_ip_address = var.public_ip
#   iam_instance_profile = aws_iam_instance_profile.instance_profile.name
#   root_block_device {
#     volume_size = 10
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }