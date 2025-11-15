# Web Server Security Group
resource "aws_security_group" "web_server" {
  name        = "web-server-sg"
  description = "Allow HTTP and SSH for web server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "web-server-sg"
    Tier = "web"
  }


}

resource "aws_vpc_security_group_ingress_rule" "web_server_http" {
  security_group_id = aws_security_group.web_server.id
  description       = "HTTP from internet"
  # if traffic from LB then can this be improved?
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}


resource "aws_vpc_security_group_ingress_rule" "web_server_ssh" {
  security_group_id = aws_security_group.web_server.id
  description       = "SSH from internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "web_server_egress" {
  security_group_id = aws_security_group.web_server.id
  description       = "Allow all outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}





