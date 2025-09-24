#!/bin/bash

# Set to exit on any error
set -e

cd ~
if [ -d "Documents/TheoWAF" ]; then
    echo "TheoWAF directory exists, using it"
else
    echo "Creating TheoWAF directory"
fi
mkdir -p Documents/TheoWAF/file-practice
cd Documents/TheoWAF/file-practice

# Create directory structure
echo "Create practice directories" 
mkdir -p files/{projects,personal,work} \
         my-first-repo

# Create test directories with various naming patterns
mkdir test1 test2 test3 \
      "test-$RANDOM" "test-$RANDOM" \
      "test-$(date +%m-%d-%Y)"

# Create practice files
echo "Create some empty files" 
touch files/{resume.txt,meeting-notes.txt} \
      files/personal/{budget.txt,shopping-list.txt} \
      files/work/{q1-sales.txt,q2-marketing.txt}

# Create README file
echo "Make a README file for later"
cat > ./my-first-repo/README.md << 'EOF'
# My Goals

## Country I am interested in:


## Desired salary:


## My House abroad has:


## Life goals: 

EOF

# Download S3 bucket contents
aws s3 sync s3://test-1256099743 ./photos --no-sign-request --quiet \
    && echo "Successfully downloaded photos with AWS S3 sync tool"

echo "All tasks completed successfully!"