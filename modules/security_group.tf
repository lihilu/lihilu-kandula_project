
######################################################################
######################## SECURITY GROUPS ##############################
######################################################################


resource "aws_security_group" "common_sg" {
  name               = "common-sg"
  description        = "Allow ssh, ping and egress traffic"
  vpc_id             = aws_vpc.vpc.id
  tags = {
    Name             = format("%s-common-sg", var.global_name_prefix)
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


######################################################################
######################## SECURITY GROUPS - DB #######################
######################################################################

resource "aws_security_group" "DB_instnaces_access" {
  vpc_id = aws_vpc.vpc.id
  name   = " DB-access"
  tags = {
    Name             = format("%s-DB-access", var.global_name_prefix)
  }
}

resource "aws_security_group_rule" "DB_ssh_acess" {
  description       = "allow ssh access from anywhere"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.DB_instnaces_access.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "DB_outbound_anywhere" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.DB_instnaces_access.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

