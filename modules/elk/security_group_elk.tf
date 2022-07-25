resource "aws_security_group" "elk_sg" {
  name        = "elk-sg"
  description = "SG for ELK"
  vpc_id      = var.my_vpc_id
  tags = {
    Name = "elk-sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elasticsearch_rest_tcp" {
  type              = "ingress"
  from_port         = 9100
  to_port           = 9200
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow elk rest tcp"
  security_group_id = aws_security_group.elk_sg.id
}

resource "aws_security_group_rule" "elasticsearch_java_tcp" {
  type              = "ingress"
  from_port         = 9300
  to_port           = 9300
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow elk java tcp"
  security_group_id = aws_security_group.elk_sg.id
}

resource "aws_security_group_rule" "kibana_tcp" {
  type              = "ingress"
  from_port         = 5601
  to_port           = 5601
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow kibana ui"
  security_group_id = aws_security_group.elk_sg.id
}

resource "aws_security_group_rule" "all_ports_engress" {
  security_group_id = aws_security_group.elk_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

}

