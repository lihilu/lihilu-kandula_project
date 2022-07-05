resource "aws_alb" "elk_alb" {
  name               = "elk-alb-${var.my_vpc_id}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elk_alb_sg.id]
  subnets            = var.private_subnet_ids_list

  tags = {
    Name = "elk-alb"
  }

  depends_on = [
    aws_instance.elk
  ]
}

resource "aws_alb_target_group" "elk_alb" {
  name     = "elk-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.my_vpc_id

  health_check {
    enabled = true
    path    = "/status"
    port    = 5601
    matcher = "200"
  }

  tags = {
    Name = "elk-alb-tg"
  }
}


resource "aws_alb_target_group_attachment" "elk_alb" {
  count            = length(aws_instance.elk)
  target_group_arn = aws_alb_target_group.elk_alb.arn
  target_id        = aws_instance.elk[count.index].id
  port             = 5601
  depends_on = [
    aws_instance.elk
  ]
}

resource "aws_alb_listener" "elk_alb" {
  load_balancer_arn = aws_alb.elk_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.elk_alb.arn
  }

  tags = {
    Name = "elk_alb_listener"
  }
}

resource "aws_alb_listener" "elk_https_alb" {
  load_balancer_arn = aws_alb.elk_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.finalproject_tls_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.elk_alb.arn
  }
}

resource "aws_security_group" "elk_alb_sg" {
  name        = "elk-alb-sg"
  description = "Allow kibana ui from world"
  vpc_id      = var.my_vpc_id
  tags = {
    Name = "elk-alb-sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elk_alb_http_all" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elk_alb_sg.id
}

resource "aws_security_group_rule" "elk_alb_https_all" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elk_alb_sg.id
}

resource "aws_security_group_rule" "elk_alb_out_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elk_alb_sg.id
}

output "elk_public_dns" {
  value = ["${aws_alb.elk_alb.dns_name}"]
}
