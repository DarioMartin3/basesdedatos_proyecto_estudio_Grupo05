import pyodbc, random, datetime
from itertools import islice

# Conexión: ajusta DRIVER/SERVER/DB/USER/PWD
cn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost\\SQLEXPRESS;DATABASE=gimnasio_db_2;Trusted_Connection=yes;",
    autocommit=False
)
cur = cn.cursor()
cur.fast_executemany = True

def fetch_valid_catalogs():
    membresia = [row[0] for row in cur.execute("SELECT id_membresia FROM dbo.membresia").fetchall()]
    clase  = [row[0] for row in cur.execute("SELECT id_clase  FROM dbo.clase").fetchall()]
    if not membresia or not clase:
        raise RuntimeError("Faltan filas en membresia o clase.")
    return membresia, clase



TOTAL_ROWS = 10_000
BATCH = 5_000

def gen_rows(n):
    membresia, clase = fetch_valid_catalogs()
    for _ in range(n):
        membresia_id = random.choice(membresia)
        clase_id  = random.choice(clase)
        yield (membresia_id, clase_id, membresia_id, clase_id)

sql = """INSERT INTO dbo.membresia_clase (membresia_id, clase_id) 
SELECT ?, ?
WHERE NOT EXISTS (
  SELECT 1
  FROM dbo.membresia_clase WITH (UPDLOCK, HOLDLOCK)
  WHERE membresia_id = ? AND clase_id = ?
);"""

def batched(iterable, size):
    while True:
        chunk = list(islice(iterable, size))
        if not chunk: break
        yield chunk

def insert_data_membresia_clase():
    count = 0
    for chunk in batched(gen_rows(TOTAL_ROWS), BATCH):
        cur.executemany(sql, chunk)
        cn.commit()
        count += len(chunk)
        print(f"Insertados {count}...")

    cur.close(); cn.close()
    print("Carga masiva de membresia_clase finalizada.")