resource "aws_lb" "web-alb" {
  name                       = "alb-${aws_vpc.vpc.id}"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = aws_subnet.public.*.id
  security_groups            = [aws_security_group.common_sg.id]

  tags = {
    Name             = format("%s-alb", var.global_name_prefix)
  }
}


resource "aws_lb_listener" "web-alb-listener" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-alb-tg.arn
  }
}

resource "aws_lb_target_group" "web-alb-tg" {
  name     = "web-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled = true
    path    = "/"
  }

  tags = {
    Name = "web-target-group-${aws_vpc.vpc.id}"
  }
}

resource "aws_lb_target_group_attachment" "web_server" {
  count            = length(aws_instance.ec2_web)
  target_group_arn = aws_lb_target_group.web-alb-tg.id
  target_id        = aws_instance.ec2_web.*.id[count.index]
  port             = 80
}
