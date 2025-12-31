# ===================================
# Web Tier Security Group (for EC2 instances)
# ===================================

resource "aws_security_group" "web_tier" {
  name        = "${local.name_prefix}-web-tier"
  description = "Security group for web tier EC2 instances - allows HTTP from ALB and SSH from VPC"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = local.web_tier_sg_name
      Tier = "web"
    }
  )
}

# ===================================
# Web Tier Security Group Rules
# ===================================

# Allow HTTP from ALB security group
resource "aws_vpc_security_group_ingress_rule" "web_tier_http_from_alb" {
  security_group_id = aws_security_group.web_tier.id

  # Reference ALB security group (create ALB SG first or comment this out)
  referenced_security_group_id = aws_security_group.alb.id

  from_port   = var.web_tier_ports["http"].port
  to_port     = var.web_tier_ports["http"].port
  ip_protocol = var.web_tier_ports["http"].protocol

  description = var.web_tier_ports["http"].description

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-web-tier-http-from-alb"
    }
  )
}

# Allow SSH from within VPC
resource "aws_vpc_security_group_ingress_rule" "web_tier_ssh" {
  security_group_id = aws_security_group.web_tier.id

  cidr_ipv4 = local.ssh_cidr

  from_port   = var.web_tier_ports["ssh"].port
  to_port     = var.web_tier_ports["ssh"].port
  ip_protocol = var.web_tier_ports["ssh"].protocol

  description = var.web_tier_ports["ssh"].description

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-web-tier-ssh"
    }
  )
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "web_tier_all_outbound" {
  security_group_id = aws_security_group.web_tier.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow all outbound traffic"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-web-tier-egress"
    }
  )
}

# ===================================
# ALB Security Group (placeholder)
# ===================================

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb"
  description = "Security group for Application Load Balancer - allows HTTP/HTTPS from internet"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = local.alb_sg_name
      Tier = "alb"
    }
  )
}

# Allow HTTP from internet
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP from internet"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-http"
    }
  )
}

# Allow HTTPS from internet
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "Allow HTTPS from internet"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-https"
    }
  )
}

# Allow outbound to web tier on port 80
resource "aws_vpc_security_group_egress_rule" "alb_to_web_tier" {
  security_group_id = aws_security_group.alb.id

  referenced_security_group_id = aws_security_group.web_tier.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow traffic to web tier instances"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-to-web-tier"
    }
  )
}
