/*
Transacción anidada para insertar una persona, un socio, una membresía y un pago.
Transaccion que se completa con exito.
*/

BEGIN TRY
    BEGIN TRANSACTION; -- Transacción principal  el @@TRANCOUNT = 1

    --Insertamos una persona en la tabla Personas
    DECLARE @id_clase INT = 2;-- Variable para almacenar el ID de la clase a la que se inscribe el socio
    DECLARE @id_persona INT;-- Variable para almacenar el ID de la persona

    INSERT INTO persona (nombre, apellido, dni, telefono, email, estado)
    VALUES ('Valentina', 'Acosta', 40741562, 3794456712, 'valentina.acosta@mail.com', 1);

    SET @id_persona = SCOPE_IDENTITY();-- Guardamos el ID de la persona insertada

    --Insertamos un socio en la tabla Socios    
    INSERT INTO socio (id_socio, contacto_emergencia, observaciones)
    VALUES (@id_persona, 3794678512, 'Lesión leve en hombro izquierdo. Hipertrofia muscular en seguimiento.');



    -- Ahora intentamos insertar la membresía y el pago
    BEGIN TRANSACTION; -- Subtransacción  el @@TRANCOUNT = 2
        DECLARE @id_membresia INT;-- Variable para almacenar el ID de la membresía
        DECLARE @total_pago DECIMAL(10,2);-- Variable para almacenar el total a pagar
        DECLARE @id_pago INT;-- Variable para almacenar el ID del pago

        -- Insertamos la membresía
        INSERT INTO membresia (usuario_id, tipo_id, socio_id, estado)
        VALUES (14, 3, @id_persona, 1);

        SET @id_membresia = SCOPE_IDENTITY();-- Guardamos el ID de la membresía insertada

        -- Insertamos la relación membresía-clase
        INSERT INTO membresia_clase (membresia_id, clase_id)
        VALUES (@id_membresia, @id_clase);

        -- Update Descuento de cupo
        UPDATE clase 
        SET cupo = cupo - 1
        WHERE id_clase = @id_clase;

        -- Calcular total
        SELECT 
            @total_pago = SUM(c.precio) * mt.duracion_dias
        FROM membresia m
        JOIN membresia_tipo mt ON m.tipo_id = mt.id_tipo
        JOIN membresia_clase mc ON m.id_membresia = mc.membresia_id
        JOIN clase c ON mc.clase_id = c.id_clase
        WHERE m.id_membresia = @id_membresia
        GROUP BY mt.duracion_dias;

        -- Insertamos el Pago
        INSERT INTO pago (socio_id, tipo_pago_id, total, estado)
        VALUES (@id_persona, 1, @total_pago, 1);

        SET @id_pago = SCOPE_IDENTITY();-- Guardamos el ID del pago insertado

        -- Insertamos el Detalle pago
        INSERT INTO pago_detalle (pago_id, membresia_id, clase_id)
        VALUES (@id_pago, @id_membresia, @id_clase);

        PRINT 'Transacción secundaria (membresía/pago) completada correctamente.';
        COMMIT TRANSACTION;-- Si todo sale bien, confirmamos los cambios de la subtransacción  el @@TRANCOUNT = 1


        COMMIT TRANSACTION;-- Si todo sale bien, confirmamos los cambios de la transacción principal  el @@TRANCOUNT = 0
        PRINT 'Transacción completa guardada.';
     
END TRY
BEGIN CATCH
    PRINT 'Error crítico.';
    IF (@@TRANCOUNT > 0)
    BEGIN
        PRINT 'Se revirtio toda la transaccion';
        ROLLBACK TRANSACTION;
    END
    PRINT 'Error en transaccion! No se guardaron los cambios: ' + ERROR_MESSAGE();
END CATCH;

--VERIFICAR LOS DATOS EN LAS TABLAS INVOLUCRADAS PARA ASEGUR
SELECT * FROM persona WHERE id_persona = @id_persona;
SELECT * FROM socio WHERE id_socio = @id_persona;
SELECT * FROM membresia WHERE id_membresia = @id_membresia;
SELECT * FROM membresia_clase WHERE membresia_id = @id_membresia;
SELECT * FROM pago WHERE id_pago = @id_pago;
SELECT * FROM pago_detalle WHERE pago_id = @id_pago;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Transacción anidada para insertar una persona, un socio, una membresía y un pago.
Provocamos un error en la insercion de persona/socio para ver el manejo de errores.
Ejemplo utilizaremos un numero de telefono que ya existe y al tener restriccion de unico, provocara un error.
*/

