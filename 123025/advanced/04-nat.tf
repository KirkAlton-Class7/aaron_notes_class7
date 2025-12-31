# ===================================
# Elastic IP for NAT Gateway
# ===================================

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : local.num_azs) : 0

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = var.single_nat_gateway ? local.eip_name : "${local.eip_name}-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

# ===================================
# NAT Gateway
# ===================================

resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : local.num_azs) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    local.common_tags,
    {
      Name = var.single_nat_gateway ? local.nat_name : "${local.nat_name}-${local.az_suffixes[count.index]}"
    }
  )

  depends_on = [aws_internet_gateway.main]
}
