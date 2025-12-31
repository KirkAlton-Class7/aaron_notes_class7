# for ASG EC2 instances

resource "aws_security_group" "web_tier" {
  name        = "allow_http_ssh_web_app"
  description = "Allow inbound HTTP and SSH for web apps in web tier"
  vpc_id      = aws_vpc.main.id
  # <resource type>.<resource local name>.<attribute type> 

  tags = {
    Name = "allow-http-ssh-web-app"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web_tier_allow_http" {
  security_group_id = aws_security_group.web_tier.id
  # ALB SG ID goes here (ALB is the source of HTTP traffic for web apps)
  referenced_security_group_id = aws_security_group.web_load_balancer.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "web_tier_allow_ssh" {
  security_group_id = aws_security_group.web_tier.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "web_tier_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.web_tier.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

