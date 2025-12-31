# ===================================
# Local Values
# ===================================

locals {
  # Naming scheme: <project>-<environment>-<resource-type>-<identifier>
  # Example: terraform-vpc-dev-public-subnet-us-west-2a

  name_prefix = "${var.project_name}-${var.environment}"

  # Common tags merged from variables
  common_tags = merge(
    var.common_tags,
    var.additional_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      Region      = var.aws_region
    }
  )

  # Naming for major resources
  vpc_name = "${local.name_prefix}-vpc"
  igw_name = "${local.name_prefix}-igw"
  nat_name = "${local.name_prefix}-nat-gw"
  eip_name = "${local.name_prefix}-eip-nat"

  # Route table names
  public_rtb_name  = "${local.name_prefix}-public-rtb"
  private_rtb_name = "${local.name_prefix}-private-rtb"

  # Security group names
  web_tier_sg_name = "${local.name_prefix}-web-tier-sg"
  alb_sg_name      = "${local.name_prefix}-alb-sg"

  # SSH CIDR - defaults to VPC CIDR if not specified
  ssh_cidr = var.allowed_ssh_cidr != null ? var.allowed_ssh_cidr : var.vpc_cidr

  # Calculate number of subnets based on AZ count
  num_azs = min(var.availability_zones_count, length(data.aws_availability_zones.available.names))

  # Subnet name suffixes based on AZ
  az_suffixes = [for i in range(local.num_azs) : data.aws_availability_zones.available.names[i]]

  # Public subnet names
  public_subnet_names = [
    for idx, az in local.az_suffixes :
    "${local.name_prefix}-public-subnet-${az}"
  ]

  # Private subnet names
  private_subnet_names = [
    for idx, az in local.az_suffixes :
    "${local.name_prefix}-private-subnet-${az}"
  ]

  # Subnet CIDR slices (in case user provides more CIDRs than needed)
  public_cidrs  = slice(var.public_subnet_cidrs, 0, local.num_azs)
  private_cidrs = slice(var.private_subnet_cidrs, 0, local.num_azs)
}

