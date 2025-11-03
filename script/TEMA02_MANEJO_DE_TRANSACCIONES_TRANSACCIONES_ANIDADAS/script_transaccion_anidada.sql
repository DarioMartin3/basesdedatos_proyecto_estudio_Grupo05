/*
Transacción anidada para insertar una persona, un socio, una membresía y un pago.
Transaccion que se completa con exito.
*/

BEGIN TRY
    BEGIN TRANSACTION; -- Transacción principal  

    --Insertamos una persona en la tabla Personas
    DECLARE @id_clase INT = 2;-- Variable para almacenar el ID de la clase a la que se inscribe el socio
    DECLARE @id_persona INT;-- Variable para almacenar el ID de la persona

    INSERT INTO persona (nombre, apellido, dni, telefono, email, estado)
    VALUES ('Valentina', 'Acosta', 40741562, 3794456712, 'valentina.acosta@mail.com', 1);

    SET @id_persona = SCOPE_IDENTITY();-- Guardamos el ID de la persona insertada

    --Insertamos un socio en la tabla Socios    
    INSERT INTO socio (id_socio, contacto_emergencia, observaciones)
    VALUES (@id_persona, 3794678512, 'Lesión leve en hombro izquierdo. Hipertrofia muscular en seguimiento.');

    /* SAVEPOINT: para conservar el socio/persona */
    SAVE TRANSACTION socio_creado;

    -- Ahora intentamos insertar la membresía y el pago
    BEGIN TRY
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

        
        COMMIT TRANSACTION;-- Si todo sale bien, confirmamos los cambios
        PRINT 'Transacción completa guardada.';
    END TRY
    BEGIN CATCH
        -- Revierte solo lo que vino después del SAVEPOINT
        ROLLBACK TRANSACTION socio_creado;

        -- Confirma los cambios hasta el savepoint que seria persona y socio
        COMMIT TRANSACTION;

        PRINT 'Error en la parte de membresía/pago. Persona y socio quedaron guardados.';
        PRINT ERROR_MESSAGE();
    END CATCH

END TRY
BEGIN CATCH
    -- Si falló antes del savepoint, se cae todo
    ROLLBACK TRANSACTION;
    PRINT 'Error crítico. No se pudo completar, ningun dato se guardo.';
    PRINT ERROR_MESSAGE();
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
    BEGIN TRANSACTION; -- Transacción principal  

    --Insertamos una persona en la tabla Personas
    DECLARE @id_clase INT = 2;-- Variable para almacenar el ID de la clase a la que se inscribe el socio
    DECLARE @id_persona INT;-- Variable para almacenar el ID de la persona

    INSERT INTO persona (nombre, apellido, dni, telefono, email, estado)
    VALUES ('Carla', 'Benítez', 40321987, 3794456712, 'carla.benitez@mail.com', 1);

    SET @id_persona = SCOPE_IDENTITY();-- Guardamos el ID de la persona insertada

    --Insertamos un socio en la tabla Socios    
    INSERT INTO socio (id_socio, contacto_emergencia, observaciones)
    VALUES (@id_persona, 3794678512, 'Lesión leve en hombro izquierdo. Hipertrofia muscular en seguimiento.');

    /* SAVEPOINT: para conservar el socio/persona */
    SAVE TRANSACTION socio_creado;

    -- Ahora intentamos insertar la membresía y el pago
    BEGIN TRY
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

        
        COMMIT TRANSACTION;-- Si todo sale bien, confirmamos los cambios
        PRINT 'Transacción completa guardada.';
    END TRY
    BEGIN CATCH
        -- Revierte solo lo que vino después del SAVEPOINT
        ROLLBACK TRANSACTION socio_creado;

        -- Confirma los cambios hasta el savepoint que seria persona y socio
        COMMIT TRANSACTION;

        PRINT 'Error en la parte de membresía/pago. Persona y socio quedaron guardados.';
        PRINT ERROR_MESSAGE();
    END CATCH

END TRY
BEGIN CATCH
    -- Si falló antes del savepoint, se cae todo
    ROLLBACK TRANSACTION;
    PRINT 'Error crítico. No se pudo completar, ningun dato se guardo.';
    PRINT ERROR_MESSAGE();
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
Provocamos un error en la insercion de la membresía para ver el comportamiento de las transacciones anidadas.
Por ejemplo el cupo de la clase es 0 y por la restriccion no se puede disminiuir mas, asi que ahi se genera el error.
A fines didacticos para ver el manejo de errores seteamos el cupo de la clase 10 en 0 al inicio del script.
*/

UPDATE clase 
SET cupo = 0
WHERE id_clase = 10;

BEGIN TRY
    BEGIN TRANSACTION; -- Transacción principal  

    --Insertamos una persona en la tabla Personas
    DECLARE @id_clase INT = 10;-- Variable para almacenar el ID de la clase a la que se inscribe el socio
    DECLARE @id_persona INT;-- Variable para almacenar el ID de la persona

    INSERT INTO persona (nombre, apellido, dni, telefono, email, estado)
    VALUES ('Diego', 'Ruiz', 39547896, 3795236987, 'diego.ruiz@mail.com', 1);

    SET @id_persona = SCOPE_IDENTITY();-- Guardamos el ID de la persona insertada

    --Insertamos un socio en la tabla Socios    
    INSERT INTO socio (id_socio, contacto_emergencia, observaciones)
    VALUES (@id_persona, 3794678512, 'Lesión leve en hombro izquierdo. Hipertrofia muscular en seguimiento.');

    /* SAVEPOINT: para conservar el socio/persona */
    SAVE TRANSACTION socio_creado;

    -- Ahora intentamos insertar la membresía y el pago
    BEGIN TRY
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

        
        COMMIT TRANSACTION;-- Si todo sale bien, confirmamos los cambios
        PRINT 'Transacción completa guardada.';
    END TRY
    BEGIN CATCH
        -- Revierte solo lo que vino después del SAVEPOINT
        ROLLBACK TRANSACTION socio_creado;

        -- Confirma los cambios hasta el savepoint que seria persona y socio
        COMMIT TRANSACTION;

        PRINT 'Error en la parte de membresía/pago. Persona y socio quedaron guardados.';
        PRINT ERROR_MESSAGE();
    END CATCH

END TRY
BEGIN CATCH
    -- Si falló antes del savepoint, se cae todo
    ROLLBACK TRANSACTION;
    PRINT 'Error crítico. No se pudo completar, ningun dato se guardo.';
    PRINT ERROR_MESSAGE();
END CATCH;

--VERIFICAR LOS DATOS EN LAS TABLAS INVOLUCRADAS PARA ASEGUR
SELECT * FROM persona WHERE id_persona = @id_persona;
SELECT * FROM socio WHERE id_socio = @id_persona;
SELECT * FROM membresia WHERE id_membresia = @id_membresia;
SELECT * FROM membresia_clase WHERE membresia_id = @id_membresia;
SELECT * FROM pago WHERE id_pago = @id_pago;
SELECT * FROM pago_detalle WHERE pago_id = @id_pago;

/*
Conclusion:
Al trabajar con transacciones anidadas, se logra un control más fino sobre los errores.
Si ocurre un fallo en una subtransacción, se puede revertir solo esa parte usando un SAVEPOINT, 
manteniendo válidas las operaciones previas que ya fueron correctas dentro de la transacción principal.
Esto permite conservar la consistencia de los datos sin perder todo el progreso.
/*