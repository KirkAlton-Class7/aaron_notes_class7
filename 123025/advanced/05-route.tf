# ===================================
# Public Route Table
# ===================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.public_rtb_name
      Type = "public"
    }
  )
}

# ===================================
# Public Route Table Associations
# ===================================

resource "aws_route_table_association" "public" {
  count = local.num_azs

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ===================================
# Private Route Table
# ===================================

resource "aws_route_table" "private" {
  # Create one route table per NAT Gateway if not using single NAT
  # If using single NAT or NAT is disabled, create one route table
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : local.num_azs) : 1

  vpc_id = aws_vpc.main.id

  # Only add NAT route if NAT Gateway is enabled
  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[count.index].id
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = var.single_nat_gateway || !var.enable_nat_gateway ? local.private_rtb_name : "${local.private_rtb_name}-${local.az_suffixes[count.index]}"
      Type = "private"
    }
  )
}

# ===================================
# Private Route Table Associations
# ===================================

resource "aws_route_table_association" "private" {
  count = local.num_azs

  subnet_id = aws_subnet.private[count.index].id
  # If single NAT gateway or NAT disabled, use index 0
  # Otherwise use corresponding index for each AZ
  route_table_id = aws_route_table.private[var.single_nat_gateway || !var.enable_nat_gateway ? 0 : count.index].id
}
