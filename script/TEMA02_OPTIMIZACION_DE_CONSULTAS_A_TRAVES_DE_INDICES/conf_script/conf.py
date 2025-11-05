DB_HOST = "localhost"
DB_NAME = "mi_base"

#----------- conf para el archivo de carga masiva de membresia_clase_insert.py -----------
#total de filas a insertar
TOTAL_ROWS_MEMBRESIA_CLASE = 10_000
#tamaño del batch para cada inserción masiva
BATCH_MEMBRESIA_CLASE = 5_000

#----------- conf para el archivo de carga masiva de membresia_insert.py -----------
# configuración de fechas para la generación aleatoria de fechas de inicio
#esto indica a partir de qué fecha se generan las fechas aleatorias
DAYS_START_MEMBRESIA = 1
MONTHS_START_MEMBRESIA = 1
YEARS_START_MEMBRESIA = 2017
#esto indica el rango máximo de días a agregar a la fecha de inicio para generar fechas aleatorias
DAYS_MEMBRESIA = 2920 #equivalente a 8 años
#total de filas a insertar
TOTAL_ROWS_MEMBRESIA = 10_000
#tamaño del batch para cada inserción masiva
BATCH_MEMBRESIA = 5_000

#----------- conf para el archivo de carga masiva de pago_insert.py -----------

DAYS_START_PAGO = 1
MONTHS_START_PAGO = 1
YEARS_START_PAGO = 2017
#esto indica el rango máximo de días a agregar a la fecha de inicio para generar fechas aleatorias
DAYS_PAGO = 2920 #equivalente a 8 años
#total de filas a insertar
TOTAL_ROWS_PAGO = 10_000
#tamaño del batch para cada inserción masiva
BATCH_PAGO = 5_000

#----------- conf para el archivo de carga masiva de pago_detalle_insert.py -----------
#total de filas a insertar
TOTAL_ROWS_PAGO_DETALLE = 10_000
#tamaño del batch para cada inserción masiva
BATCH_PAGO_DETALLE = 5_000