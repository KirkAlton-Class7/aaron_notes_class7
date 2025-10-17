# Terraform Introduction: 18 Oct 2025

## Overview

### Goals for class
- Verify computer is setup correctly
- Why terraform is useful over API Calls, AWS Console, AWS CLI, etc
- High level overview of Terraform and IaC
- HCL Basics and Terraform workflow 


### Play by play 
1) Verify prereqs are met

2) Discuss why Terraform is needed

3) What is terraform exactly and key terminology 

4) Open Git Bash or Terminal
    - navigate to TheoWAF directory
    - navigate to Terraform directory 
    - create project folder 
    - navigate to project folder

5) Clone Theo's repo

6) Create `auth.tf` and `main.tf` files

7) Open VS Code

8) Build out `*.tf` files







## Prereqs 

Today there are several prereqs for class. There is a script that will automatically check. If your computer doesn't pass these checks then you can't use terraform today. 

Run this command: 
```bash
curl https://raw.githubusercontent.com/aaron-dm-mcdonald/Class7-notes/refs/heads/main/101825/check.sh | bash
```

If you get a revocation error run this:
```bash
curl --ssl-no-revoke https://raw.githubusercontent.com/aaron-dm-mcdonald/Class7-notes/refs/heads/main/101825/check.sh | bash
```

<add note> This revocation error means Git Bash is not whitelisted by an antivirus or firewall or you're on a corporate network. This isn't a long term fix. 

### What the script does

Checks on the following: 
    - AWS CLI installed, configured and authenticated 
    - Terraform binary is installed 
    - TheoWAF Folder present at `~/Documents/TheoWAF/class7/AWS/Terraform`
    - create .gitignore file

It will create the TheoWAF folder if needed (not all of them, just the terraform folder) and will create a .gitignore file as well. 






## Why is this tool needed?












## Understanding Terraform

### What is Terraform?

Terraform is an infrastructure as code (IaC) tool that lets you define, provision, query and manage cloud resources using a declarative configuration language. Instead of clicking through the AWS console to create resources, you write code that describes what you want, and Terraform makes it happen.

Official documentation: https://developer.hashicorp.com/terraform/docs

### Authentication

Terraform uses the same authentication as the AWS CLI. Common methods:

1. AWS CLI profile (recommended for local development)
2. Environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
3. IAM roles (recommended for CI/CD and production)

You don't specify credentials in the Terraform code; they come from the environment.

Authentication documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration

### Key terms:

- IaC

- Terraform 

- State 

- Provider

- HCL

- Idempotency

- Resource

- Execution Plan












## Terraform Workflow 

```bash
# Initialize working directory
terraform init

# Check the HCL syntax statically (Is the "grammar" right?)
terraform validate

# Show execution plan
terraform plan

# Apply changes
terraform apply

# Destroy all resources
terraform destroy
```

CLI documentation: https://developer.hashicorp.com/terraform/cli/commands


## Learning Resources

Official Terraform documentation:
- Getting Started: https://developer.hashicorp.com/terraform/tutorials/aws-get-started
- Language Reference: https://developer.hashicorp.com/terraform/language
- AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
