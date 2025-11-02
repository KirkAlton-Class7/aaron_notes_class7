
# for web server only 
resource "aws_security_group" "web_server" {
  name        = "web_server"
  description = "Allow HTTP and SSH for web server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "web-server-ingress"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web_server.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.web_server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.web_server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

############################ SG for ping 
resource "aws_security_group" "ping" {
  name        = "ping"
  description = "Allow icmp for ping"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "icmp-for-ping"
  }
}

resource "aws_vpc_security_group_ingress_rule" "icmp" {
  security_group_id = aws_security_group.ping.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = -1
  ip_protocol = "icmp"
  to_port     = -1
}

resource "aws_vpc_security_group_egress_rule" "egress_for_ping" {
  security_group_id = aws_security_group.ping.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}