# Security Group for HTTP traffic
# This allows incoming HTTP traffic on port 80
resource "aws_security_group" "http" {
  name        = "demo-http-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id
  
  tags = {
    Name = "demo-http-sg"
  }
}

# Ingress rule to allow HTTP traffic
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.http.id
  description       = "Allow HTTP from anywhere"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Egress rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.http.id
  description       = "Allow all outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
