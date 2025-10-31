--Escribir el código Transact SQL que permita definir una transacción consistente en: 
--Tarea 1:
--Insertar un registro en alguna tabla, luego otro registro en otra tabla y por último la actualización de uno o más registros en otra tabla.
--Actualizar los datos solamente si toda la operación es completada con éxito. 


BEGIN TRY
    BEGIN TRANSACTION;

    --Insertamos una persona en la tabla Personas
    DECLARE @id_clase INT = 2; -- Variable para almacenar el ID de la clase a la que se inscribe el socio

    DECLARE @id_persona INT; -- Variable para almacenar el ID de la persona
    INSERT INTO persona (nombre, apellido, dni, telefono, email, estado)
    VALUES ('Lucas', 'Fernández', 40231567, 3795127845, 'lucas.fernandez@mail.com', 1);

    SET @id_persona = SCOPE_IDENTITY(); -- Guardamos el ID de la persona insertada

    --Insertamos un socio en la tabla Socios    
    INSERT INTO socio (id_socio, contacto_emergencia, observaciones)
    VALUES (@id_persona, 3794678512, 'Lesión leve en hombro izquierdo. Hipertrofia muscular en seguimiento.');

    --Insertamos una membresia
    DECLARE @id_membresia INT; -- Variable para almacenar el ID de la membresía

    INSERT INTO membresia (usuario_id, tipo_id, socio_id, estado)
    VALUES (14, 3, @id_persona, 1);

    SET @id_membresia = SCOPE_IDENTITY(); -- Guardamos el ID de la membresía insertada

    --Insetertamos la relacion entre membresia y clase
    INSERT INTO membresia_clase (membresia_id, clase_id)
    VALUES (@id_membresia, @id_clase);

    --Update de las del cupo de la clase    
    UPDATE clase 
    SET cupo = cupo - 1
    WHERE id_clase = @id_clase;    

    --Insertamos un pago
    DECLARE @total_pago DECIMAL(10,2);

    --Calculamos el total a pagar ya que es un valor derivado de la membresia y la clase
    SELECT 
    @total_pago = SUM(c.precio) * mt.duracion_dias
    FROM membresia m
    JOIN membresia_tipo mt ON m.tipo_id = mt.id_tipo
    JOIN membresia_clase mc ON m.id_membresia = mc.membresia_id
    JOIN clase c ON mc.clase_id = c.id_clase
    WHERE m.id_membresia = @id_membresia
    GROUP BY mt.duracion_dias;

    INSERT INTO pago (socio_id, tipo_pago_id, total, estado)
    VALUES (@id_persona, 1,  @total_pago, 1);

    --Insetertamos un pago detalle
    INSERT INTO pago_detalle (pago_id, membresia_id, clase_id)
    VALUES (SCOPE_IDENTITY(), @id_membresia, @id_clase);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    -- Manejo de errores
    PRINT 'Error al hacer la transaccion' + ERROR_MESSAGE();
END CATCH;


--Tarea 2:
--Sobre el código escrito anteriormente provocar intencionalmente un error luego del insert y verificar que los datos queden consistentes 
--(No se debería realizar ningún insert).


--Tarea 3:
--Expresar las conclusiones en base a las pruebas realizadas.

