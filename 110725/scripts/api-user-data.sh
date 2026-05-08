#!/bin/bash

# Update system
sudo yum update -y

# Install Python 3 and pip
sudo yum install -y python3 python3-pip git

# Create application directory
sudo mkdir -p /opt/api

# Clone the repository
cd /tmp
git clone https://github.com/aaron-dm-mcdonald/Class7-notes.git
cd Class7-notes/110725

# Copy API files
sudo cp src/api/app.py /opt/api/

# Install Flask and dependencies
sudo pip3 install flask flask-cors mysql-connector-python

# Create systemd service for Flask app
sudo tee /etc/systemd/system/flask-app.service > /dev/null <<EOF
[Unit]
Description=Flask API Application
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/api
Environment="DB_HOST=YOUR_DB_PRIVATE_IP"
ExecStart=/usr/bin/python3 /opt/api/app.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Set proper permissions
sudo chown -R ec2-user:ec2-user /opt/api

# Reload systemd
sudo systemctl daemon-reload

echo "API server setup complete!"
echo "IMPORTANT: Update DB_HOST in /etc/systemd/system/flask-app.service with your DB private IP"
echo "Then run:"
echo "  sudo systemctl daemon-reload"
echo "  sudo systemctl start flask-app"
echo "  sudo systemctl enable flask-app"
echo "Check status: sudo systemctl status flask-app"
echo "View logs: sudo journalctl -u flask-app -f"