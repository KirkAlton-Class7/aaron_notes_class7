# Terraform AWS VPC Demo

A simple Terraform project that creates a VPC with public and private subnets across three availability zones.

## What This Creates

- 1 VPC (10.0.0.0/16)
- 3 Public Subnets (one per AZ)
- 3 Private Subnets (one per AZ)
- 1 Internet Gateway
- 1 NAT Gateway
- Route tables for public and private subnets
- Security group allowing HTTP traffic

## Prerequisites

- Terraform installed (version 1.0 or higher)
- AWS CLI configured with credentials
- Basic understanding of AWS networking concepts


## Understanding Terraform

### What is Terraform?

Terraform is an infrastructure as code (IaC) tool that lets you define and provision cloud resources using a declarative configuration language. Instead of clicking through the AWS console to create resources, you write code that describes what you want, and Terraform makes it happen.

Official documentation: https://developer.hashicorp.com/terraform/docs

### Key Concepts

#### Providers

Providers are plugins that let Terraform interact with cloud platforms, SaaS providers, and APIs. In this project, we use the AWS provider to manage AWS resources.

```hcl
provider "aws" {
  region = "us-east-1"
}
```

The provider configuration tells Terraform:
- Which cloud platform to use (AWS)
- How to authenticate (uses AWS CLI credentials by default)
- Which region to create resources in

Provider documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

#### Resources

Resources are the most important element in Terraform. Each resource block describes one or more infrastructure objects, such as a VPC, subnet, or security group.

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

This creates a VPC in AWS. The resource type is `aws_vpc` and the local name is `main`. You reference this resource elsewhere as `aws_vpc.main`.

#### Data Sources

Data sources allow Terraform to fetch information from AWS without creating anything. Think of them as read-only resources.

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

This queries AWS to get a list of available availability zones. We use this to dynamically select which AZs to use for our subnets.

Data source documentation: https://developer.hashicorp.com/terraform/language/data-sources

#### State

Terraform stores information about your infrastructure in a state file (terraform.tfstate). This file maps your configuration to real-world resources.

Important points about state:
- State is how Terraform knows what it has already created
- Never manually edit the state file
- Never commit state files to git (they can contain sensitive data)
- For teams, use remote state storage (S3 + DynamoDB)

State documentation: https://developer.hashicorp.com/terraform/language/state

#### HCL (HashiCorp Configuration Language)

HCL is the language Terraform uses. It's designed to be human-readable and writable. Key features:

- Blocks define resources, data sources, and other constructs
- Arguments assign values to settings
- Expressions compute values
- Comments use # or //

```hcl
# This is a comment
resource "aws_subnet" "example" {  # Block type and labels
  vpc_id     = aws_vpc.main.id     # Argument with expression
  cidr_block = "10.0.1.0/24"       # Argument with literal (string) value
}
```

HCL documentation: https://developer.hashicorp.com/terraform/language/syntax

#### Idempotency

Idempotency means running the same Terraform configuration multiple times produces the same result. If you run `terraform apply` and nothing in your configuration changed, Terraform won't modify anything in AWS.

This is different from a script that creates resources - running the script twice would try to create everything twice and fail. Terraform is declarative: you describe the desired end state, and Terraform figures out how to get there.

Example:
1. First `terraform apply`: Creates a VPC
2. Second `terraform apply`: Terraform checks AWS, sees the VPC exists with the correct settings, makes no changes
3. Change cidr_block in config, then `terraform apply`: Terraform replaces the VPC with the new CIDR

### Provider Configuration Details

#### Region

The region specifies where AWS will create your resources. This is the default region all resources use. You can add an argument like `region = `us-east-1` 


In this project, we hardcoded `us-east-1` in the provider block. In production, you might use variables to make this configurable.

AWS regions documentation: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html

#### Default Tags

The `default_tags` block in the provider applies tags to all resources automatically:

```hcl
provider "aws" {
  default_tags {
    tags = {
      Project     = "vpc-demo"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}
```

This is better than adding tags to each resource individually because:
- Less repetition in your code
- Ensures consistency across all resources
- Makes cost tracking and resource management easier

Tags documentation: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html

#### Authentication

Terraform uses the same authentication as the AWS CLI. Common methods:

1. AWS CLI profile (recommended for local development)
2. Environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
3. IAM roles (recommended for CI/CD and production)

You don't specify credentials in the Terraform code - they come from the environment.

Authentication documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration

## File Organization

This project splits resources into logical files for better organization:

- `auth.tf` - Provider and Terraform configuration
- `vpc.tf` - VPC resource and data sources
- `subnet.tf` - Public and private subnet definitions
- `gateway.tf` - Internet gateway and NAT gateway
- `route.tf` - Route tables and associations
- `sg.tf` - Security groups
- `output.tf` - Output values

This approach makes it easier to find and modify specific resources. For larger projects, you might further organize with modules.

## Common Terraform Commands

```bash
# Initialize working directory
terraform init

# Format code to canonical style
terraform fmt

# Validate configuration syntax
terraform validate

# Show execution plan
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# List resources in state
terraform state list

# Display outputs
terraform output

# Destroy all resources
terraform destroy
```

CLI documentation: https://developer.hashicorp.com/terraform/cli/commands

## Resource Dependencies

Terraform automatically handles dependencies between resources. For example:

```hcl
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id        # Depends on EIP
  subnet_id     = aws_subnet.public_1.id # Depends on subnet
}
```

When you run `terraform apply`, Terraform:
1. Creates resources in the correct order
2. Waits for each resource to be ready before creating dependent resources
3. Can create independent resources in parallel for faster execution

Most dependencies are implicit (Terraform figures them out automatically). The `depends_on` argument is for explicit dependencies that Terraform can't detect.



## Learning Resources

Official Terraform documentation:
- Getting Started: https://developer.hashicorp.com/terraform/tutorials/aws-get-started
- Language Reference: https://developer.hashicorp.com/terraform/language
- AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

AWS VPC documentation:
- VPC Overview: https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
- VPC Best Practices: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html

## Troubleshooting

**Error: "No available subnets"**
- Your region may not have 3 availability zones
- Solution: Modify subnet.tf to use fewer AZs

**Error: "terraform: command not found"**
- Terraform is not installed or not in your PATH
- Solution: Install Terraform from https://www.terraform.io/downloads

**Error: "Error acquiring the state lock"**
- Another Terraform process is running
- Solution: Wait for it to complete or remove the lock file

**Error: "UnauthorizedOperation"**
- AWS credentials are not configured or lack permissions
- Solution: Run `aws configure` or check IAM permissions


## Notes

This is a demo project meant for learning. For production use additional configuration is needed. 
