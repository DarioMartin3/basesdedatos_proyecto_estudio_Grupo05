USE gimnasio_db

----------------------------------------------
--	TEMA: BACKUP Y RESTORE. BACKUP EN LINEA
----------------------------------------------
--  TAREAS

--1) Verificar que el modelo de recuperación de la base de datos esté en el modo adecuado para realizar backup en línea
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'gimnasio_db';

-- Salida al ejecutar esta consulta: "SIMPLE", al estar en modo simple, no se encuentra en el modo adecuado 
-- para realizar el backup en linea, ya que para poder hacer un backup en linea, debe estar en modo "FULL"
-- Entonces procedo a cambiar el modo:
ALTER DATABASE gimnasio_db
SET RECOVERY FULL;

-- Ahora si volvemos a ejecutar la consulta anterior, podemos ver que la salida es "FULL", es decir ya se encuentra
-- en el modo correcto.

------------------------------------------------------------------------------------------------------------------------

--2) Realizar un backup full de la base de datos.
BACKUP DATABASE gimnasio_db
TO DISK = 'C:\BackupsSQL\gimnasio_db_full.bak'
WITH NAME = 'Backup full gimnasio_db'

-- Realizo el backup full de la base de datos

------------------------------------------------------------------------------------------------------------------------

--3) Generar 10 inserts sobre una tabla de referencia.
-- Inserto 10 nuevas personas

-- Declaramos la variable para guardar los IDs generados, para hacer el insert de manera dinamica
-- y no tener problemas con el ingreso del lote luego
DECLARE @NuevosIDs TABLE (id INT);

INSERT INTO persona (nombre, apellido, dni, telefono, email) 
OUTPUT inserted.id_persona INTO @NuevosIDs --Capturo los IDs generados por las nuevas personas para los socios
VALUES
('Juan', 'Perez', 30123456, 111111, 'juan.perez@email.com'),
('Ana', 'Gomez', 31123457, 222222, 'ana.gomez@email.com'),
('Luis', 'Martinez', 32123458, 333333, 'luis.martinez@email.com'),
('Maria', 'Rodriguez', 33123459, 444444, 'maria.rodriguez@email.com'),
('Carlos', 'Lopez', 34123450, 555555, 'carlos.lopez@email.com'),
('Laura', 'Sanchez', 35123451, 666666, 'laura.sanchez@email.com'),
('Pedro', 'Gonzalez', 36123452, 777777, 'pedro.gonzalez@email.com'),
('Sofia', 'Fernandez', 37123453, 888888, 'sofia.fernandez@email.com'),
('Diego', 'Diaz', 38123454, 999999, 'diego.diaz@email.com'),
('Valeria', 'Moreno', 39123455, 101010, 'valeria.moreno@email.com');

-- Como id_socio es clave foránea de persona, inserto los socios correspondientes.
-- Inserto los 10 socios de una sola vez, usando los IDs que capture en la variable.
INSERT INTO socio (id_socio, contacto_emergencia, observaciones)
SELECT
    id,                         -- El id dinámico de la variable
    123456789,                  -- El contacto de emergencia
    'Sin observaciones'         -- Una observación genérica para todos
FROM @NuevosIDs;

------------------------------------------------------------------------------------------------------------------------

--4) Realizar backup del archivo de log y registrar la hora del backup
BACKUP LOG gimnasio_db
TO DISK = 'C:\BackupsSQL\gimnasio_db_log1.trn'
WITH NAME = 'Backup del log 1 - Luego de 10 inserts';
--GUARDO LA HORA:
SELECT GETDATE() AS HoraBackupLog1;

------------------------------------------------------------------------------------------------------------------------

--5) Generar otros 10 insert sobre la tabla de referencia.
-- Inserto otras 10 personas

-- Creo otra variable para insertar los nuevos 10 socios tambien de manera dinamica
DECLARE @NuevosIDs2 TABLE (id INT);

INSERT INTO persona (nombre, apellido, dni, telefono, email) 
OUTPUT inserted.id_persona INTO @NuevosIDs2 --Capturo los IDs generados por las nuevas personas para los socios
VALUES
('Jorge', 'Ramirez', 40123456, 111112, 'jorge.ramirez@email.com'),
('Lucia', 'Acosta', 41123457, 222223, 'lucia.acosta@email.com'),
('Martin', 'Garcia', 42123458, 333334, 'martin.garcia@email.com'),
('Camila', 'Alvarez', 43123459, 444445, 'camila.alvarez@email.com'),
('Nicolas', 'Torres', 44123450, 555556, 'nicolas.torres@email.com'),
('Julieta', 'Ruiz', 45123451, 666667, 'julieta.ruiz@email.com'),
('Matias', 'Gimenez', 46123452, 777778, 'matias.gimenez@email.com'),
('Paula', 'Sosa', 47123453, 888889, 'paula.sosa@email.com'),
('Federico', 'Benitez', 48123454, 999990, 'federico.benitez@email.com'),
('Agustina', 'Pereyra', 49123455, 101011, 'agustina.pereyra@email.com');

