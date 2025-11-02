# Class 7 Notes for 11/2/2025: AWS EC2 and Security with Terraform; advanced terraform features (functions, data typing, output basics and data source demo)

<insert table of contents>

## Overview 

Today for class we will be building out the AWS networking infrastructure we have been working on for the past several weeks. We will build out a secured EC2 instance and utilize some more advanced automation techniques along the way. We want to increase your comfort today with Terraform by using these resources as examples as the resources themselves are not intrinsically complicated or unique. 

## Prerequisites 

1) Have an entire VPC and associated resources in terraform deployed without errors
2) A user_data.sh script (I will provide one below)
3) A .gitignore file 
4) VS Code open with your project `*.tf` files open in a new folder
5) Run the Terraform workflow (aka I(V)PAD) to deploy the network infrastructure 

Note: Today is not the day to troubleshoot network infrastructure. That was the past few weeks. If you have minor issues in class with VPC settings but it otherwise deploys correctly and has zero errors then some time may be spent correctly that. 

### User data shell script 

Note: Windows users may need their shell as an administrator.

If you need a user data shell script then run this command and it will download it to your working directory: 
```bash
curl -O <link> 
```

If you recieve an error while running this command concerning the revocation function (why haven't you corrected this security issue with your group?) then run this command for today only:
```bash
curl -O --ssl-no-revoke <link>
```

## Goals for today
1) Discuss advanced terraform features
    - Functions and some common functions
    - Output blocks and its common use cases. 
    - Data types and terraform data type primitives 
    - Data source blocks and its use cases.

2) Verify your network infrastructure works and increase the speed and independence of your troubleshooting. 
    - Your network infrastructure deploys but insert italics does it work end italics 
    - Fix minor configuration issues by indepdently reviewing existing code and using the documentation
    - Use comments to ensure your code is truly self-documenting 

3) Explore EC2 instances and the needed infrastructure resources in terraform. 
    - Note small "quirks" in terraform when interacting with the provider
    - Integrate new resources into your terraform code 
    - Note best practices and avoid code for backward compaitiblity. Understand it uses the same upstream API in the provider. 

## Play by play 
1) Discuss goals 
2) Ensure prereqs are met and terraform deploys your network infrastructure
3) Explore documentation and new HCL constructs for today 
4) Use console as a template to note what is a default and what configuration parameters need to be edited. 
5) Build out needed security infrastructure using best practices. 
    - Note best practices 
    - How is it done "IRL" vs how could it be done entirely automated and why isnt that best
    - Security groups (web server, ping)
6) Bulid out EC2 infrastructure. 
    - Explore console and note config parameters 
    - Explore registry and rewrite those paramters as HCL arguments 
    - Hardcode AMI, user data and key
7) Explore output blocks
    - Show simple use case
    - Show useful use case
    - Show a "correct" or "deliverable" use case 
8) Refactor EC2 instance with file() function, data source, and key pair. 

## Infrastructure used 

### Security groups

[Terraform registry security group resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)

Please read the notes and warnings. There are multiple ways to write a security group and many times both ways work. There is, however, a best practice which we will use today. 

### Security group rules 

1) [Terraform registry ingress rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule)
2) [Terraform registry egress rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule)

### Key pairs

These can be made with Terraform but are not the preferred method:

1) There is little need for automation with these
2) The cryptographic key (public and private) would be stored in state
3) Additional providers are needed (TLS and Local) to create the private key file 
4) AWS API provides a much more efficent and secure method and can be easily automated
    - CFN 
    - Boto3
    - AWS CLI

```bash
aws ec2 create-key-pair \
  --key-name my-ec2-key \
  --query 'KeyMaterial' \
  --output text > my-ec2-key.pem
```

### EC2

1) [EC2 instance resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
2) We will need to note the default configuration and paramters we edit in the console. 
3) We need to use the previous step as a template for our configuration and covert it to terraform arguments. 

## Advanced terraform and HCL features

### Data types

A type specifies what kind of data (for us, as far as we know, this is the value of the argument) we are working with and what we can do with it. Thus far we have worked with data types that fall into the category of primitives. This means that they have a single value:
- string (alphanumeric characters, requires quotes around the value)
- boolean (true or false; 0 or 1 are the only acceptable values)
- number (signed whole or fractional numbers)

Today we will use a data type that falls in the category of collections. Specifically a data type called list (sometimes called an array or tuple):

`argument = [value1, value2, value3]`

Please keep in mind this is an ordered list meaning the list knows the position of each value (called its index). We won't use this functionality today but its good to keep in mind. 

[Data types](https://developer.hashicorp.com/terraform/language/expressions/types)

### Functions

In terraform there is a feature called functions. They combine or modify expressions (including literal values) in some way to produce a different value. There are built in functions and provider defined functions. 

[Terraform developer documention on functions](https://developer.hashicorp.com/terraform/language/functions)

We will use a specific function today found [here](https://developer.hashicorp.com/terraform/language/functions/file)

### Output blocks

Output blocks are code blocks (like we use resource blocks) that generate output. They are an "overloaded" feature meaning depending on the context they can work differently. Output is stored in the state file. 

[Terraform developer documentation on outblock blocks](https://developer.hashicorp.com/terraform/tutorials/configuration-language/outputs)

We can use output blocks to output expressions of any type. 

### Data sources 

Data sources are another type of code block. We use them similar to resource blocks but in reverse. Instead of modifying your cloud infrastructure, they query your existing infrastructure and return information about the specific resource in question. They can be very dynamic making your deployment more flexible and have less dependencies thus increasing the automation. 

[Terraform developer documentation on data sources](https://developer.hashicorp.com/terraform/tutorials/configuration-language/data-sources)