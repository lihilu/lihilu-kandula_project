resource "aws_alb" "elk_alb" {
  name               = "elk-alb-${var.my_vpc_id}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_elk_sg.id]
  subnets            = var.private_subnet_ids_list

  tags = {
    Name = "elk-alb"
  }

  depends_on = [
    aws_instance.elk
  ]
}


resource "aws_security_group" "alb_elk_sg" {
  name   = "alb-elk-security-group"
  vpc_id = var.my_vpc_id
  ## Incoming roles
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow 443 certificate access"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow  UI access"
  }
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow kibana UI access"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb-elk-sg"
  }
}


resource "aws_alb_listener" "elk_alb" {
  load_balancer_arn = aws_alb.elk_alb.arn
  port              = 5601
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.elk_tg.arn
  }

  tags = {
    Name = "elk_alb_listener"
  }
}


resource "aws_alb_listener" "elk_https_alb" {
  load_balancer_arn = aws_alb.elk_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.finalproject_tls_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.elk_tg.arn
  }
}

output "elk_public_dns" {
  value = ["${aws_alb.elk_alb.dns_name}"]
}


resource "aws_alb_target_group" "elk_tg" {
  name     = "elk-target-group"
  port     = 5601
  protocol = "HTTP"
  vpc_id   = var.my_vpc_id
  health_check {
    enabled  = true
    path     = "/ui/"
    port     = 5601
    timeout  = 8
    interval = 10
    matcher  = "200" # has to be HTTP 200 or fails
  }
}


resource "aws_alb_target_group_attachment" "elk_alb" {
  count            = length(aws_instance.elk)
  target_group_arn = aws_alb_target_group.elk_tg.arn
  target_id        = aws_instance.elk[count.index].id
  port             = 5601
  depends_on = [
    aws_instance.elk
  ]
}
