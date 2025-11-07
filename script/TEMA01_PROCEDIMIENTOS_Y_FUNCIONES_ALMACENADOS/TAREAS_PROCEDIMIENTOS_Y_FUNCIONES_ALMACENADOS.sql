USE gimnasio_db;
GO

/*
	PROCEDIMIENTOS ALMACENADOS
	
	1) Realizar al menos tres procedimientos almacenados que permitan:
	Insertar, Modificar y borrar registros de alguna de las tablas del proyecto.
*/

/*

	1.a. Insertar una nueva persona
	
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

GO

/*
	1.b. Modificar una persona
	
  Documentación (Cumpliendo Criterio de Evaluación):
  - Nombre: sp_ModificarPersona
  - Objetivo: Modifica datos existentes de una persona en la tabla 'persona'.
  - Parámetros de Entrada:
    - @id_persona: (int) ID de la persona a modificar (Obligatorio)
    - @nombre: (varchar) Nuevo nombre (Opcional, NULL para no cambiar)
    - @apellido: (varchar) Nuevo apellido (Opcional, NULL para no cambiar)
    - @dni: (bigint) Nuevo DNI (Opcional, NULL para no cambiar)
    - @telefono: (bigint) Nuevo teléfono (Opcional, NULL para no cambiar)
    - @email: (varchar) Nuevo email (Opcional, NULL para no cambiar)
*/
CREATE PROCEDURE sp_ModificarPersona
    @id_persona int,
    @nombre varchar(255) = NULL,
    @apellido varchar(255) = NULL,
    @dni bigint = NULL,
    @telefono bigint = NULL,
    @email varchar(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE persona
    SET 
        nombre = ISNULL(@nombre, nombre), -- Si el valor de @nombre es NULL (El usuario no pasé este paramétro) usa el valor que tenía
        apellido = ISNULL(@apellido, apellido), -- Lo mismo
        dni = ISNULL(@dni, dni),
        telefono = ISNULL(@telefono, telefono),
        email = ISNULL(@email, email)
    WHERE 
        id_persona = @id_persona;
END
GO

/*
Para ejecutar/llamar a este procedimiento sería con la siguiente sintaxis:

	- Si SOLO querés cambiar el teléfono de la persona con ID = 1
	
	EXEC sp_ModificarPersona @id_persona = 1, @telefono = 3794999999;
	
	*PD: El usuario al no pasar los demás paramétros, usarán su valor que ya tenían previamente, mediante el filtro de ISNULL(@variable_que_puede_ser_nula, @valor_por_defecto) 
*/


GO
/*
	1.c. Eliminar una persona
	
  Documentación (Cumpliendo Criterio de Evaluación):
  - Nombre: sp_BorrarPersona (Borrado Lógico)
  - Objetivo: Desactiva una persona en la tabla 'persona' (borrado lógico).
  - Parámetros de Entrada:
    - @id_persona: (int) ID de la persona a desactivar (Obligatorio)
  - Notas: Esto no borra el registro físicamente, solo cambia 'estado' a 0.
*/
CREATE PROCEDURE sp_BorrarPersona
    @id_persona int
AS
BEGIN
    SET NOCOUNT ON;

    -- La ACCIÓN (Borrado Lógico)
    UPDATE persona
    SET 
        estado = 0 -- 0 significa "Inactivo" o "Borrado"
    WHERE 
        id_persona = @id_persona;
END
GO

/*
Para ejecutar/llamar a este procedimiento sería con la siguiente sintaxis:

	EXEC sp_BorrarPersona @id_persona = 1;
*/

/*
	FUNCIONES ALMACENADAS
	
	Desarrollar al menos tres funciones almacenadas. Por ej: calcular la edad, etc.
*/

USE gimnasio_db;
GO

/*
  Documentación (Cumpliendo Criterio de Evaluación):
  - Nombre: fn_GetNombreCompleto
  - Objetivo: Devuelve el nombre completo de una persona en formato "Apellido, Nombre".
  - Parámetros de Entrada:
    - @id_persona: (int) El ID de la persona a consultar.
  - Retorno: VARCHAR(511) - (255 del apellido + 2 + 255 del nombre)
*/
CREATE FUNCTION fn_GetNombreCompleto
(
    @id_persona int
)
RETURNS VARCHAR(511) -- La suma de los varchar de nombre y apellido
AS
BEGIN
    -- 1. Declaramos la "caja" (variable) de retorno
    DECLARE @NombreCompleto VARCHAR(511);

    -- 2. Hacemos el cálculo (la consulta)
    SELECT @NombreCompleto = apellido + ', ' + nombre
    FROM persona
    WHERE id_persona = @id_persona;

    -- 3. Devolvemos el valor
    RETURN @NombreCompleto;
END
GO

/*
Para ejecutar/llamar a esta función sería con la siguiente sintaxis:

	-- Obtenemos el listado de todos los socios activos
SELECT 
    id_socio,
    dbo.fn_GetNombreCompleto(id_socio) AS NombreSocio, -- ¡Acá la usamos!
    contacto_emergencia
FROM 
    socio
INNER JOIN 
    persona ON socio.id_socio = persona.id_persona
WHERE
    persona.estado = 1;
*/