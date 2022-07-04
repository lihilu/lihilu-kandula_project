#Monitoring Security Group
resource "aws_security_group" "monitor_sg" {
  name        = "monitor_sg_1"
  description = "Security group for monitoring server"
  vpc_id      = var.my_vpc_id
      ## Incoming roles
     ingress {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       self        = true
       description = "Allow all inside security group"
     }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Connection"
  }
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [var.alb_security_group]
    description     = "Allow all traffic to HTTP port 3000"
  }
   ingress {
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [var.alb_security_group]
    description     = "Allow all traffic to HTTP port 9090"
  }
    ingress {
    from_port       = 8000
    to_port         = 8900
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [var.alb_security_group]
    description     = "Allow all traffic 8000 8900"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "node_exporter_sg" {
  name        = "node-exporter-sg"
  description = "Security group for node-exporter"
  vpc_id      = var.my_vpc_id
  tags = {
    Name = "node-exporter-sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "node_exporter" {
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description       = "Allow node_exporter port within group"
  security_group_id = aws_security_group.node_exporter_sg.id
}


# resource "aws_security_group" "node_exporter_sg" {
#   name        = "node_exporter_sg"
#   description = "Security group for node exporter"
#   vpc_id      = var.my_vpc_id
#       ## Incoming roles
#      ingress {
#        from_port   = 9100
#        to_port     = 9100
#        protocol    = "tcp"
#        self        = true
#        description = "Allow all inside security group"
#      }
# }