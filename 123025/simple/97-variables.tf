

variable "aws_region" {
  description = "AWS region where resources will be created (string type example)"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name for resource tagging and naming (string type with validation)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, staging, or prod."
  }
}

variable "project_name" {
  description = "Project name used in resource naming and tagging (string type)"
  type        = string
  default     = "terraform-vars-lab"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (string type)"
  type        = string
  default     = "10.10.0.0/16"
}


variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC (bool type)"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC (bool type)"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public IPs to instances in public subnets (bool type)"
  type        = bool
  default     = true
}



variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (list of strings type)"
  type        = list(string)
  default = [
    "10.10.1.0/24",
    "10.10.2.0/24",
    "10.10.3.0/24"
  ]
}


variable "root_ebs_size" {
  description = "Size of the root EBS volume"
  type = number
  default = 20
}

# ===================================
# OBJECT VARIABLES (split ingress rules)
# ===================================

variable "http_ingress_rule" {
  description = "HTTP ingress rule for web tier (object type)"
  type = object({
    port        = number
    protocol    = string
    cidr_blocks = string
    description = string
  })
  default = {
    port        = 80
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    description = "Allow HTTP from anywhere"
  }
}

variable "ssh_ingress_rule" {
  description = "SSH ingress rule for web tier (object type)"
  type = object({
    port        = number
    protocol    = string
    cidr_blocks = string
    description = string
  })
  default = {
    port        = 22
    protocol    = "tcp"
    cidr_blocks = "10.10.0.0/16"
    description = "Allow SSH from VPC"
  }
}


# only network team to modify this
variable "egress_rule_settings" {
  description = "Egress rule configuration for security group (object type with multiple attributes)"
  type = object({
    cidr_ipv4   = string
    ip_protocol = string
    description = string
  })
  default = {
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "-1"
    description = "Allow all outbound traffic"
  }
}

# ===================================
# COMMON TAGS (MAP)
# ===================================

variable "common_tags" {
  description = "Common tags to apply to all resources (map of strings type)"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Team      = "Platform"
  }
}
