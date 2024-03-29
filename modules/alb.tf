
resource "aws_alb" "web-alb" {
  name               = "alb-${aws_vpc.vpc.id}"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "alb-all"
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "alb-security-group"
  vpc_id = aws_vpc.vpc.id
  ## Incoming roles
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow 443 certificate access"
  }
  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access"
  }
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow kubana UI access"
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow jenkins UI access"
  }
   ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow monitor UI access"
  }
   ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow monitor UI access"
  }
   ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow monitor UI access"
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



resource "aws_alb_listener" "jenkins_https_alb" {
   load_balancer_arn = aws_alb.web-alb.arn
   port              = "443"
   protocol          = "HTTPS"
   ssl_policy        = "ELBSecurityPolicy-2016-08"
   certificate_arn   = aws_acm_certificate.kandula_tls.arn
   default_action {
     type             = "forward"
     target_group_arn = aws_alb_target_group.jenkins_server.arn
   }
 }



resource "aws_alb_listener" "monitor_grafana_listener" {
  load_balancer_arn = aws_alb.web-alb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.monitor_grafana_server.arn
  }

  tags = {
    Name = "monitor_grafana_alb_listener"
  }
}
resource "aws_alb_target_group" "monitor_grafana_server" {
  name     = "monitor-grafana-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled = true
    path    = "/"
    port    = 3000
  }

  tags = {
    Name = "monitor-alb-tg"
  }
}

resource "aws_alb_target_group_attachment" "monitor_grafana_server" {
  target_group_arn = aws_alb_target_group.monitor_grafana_server.arn
  target_id        = var.monitor_server_id
  port             = 3000
  depends_on = [
    var.monitor_server_id
  ]
}



resource "aws_alb_listener" "monitor_prometheus_listener" {
  load_balancer_arn = aws_alb.web-alb.arn
  port              = 9090
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.monitor_prometheus_server.arn
  }

  tags = {
    Name = "monitor_alb_listener"
  }
}
resource "aws_alb_target_group" "monitor_prometheus_server" {
  name     = "monitor-prometheus-server-tg"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled = true
    path    = "/"
    port    = 9090
  }

  tags = {
    Name = "monitor-prometheus-alb-tg"
  }
}

resource "aws_alb_target_group_attachment" "monitor_prometheus_server" {
  target_group_arn = aws_alb_target_group.monitor_prometheus_server.arn
  target_id        = var.monitor_server_id
  port             = 9090
  depends_on = [
    var.monitor_server_id
  ]
}

resource "aws_alb_listener" "kibana_listener" {
  load_balancer_arn = aws_alb.web-alb.arn
  port              = 5601
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.kibana_server.arn
  }

  tags = {
    Name = "kibana_alb_listener"
  }
}
resource "aws_alb_target_group" "kibana_server" {
  name     = "kibana-server-tg"
  port     = 5601
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled = true
    path    = "/"
    port    = 5601
  }

  tags = {
    Name = "kibana-alb-tg"
  }
}

resource "aws_alb_target_group_attachment" "kibana_server" {
  target_group_arn = aws_alb_target_group.kibana_server.arn
  target_id        = var.elk_server_id
  port             = 5601
  depends_on = [
    var.elk_server_id
  ]
}
