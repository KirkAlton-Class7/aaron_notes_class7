# Public Subnets
# These subnets have direct internet access via the internet gateway

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "demo-public-subnet-1"
    Type = "Public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "demo-public-subnet-2"
    Type = "Public"
  }
}

resource "aws_subnet" "public_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.3.0/24"
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "demo-public-subnet-3"
    Type = "Public"
  }
}

# Private Subnets
# These subnets do not have direct internet access
# They can reach the internet through the NAT gateway

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  
  tags = {
    Name = "demo-private-subnet-1"
    Type = "Private"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.12.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  
  tags = {
    Name = "demo-private-subnet-2"
    Type = "Private"
  }
}

resource "aws_subnet" "private_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.13.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]
  
  tags = {
    Name = "demo-private-subnet-3"
    Type = "Private"
  }
}
