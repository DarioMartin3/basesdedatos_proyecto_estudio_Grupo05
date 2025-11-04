/*
Insertando datos de la forma tradicional
*/

INSERT INTO persona VALUES ('Carlos', 'Martin', 38211456, 3794112233, 'carlos.martin@mail.com', '2025-09-13', 1);
INSERT INTO persona VALUES ('Nahim', 'Martinez', 40322344, 3794566999, 'nahim.martinez@mail.com', '2025-09-13', 1);
INSERT INTO persona VALUES ('Maria Jose', 'Ribas', 39245123, 3794556677, 'Ribas@mail.com', '2025-09-13', 1);
INSERT INTO persona VALUES ('Juan', 'Mayorana', 40122345, 3794887799, 'juan.mayorana@mail.com', '2025-09-20', 1);
INSERT INTO persona VALUES ('Pablo', 'Maidana', 38455678, 3813813822, 'pablo.maidana@mail.com', '2025-09-22', 1);
INSERT INTO persona VALUES ('Juan', 'Camurthers', 39543112, 3132121222, 'juan.camurthers@mail.com', '2025-09-22', 1);
INSERT INTO persona VALUES ('Lucas', 'Ramírez', 40321123, 3794123001, 'lucas.ramirez@mail.com', '2025-09-14', 1);
INSERT INTO persona VALUES ('María', 'Gómez', 38456789, 3794123002, 'maria.gomez@mail.com', '2025-09-15', 1);
INSERT INTO persona VALUES ('Julián', 'Fernández', 39234567, 3794123003, 'julian.fernandez@mail.com', '2025-09-16', 0);
INSERT INTO persona VALUES ('Camila', 'Ortiz', 40111222, 3794123004, 'camila.ortiz@mail.com', '2025-09-17', 1);
INSERT INTO persona VALUES ('Tomás', 'López', 38765432, 3794123005, 'tomas.lopez@mail.com', '2025-09-18', 1);
INSERT INTO persona VALUES ('Sofía', 'Benítez', 39987654, 3794123006, 'sofia.benitez@mail.com', '2025-09-19', 1);

/*
Insertar lote de datos usando Procedimiento creado previamente
*/

USE gimnasio_db;
GO

PRINT 'Iniciando lote de inserción con Procedimientos Almacenados...';
GO

-- Lote de 10 nuevas personas
EXEC sp_InsertarPersona 
    @nombre = 'Ana', 
    @apellido = 'Torres', 
    @dni = 41000111, 
    @telefono = 3794111222, 
    @email = 'ana.torres@mail.com';

EXEC sp_InsertarPersona 
    @nombre = 'Bruno', 
    @apellido = 'Costa', 
    @dni = 41000222, 
    @telefono = 3794222333, 
    @email = 'bruno.costa@mail.com';

EXEC sp_InsertarPersona 
    @nombre = 'Carla', 
    @apellido = 'Diaz', 
    @dni = 41000333, 
    @telefono = 3794333444, 
    @email = 'carla.diaz@mail.com';

EXEC sp_InsertarPersona 
    @nombre = 'Daniel', 
    @apellido = 'Rojas', 
    @dni = 41000444, 
    @telefono = 3794444555, 
    @email = 'daniel.rojas@mail.com';

EXEC sp_InsertarPersona 
    @nombre = 'Elena', 
    @apellido = 'Soto', 
    @dni = 41000555, 
    @telefono = 3794555666, 
    @email = 'elena.soto@mail.com';

EXEC sp_InsertarPersona 
    @nombre = 'Marcos', 
    @apellido = 'Luna', 
    @dni = 41000666, 
    @telefono = 3794666777, 
    @email = 'marcos.luna@mail.com';

EXEC sp_InsertarPersona 
    @nombre = 'Gabriela', 
    @apellido = 'Molina', 
    @dni = 41000777, 
    @telefono = 3794777888, 
    @email = 'gabriela.molina@mail.com';

EXEC sp_InsertarPersona 
    @nombre = 'Hernan', 
    @apellido = 'Campos', 
    @dni = 41000888, 
    @telefono = 3794888999, 
    @email = 'hernan.campos@mail.com';

EXEC sp_InsertarPersona 
    @nombre = 'Irene', 
    @apellido = 'Vega', 
    @dni = 41000999, 
    @telefono = 3794999000, 
    @email = 'irene.vega@mail.com';

EXEC sp_InsertarPersona 
    @nombre = 'Javier', 
    @apellido = 'Paz', 
    @dni = 41000101, 
    @telefono = 3794101101, 
    @email = 'javier.paz@mail.com';
GO

PRINT 'Lote de 10 personas insertadas correctamente.';
GO