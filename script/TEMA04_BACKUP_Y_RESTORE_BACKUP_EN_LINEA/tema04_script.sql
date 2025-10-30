USE gimnasio_db

----------------------------------------------
--	TEMA: BACKUP Y RESTORE. BACKUP EN LINEA
----------------------------------------------
SELECT * FROM persona;
SELECT * FROM socio;

--  TAREAS
------------------------------------------------------------------------------------------------------------------------
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
-- Insertamos 10 nuevas personas
INSERT INTO persona (nombre, apellido, dni, telefono, email) VALUES
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

-- Como id_socio es clave foránea de persona, insertamos los socios correspondientes.
INSERT INTO socio (id_socio, contacto_emergencia, observaciones) VALUES
(76, 123456789, 'Rotura de ligamentos'),
(77, 123456789, ' '),
(78, 123456789, ' '),
(79, 123456789, 'Desviacion en la columna'),
(80, 123456789, ' '),
(81, 123456789, ' '),
(82, 123456789, ' '),
(83, 123456789, 'Dolores de hombro derecho'),
(84, 123456789, ' '),
(85, 123456789, ' ');

--4) Realizar backup del archivo de log y registrar la hora del backup
--5) Generar otros 10 insert sobre la tabla de referencia.
--6) Realizar nuevamente backup de archivo de log  en otro archivo físico.
--7) Restaurar la base de datos al momento del primer backup del archivo de log. Es decir después de los primeros 10 insert.
--8) Verificar el resultado.
--9) Restaurar la base de datos aplicando ambos archivos de log.
--10) Expresar sus conclusiones.