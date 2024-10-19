from flask import Flask, render_template
import mysql.connector
from mysql.connector import Error
 
app = Flask(__name__)
 
# Function to check database connection
def check_db_connection():
    try:
        # Try to connect to the MySQL database
        connection = mysql.connector.connect(
            host='172.30.0.15',
            database='db_services',  # Change this to your database name
            user='toor',
            password='summer'
        )
        if connection.is_connected():
            return True
    except Error as e:
        return False
    finally:
        if 'connection' in locals() and connection.is_connected():
            connection.close()
 
@app.route('/')
def home():
    # Check if the database connection is successful
    is_connected = check_db_connection()
    return render_template('index.html', is_connected=is_connected)
 
if __name__ == '__main__':
    # Host the app on port 9200
    app.run(host='0.0.0.0', port=9200, debug=True)