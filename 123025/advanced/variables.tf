# ===================================
# Core Configuration Variables
# ===================================

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-west-2"

  validation {
    condition     = can(regex("^(us|eu|ap|sa|ca|me|af)-(east|west|south|north|central|northeast|southeast)-[1-9]$", var.aws_region))
    error_message = "The aws_region must be a valid AWS region format (e.g., us-west-2, eu-central-1)."
  }
}

variable "environment" {
  description = "Environment name for resource tagging and naming (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Project name used in resource naming and tagging"
  type        = string
  default     = "terraform-vpc"
}

# ===================================
# VPC Configuration
# ===================================

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"

  validation {
    condition     =  can(cidrhost(var.vpc_cidr, 0))
    error_message = "The vpc_cidr must be a valid IPv4 CIDR block."
  }
  
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "instance_tenancy" {
  description = "Tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "Instance tenancy must be either 'default' or 'dedicated'."
  }
}

# ===================================
# Subnet Configuration
# ===================================

variable "availability_zones_count" {
  description = "Number of availability zones to use (determines number of subnets created)"
  type        = number
  default     = 3

  validation {
    condition     = var.availability_zones_count >= 2 && var.availability_zones_count <= 6
    error_message = "Availability zones count must be between 2 and 6 for high availability."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default = [
    "10.10.1.0/24",
    "10.10.2.0/24",
    "10.10.3.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default = [
    "10.10.11.0/24",
    "10.10.12.0/24",
    "10.10.13.0/24"
  ]
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public IP addresses to instances launched in public subnets"
  type        = bool
  default     = true
}

# ===================================
# NAT Gateway Configuration
# ===================================

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets to access the internet"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets (cost savings vs. high availability)"
  type        = bool
  default     = true
}

# ===================================
# Security Group Configuration
# ===================================

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into instances (use VPC CIDR for internal-only access)"
  type        = string
  default     = null # Will default to VPC CIDR in locals
}

variable "web_tier_ports" {
  description = "Map of ports to allow in web tier security group"
  type = map(object({
    port        = number
    protocol    = string
    description = string
  }))
  default = {
    http = {
      port        = 80
      protocol    = "tcp"
      description = "HTTP traffic from ALB"
    }
    ssh = {
      port        = 22
      protocol    = "tcp"
      description = "SSH access from within VPC"
    }
  }
}

# ===================================
# Tagging
# ===================================

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

variable "additional_tags" {
  description = "Additional tags to merge with common tags"
  type        = map(string)
  default     = {}
}
