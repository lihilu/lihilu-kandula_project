## Jenkins security group
resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins_sg"
  vpc_id = var.my_vpc_id
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
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = [var.alb_security_group]
      description     = "UI"
      }
      ingress {
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "promethos Connection"
      }
      egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      }
    tags = {
      Name = format("jenkins-sg-%s", var.default_tags)
    }
}