BEGIN TRY
    -- Inicia la transacción externa 
    BEGIN TRANSACTION; -- @@TRANCOUNT ahora es 1

    --Insertamos una persona en la tabla Personas
    DECLARE @id_clase INT = 2;
    DECLARE @id_persona INT;

    INSERT INTO persona (nombre, apellido, dni, telefono, email, estado)
    VALUES ('Carla', 'Benítez', 40321987, 3794456712, 'carla.benitez@mail.com', 1);

    SET @id_persona = SCOPE_IDENTITY();

    --Insertamos un socio en la tabla Socios     
    INSERT INTO socio (id_socio, contacto_emergencia, observaciones)
    VALUES (@id_persona, 3794678512, 'Lesión leve en hombro izquierdo...');

    PRINT 'Persona y Socio insertados. Iniciando subtransacción...';

    -- Inicia la transacción interna 
    BEGIN TRANSACTION; -- @@TRANCOUNT ahora es 2
    
        DECLARE @id_membresia INT;
        DECLARE @total_pago DECIMAL(10,2);
        DECLARE @id_pago INT;

        -- Insertamos la membresía
        INSERT INTO membresia (usuario_id, tipo_id, socio_id, estado)
        VALUES (14, 3, @id_persona, 1);
        SET @id_membresia = SCOPE_IDENTITY();

        -- Insertamos la relación membresía-clase
        INSERT INTO membresia_clase (membresia_id, clase_id)
        VALUES (@id_membresia, @id_clase);

        -- Update Descuento de cupo
        UPDATE clase 
        SET cupo = cupo - 1
        WHERE id_clase = @id_clase;

        -- Calcular total
        SELECT 
            @total_pago = SUM(c.precio) * mt.duracion_dias
        FROM membresia m
        JOIN membresia_tipo mt ON m.tipo_id = mt.id_tipo
        JOIN membresia_clase mc ON m.id_membresia = mc.membresia_id
        JOIN clase c ON mc.clase_id = c.id_clase
        WHERE m.id_membresia = @id_membresia
        GROUP BY mt.duracion_dias;

        -- Insertamos el Pago
        INSERT INTO pago (socio_id, tipo_pago_id, total, estado)
        VALUES (@id_persona, 1, @total_pago, 1);
        SET @id_pago = SCOPE_IDENTITY();

        -- Insertamos el Detalle pago
        INSERT INTO pago_detalle (pago_id, membresia_id, clase_id)
        VALUES (@id_pago, @id_membresia, @id_clase);
        
    -- Confirma la transacción interna.
    -- ESTO NO GUARDA NADA, solo decrementa el contador.
    COMMIT TRANSACTION; -- @@TRANCOUNT ahora es 1
    PRINT 'Subtransacción (membresía/pago) completada internamente.';
    
    COMMIT TRANSACTION; --Guardamos todo @@TRANCOUNT ahora es 0
    PRINT 'Transacción completa guardada (principal y anidada).';
    
END TRY
BEGIN CATCH
    PRINT '¡Error detectado!';
    -- Si @@TRANCOUNT es > 0, significa que una transacción está activa.
    IF (@@TRANCOUNT > 0)
    BEGIN
        -- Este ROLLBACK revierte TODO, sin importar si el error        
        PRINT 'Revirtiendo TODA la transacción...';
        
        ROLLBACK TRANSACTION; 
    END
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

--VERIFICAR LOS DATOS EN LAS TABLAS INVOLUCRADAS PARA ASEGUR
SELECT * FROM persona WHERE id_persona = @id_persona;
SELECT * FROM socio WHERE id_socio = @id_persona;
SELECT * FROM membresia WHERE id_membresia = @id_membresia;
SELECT * FROM membresia_clase WHERE membresia_id = @id_membresia;
SELECT * FROM pago WHERE id_pago = @id_pago;
SELECT * FROM pago_detalle WHERE pago_id = @id_pago;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
Conclusion:
Al trabajar con transacciones anidadas , el objetivo es la modularidad, 
Si ocurre un fallo en una subtransacción y se ejecuta un ROLLBACK, 
esta acción revierte toda la transacción principal, no solo esa parte. 
Este comportamiento de "todo o nada" asegura la consistencia atómica del proceso completo. Los COMMIT internos solo decrementan el contador @@TRANCOUNT; 
solo el COMMIT externo confirma permanentemente el trabajo.
/*