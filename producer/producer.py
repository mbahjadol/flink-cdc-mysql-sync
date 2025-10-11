import pymysql
import time, random

cfg = dict(host='127.0.0.1', port=3307, user='root', password='rootpwd', db='testdb', autocommit=True)
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