-- Inserto los 10 socios correspondientes de manera dinamica
INSERT INTO socio (id_socio, contacto_emergencia, observaciones)
SELECT
    id,                         -- El id dinámico de la variable
    123456789,                  -- El contacto de emergencia
    'Sin observaciones'         -- Una observación genérica para todos
FROM @NuevosIDs2;

------------------------------------------------------------------------------------------------------------------------

--6) Realizar nuevamente backup de archivo de log en otro archivo físico.
BACKUP LOG gimnasio_db
TO DISK = 'C:\BackupsSQL\gimnasio_db_log2.trn'
WITH NAME = 'Backup del log 2 - Luego de 10 inserts';
--GUARDO LA HORA:
SELECT GETDATE() AS HoraBackupLog2;

------------------------------------------------------------------------------------------------------------------------
--7) Restaurar la base de datos al momento del primer backup del archivo de log. Es decir después de los primeros 10 insert.
USE master; --CAMBIO DE BASE PARA EVITAR ERRORES DE BASE EN USO

-- Primero debo restaurar el backup completo 
-- uso NORECOVERY para dejar la base de datos en modo "restauración",
-- lista para recibir el archivo de log.
RESTORE DATABASE gimnasio_db
FROM DISK = 'C:\BackupsSQL\gimnasio_db_full.bak' 
WITH NORECOVERY, REPLACE;

-- Segundo, Ahora si, una vez estando el modo correcto aplico el primer archivo de log
-- uso RECOVERY para finalizar el proceso y dejar la base de datos
-- en línea y lista para usar.
RESTORE LOG gimnasio_db
FROM DISK = 'C:\BackupsSQL\gimnasio_db_log1.trn'
WITH RECOVERY;

------------------------------------------------------------------------------------------------------------------------

--8) Verificar el resultado.
USE gimnasio_db; --Vuelvo a nuestra base

-- Hago una consulta para contar cuántos socios hay.
SELECT * FROM socio;
-- Al hacer esta consulta, en la salida se puede ver que el ultimo o mas alto id que devuelve es el que estaba ultimo hasta la primer insercion,
-- mientras que los socios que ingrese en el segundo insert no salen.
-- esto quiere decir que se realizo correctamente la restauracion

------------------------------------------------------------------------------------------------------------------------

--9) Restaurar la base de datos aplicando ambos archivos de log.
-- Según lo que yo entendi, el objetivo de este punto es restaurar la base a la ultima version que tengo
-- donde hice el segundo insert.
USE master; --CAMBIO DE BASE PARA EVITAR ERRORES DE BASE EN USO

-- De nuevo, empiezo con el backup completo. Lo dejo en modo NORECOVERY
-- porque voy a aplicarle mas de un archivo de log.
RESTORE DATABASE gimnasio_db
FROM DISK = 'C:\BackupsSQL\gimnasio_db_full.bak'
WITH NORECOVERY, REPLACE;

-- Aplico el primer log, también con NORECOVERY,
-- porque todavía falta aplicar el segundo log.
RESTORE LOG gimnasio_db
FROM DISK = 'C:\BackupsSQL\gimnasio_db_log1.trn'
WITH NORECOVERY;

-- Ahora aplico el último log. Como este es el final
-- del proceso, uso RECOVERY para que la base de datos quede en línea y funcional.
RESTORE LOG gimnasio_db
FROM DISK = 'C:\BackupsSQL\gimnasio_db_log2.trn'
WITH RECOVERY;

------------------------------------------------------------------------------------------------------------------------

--10) Expresar sus conclusiones.
-- Al finalizar este trabajo, pude comprender de mejor manera las tecnicas de backup y restore en SQL SERVER.

-- En el primer ejercicio, entendi que sin establecer la base de datos al modo correcto (FULL), no se puede
-- implementar una tecnica de backup en linea, ya que en modo simple, no se registran las transacciones en el log
-- impidiendo la restauracion a un punto especifico en el tiempo.

-- En el proceso de restauracion, entendi que hay que seguir una serie de pasos, que no se pueden romper
-- siempre partiendo de un backup FULL como base, a partir de alli, se aplican los backups de logs.

-- Al resolver los ejercicios 7) y 9), restaurando la base con uno y dos archivos log, entendi lo potente
-- que que puede ser esta herramienta, permitiendonos volver atras sin perder lo ultimo que tenemos

------------------------------------------------------------------------------------------------------------------------
