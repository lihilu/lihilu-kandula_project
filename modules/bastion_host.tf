
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
variable "ubuntu_account_number" {
  default = "099720109477"
}

# get my external ip 
data "http" "myip" {
  url = "http://ifconfig.me"
}

# Configure the EC2 instance in a public subnet as bastion_host
resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.ubuntu.id
  count                       = var.num_web_server
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.web_admin.name
  subnet_id                   = aws_subnet.public[count.index].id

  vpc_security_group_ids = [
    aws_security_group.common_sg.id,
    aws_security_group.bastion_sg.id,
    var.consul_security_group_id
  ]

  user_data = local.bastion_connect_ssh

  tags = {
    Name         = "bastion-host"
    bastion_host = "true"
    purpose      = var.default_tags
    consul = "agent"
    consul_join = var.consul_join_tag_value
  }

}
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow ssh and ping"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "bastion-sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${data.http.myip.body}/32"]
  description       = "Allow ssh from owner"
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["${data.http.myip.body}/32"]
  description       = "Allow ping from owner"
  security_group_id = aws_security_group.bastion_sg.id
}
