-- Create the database
CREATE DATABASE IF NOT EXISTS picture_gallery;
USE picture_gallery;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create pictures table
CREATE TABLE IF NOT EXISTS pictures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    url VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample users
INSERT INTO users (username, password) VALUES
('admin', 'admin123'),
('user1', 'password1'),
('demo', 'demo123');

-- Insert sample pictures
INSERT INTO pictures (name, url) VALUES
('Beautiful Sunset', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4'),
('Mountain Peak', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4'),
('Ocean Waves', 'https://images.unsplash.com/photo-1505142468610-359e7d316be0'),
('Forest Trail', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e'),
('City Lights', 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b'),
('Desert Dunes', 'https://images.unsplash.com/photo-1509316785289-025f5b846b35'),
('Northern Lights', 'https://images.unsplash.com/photo-1531366936337-7c912a4589a7'),
('Tropical Beach', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e');

-- Create application user for API access
CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'apppassword';
GRANT SELECT, INSERT, UPDATE, DELETE ON picture_gallery.* TO 'appuser'@'%';
FLUSH PRIVILEGES;

-- Display success message
SELECT 'Database initialized successfully!' AS message;