resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow postgres ports"
  # for project vpc should be from module
  vpc_id = var.my_vpc_id
  tags = {
    Name = "rds_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds_sg" {
  type                     = "ingress"
  from_port                = aws_db_instance.kandula_db.port
  to_port                  = aws_db_instance.kandula_db.port
  protocol                 = "tcp"
  source_security_group_id = var.source_security_group_id_common
  description              = "Allow psql port tcp"
  security_group_id        = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "rds_from_eks" {
  type                     = "ingress"
  from_port                = aws_db_instance.kandula_db.port
  to_port                  = aws_db_instance.kandula_db.port
  protocol                 = "tcp"
  source_security_group_id = var.source_security_group_id_kube
  description              = "Allow psql port tcp connect to kube"
  security_group_id        = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "rds_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow ssh from vpc"
  security_group_id = aws_security_group.rds_sg.id
}

# resource "aws_security_group_rule" "rds_egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   description       = "Allow communication between instances"
#   security_group_id = aws_security_group.rds_sg.id
# }
