variable "ec2_settings" {
  description = "EC2 configuration settings"
  type = object({
    instance_type = string
    subnet_name   = string
    extra_tags    = map(string)
  })

  default = {
    instance_type = "t3.micro"
    subnet_name   = "public_a"
    extra_tags    = {}
  }
}

locals {
  subnet_ids = {
    public_a = aws_subnet.public_a.id
    public_b = aws_subnet.public_b.id
    public_c = aws_subnet.public_c.id
  }
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.amzn_linux_2023_ami.id
  instance_type = var.ec2_settings.instance_type
  subnet_id     = local.subnet_ids[var.ec2_settings.subnet_name]

  vpc_security_group_ids = [
    aws_security_group.web_tier.id
  ]

  tags = merge(
    { Name = "${var.project_name}-${var.environment}-web-tier-server" },
    var.ec2_settings.extra_tags
  )
}


