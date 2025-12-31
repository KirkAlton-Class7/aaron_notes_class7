# ===================================
# Web Tier Security Group (no variables/locals)
# ===================================

resource "aws_security_group" "web_tier" {
  name        = "terraform-vars-lab-dev-web-tier-sg"
  description = "Security group for web tier EC2 instances"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "terraform-vars-lab-dev-web-tier-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web_tier.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  description = "Allow HTTP from anywhere"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web_tier.id

  cidr_ipv4   = "10.10.0.0/16"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  description = "Allow SSH from VPC"
}

resource "aws_vpc_security_group_egress_rule" "web_tier_all_outbound" {
  security_group_id = aws_security_group.web_tier.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}
