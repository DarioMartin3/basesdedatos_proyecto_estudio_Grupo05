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
EXEC sp_CrearPersonaYSocio @nombre='Juan',    @apellido='Perez',     @dni=50111222, @telefono=1110001, @email='juan.perez@demo.com',        @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Ana',     @apellido='Gomez',     @dni=50111223, @telefono=1110002, @email='ana.gomez@demo.com',         @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Luis',    @apellido='Martinez',  @dni=50111224, @telefono=1110003, @email='luis.martinez@demo.com',     @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Maria',   @apellido='Rodriguez', @dni=50111225, @telefono=1110004, @email='maria.rodriguez@demo.com',   @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Carlos',  @apellido='Lopez',     @dni=50111226, @telefono=1110005, @email='carlos.lopez@demo.com',      @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Laura',   @apellido='Sanchez',   @dni=50111227, @telefono=1110006, @email='laura.sanchez@demo.com',     @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Pedro',   @apellido='Gonzalez',  @dni=50111228, @telefono=1110007, @email='pedro.gonzalez@demo.com',    @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Sofia',   @apellido='Fernandez', @dni=50111229, @telefono=1110008, @email='sofia.fernandez@demo.com',   @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Diego',   @apellido='Diaz',      @dni=50111230, @telefono=1110009, @email='diego.diaz@demo.com',        @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Valeria', @apellido='Moreno',    @dni=50111231, @telefono=1110010, @email='valeria.moreno@demo.com',    @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona OUTPUT;

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
EXEC sp_CrearPersonaYSocio @nombre='Jorge',     @apellido='Ramirez',  @dni=60111222, @telefono=2110001, @email='jorge.ramirez@demo.com',     @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Lucia',     @apellido='Acosta',   @dni=60111223, @telefono=2110002, @email='lucia.acosta@demo.com',       @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Martin',    @apellido='Garcia',   @dni=60111224, @telefono=2110003, @email='martin.garcia@demo.com',      @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Camila',    @apellido='Alvarez',  @dni=60111225, @telefono=2110004, @email='camila.alvarez@demo.com',     @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Nicolas',   @apellido='Torres',   @dni=60111226, @telefono=2110005, @email='nicolas.torres@demo.com',     @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Julieta',   @apellido='Ruiz',     @dni=60111227, @telefono=2110006, @email='julieta.ruiz@demo.com',       @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Matias',    @apellido='Gimenez',  @dni=60111228, @telefono=2110007, @email='matias.gimenez@demo.com',     @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Paula',     @apellido='Sosa',     @dni=60111229, @telefono=2110008, @email='paula.sosa@demo.com',         @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Federico',  @apellido='Benitez',  @dni=60111230, @telefono=2110009, @email='federico.benitez@demo.com',   @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;
EXEC sp_CrearPersonaYSocio @nombre='Agustina',  @apellido='Pereyra',  @dni=60111231, @telefono=2113010, @email='agustina.pereyra@demo.com',    @contacto_emergencia=123456789, @observaciones='Sin observaciones', @id_persona=@id_persona2 OUTPUT;

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
