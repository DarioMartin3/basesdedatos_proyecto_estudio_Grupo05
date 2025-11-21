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
-- Reemplazado por llamadas al procedimiento almacenado sp_CrearPersonaYSocio
DECLARE @id_persona INT;
EXEC sp_CrearPersonaYSocio @nombre='Juan',   @apellido='Perez',      @dni=30123456, @telefono=111111, @email='juan.perez@email.com',      @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Ana',    @apellido='Gomez',      @dni=31123457, @telefono=222222, @email='ana.gomez@email.com',       @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Luis',   @apellido='Martinez',   @dni=32123458, @telefono=333333, @email='luis.martinez@email.com',   @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Maria',  @apellido='Rodriguez',  @dni=33123459, @telefono=444444, @email='maria.rodriguez@email.com', @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Carlos', @apellido='Lopez',      @dni=34123450, @telefono=555555, @email='carlos.lopez@email.com',    @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Laura',  @apellido='Sanchez',    @dni=35123451, @telefono=666666, @email='laura.sanchez@email.com',   @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Pedro',  @apellido='Gonzalez',   @dni=36123452, @telefono=777777, @email='pedro.gonzalez@email.com',  @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Sofia',  @apellido='Fernandez',  @dni=37123453, @telefono=888888, @email='sofia.fernandez@email.com', @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Diego',  @apellido='Diaz',       @dni=38123454, @telefono=999999, @email='diego.diaz@email.com',      @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Valeria',@apellido='Moreno',     @dni=39123455, @telefono=101010, @email='valeria.moreno@email.com',  @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;

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
-- Reemplazado por llamadas al procedimiento almacenado sp_CrearPersonaYSocio
DECLARE @id_persona2 INT;
EXEC sp_CrearPersonaYSocio @nombre='Jorge',    @apellido='Ramirez',  @dni=40123456, @telefono=111112, @email='jorge.ramirez@email.com',    @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Lucia',    @apellido='Acosta',   @dni=41123457, @telefono=222223, @email='lucia.acosta@email.com',     @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Martin',   @apellido='Garcia',   @dni=42123458, @telefono=333334, @email='martin.garcia@email.com',     @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Camila',   @apellido='Alvarez',  @dni=43123459, @telefono=444445, @email='camila.alvarez@email.com',    @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Nicolas',  @apellido='Torres',   @dni=44123450, @telefono=555556, @email='nicolas.torres@email.com',    @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Julieta',  @apellido='Ruiz',     @dni=45123451, @telefono=666667, @email='julieta.ruiz@email.com',      @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Matias',   @apellido='Gimenez',  @dni=46123452, @telefono=777778, @email='matias.gimenez@email.com',    @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Paula',    @apellido='Sosa',     @dni=47123453, @telefono=888889, @email='paula.sosa@email.com',        @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Federico', @apellido='Benitez',  @dni=48123454, @telefono=999990, @email='federico.benitez@email.com',  @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Agustina', @apellido='Pereyra',  @dni=49123455, @telefono=101011, @email='agustina.pereyra@email.com',  @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;

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
