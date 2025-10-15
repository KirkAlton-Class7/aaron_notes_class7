# Data source to get available AZs in the current region
# This queries AWS for information rather than creating resources
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC resource
# This creates the virtual private cloud
resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "demo-vpc"
  }
}
