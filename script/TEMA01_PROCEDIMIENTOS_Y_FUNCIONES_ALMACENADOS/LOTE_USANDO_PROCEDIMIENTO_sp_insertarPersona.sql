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