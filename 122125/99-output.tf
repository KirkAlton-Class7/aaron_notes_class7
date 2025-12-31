output "lb_url" {
  value       = "http://${aws_lb.web_tier.dns_name}"
  description = "fully qualified domain name/URL for LB"
}

output "fqdn" {
  value = {
    http  = "http://${local.domain_name}"
    https = "https://${local.domain_name}"
    fixed = "http://${local.domain_name}:8000"
  }
  description = "fully qualified domain name/URL for r53 domain"
}
