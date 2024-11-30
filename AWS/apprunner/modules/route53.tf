# data "aws_route53_zone" "this" {
#   name = var.domain
# }

# resource "aws_route53_record" "appruner-poc-record" {
#   zone_id = data.aws_route53_zone.this.zone_id
#   name    = aws_apprunner_custom_domain_association.domain_name.domain_name
#   type    = "CNAME"
#   ttl     = "300"
#   records = [aws_apprunner_custom_domain_association.domain_name.dns_target]
# }

#apprunnerが成功しないため一旦保留