import pyodbc, random, datetime
from itertools import islice
from conf_script.conf import TOTAL_ROWS_PAGO_DETALLE, BATCH_PAGO_DETALLE, BD_HOST, DB_NAME

# Conexión: ajusta DRIVER/SERVER/DB/USER/PWD
cn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    f"SERVER={BD_HOST};DATABASE={DB_NAME};Trusted_Connection=yes;",
    autocommit=False
)
cur = cn.cursor()
cur.fast_executemany = True

TOTAL_ROWS = TOTAL_ROWS_PAGO_DETALLE
BATCH = BATCH_PAGO_DETALLE

sql = "INSERT INTO dbo.pago_detalle (membresia_id, clase_id, pago_id) VALUES (?,?,?)"

def fetch_valid_catalogs():
    pago = [row[0] for row in cur.execute("SELECT id_pago FROM dbo.pago").fetchall()]
    membresia = [row[0] for row in cur.execute("SELECT id_membresia  FROM dbo.membresia").fetchall()]
    clase  = [row[0] for row in cur.execute("SELECT id_clase  FROM dbo.clase").fetchall()]
    if not membresia or not clase or not pago:
        raise RuntimeError("Faltan filas en membresia o clase.")
    return membresia, clase, pago


def gen_rows(n):
    membresia, clase, pago = fetch_valid_catalogs()
    for _ in range(n):
        membresia_id = random.choice(membresia)
        clase_id  = random.choice(clase)
        pago_id = random.choice(pago)
        yield (membresia_id, clase_id, pago_id)



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