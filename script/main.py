from TEMA02_OPTIMIZACION_DE_CONSULTAS_A_TRAVES_DE_INDICES.membresia_clase_insert import insert_data_membresia_clase
from TEMA02_OPTIMIZACION_DE_CONSULTAS_A_TRAVES_DE_INDICES.pago_detalle_insert import insert_data_pago_detalle    
from TEMA02_OPTIMIZACION_DE_CONSULTAS_A_TRAVES_DE_INDICES.pagos_insert import insert_data_pagos
from TEMA02_OPTIMIZACION_DE_CONSULTAS_A_TRAVES_DE_INDICES.membresia_insert import insert_data

if __name__ == "__main__":
    print("Iniciando carga masiva de datos...")
    insert_data()
    insert_data_pagos()
    insert_data_pago_detalle()
    insert_data_membresia_clase()
    print("Carga masiva de datos completada.")