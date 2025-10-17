#!/bin/bash


# AWS CLI installed, configured and authenticated 
# This section needs to check for errors

aws --version
aws configure NEED THE NON INTERACTIVE 
aws sts get-caller-identity 



# is terraform installed?
# needs to check for errors 
terraform --version 


# check if folder exists, if it does, break
# if it doesnt, create this path and output that the TheoWAF folder was incomplete and they need to finish later 
 `~/Documents/TheoWAF/class7/AWS/Terraform`



# create .gitignore file
curl NO-SSL -O <raw .gitignore path on github>

