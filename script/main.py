from OPTIMIZACION_DE_CONSULTAS_A_TRAVES_DE_INDICES_1.membresia_clase_insert import insert_data_membresia_clase
from OPTIMIZACION_DE_CONSULTAS_A_TRAVES_DE_INDICES_1.pago_detalle_insert import insert_data_pago_detalle    
from OPTIMIZACION_DE_CONSULTAS_A_TRAVES_DE_INDICES_1.pagos_insert import insert_data_pagos
from OPTIMIZACION_DE_CONSULTAS_A_TRAVES_DE_INDICES_1.membresia_insert import insert_data

if __name__ == "__main__":
    print("Iniciando carga masiva de datos...")
    insert_data()
    insert_data_pagos()
    insert_data_pago_detalle()
    insert_data_membresia_clase()
    print("Carga masiva de datos completada.")