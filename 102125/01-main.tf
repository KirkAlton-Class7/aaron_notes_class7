# VPC resource
# This creates the virtual private cloud
resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  
  tags = {
    Name = "demo-vpc"
  }

}
