output "lb_url" {
  value = "http://${aws_lb.web_tier.dns_name}"
}