# Backup y Restore en Línea

## Información General
**Asignatura:** Bases de Datos I (FaCENA - UNNE)

## Descripción del Procedimiento
Este documento detalla el proceso implementado para ejecutar y validar una estrategia de backup y restore en SQL Server sobre la base de datos `gimnasio_db`. El objetivo es demostrar cómo realizar copias de seguridad mientras la base de datos está en uso y cómo restaurar la información a puntos específicos en el tiempo.

## 1. Preparación de la Base de Datos
Antes de realizar cualquier backup, es fundamental asegurarse de que la base de datos esté configurada para registrar todas las transacciones. Esto se logra con el **Modelo de Recuperación FULL**.

### Verificación del Modelo Actual
```sql
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'gimnasio_db';
```
La salida de este comando fue `SIMPLE`, lo cual no es adecuado para backups de log.

> **Nota:** `sys.databases` vista del sistema que contiene información sobre todas las bases de datos del servidor. `name` devuelve el nombre de la base de datos. `recovery_model_desc` muestra el modelo de recuperación actual (SIMPLE, FULL o BULK_LOGGED)

## Comparativa de Modelos de Recuperación en SQL Server usados en este trabajo

| Característica | SIMPLE | FULL |
|----------------|---------|------|
| **Registro de transacciones** | Solo se registra lo minimo y necesario para completar la operacion, el log se limpia automáticamente al terminar la transaccion. | Se registran **todas** las transacciones. |
| **Tamaño del log de transacciones** | Pequeño (se limpia automáticamente). | Puede crecer mucho si no se hacen backups de log ya que el log no se limpia automáticamente como en el **SIMPLE**. | 
| **Posibilidad de restaurar a un punto específico en el tiempo** | ❌ No se puede. | ✅ Sí, se puede restaurar a cualquier punto exacto. | 
| **Uso típico** | Bases de datos pequeñas o de prueba, donde no se necesita recuperación avanzada. | Sistemas críticos donde la pérdida de datos no es aceptable. |
| **Backups de log permitidos** | ❌ No. | ✅ Sí. |
| **Rendimiento** | Alto (menos sobrecarga de log). El servidor no escribe tanto en el log por eso trabaja más rápido | Menor rendimiento (más escritura en log). Ya que cada detalle de la operación de resgistra en el log | 

> **Resumen:**  
> - **SIMPLE:** rápido pero con menor capacidad de recuperación.  
> - **FULL:** más seguro, permite restauraciones exactas en el tiempo.  


### Configuración del Modelo FULL
```sql
ALTER DATABASE gimnasio_db
SET RECOVERY FULL;
```
> **Nota:** `SET RECOVERY FULL` Este comando modifica la propiedad de la base de datos para que comience a registrar cada transacción en su archivo de log, habilitando la capacidad de restauración a un punto en el tiempo.

## 2. Creación del Backup Completo (Full)
Se creó un backup completo como punto de partida. Este archivo `.bak` es la "fotografía" inicial y completa de la base de datos.

```sql
BACKUP DATABASE gimnasio_db
TO DISK = 'C:\BackupsSQL\gimnasio_db_full.bak'
WITH NAME = 'Backup full gimnasio_db';
```
> **Nota:** `BACKUP DATABASE` es el comando principal para crear una copia de seguridad completa de la base de datos especificada. `TO DISK` ruta donde se guardará la copia. `WITH NAME` escribe un nombre descriptivo dentro del archivo de backup.

## 3. Simulación de Cambios y Backup de Log

### Primer Lote de Cambios
1. Se insertaron 10 registros en las tablas `persona` y `socio`.
2. Se realizó el primer backup de log para guardar estas 10 transacciones:
```sql
BACKUP LOG gimnasio_db
TO DISK = 'C:\BackupsSQL\gimnasio_db_log1.trn';
```
> **Nota:** `BACKUP LOG` solo copia las transacciones registradas desde el último backup, no toda la base de datos.
Este archivo `.trn` guarda todas las transacciones ocurridas luego de la copia `.bak`.

### Segundo Lote de Cambios
Se repitió el proceso:
1. Se insertaron otros 10 registros
2. Se creó un segundo archivo de log (`gimnasio_db_log2.trn`) para guardar estas nuevas transacciones.

## 4. Restauración a un Punto Específico en el Tiempo
En este paso, se restauró la base de datos al estado que tenía después del primer lote de 10 inserts, descartando el segundo.

### Paso A: Restaurar la Base Completa
Se restauró el archivo `.bak` principal, pero dejándolo en un estado de "restauración" para poder aplicarle más archivos.
```sql
RESTORE DATABASE gimnasio_db
FROM DISK = 'C:\BackupsSQL\gimnasio_db_full.bak' 
WITH NORECOVERY, REPLACE;
```
> **Nota:** `RESTORE DATABASE` recupera los datos. destruye el presente y reconstruye la base a como estaba en esa copia.
 `WITH NORECOVERY` deja la base de datos inaccesible, esperando más archivos de restauración. es como que se deja "en proceso".
 `WITH REPLACE` sobrescribe la base de datos actual.

### Paso B: Aplicar el Log y Finalizar: Se aplicó el primer archivo de log y se finalizó el  proceso.
```sql
RESTORE LOG gimnasio_db
FROM DISK = 'C:\BackupsSQL\gimnasio_db_log1.trn'
WITH RECOVERY;
```
> **Nota:** `WITH RECOVERY` esta opción "cierra" la restauración y pone la base de datos en línea y funcional, lista para usarse.

Verificación: Una consulta SELECT * FROM socio; mostró que solo estaban presentes los socios hasta el ultimo id_socio del primer insert, confirmando que la restauración fue exitosa.
## 5. Restauración Completa Aplicando Todos los Logs
Finalmente, se demostró cómo recuperar todo el trabajo, restaurando la base de datos a su estado más reciente.

El proceso fue similar, pero aplicando toda la cadena de backups:

1. `RESTORE DATABASE ... WITH NORECOVERY;` (Usando el archivo `.bak`)
2. `RESTORE LOG ... WITH NORECOVERY;` (Usando el primer archivo `.trn`)
3. `RESTORE LOG ... WITH RECOVERY;` (Usando el segundo archivo `.trn` para finalizar)

La verificación final con `SELECT` mostró los 20 registros agregados en los inserts, confirmando que todos los datos fueron recuperados exitosamente.
