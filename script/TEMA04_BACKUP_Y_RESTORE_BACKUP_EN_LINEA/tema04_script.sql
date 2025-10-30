USE gimnasioDB

----------------------------------------------
--	TEMA: BACKUP Y RESTORE. BACKUP EN LINEA
----------------------------------------------

--  TAREAS
--1) Verificar que el modelo de recuperación de la base de datos esté en el modo adecuado para realizar backup en línea
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'gimnasio_db';

-- SALIDA: al ejecutar esta consulta,

--2) Realizar un backup full de la base de datos.
--3) Generar 10 inserts sobre una tabla de referencia.
--4) Realizar backup del archivo de log y registrar la hora del backup
--5) Generar otros 10 insert sobre la tabla de referencia.
--6) Realizar nuevamente backup de archivo de log  en otro archivo físico.
--7) Restaurar la base de datos al momento del primer backup del archivo de log. Es decir después de los primeros 10 insert.
--8) Verificar el resultado.
--9) Restaurar la base de datos aplicando ambos archivos de log.
--10) Expresar sus conclusiones.