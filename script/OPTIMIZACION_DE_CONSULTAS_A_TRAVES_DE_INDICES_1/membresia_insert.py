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
    tipos = [row[0] for row in cur.execute("SELECT id_tipo FROM dbo.membresia_tipo").fetchall()]
    users  = [row[0] for row in cur.execute("SELECT id_usuario  FROM dbo.usuario").fetchall()]
    socios  = [row[0] for row in cur.execute("SELECT id_socio  FROM dbo.socio").fetchall()]
    if not users or not tipos or not socios:
        raise RuntimeError("Faltan filas en socio, usuario o tipo.")
    return tipos, users, socios

START = datetime.date(2017,1,1)
DAYS  = 2920
TOTAL_ROWS = 10_000
BATCH = 5_000

def gen_rows(n):
    tipos, users, socios = fetch_valid_catalogs()
    for _ in range(n):
        usuario_id = random.choice(users)
        tipo_id  = random.choice(tipos)
        socio_id = random.choice(socios)
        fecha_inicio    = START + datetime.timedelta(days=random.randrange(DAYS))
        estado   = 1 if random.randrange(100) < 92 else 0
        yield (usuario_id, tipo_id, socio_id, fecha_inicio, estado)

sql = "INSERT INTO dbo.membresia (usuario_id, tipo_id, socio_id, fecha_inicio, estado) VALUES (?,?,?,?,?)"

def batched(iterable, size):
    while True:
        chunk = list(islice(iterable, size))
        if not chunk: break
        yield chunk


def insert_data():
    count = 0
    for chunk in batched(gen_rows(TOTAL_ROWS), BATCH):
        cur.executemany(sql, chunk)
        cn.commit()
        count += len(chunk)
        print(f"Insertados {count}...")

    cur.close(); cn.close()
    print("Carga masiva de membresia finalizada.")

