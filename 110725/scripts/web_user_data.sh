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

# Configure Apache with reverse proxy
sudo tee /etc/httpd/conf.d/app.conf > /dev/null <<'EOF'
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    
    <Directory /var/www/html>
        Options -Indexes +FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
    
    # Reverse proxy for API requests
    ProxyPreserveHost On
    ProxyPass /api http://API_PRIVATE_IP:5000/api
    ProxyPassReverse /api http://API_PRIVATE_IP:5000/api
    
    ErrorLog /var/log/httpd/app_error.log
    CustomLog /var/log/httpd/app_access.log combined
</VirtualHost>
EOF

# Enable proxy modules
sudo tee /etc/httpd/conf.modules.d/00-proxy.conf > /dev/null <<'EOF'
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so
EOF

# Remove default welcome page
sudo rm -f /etc/httpd/conf.d/welcome.conf

# Generate metadata page using IMDSv2
echo "Fetching EC2 metadata..."

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Fetch metadata in parallel
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id &> /tmp/instance_id &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-type &> /tmp/instance_type &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/public-ipv4 &> /tmp/public_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/region &> /tmp/region &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
wait

# Read metadata
macid=$(cat /tmp/macid)
instance_id=$(cat /tmp/instance_id)
instance_type=$(cat /tmp/instance_type)
local_ipv4=$(cat /tmp/local_ipv4)
public_ipv4=$(cat /tmp/public_ipv4)
az=$(cat /tmp/az)
region=$(cat /tmp/region)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${macid}/vpc-id)
subnet=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${macid}/subnet-id)

# Create metadata.html page with matching styles
sudo tee /var/www/html/metadata.html > /dev/null <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EC2 Instance Metadata</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .metadata-box {
            background: #ffffff;
            border-radius: 8px;
            padding: 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            max-width: 600px;
        }
        .metadata-item {
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .metadata-item:last-child {
            border-bottom: none;
        }
        .metadata-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
        }
        .metadata-value {
            color: #666;
            font-family: 'Courier New', monospace;
            font-size: 14px;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #333;
            text-decoration: none;
            padding: 10px 20px;
            border: 1px solid #ddd;
            border-radius: 6px;
            transition: all 0.2s;
        }
        .back-link:hover {
            background: #f5f5f5;
            border-color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="metadata-box">
            <h1>EC2 Instance Metadata</h1>
            <p>Instance information from AWS metadata service</p>
            
            <div class="metadata-item">
                <div class="metadata-label">Instance ID</div>
                <div class="metadata-value">${instance_id}</div>
            </div>
            
            <div class="metadata-item">
                <div class="metadata-label">Instance Type</div>
                <div class="metadata-value">${instance_type}</div>
            </div>
            
            <div class="metadata-item">
                <div class="metadata-label">Hostname</div>
                <div class="metadata-value">$(hostname -f)</div>
            </div>
            
            <div class="metadata-item">
                <div class="metadata-label">Private IP Address</div>
                <div class="metadata-value">${local_ipv4}</div>
            </div>
            
            <div class="metadata-item">
                <div class="metadata-label">Public IP Address</div>
                <div class="metadata-value">${public_ipv4}</div>
            </div>
            
            <div class="metadata-item">
                <div class="metadata-label">Availability Zone</div>
                <div class="metadata-value">${az}</div>
            </div>
            
            <div class="metadata-item">
                <div class="metadata-label">Region</div>
                <div class="metadata-value">${region}</div>
            </div>
            
            <div class="metadata-item">
                <div class="metadata-label">VPC ID</div>
                <div class="metadata-value">${vpc}</div>
            </div>
            
            <div class="metadata-item">
                <div class="metadata-label">Subnet ID</div>
                <div class="metadata-value">${subnet}</div>
            </div>
            
            <a href="/" class="back-link">← Back to Application</a>
        </div>
    </div>
</body>
</html>
EOF

# Clean up temp files
rm -f /tmp/instance_id /tmp/instance_type /tmp/local_ipv4 /tmp/public_ipv4 /tmp/az /tmp/region /tmp/macid

# Set permissions
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

echo "Apache setup complete!"
echo "Application available at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)/"
echo "Metadata page available at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)/metadata.html"
echo "IMPORTANT: Edit /etc/httpd/conf.d/app.conf and replace API_PRIVATE_IP"
echo "Then run: sudo systemctl restart httpd"