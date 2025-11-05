 # **Informe: Optimización de consultas por período mediante índices en SQL Server**

## Introducción

En bases de datos con gran volumen de información —por ejemplo, tablas con más de un millón de registros— las consultas que filtran por rangos de fecha suelen ser costosas en tiempo y en I/O. SQL Server ofrece distintos tipos de índices que permiten reducir las lecturas físicas y mejorar los tiempos de respuesta.

Este informe documenta un práctico cuyo objetivo fue:

- Ejecutar una consulta filtrada por período de fechas
- Registrar el plan de ejecución y tiempos sin índices
- Crear un índice agrupado (clustered) y medir el impacto
- Crear un índice no agrupado con columnas incluidas (INCLUDE) y comparar

## Consulta evaluada

La consulta analizada fue:

```sql
SELECT socio_id, tipo_pago_id, fecha, total, estado
FROM dbo.pago
WHERE fecha >= '2024-01-01' AND fecha < '2024-03-01';
```

La prueba se aplicó sobre una tabla con más de 1 millón de filas.

## Metodología

Para obtener mediciones comparables se aplicaron las siguientes prácticas:

- Se habilitaron SET STATISTICS IO y SET STATISTICS TIME para cuantificar consumo de recursos.
- Se obtuvieron planes de ejecución reales desde SSMS.
- Se ejecutaron DBCC FREEPROCCACHE y DBCC DROPCLEANBUFFERS para medir en frío.(borrar el cache de las consultas)
- Se repitieron las pruebas bajo distintos esquemas de indexación.

## Resultados obtenidos

### Escenario 1 — Sin índice en fecha (búsqueda completa)

| Métrica         | Valor          |
| --------------- | -------------- |
| Filas devueltas | 20.514         |
| Logical Reads   | **5209**       |
| CPU Time        | **250 ms**     |
| Elapsed Time    | **487 ms**     |
| Plan            | **Table Scan** |

Interpretación: el motor realizó un recorrido completo de la tabla (table scan), con un coste elevado en I/O y tiempo.

### Escenario 2 — Índice Clustered en fecha

| Métrica         | Valor                      |
| --------------- | -------------------------- |
| Filas devueltas | 20.514                     |
| Logical Reads   | **112**                    |
| CPU Time        | **16 ms**                  |
| Elapsed Time    | **155 ms**                 |
| Plan            | **Index Seek (Clustered)** |

Mejora notable: las lecturas lógicas se redujeron ~98% y los tiempos se redujeron considerablemente. La tabla quedó físicamente ordenada por fecha.

### Escenario 3 — Índice No Clustered con INCLUDE

| Métrica       | Valor                   |
| ------------- | ----------------------- |
| Logical Reads | **93**                  |
| CPU Time      | **0 ms**                |
| Elapsed Time  | **176 ms**              |
| Plan          | **Index Seek (Covering)** |

El índice nonclustered incluía las columnas necesarias (INCLUDE), convirtiendo la consulta en una operación cubriente (covering index). Esto minimizó aún más las lecturas lógicas.

## Comparación general

| Escenario              | Logical Reads | CPU Time | Tiempo Total | Plan                  |
| ---------------------- | ------------- | -------- | ------------ | --------------------- |
| Sin índice             | 5209          | 250 ms   | 487 ms       | Table Scan            |
| Clustered por fecha    | 112           | 16 ms    | 155 ms       | Index Seek            |
| NonClustered + INCLUDE | **93**        | **0 ms** | 176 ms       | Index Seek (Covering) |

## Conclusión

El uso de índices tiene un impacto crítico en el rendimiento de consultas por rango de fechas. Sin índices, SQL Server debe escanear toda la tabla, lo que genera altos tiempos de respuesta. Un índice clustered sobre la columna de fecha transforma un Table Scan en un Index Seek y reduce lecturas y tiempo significativamente. Un índice nonclustered con columnas incluidas puede reducir aún más las lecturas lógicas y servir como índice cubriente cuando la consulta requiere siempre las mismas columnas.

En resumen: elegir el tipo de índice correcto (clustered vs nonclustered + INCLUDE) depende del patrón de consultas y del conjunto de columnas que la consulta necesita; en este caso el índice nonclustered cubriente obtuvo las mejores lecturas lógicas, mientras que el clustered también ofreció una mejora muy significativa en tiempos.