import pymysql
from fastapi import FastAPI
import asyncio
import os
import time
import random

DB_SERVER = os.getenv("DB_SERVER", "mysql-source")
DB_PORT = os.getenv("DB_PORT", "3306")
DB_USER = os.getenv("DB_USER", "root")
DB_PASSWORD = os.getenv("DB_PASSWORD", "rootpwd")
DB_NAME = os.getenv("DB_NAME", "testdb")

app = FastAPI(title="MySQL Simulation Service")


# --- Async loops ---
async def background_loop():
    cfg = dict(host=DB_SERVER, port=int(DB_PORT), user=DB_USER, password=DB_PASSWORD, db=DB_NAME, autocommit=True)
    conn = pymysql.connect(**cfg)
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )
    """)

    i = 1
    while True:
        op = random.choice(['insert', 'update', 'delete'])
        try:
            if op == 'insert':
                cur.execute("INSERT INTO users (id, name) VALUES (%s, %s)", (i, f'name-{i}'))
                i += 1
            elif op == 'update':
                uid = random.randint(1, max(1, i-1))
                cur.execute("UPDATE users SET name = %s WHERE id = %s", (f'upd-{uid}-{int(time.time())}', uid))
            else:
                uid = random.randint(1, max(1, i-1))
                cur.execute("DELETE FROM users WHERE id = %s", (uid,))
        except Exception as e:
            pass
        time.sleep(0.05)


# --- Routes ---
@app.get("/sim-loop")
async def sim_loop():
    asyncio.create_task(background_loop())
    return {"status": "ok", "message": "Simulation loop started in background"}
