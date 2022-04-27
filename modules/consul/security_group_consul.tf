
resource "aws_security_group" "consul_security_group" {
  name        = "consul-sg"
  description = "Consul servers"
  vpc_id      = var.my_vpc_id
}

resource "aws_security_group_rule" "consul_ssh" {
  security_group_id = aws_security_group.consul_security_group.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

}

# rule to allow egress from 443 to 443 externally
resource "aws_security_group_rule" "consul_external_egress_https" {
  security_group_id = aws_security_group.consul_security_group.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# rule to allow egress from 80 to 80 externally
resource "aws_security_group_rule" "consul_external_egress_http" {
  security_group_id = aws_security_group.consul_security_group.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# rule to allow internal egress from 8300 to 8600 TCP
resource "aws_security_group_rule" "consul_internal_egress_tcp" {
  security_group_id        = aws_security_group.consul_security_group.id
  type                     = "egress"
  from_port                = 8300
  to_port                  = 8600
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.consul_security_group.id
}

# rule to allow internal egress from 8300 to 8600 UDP
resource "aws_security_group_rule" "consul_internal_egress_udp" {
  security_group_id        = aws_security_group.consul_security_group.id
  type                     = "egress"
  from_port                = 8300
  to_port                  = 8600
  protocol                 = "udp"
  source_security_group_id = aws_security_group.consul_security_group.id
}

// This rule allows Consul RPC.
resource "aws_security_group_rule" "consul_rpc" {
  security_group_id        = aws_security_group.consul_security_group.id
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.consul_security_group.id
}

// This rule allows Consul Serf TCP.
resource "aws_security_group_rule" "consul_serf_tcp" {
  security_group_id        = aws_security_group.consul_security_group.id
  type                     = "ingress"
  from_port                = 8301
  to_port                  = 8302
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.consul_security_group.id
}

// This rule allows Consul Serf UDP.
resource "aws_security_group_rule" "consul_serf_udp" {
  security_group_id        = aws_security_group.consul_security_group.id
  type                     = "ingress"
  from_port                = 8301
  to_port                  = 8302
  protocol                 = "udp"
  source_security_group_id = aws_security_group.consul_security_group.id
}

// This rule allows Consul API.
resource "aws_security_group_rule" "consul_api_tcp" {
  security_group_id        = aws_security_group.consul_security_group.id
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.consul_security_group.id
}

// This rule exposes the Consul API for traffic from the same CIDR block as approved SSH.
resource "aws_security_group_rule" "consul_ui_ingress" {
  security_group_id = aws_security_group.consul_security_group.id
  type              = "ingress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

}

// This rule allows Consul DNS.
resource "aws_security_group_rule" "consul_dns_tcp" {
  security_group_id        = aws_security_group.consul_security_group.id
  type                     = "ingress"
  from_port                = 8600
  to_port                  = 8600
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.consul_security_group.id
}

// This rule allows Consul DNS.
resource "aws_security_group_rule" "consul_dns_udp" {
  security_group_id        = aws_security_group.consul_security_group.id
  type                     = "ingress"
  from_port                = 8600
  to_port                  = 8600
  protocol                 = "udp"
  source_security_group_id = aws_security_group.consul_security_group.id
}


 resource "aws_security_group_rule" "consul_http_acess" {
     description       = "allow http access from anywhere"
     from_port         = 80
     protocol          = "tcp"
     security_group_id = aws_security_group.consul_security_group.id
     to_port           = 80
     type              = "ingress"
     cidr_blocks       = ["0.0.0.0/0"]
 }