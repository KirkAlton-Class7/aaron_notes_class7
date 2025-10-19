# Terraform Introduction: 18 Oct 2025

## Table of Contents

- [Overview](#overview)
  - [Goals for class](#goals-for-class)
  - [Play by play](#play-by-play)
- [Prereqs](#prereqs)
  - [What the script does](#what-the-script-does)
- [Why is this tool needed?](#why-is-this-tool-needed)
  - [Console (ClickOps)](#console-clickops)
  - [API](#api)
  - [AWS CLI](#aws-cli)
  - [The Terraform Solution](#the-terraform-solution)
- [Understanding Terraform](#understanding-terraform)
  - [What is Terraform?](#what-is-terraform)
  - [Authentication](#authentication)
  - [Key terms](#key-terms)
- [Terraform Workflow](#terraform-workflow)
- [Learning Resources](#learning-resources)

## Overview

### Goals for class
- Verify computer is set up correctly
- Why Terraform is useful over API Calls, AWS Console, AWS CLI, etc.
- High level overview of Terraform and IaC
- HCL basics and Terraform workflow 
- Build VPC with Terraform

### Play by play 
1) Verify prereqs are met

2) Discuss why Terraform is needed

3) What is Terraform exactly and key terminology 

4) Open Git Bash or Terminal
    - Navigate to TheoWAF directory
    - Navigate to Terraform directory 
    - Create project folder 
    - Navigate to project folder

5) Clone Theo's repo

6) Create `auth.tf` and `main.tf` files

7) Open VS Code

8) Build out `*.tf` files

9) Run through TF workflow

## Prereqs 

Today there are several prereqs for class. There is a script that will automatically check these. If your computer doesn't pass these checks then you can't use Terraform today. 

**For Windows users:** You should run Git Bash as an administrator. 

Run this command: 
```bash
curl https://raw.githubusercontent.com/aaron-dm-mcdonald/Class7-notes/refs/heads/main/101825/check.sh | bash
```

If you get a revocation error, run this instead:
```bash
curl --ssl-no-revoke https://raw.githubusercontent.com/aaron-dm-mcdonald/Class7-notes/refs/heads/main/101825/check.sh | bash
```

> **Note:** This revocation error means Git Bash is not whitelisted by an antivirus or firewall, or you're on a corporate network. This isn't a long term fix; you should work with your group to properly whitelist Git Bash.

### What the script does

The script checks the following: 
- AWS CLI installed, configured and authenticated 
- Terraform binary is installed and up to date
- TheoWAF folder present at `~/Documents/TheoWAF/class7/AWS/Terraform`
- Creates a .gitignore file

It will create the TheoWAF folder structure if needed and will download a .gitignore file configured for Terraform projects.

## Why is this tool needed?

### Console (ClickOps)
![](./assets/vpc-creation.PNG)

**Cons of ClickOps:**
- Difficult to reproduce across environments (dev, staging, prod)
- Not self-documenting: no record of what you clicked or why
- Impossible to automate or version control

### API
An API (Application Programming Interface) is at the heart of AWS and most cloud platforms. It allows programs, services, and computers to communicate with AWS. Every action in the AWS console actually makes API calls behind the scenes.

**API call example:**
```
https://ec2.amazonaws.com/?Action=CreateVpc
&CidrBlock=10.0.0.0/16
&InstanceTenancy=default
&TagSpecification.1.ResourceType=vpc
&TagSpecification.1.Tag.1.Key=Name
&TagSpecification.1.Tag.1.Value=demo-vpc
&AUTHPARAMS
```

**Cons of direct API calls:**
- Extremely verbose and error prone
- Requires manual authentication handling
- Not designed for human interaction
- No state tracking: you have to manually track what you've created
- Hard to make small edits

**Reference:** [AWS EC2 CreateVpc API Documentation](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateVpc.html)

### AWS CLI
The AWS CLI wraps the AWS API in a more user-friendly command-line interface.

```bash
aws ec2 create-vpc --cidr-block "10.0.0.0/16" --instance-tenancy "default" --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=demo-vpc}]'
```

**Cons of AWS CLI:**
- Many flags needed for the many parameters
- Different commands needed for create, update, and delete operations
- Easy to make mistakes
- No state tracking: CLI doesn't remember what resources it created
- No idempotency: running the same command twice creates duplicate resources

### The Terraform Solution

Terraform solves these problems by:
- Using declarative code (describe what you want, not how to create it)
- Maintaining state (knows what exists and what needs to change)
- Being idempotent (safe to run multiple times)
- Managing dependencies automatically
- Supporting version control
- Enabling code reuse through modules

## Understanding Terraform

### What is Terraform?

Terraform is an infrastructure as code (IaC) tool that lets you define, provision, query and manage cloud resources using a declarative configuration language. Instead of clicking through the AWS console or writing complex API calls, you write code that describes your desired infrastructure, and Terraform handles all the API calls and sequencing needed to make it happen.

**Official documentation:** [Terraform Docs](https://developer.hashicorp.com/terraform/docs)

### Authentication

Terraform uses the same authentication mechanisms as the AWS CLI. Common methods:

1. **AWS CLI profile** (recommended for local development) - stored in `~/.aws/credentials`
2. **Environment variables** - `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
3. **IAM roles** (recommended for CI/CD and production)

You don't specify credentials directly in Terraform code. Terraform automatically uses whatever credentials are available in your environment.

**Authentication documentation:** [AWS Provider Authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration)

### Key terms:

- **IaC (Infrastructure as Code):** The practice of managing infrastructure through code rather than manual configuration. Terraform is an IaC tool that allows us to write code that interacts with cloud provider APIs.

- **Terraform:** An open-source IaC tool created by HashiCorp for cloud automation. Cloud agnostic (works with AWS, Azure, GCP, etc.), widely used, simple declarative language, and extensive community support.

- **State:** A JSON file (`terraform.tfstate`) that keeps track of what infrastructure Terraform is managing, the current attributes of each resource, and metadata. This is how Terraform knows what already exists vs. what needs to be created or changed. **Never manually edit this file.**

- **Provider:** A plugin that enables Terraform to interact with a specific cloud platform or service. In our case, we use the AWS provider to interact with AWS APIs.

- **HCL (HashiCorp Configuration Language):** Terraform's declarative configuration language. More human-readable than JSON. While primarily declarative (you describe what you want), it includes some procedural features like loops and conditionals.

- **Idempotency:** A critical property of Terraform; running `terraform apply` multiple times with the same configuration produces the same result. Terraform won't recreate or modify resources unless your code changes or state drift is detected.

- **Resource:** A block of HCL code that defines infrastructure to create in the cloud, like a VPC or EC2 instance. Each resource has a type and configuration parameters.

- **Execution Plan:** Generated by `terraform plan`, this shows exactly what Terraform will do before it does it; what resources will be created, modified, or destroyed, and in what order. This is Terraform's "dry run" feature.

- **State Drift:** When the actual infrastructure in AWS differs from what's recorded in the Terraform state file. This can happen if someone manually changes resources in the console. Terraform can detect and correct drift using `terraform plan` and `terraform apply`.

## Terraform Workflow 

```bash
# Initialize working directory: downloads provider plugins, generates lock file, etc
terraform init

# Validate HCL syntax and configuration (check your "grammar", not if it "makes sense" otherwise known as semantically correct)
terraform validate

# Show execution plan: preview what will change
terraform plan

# Apply changes: actually create/modify/destroy infrastructure
terraform apply

# Destroy all resources managed by this configuration
terraform destroy
```

**Typical workflow:**
1. Write or modify `.tf` files
2. Run `terraform validate` to check syntax
3. Run `terraform plan` to see what will change
4. Review the plan carefully
5. Run `terraform apply` to make the changes
6. Terraform updates the state file automatically

**CLI documentation:** [Terraform CLI Commands](https://developer.hashicorp.com/terraform/cli/commands)

## Learning Resources

Official Terraform documentation:
- [Getting Started with Terraform and AWS](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)
- [Terraform Language Reference](https://developer.hashicorp.com/terraform/language)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)