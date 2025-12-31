# ===================================
# Web Tier Security Group (demonstrates MAP variable usage)
# ===================================

resource "aws_security_group" "web_tier" {
  name        = "${local.name_prefix}-web-tier-sg"
  description = "Security group for web tier EC2 instances"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-web-tier-sg"
  }
}

# HTTP rule - demonstrates accessing MAP variable
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web_tier.id
  
  cidr_ipv4   = var.http_ingress_rule.cidr_blocks
  from_port   = var.http_ingress_rule.port
  to_port     = var.http_ingress_rule.port
  ip_protocol = var.http_ingress_rule.protocol
  description = var.http_ingress_rule.description
}

# SSH rule - demonstrates accessing MAP variable
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web_tier.id
  
  cidr_ipv4   = var.ssh_ingress_rule.cidr_blocks
  from_port   = var.ssh_ingress_rule.port
  to_port     = var.ssh_ingress_rule.port
  ip_protocol = var.ssh_ingress_rule.protocol
  description = var.ssh_ingress_rule.description
}

resource "aws_vpc_security_group_egress_rule" "web_tier_all_outbound" {
  security_group_id = aws_security_group.web_tier.id
  cidr_ipv4         = var.egress_rule_settings.cidr_ipv4
  ip_protocol       = var.egress_rule_settings.ip_protocol
  description       = var.egress_rule_settings.description
}