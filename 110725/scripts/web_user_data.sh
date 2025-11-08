#!/bin/bash

# Update system
sudo yum update -y

# Install nginx
sudo yum install -y nginx

# Install git
sudo yum install -y git

# Create web directory
sudo mkdir -p /var/www/html
sudo mkdir -p /var/www/html/static

# Clone the repository
cd /tmp
git clone https://github.com/aaron-dm-mcdonald/Class7-notes.git
cd Class7-notes/110725

# Copy web files
sudo cp src/web/app.js /var/www/html/
sudo cp src/web/static/index.html /var/www/html/static/
sudo cp src/web/static/pictures.html /var/www/html/static/
sudo cp src/web/static/styles.css /var/www/html/static/

# Configure nginx
sudo tee /etc/nginx/conf.d/app.conf > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    
    root /var/www/html/static;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    location /app.js {
        alias /var/www/html/app.js;
    }
    
    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Remove default nginx config
sudo rm -f /etc/nginx/sites-enabled/default

# Set proper permissions
sudo chown -R nginx:nginx /var/www/html
sudo chmod -R 755 /var/www/html

# Start and enable nginx
sudo systemctl start nginx
sudo systemctl enable nginx

echo "Web server setup complete!"
echo "Note: Update API_URL in /var/www/html/app.js with your API server's IP"