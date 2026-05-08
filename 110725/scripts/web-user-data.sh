#!/bin/bash

# Update system
sudo yum update -y

# Install Apache and Git
sudo yum install -y httpd git

# Create web directory
sudo mkdir -p /var/www/html

# Clone the repository
cd /tmp
git clone https://github.com/aaron-dm-mcdonald/Class7-notes.git
cd Class7-notes/110725

# Copy web files
sudo cp src/web/static/* /var/www/html/
sudo cp src/web/app.js /var/www/html/

# Copy Apache configuration files
sudo cp src/web/app.conf /etc/httpd/conf.d/app.conf
sudo cp src/web/00-proxy.conf /etc/httpd/conf.modules.d/00-proxy.conf

# Remove default welcome page
sudo rm -f /etc/httpd/conf.d/welcome.conf

# Generate metadata values using IMDSv2
echo "Fetching EC2 metadata..."

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Fetch metadata and assign directly to variables
instance_id=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
instance_type=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-type)
local_ipv4=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4)
public_ipv4=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/public-ipv4)
az=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
region=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/region)
macid=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${macid}/vpc-id)
subnet=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${macid}/subnet-id)
hostname=$(hostname -f)

# Inject metadata values into metadata.html using sed
sudo sed -i "s|{{INSTANCE_ID}}|${instance_id}|g" /var/www/html/metadata.html
sudo sed -i "s|{{INSTANCE_TYPE}}|${instance_type}|g" /var/www/html/metadata.html
sudo sed -i "s|{{HOSTNAME}}|${hostname}|g" /var/www/html/metadata.html
sudo sed -i "s|{{PRIVATE_IP}}|${local_ipv4}|g" /var/www/html/metadata.html
sudo sed -i "s|{{PUBLIC_IP}}|${public_ipv4}|g" /var/www/html/metadata.html
sudo sed -i "s|{{AZ}}|${az}|g" /var/www/html/metadata.html
sudo sed -i "s|{{REGION}}|${region}|g" /var/www/html/metadata.html
sudo sed -i "s|{{VPC_ID}}|${vpc}|g" /var/www/html/metadata.html
sudo sed -i "s|{{SUBNET_ID}}|${subnet}|g" /var/www/html/metadata.html

# Set permissions
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

echo "Apache setup complete!"
echo ""
echo "==============================================="
echo "MANUAL CONFIGURATION REQUIRED:"
echo "==============================================="
echo "1. Replace API_PRIVATE_IP placeholder in Apache config:"
echo "   sudo sed -i 's/{{API_PRIVATE_IP}}/YOUR_API_PRIVATE_IP_HERE/g' /etc/httpd/conf.d/app.conf"
echo ""
echo "2. Test Apache configuration:"
echo "   sudo apachectl configtest"
echo ""
echo "3. Restart Apache:"
echo "   sudo systemctl restart httpd"
echo ""
echo "4. Verify Apache status:"
echo "   sudo systemctl status httpd"
echo ""
echo "5. Test the proxy:"
echo "   curl http://localhost/api/health"
echo "==============================================="

