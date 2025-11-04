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

# Traer catálogos válidos para FKs
def fetch_valid_catalogs():
    socios = [row[0] for row in cur.execute("SELECT id_socio FROM dbo.socio").fetchall()]
    tipos  = [row[0] for row in cur.execute("SELECT id_tipo_pago  FROM dbo.tipo_pago").fetchall()]
    if not socios or not tipos:
        raise RuntimeError("Faltan filas en socio o tipo_pago.")
    return socios, tipos

START = datetime.date(2017,1,1)
DAYS  = 2920
TOTAL_ROWS = 10_000
BATCH = 5_000

def gen_rows(n):
    socios, tipos = fetch_valid_catalogs()
    for _ in range(n):
        socio_id = random.choice(socios)
        tipo_id  = random.choice(tipos)
        fecha    = START + datetime.timedelta(days=random.randrange(DAYS))
        total    = round(500 + random.randrange(49_501) + random.random(), 2)
        estado   = 1 if random.randrange(100) < 92 else 0
        yield (socio_id, tipo_id, fecha, total, estado)

sql = "INSERT INTO dbo.pago (socio_id, tipo_pago_id, fecha, total, estado) VALUES (?,?,?,?,?)"

def batched(iterable, size):
    while True:
        chunk = list(islice(iterable, size))
        if not chunk: break
        yield chunk 



def insert_data_pagos():
    count = 0
    for chunk in batched(gen_rows(TOTAL_ROWS), BATCH):
        cur.executemany(sql, chunk)
        cn.commit()
        count += len(chunk)
        print(f"Insertados {count}...")

    cur.close(); cn.close()
    print("Carga masiva finalizada.")