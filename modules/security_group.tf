
######################################################################
######################## SECURITY GROUPS ##############################
######################################################################


resource "aws_security_group" "common_sg" {
  name        = "common-sg"
  description = "Allow ssh, ping and egress traffic"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "common-sg"
  }
  # lifecycle {
  #   create_before_destroy = true
  # }
}

resource "aws_security_group_rule" "nginx_http_acess" {
  description       = "allow http access from anywhere"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.common_sg.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = [var.destination_cidr_block]
}


resource "aws_security_group_rule" "nginx_ssh_acess" {
  description       = "allow ssh access from anywhere"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.common_sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = [var.destination_cidr_block]
}

resource "aws_security_group_rule" "nginx_outbound_anywhere" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.common_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = [var.destination_cidr_block]
}

resource "aws_security_group_rule" "ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  self              = true
  description       = "Allow ping"
  security_group_id = aws_security_group.common_sg.id
}

