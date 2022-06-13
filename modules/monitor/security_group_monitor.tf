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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
