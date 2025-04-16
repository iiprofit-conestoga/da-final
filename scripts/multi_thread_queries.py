import mysql.connector
import threading
import time
from datetime import datetime, timedelta
import random

# Database configuration
DB_CONFIG = {
    'host': '185.239.208.33',
    'user': 'root',
    'password': 'Capstone_2025',
    'database': 'project_db'
}

def execute_insert_query():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        # Generate random climate data
        locations = ['Toronto', 'Vancouver', 'Montreal', 'Calgary', 'Halifax']
        location = random.choice(locations)
        temperature = random.uniform(5, 25)
        precipitation = random.uniform(0, 10)
        humidity = random.uniform(50, 90)
        
        query = """
        INSERT INTO ClimateData (location, record_date, temperature, precipitation, humidity)
        VALUES (%s, %s, %s, %s, %s)
        """
        values = (location, datetime.now().date(), temperature, precipitation, humidity)
        
        cursor.execute(query, values)
        conn.commit()
        print(f"Insert successful: {location}, {temperature}°C")
        
    except Exception as e:
        print(f"Insert error: {str(e)}")
    finally:
        cursor.close()
        conn.close()

def execute_select_query():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        query = """
        SELECT location, temperature, humidity 
        FROM ClimateData 
        WHERE temperature > 20
        """
        
        cursor.execute(query)
        results = cursor.fetchall()
        print(f"Select results: Found {len(results)} records with temperature > 20°C")
        
    except Exception as e:
        print(f"Select error: {str(e)}")
    finally:
        cursor.close()
        conn.close()

def execute_update_query():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        query = """
        UPDATE ClimateData 
        SET humidity = humidity + 5 
        WHERE location = 'Toronto'
        """
        
        cursor.execute(query)
        conn.commit()
        print(f"Update successful: Modified {cursor.rowcount} records")
        
    except Exception as e:
        print(f"Update error: {str(e)}")
    finally:
        cursor.close()
        conn.close()

def main():
    # Create threads for each query type
    threads = []
    
    # Start multiple threads for each query type
    for _ in range(3):
        threads.append(threading.Thread(target=execute_insert_query))
        threads.append(threading.Thread(target=execute_select_query))
        threads.append(threading.Thread(target=execute_update_query))
    
    # Start all threads
    for thread in threads:
        thread.start()
    
    # Wait for all threads to complete
    for thread in threads:
        thread.join()

if __name__ == "__main__":
    main() 