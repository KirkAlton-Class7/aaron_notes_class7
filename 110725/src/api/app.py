from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for frontend requests

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'YOUR_DB_PRIVATE_IP'),
    'user': 'appuser',
    'password': 'apppassword',
    'database': 'picture_gallery'
}

def get_db_connection():
    """Create and return a database connection"""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except mysql.connector.Error as err:
        print(f"Database connection error: {err}")
        return None

@app.route('/api/login', methods=['POST'])
def login():
    """Authenticate user credentials"""
    data = request.get_json()
    
    if not data or 'username' not in data or 'password' not in data:
        return jsonify({
            'success': False,
            'message': 'Username and password required'
        }), 400
    
    username = data['username']
    password = data['password']
    
    conn = get_db_connection()
    if not conn:
        return jsonify({
            'success': False,
            'message': 'Database connection failed'
        }), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        query = "SELECT * FROM users WHERE username = %s AND password = %s"
        cursor.execute(query, (username, password))
        user = cursor.fetchone()
        
        if user:
            return jsonify({
                'success': True,
                'message': 'Login successful'
            }), 200
        else:
            return jsonify({
                'success': False,
                'message': 'Invalid username or password'
            }), 401
    
    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({
            'success': False,
            'message': 'Database error'
        }), 500
    
    finally:
        cursor.close()
        conn.close()

@app.route('/api/pictures', methods=['GET'])
def get_pictures():
    """Retrieve all pictures from database"""
    conn = get_db_connection()
    if not conn:
        return jsonify({
            'success': False,
            'message': 'Database connection failed'
        }), 500
    
    try:
        cursor = conn.cursor(dictionary=True)
        query = "SELECT id, name, url FROM pictures ORDER BY name"
        cursor.execute(query)
        pictures = cursor.fetchall()
        
        return jsonify({
            'success': True,
            'pictures': pictures
        }), 200
    
    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({
            'success': False,
            'message': 'Database error'
        }), 500
    
    finally:
        cursor.close()
        conn.close()

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)