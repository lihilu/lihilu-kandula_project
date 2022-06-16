data "aws_ami" "ubuntu_monitor" {
  most_recent = true

  filter {
    name   = "name"
    values = ["grafana_prometheus"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["314452776120"] # Canonical
}

resource "aws_instance" "monitor" {
  count         = var.monitor_servers
  ami           = data.aws_ami.ubuntu_monitor.id
  instance_type = var.monitor_instance_type

  subnet_id              = var.private_subnet_ids_list[0]
  vpc_security_group_ids = [
   aws_security_group.monitor_sg.id,   
   var.aws_security_group_common_id,
   var.consul_security_group_id,
   var.sg_all_worker_managment_id]
  key_name               = var.key_name

  tags = {
    Name  = "Monitor-${count.index}"
    consul_join = var.consul_join_tag_value
    consul      = "agent"
    monitor = "graphan and prometheus"
  }
}