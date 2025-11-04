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
    pago = [row[0] for row in cur.execute("SELECT id_pago FROM dbo.pago").fetchall()]
    membresia = [row[0] for row in cur.execute("SELECT id_membresia  FROM dbo.membresia").fetchall()]
    clase  = [row[0] for row in cur.execute("SELECT id_clase  FROM dbo.clase").fetchall()]
    if not membresia or not clase or not pago:
        raise RuntimeError("Faltan filas en membresia o clase.")
    return membresia, clase, pago
TOTAL_ROWS = 10_000
BATCH = 5_000

def gen_rows(n):
    membresia, clase, pago = fetch_valid_catalogs()
    for _ in range(n):
        membresia_id = random.choice(membresia)
        clase_id  = random.choice(clase)
        pago_id = random.choice(pago)
        yield (membresia_id, clase_id, pago_id)

sql = "INSERT INTO dbo.pago_detalle (membresia_id, clase_id, pago_id) VALUES (?,?,?)"

def batched(iterable, size):
    while True:
        chunk = list(islice(iterable, size))
        if not chunk: break
        yield chunk


def insert_data_pago_detalle():
    count = 0
    for chunk in batched(gen_rows(TOTAL_ROWS), BATCH):
        cur.executemany(sql, chunk)
        cn.commit()
        count += len(chunk)
        print(f"Insertados {count}...")

    cur.close(); cn.close()
    print("Carga masiva de pago_detalle finalizada.")