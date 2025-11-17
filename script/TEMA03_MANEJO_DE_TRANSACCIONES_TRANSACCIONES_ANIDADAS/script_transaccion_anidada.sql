/*
Transacción anidada para insertar una persona, un socio, una membresía y un pago.
Transaccion que se completa con exito.
*/
DECLARE 
    @id_persona   INT,
    @id_membresia INT,
    @id_pago      INT,
    @total_pago   DECIMAL(10,2),
    @id_clase     INT = 2; --id de la clase en la que el socio se va a inscribir

BEGIN TRY
    BEGIN TRANSACTION Trans_Principal;  -- @@TRANCOUNT = 1

    -- Insertamos persona y socio
    EXEC dbo.sp_CrearPersonaYSocio
        @nombre = 'Valentina',
        @apellido = 'Acostandez',
        @dni = 40741562,
        @telefono = 3794456712,
        @email = 'valentina.acosta@mail.com',
        @contacto_emergencia = 3794678512,
        @observaciones = N'Lesión leve en hombro izquierdo. Hipertrofia muscular en seguimiento.',
        @id_persona = @id_persona OUTPUT; 

    PRINT 'Persona y socio insertados. Iniciando transacción secundaria...';

    BEGIN TRY
        -- Transacción interna (anidada)
        BEGIN TRANSACTION Trans_Secundaria;   -- @@TRANCOUNT = 2

        -- 2) Membresía
        EXEC dbo.sp_CrearMembresia
            @usuario_id   = 14,
            @tipo_id      = 3,
            @socio_id     = @id_persona,
            @id_membresia = @id_membresia OUTPUT;

        -- 3) Clase y cupo
        EXEC dbo.sp_AsignarClaseADescontarCupo
            @id_membresia = @id_membresia,
            @id_clase     = @id_clase;

        -- 4) Pago + detalle
        EXEC dbo.sp_RegistrarPago
            @socio_id     = @id_persona,
            @id_membresia = @id_membresia,
            @id_clase     = @id_clase,
            @id_pago      = @id_pago OUTPUT,
            @total        = @total_pago OUTPUT;

        PRINT 'Subtransacción (membresía/pago) completada correctamente.';

        COMMIT TRANSACTION Trans_Secundaria;  -- @@TRANCOUNT = 1
    END TRY
    BEGIN CATCH
        PRINT 'Error dentro de la transacción secundaria(membresía/pago). Se revierte todo.';

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION Trans_Principal; 
        THROW;
    END CATCH;

    COMMIT TRANSACTION Trans_Principal;       -- @@TRANCOUNT = 0
    PRINT 'Transacción anidada completada correctamente.';
END TRY
BEGIN CATCH
    PRINT 'Error crítico en la transacción principal.';
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Transacción anidada para insertar una persona, un socio, una membresía y un pago.
Provocamos un error en la insercion de persona/socio para ver el manejo de errores.
Ejemplo utilizaremos un numero de telefono que ya existe y al tener restriccion de unico, provocara un error.
*/

DECLARE 
    @id_persona   INT,
    @id_membresia INT,
    @id_pago      INT,
    @total_pago   DECIMAL(10,2),
    @id_clase     INT = 2; --id de la clase en la que el socio se va a inscribir

BEGIN TRY
    BEGIN TRANSACTION Trans_Principal;  -- @@TRANCOUNT = 1

    -- Insertamos persona y socio
    EXEC dbo.sp_CrearPersonaYSocio
        @nombre = 'Carla',
        @apellido = 'Benítez',
        @dni = 40321987,
        @telefono = 3794456712,
        @email = 'carla.benitez@mail.com',
        @contacto_emergencia = 3794678512,
        @observaciones = N'Lesión leve en hombro izquierdo. Hipertrofia muscular en seguimiento.',
        @id_persona = @id_persona OUTPUT; 

    PRINT 'Persona y socio insertados. Iniciando transacción secundaria...';

    BEGIN TRY
        -- Transacción interna (anidada)
        BEGIN TRANSACTION Trans_Secundaria;   -- @@TRANCOUNT = 2

        -- 2) Membresía
        EXEC dbo.sp_CrearMembresia
            @usuario_id   = 14,
            @tipo_id      = 3,
            @socio_id     = @id_persona,
            @id_membresia = @id_membresia OUTPUT;

        -- 3) Clase y cupo
        EXEC dbo.sp_AsignarClaseADescontarCupo
            @id_membresia = @id_membresia,
            @id_clase     = @id_clase;

        -- 4) Pago + detalle
        EXEC dbo.sp_RegistrarPago
            @socio_id     = @id_persona,
            @id_membresia = @id_membresia,
            @id_clase     = @id_clase,
            @id_pago      = @id_pago OUTPUT,
            @total        = @total_pago OUTPUT;

        PRINT 'Subtransacción (membresía/pago) completada correctamente.';

        COMMIT TRANSACTION Trans_Secundaria;  -- @@TRANCOUNT = 1
    END TRY
    BEGIN CATCH
        PRINT 'Error dentro de la transacción secundaria(membresía/pago). Se revierte todo.';

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION Trans_Principal; 
        THROW;
    END CATCH;

    COMMIT TRANSACTION Trans_Principal;       -- @@TRANCOUNT = 0
    PRINT 'Transacción anidada completada correctamente.';
