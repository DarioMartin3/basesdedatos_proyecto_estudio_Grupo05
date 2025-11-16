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

/*
  FN: fn_TotalMembresia
  PROPÓSITO:
    Calcula el total a pagar de una membresía multiplicando
    la suma de precios de las clases asociadas por la duración (días)
    definida en el tipo de membresía.

  PARÁMETROS:
    @id_membresia INT -> ID de la membresía a calcular

  RETORNO:
    DECIMAL(10,2) -> Total calculado. Devuelve 0.00 si no hay datos.
*/
CREATE FUNCTION fn_TotalMembresia(@id_membresia INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(c.precio) * mt.duracion_dias
    FROM membresia m
    JOIN membresia_tipo mt ON m.tipo_id = mt.id_tipo
    JOIN membresia_clase mc ON m.id_membresia = mc.membresia_id
    JOIN clase c ON mc.clase_id = c.id_clase
    WHERE m.id_membresia = @id_membresia
    GROUP BY mt.duracion_dias;

    RETURN ISNULL(@total, 0.00);  
END;
GO

/*
  SP: sp_CrearPersonaYSocio
  PROPÓSITO:
    Inserta una persona y su correspondiente socio.

  PARÁMETROS DE ENTRADA:
    @nombre NVARCHAR(100)
    @apellido NVARCHAR(100)
    @dni INT
    @telefono BIGINT
    @email NVARCHAR(150)
    @estado BIT
    @contacto_emergencia BIGINT
    @observaciones NVARCHAR(400)

  PARÁMETROS DE SALIDA:
    @id_persona INT OUTPUT -> ID generado en persona

  TABLAS ESCRITAS:
    persona, socio
*/
CREATE PROCEDURE sp_CrearPersonaYSocio
    @nombre NVARCHAR(100), @apellido NVARCHAR(100), @dni INT,
    @telefono BIGINT, @email NVARCHAR(150), 
    @contacto_emergencia BIGINT, @observaciones NVARCHAR(400),
    @id_persona INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Inserta persona
    INSERT INTO persona (nombre, apellido, dni, telefono, email)
    VALUES (@nombre, @apellido, @dni, @telefono, @email);

    -- Retorna ID generado
    SET @id_persona = SCOPE_IDENTITY();

    -- Inserta socio vinculado a la persona creada
    INSERT INTO socio (id_socio, contacto_emergencia, observaciones)
    VALUES (@id_persona, @contacto_emergencia, @observaciones);
END;
GO

/*
  SP: sp_CrearMembresia
  PROPÓSITO:
    Crea una membresía activa para un socio.

  ENTRADAS:
    @usuario_id INT -> Usuario interno que registra
    @tipo_id INT -> Tipo de membresía
    @socio_id INT -> Socio destinatario

  SALIDA:
    @id_membresia INT OUTPUT -> ID generado en membresia

  TABLAS ESCRITAS:
    membresia
*/
CREATE PROCEDURE sp_CrearMembresia
    @usuario_id INT, @tipo_id INT, @socio_id INT, @id_membresia INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO membresia (usuario_id, tipo_id, socio_id, estado)
    VALUES (@usuario_id, @tipo_id, @socio_id, 1);

    SET @id_membresia = SCOPE_IDENTITY();
END;
GO

/*
  SP: sp_AsignarClaseADescontarCupo
  PROPÓSITO:
    Vincula una clase a una membresía y descuenta 1 del cupo de la clase.

  ENTRADAS:
    @id_membresia INT
    @id_clase INT

  TABLAS ESCRITAS:
    membresia_clase, clase
*/
CREATE PROCEDURE sp_AsignarClaseADescontarCupo
    @id_membresia INT, @id_clase INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Relaciona membresía con clase
    INSERT INTO membresia_clase (membresia_id, clase_id)
    VALUES (@id_membresia, @id_clase);

    -- Descuenta 1 del cupo de la clase
    UPDATE clase
    SET cupo = cupo - 1
    WHERE id_clase = @id_clase;
END;
GO

/*
  SP: sp_RegistrarPago
  PROPÓSITO:
    Calcula el total con fn_TotalMembresia, inserta el pago y su detalle.

  ENTRADAS:
    @socio_id INT
    @id_membresia INT
    @id_clase INT

  SALIDAS:
    @id_pago INT OUTPUT -> ID generado en pago
    @total   DECIMAL(10,2) OUTPUT -> Total calculado

  TABLAS LEÍDAS:
    membresia, membresia_tipo, membresia_clase, clase  (vía la función)

  TABLAS ESCRITAS:
    pago, pago_detalle
*/
CREATE PROCEDURE sp_RegistrarPago
    @socio_id INT, @id_membresia INT, @id_clase INT,
    @id_pago INT OUTPUT, @total DECIMAL(10,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Calcula total usando la función
    SET @total = dbo.fn_TotalMembresia(@id_membresia);

    -- Inserta pago principal
    INSERT INTO pago (socio_id, tipo_pago_id, total, estado)
    VALUES (@socio_id, 1, @total, 1);

    SET @id_pago = SCOPE_IDENTITY();

    -- Inserta detalle de pago
    INSERT INTO pago_detalle (pago_id, membresia_id, clase_id)
    VALUES (@id_pago, @id_membresia, @id_clase);
END;
GO




