#!/bin/bash

#####################################
# Check if AWS CLI is installed
echo "=== Checking AWS CLI Installation ==="

if aws --version 2>&1; then
    echo "AWS CLI is installed"
else
    echo "ERROR: 'aws --version' failed"
    echo "Reason: AWS CLI is not installed or not in your PATH"
fi


#####################################
# Check if AWS is configured (non-interactive check)
echo ""
echo "=== Checking if AWS CLI is Configured ==="

# Check if AWS is configured by looking for <not set> in access_key, secret_key, or region only
if aws configure list 2>&1 | grep -E "access_key|secret_key|region" | grep -q "<not set>"; then
    echo "ERROR: 'aws configure list' shows required settings are not set"
    echo "Reason: AWS CLI is not configured properly"
    echo "Fix: Run 'aws configure' per install document"
else
    echo "AWS CLI is configured"
fi

#####################################
# Verify authentication with AWS
echo ""
echo "=== Verifying AWS Authentication ==="

if aws sts get-caller-identity &> /dev/null; then
    echo "AWS authentication successful"
    aws sts get-caller-identity
else
    echo "ERROR: 'aws sts get-caller-identity' failed"
    echo "Reason: Cannot authenticate with AWS"
    echo "Fix: Check your AWS credentials"
fi

#####################################
# Check if terraform is installed
echo ""
echo "=== Checking Terraform Installation ==="

if terraform --version &> /dev/null; then
    echo "Terraform is installed"
    terraform --version
else
    echo "ERROR: 'terraform --version' failed"
    echo "Reason: Terraform is not installed properly"
    echo "Fix: Install Terraform with choco or brew"
fi

echo ""
echo "=== Updating Terraform (if applicable) ==="

# Check for package managers and update accordingly
if command -v choco &> /dev/null; then
    echo "Found Chocolatey, updating Terraform..."
    choco upgrade terraform -y
elif command -v brew &> /dev/null; then
    echo "Found Homebrew, updating Terraform..."
    brew update && brew upgrade terraform
else
    echo "No supported package manager found (choco/brew), skipping Terraform update"
fi


#####################################
# look for TheoWAF directory, fix as needed
echo ""
echo "=== Checking TheoWAF Directory ==="

# Define the path
TARGET_DIR="$HOME/Documents/TheoWAF/class7/AWS/Terraform"

# Check if folder exists
if [ -d "$TARGET_DIR" ]; then
    echo "Directory already exists: $TARGET_DIR"
else
    # Create the directory
    if mkdir -p "$TARGET_DIR" 2> /dev/null; then
        echo "Created directory: $TARGET_DIR"
        echo "Note: TheoWAF folder was incomplete. You need to finish the setup later. Only terraform folder was created."
    else
        echo "ERROR: 'mkdir -p $TARGET_DIR' failed"
        echo "Reason: Permission denied or invalid path"
        echo "Fix: Check directory permissions or path validity"
    fi
fi

echo ""
echo "=== Downloading .gitignore File ==="

#####################################
# Download .gitignore file 
if curl --ssl-no-revoke -o $TARGET_DIR/.gitignore  https://raw.githubusercontent.com/aaron-dm-mcdonald/Class7-notes/refs/heads/main/101825/.gitignore 2> /dev/null; then
    echo "Successfully downloaded .gitignore"
else
    echo "ERROR: 'curl --insecure -O <URL>' failed"
    echo "Reason: Could not download .gitignore, probably network issue"
    echo "Fix: Check internet connection and verify the URL is accessible, copy and paste if needed"
fi

echo ""
echo "Script complete!"