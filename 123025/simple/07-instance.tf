data "aws_ami" "amzn_linux_2023_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amzn_linux_2023_ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.web_tier.id]
  #user_data =

  root_block_device {
    volume_size = var.root_ebs_size
  }

  tags = {
    Name = "${local.name_prefix}-web-tier-server"
  }
}