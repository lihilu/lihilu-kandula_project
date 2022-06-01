
resource "aws_acm_certificate" "kandula_tls" {
 domain_name       = "*.ops.club"
 validation_method = "DNS"

  tags = {
    Environment = "prod"
  }

#   lifecycle {
#     create_before_destroy = true
#   }
}

 resource "aws_acm_certificate_validation" "validation" {
   timeouts {
     create = "15m"
   }
   certificate_arn         = aws_acm_certificate.kandula_tls.arn
   validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]
 }

 resource "aws_route53_record" "cert_validation_record" {
   for_each = {
     for dvo in aws_acm_certificate.kandula_tls.domain_validation_options : dvo.domain_name => {
       name   = dvo.resource_record_name
       record = dvo.resource_record_value
       type   = dvo.resource_record_type
     }
   }

   allow_overwrite = true
   name            = each.value.name
   records         = [each.value.record]
   ttl             = 60
   type            = each.value.type
   zone_id         = "Z0312079349EEESZ08KQS"
 }

