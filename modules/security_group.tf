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

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  self              = true
  description       = "Allow ssh from the world"
  security_group_id = aws_security_group.common_sg.id
}

resource "aws_security_group_rule" "out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outside security group"
  security_group_id = aws_security_group.common_sg.id

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

resource "aws_security_group_rule" "web_http_access" {
  description       = "allow http access from anywhere"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.common_sg.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]

}

######################################################################
######################## SECURITY GROUPS - DB #######################
######################################################################

resource "aws_security_group" "DB_instnaces_access" {
  vpc_id = aws_vpc.vpc.id
  name   = " DB-access"
  tags = {
    "Name" = " DB-access"
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



# ##########################################


# ####DB - Security Group
# resource "aws_security_group" "DB_instnaces_access" {
#   vpc_id = aws_vpc.vpc.id
#   name   = " DB-access"

#   tags = {
#     "Name" = " DB-access"
#   }
# }

# resource "aws_security_group_rule" "DB_ssh_acess" {
#   description       = "allow ssh access from anywhere"
#   from_port         = var.sshport
#   protocol          = "tcp"
#   security_group_id = aws_security_group.DB_instnaces_access.id
#   to_port           = var.sshport
#   type              = "ingress"
#   cidr_blocks       = [var.cidr_blocks]
# }

# resource "aws_security_group_rule" "DB_outbound_anywhere" {
#   description       = "allow outbound traffic to anywhere"
#   from_port         = 0
#   protocol          = "-1"
#   security_group_id = aws_security_group.DB_instnaces_access.id
#   to_port           = 0
#   type              = "egress"
#   cidr_blocks       = [var.cidr_blocks]
# }

