#!/bin/bash

# Update system
sudo yum update -y

# Install MariaDB server
sudo yum install -y mariadb105-server git

# Start and enable MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation (basic setup)
# Set root password and remove anonymous users
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RootPassword123!';"
sudo mysql -u root -pRootPassword123! -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -u root -pRootPassword123! -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -u root -pRootPassword123! -e "DROP DATABASE IF EXISTS test;"
sudo mysql -u root -pRootPassword123! -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -u root -pRootPassword123! -e "FLUSH PRIVILEGES;"

# Configure MariaDB to accept remote connections
sudo tee -a /etc/my.cnf.d/server.cnf > /dev/null <<EOF

[mysqld]
bind-address = 0.0.0.0
EOF

# Restart MariaDB to apply configuration
sudo systemctl restart mariadb

# Create directory for SQL files
sudo mkdir -p /opt/db-init

# Clone the repository
cd /tmp
git clone https://github.com/aaron-dm-mcdonald/Class7-notes.git
cd Class7-notes/110725

# Copy init.sql
sudo cp src/db/init.sql /opt/db-init/

# Initialize the database
sudo mysql -u root -pRootPassword123! < /opt/db-init/init.sql

echo "Database server setup complete!"
echo "Database initialized with picture_gallery schema"
echo "Verify with: sudo mysql -u root -pRootPassword123! -e 'SHOW DATABASES;'"
echo "Check tables: sudo mysql -u root -pRootPassword123! -e 'USE picture_gallery; SHOW TABLES;'"