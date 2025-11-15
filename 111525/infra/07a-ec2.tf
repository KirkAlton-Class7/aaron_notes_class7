# EC2 Instances

resource "aws_instance" "web_tier" {
  ami                         = data.aws_ssm_parameter.al2023.value
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  subnet_id                   = aws_subnet.public_a.id

  user_data = file("./scripts/web_startup_script.sh")

  tags = {
    Name = "web-server"
    Tier = "web"
  }
}

