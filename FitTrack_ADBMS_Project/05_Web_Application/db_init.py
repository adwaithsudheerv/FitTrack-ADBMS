"""
FitTrack Database Initializer
Creates SQLite database from schema_ddl.sql and mock_data_dml.sql
"""

import sqlite3
import os

DB_PATH = os.path.join(os.path.dirname(__file__), "fittrack.db")
DDL_PATH = os.path.join(os.path.dirname(__file__), "..", "02_Database_Scripts", "schema_ddl.sql")
DML_PATH = os.path.join(os.path.dirname(__file__), "..", "02_Database_Scripts", "mock_data_dml.sql")

def init_database():
    if os.path.exists(DB_PATH):
        try:
            os.remove(DB_PATH)
        except Exception:
            pass

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Enable foreign keys
    cursor.execute("PRAGMA foreign_keys = ON;")

    # Read and execute DDL
    with open(DDL_PATH, "r", encoding="utf-8") as f:
        ddl_script = f.read()
    cursor.executescript(ddl_script)

    # Read and execute DML
    with open(DML_PATH, "r", encoding="utf-8") as f:
        dml_script = f.read()
    cursor.executescript(dml_script)

    # Also create Diet Plan table for Task 10 JSON operations
    diet_ddl = """
    CREATE TABLE IF NOT EXISTS MEMBER_DIET_PLAN (
        diet_id INT PRIMARY KEY,
        member_id INT NOT NULL,
        plan_name VARCHAR(100) NOT NULL,
        daily_calories INT CHECK (daily_calories > 0),
        nutrition_spec_json TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (member_id) REFERENCES MEMBER(member_id)
    );
    """
    cursor.execute(diet_ddl)

    # Insert Task 10 diet records
    task10_sql = os.path.join(os.path.dirname(__file__), "..", "04_JSON_and_XML", "task_10_json_operations.sql")
    with open(task10_sql, "r", encoding="utf-8") as f:
        lines = f.readlines()
        insert_stmts = []
        current = []
        capture = False
        for line in lines:
            if "INSERT INTO MEMBER_DIET_PLAN" in line:
                capture = True
            if capture:
                current.append(line)
                if line.strip().endswith(";"):
                    insert_stmts.append("".join(current))
                    current = []
                    capture = False
        for stmt in insert_stmts:
            try:
                cursor.execute(stmt)
            except Exception as e:
                print(f"Diet insert warning: {e}")

    conn.commit()
    conn.close()
    print("FitTrack database successfully initialized at:", DB_PATH)

if __name__ == "__main__":
    init_database()
