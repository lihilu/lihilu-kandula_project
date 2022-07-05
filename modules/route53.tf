#manually configured to prevent destroy

data "aws_route53_zone" "hosted_zone_53" {
  name         = var.route53_host_zone_name
  private_zone = false
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.hosted_zone_53.zone_id
  name    = "finalproject.ops.club"
  type    = "CNAME"
  allow_overwrite = true
  ttl     = "60"
  records = [aws_alb.web-alb.dns_name]
}

resource "aws_route53_record" "www_elk" {
  zone_id = data.aws_route53_zone.hosted_zone_53.zone_id
  name    = "elk.ops.club"
  type    = "CNAME"
  allow_overwrite = true
  ttl     = "60"
  records = [var.elk_alb_dns_name]
}