END TRY
BEGIN CATCH
    PRINT 'Error crítico en la transacción principal.';
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Transacción anidada para insertar una persona, un socio, una membresía y un pago.
Provocamos un error en al actualizar la clase con cupo 0 ya que viola la restriccion para ver el manejo de errores.
Ejemplo utilizaremos un numero de telefono que ya existe y al tener restriccion de unico, provocara un error.
*/

DECLARE 
    @id_persona   INT,
    @id_membresia INT,
    @id_pago      INT,
    @total_pago   DECIMAL(10,2),
    @id_clase     INT = 11; --id de la clase en la que el socio se va a inscribir

    
BEGIN TRY
    BEGIN TRANSACTION Trans_Principal;  -- @@TRANCOUNT = 1

    -- Insertamos persona y socio
    EXEC dbo.sp_CrearPersonaYSocio
        @nombre = 'Juan',
        @apellido = 'Cardozo',
        @dni = 40999999,
        @telefono = 3794999999,
        @email = 'juan.cardozo@mail.com',
        @contacto_emergencia = 3794678512,
        @observaciones = N'Lesión leve en hombro izquierdo. Hipertrofia muscular en seguimiento.',
        @id_persona = @id_persona OUTPUT; 

    PRINT 'Persona y socio insertados. Iniciando transacción secundaria...';

    BEGIN TRY
        -- Transacción interna (anidada)
        BEGIN TRANSACTION Trans_Secundaria;   -- @@TRANCOUNT = 2

        -- 2) Membresía
        EXEC dbo.sp_CrearMembresia
            @usuario_id   = 14,
            @tipo_id      = 3,
            @socio_id     = @id_persona,
            @id_membresia = @id_membresia OUTPUT;

        -- 3) Clase y cupo
        EXEC dbo.sp_AsignarClaseADescontarCupo
            @id_membresia = @id_membresia,
            @id_clase     = @id_clase;

        -- 4) Pago + detalle
        EXEC dbo.sp_RegistrarPago
            @socio_id     = @id_persona,
            @id_membresia = @id_membresia,
            @id_clase     = @id_clase,
            @id_pago      = @id_pago OUTPUT,
            @total        = @total_pago OUTPUT;

        PRINT 'Subtransacción (membresía/pago) completada correctamente.';

        COMMIT TRANSACTION Trans_Secundaria;  -- @@TRANCOUNT = 1
    END TRY
    BEGIN CATCH
        PRINT 'Error dentro de la transacción secundaria(membresía/pago). Se revierte todo.';

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION Trans_Principal; 
        THROW;
    END CATCH;

    COMMIT TRANSACTION Trans_Principal;       -- @@TRANCOUNT = 0
    PRINT 'Transacción anidada completada correctamente.';
END TRY
BEGIN CATCH
    PRINT 'Error crítico en la transacción principal.';
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

--VERIFICAR LOS DATOS EN LAS TABLAS INVOLUCRADAS PARA ASEGUR
SELECT TOP 1
    p.id_persona,
    CONCAT(p.nombre, ' ', p.apellido) AS NombreCompleto,
    p.dni,
    p.email,
    p.telefono,
    s.contacto_emergencia,
    s.observaciones, 
    m.id_membresia,
    m.tipo_id,
    m.fecha_inicio, 
    DATEADD(DAY, mt.duracion_dias, m.fecha_inicio) AS FechaFin,
    pa.id_pago,
    pa.fecha,   
    pa.total 
FROM persona p 
JOIN socio s ON p.id_persona = s.id_socio 
LEFT JOIN Membresia m ON p.id_persona = m.socio_id
LEFT JOIN membresia_tipo mt ON mt.id_tipo = m.tipo_id
LEFT JOIN pago_detalle pd ON m.id_membresia = pd.membresia_id 
LEFT JOIN pago pa ON pa.id_pago = pd.pago_id
ORDER BY p.id_persona DESC

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
Conclusión:
Las transacciones anidadas permiten dividir un proceso complejo en secciones lógicas, 
pero en SQL Server no funcionan como transacciones independientes. Los COMMIT internos 
solo disminuyen el @@TRANCOUNT, mientras que el único COMMIT efectivo es el externo. 
Si ocurre un error en una subtransacción y se ejecuta un ROLLBACK sin un savepoint, 
toda la transacción completa se revierte, garantizando la atomicidad del proceso. 
Para lograr control parcial de errores dentro de una transacción anidada, es necesario 
utilizar SAVE TRANSACTION, que habilita regresar a un punto exacto sin perder todo el 
trabajo previo. Esto permite modularidad sin comprometer la integridad de los datos.
/*