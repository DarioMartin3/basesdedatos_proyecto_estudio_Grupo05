USE gimnasio_db;
GO

/*
  Documentación (Cumpliendo Criterio de Evaluación):
  - Nombre: sp_InsertarPersona
  - Objetivo: Da de alta una nueva persona en la tabla 'persona'.
  - Parámetros de Entrada:
    - @nombre: Nombre de la persona (varchar(255))
    - @apellido: Apellido de la persona (varchar(255))
    - @dni: DNI (bigint), debe ser único
    - @telefono: Teléfono (bigint), debe ser único
    - @email: Email (varchar(200)), debe ser único
  - Notas: 'id_persona' es IDENTITY. 'fecha_alta' y 'estado' son DEFAULT.
*/

-- Definimos el nombre del procedimiento como ´sp_InsertarPersona´
CREATE PROCEDURE sp_InsertarPersona
    -- Parámetros de ENTRADA
    @nombre varchar(255),
    @apellido varchar(255),
    @dni bigint,
    @telefono bigint,
    @email varchar(200)
AS
BEGIN
    -- 1. Evitar mensajes de "filas afectadas"
    SET NOCOUNT ON; 

    -- 2. La ACCIÓN (tu INSERT)
    INSERT INTO persona (nombre, apellido, dni, telefono, email) 
    VALUES (@nombre, @apellido, @dni, @telefono, @email);
END
GO

/*
Para ejecutar/llamar a este procedimiento sería con la siguiente sintaxis:

EXEC sp_InsertarPersona 
    @nombre = 'Laura', 
    @apellido = 'Gómez', 
    @dni = 40111222, 
    @telefono = 3794123456, 
    @email = 'laura.gomez@mail.com';
*/