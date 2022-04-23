resource "aws_lb" "web-alb" {
  name                       = "alb-${aws_vpc.vpc.id}"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = aws_subnet.public.*.id
  security_groups            = [aws_security_group.lb_sg.id]

  tags = {
    Name             = format("%s-alb", var.global_name_prefix)
  }
}

resource "aws_security_group" "lb_sg" {
  name ="lb-security-group"
  vpc_id = aws_vpc.vpc.id
  ## Incoming roles
  ingress {
    from_port = 8500
    to_port =  8500
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "lb-sg"
  }
}


resource "aws_alb_listener" "consul" {
  load_balancer_arn =  aws_lb.web-alb.arn
  port              = 8500
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.consul-server.arn
  }
}


resource "aws_lb_target_group" "consul-server" {
  name     = "consul-server-target-group"
  port     = 8500
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    enabled = true
    path = "/"
    port = 8500
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 8
    interval = 10
    matcher = "200"  # has to be HTTP 200 or fails
  }
}



resource "aws_lb_target_group_attachment" "web_server" {
  count            = length(aws_instance.ec2_db)
  target_group_arn = aws_lb_target_group.consul-server.id
  target_id        = aws_instance.ec2_db.*.id[count.index]
  port             = 80
}
