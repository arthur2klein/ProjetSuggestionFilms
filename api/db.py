import psycopg2

DB_HOST = 'database'
DB_PORT = '5432'
DB_NAME = 'movie_db'
DB_USER = 'myuser'
DB_PASSWORD = 'mypassword'

def get_db_connection():
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    return conn
