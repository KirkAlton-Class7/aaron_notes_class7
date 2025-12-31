locals {
  domain_name = "dunder-mifflin-cloud-company.click"
}

data "aws_route53_zone" "main" {
  name         = local.domain_name
  private_zone = false
}

data "aws_acm_certificate" "main" {
  domain      = local.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}


resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.web_tier.dns_name
    zone_id                = aws_lb.web_tier.zone_id
    evaluate_target_health = true
  }
}