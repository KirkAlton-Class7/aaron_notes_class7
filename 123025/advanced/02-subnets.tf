# ===================================
# Public Subnets
# ===================================

resource "aws_subnet" "public" {
  count = local.num_azs

  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_cidrs[count.index]
  availability_zone       = local.az_suffixes[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    local.common_tags,
    {
      Name = local.public_subnet_names[count.index]
      Type = "public"
      Tier = "public"
    }
  )
}

# ===================================
# Private Subnets
# ===================================

resource "aws_subnet" "private" {
  count = local.num_azs

  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.private_cidrs[count.index]
  availability_zone       = local.az_suffixes[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    local.common_tags,
    {
      Name = local.private_subnet_names[count.index]
      Type = "private"
      Tier = "private"
    }
  )
}
