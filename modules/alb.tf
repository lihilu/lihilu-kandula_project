
resource "aws_alb" "web-alb" {
  name               = "alb-${aws_vpc.vpc.id}"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = format("alb-%s", var.global_name_prefix)
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "alb-security-group"
  vpc_id = aws_vpc.vpc.id
  ## Incoming roles
  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access"
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow jenkins UI access"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb-sg"
  }
}


resource "aws_alb_listener" "consul" {
  load_balancer_arn = aws_alb.web-alb.arn
  port              = 8500
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.consul-server.arn
  }
}


resource "aws_alb_target_group" "consul-server" {
  name     = "consul-server-target-group"
  port     = 8500
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    enabled  = true
    path     = "/ui/"
    port     = 8500
    timeout  = 8
    interval = 10
    matcher  = "200" # has to be HTTP 200 or fails
  }
}


# resource "aws_alb_target_group_attachment" "web_server" {
#   count            = length(aws_instance.ec2_db)
#   target_group_arn = aws_alb_target_group.consul-server.id
#   target_id        = aws_instance.ec2_db.*.id[count.index]
#   port             = 80
# }

resource "aws_alb_listener" "jenkins_listener" {
  load_balancer_arn = aws_alb.web-alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.jenkins_server.arn
  }

  tags = {
    Name = "jenkins_alb_listener"
  }
}
resource "aws_alb_target_group" "jenkins_server" {
  name     = "jenkins-server-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled = true
    path    = "/"
    port    = 8080
  }

  tags = {
    Name = "jenkins-alb-tg"
  }
}

resource "aws_alb_target_group_attachment" "jenkins_server" {
  target_group_arn = aws_alb_target_group.jenkins_server.arn
  target_id        = var.jenkins_server_id
  port             = 8080
  depends_on = [
    var.jenkins_server_id
  ]
}



# resource "aws_alb_listener" "jenkins_https_alb" {
#   load_balancer_arn = aws_lb.jenkins_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate.kandula_tls.arn
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.jenkins_alb.arn
#   }
# }

