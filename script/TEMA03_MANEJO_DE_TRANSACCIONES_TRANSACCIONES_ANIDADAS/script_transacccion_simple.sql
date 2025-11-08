/*Escribir el código Transact SQL que permita definir una transacción consistente en: 
Tarea 1:
Insertar un registro en alguna tabla, luego otro registro en otra tabla y por último la actualización de uno o más registros en otra tabla.
Actualizar los datos solamente si toda la operación es completada con éxito. 

Insertamos socios, membresias, pagos 
*/
--Declaro las variables para almacenar los ids generados
DECLARE 
    @id_persona   INT,
    @id_membresia INT,
    @id_pago      INT,
    @total_pago   DECIMAL(10,2),
    @id_clase     INT = 2; --id de la clase en la que el socio se va a inscribir

BEGIN TRY
    BEGIN TRANSACTION;

    --Insertamos una persona y socio mediante un proceso almacenado
    EXEC dbo.sp_CrearPersonaYSocio
    @nombre = 'Lucas',
    @apellido = 'Fernández',
    @dni = 40231567,
    @telefono = 3795127845,
    @email = 'lucas.fernandez@mail.com',
    @contacto_emergencia = 3794678512,
    @observaciones = N'Lesión leve en hombro izquierdo. Hipertrofia muscular en seguimiento.',
    @id_persona = @id_persona OUTPUT; 

    --Insertamos una membresia
    EXEC dbo.sp_CrearMembresia
        @usuario_id = 14,
        @tipo_id = 3,
        @socio_id = @id_persona,
        @id_membresia = @id_membresia OUTPUT;

    
    --Insetertamos la relacion entre membresia y clase, y descontamos el cupo 
    EXEC dbo.sp_AsignarClaseADescontarCupo
        @id_membresia = @id_membresia,
        @id_clase = @id_clase;

    --Insertamos un pago y pago detalle, dentro del mismo procedimiento se calcula el total que se debe pagar
    EXEC dbo.sp_RegistrarPago
        @socio_id = @id_persona,
        @id_membresia = @id_membresia,
        @id_clase = @id_clase,
        @id_pago = @id_pago OUTPUT,
        @total = @total_pago OUTPUT;    

    COMMIT TRANSACTION;--Si todo sale bien, confirmamos los cambios
    PRINT 'Transacción completada con éxito';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;--En caso de error, se revierte toda la transaccion
    -- Manejo de errores
    PRINT 'Error en transaccion! No se guardaron los cambios: ' + ERROR_MESSAGE();
END CATCH;

--VERIFICAR LOS DATOS EN LAS TABLAS INVOLUCRADAS PARA ASEGUR
SELECT * FROM persona WHERE id_persona = @id_persona;
SELECT * FROM socio WHERE id_socio = @id_persona;
SELECT * FROM membresia WHERE id_membresia = @id_membresia;
SELECT * FROM membresia_clase WHERE membresia_id = @id_membresia;
SELECT * FROM pago WHERE id_pago = @id_pago;
SELECT * FROM pago_detalle WHERE pago_id = @id_pago;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Tarea 2:
Sobre el código escrito anteriormente provocar intencionalmente un error luego del insert 
y verificar que los datos queden consistentes (No se debería realizar ningún insert).


Usando el caso anterior tomamos el mismo dni pero cambiando los demas 
datos de la persona, al tener el campo dni como unico, se generara un error
*/
BEGIN TRY
    BEGIN TRANSACTION;

    --Insertamos una persona en la tabla Personas
    DECLARE @id_clase INT = 2; -- Variable para almacenar el ID de la clase a la que se inscribe el socio     

    DECLARE @id_persona INT; -- Variable para almacenar el ID de la persona
    INSERT INTO persona (nombre, apellido, dni, telefono, email, estado)
    VALUES ('Maria', 'Saucedo', 40231567, 379392134, 'maria.saucedo@mail.com', 1);

    SET @id_persona = SCOPE_IDENTITY(); -- Guardamos el ID de la persona insertada

    --Insertamos un socio en la tabla Socios    
    INSERT INTO socio (id_socio, contacto_emergencia, observaciones)
    VALUES (@id_persona, 3794678512, 'Sin lesiones');

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
    DECLARE @id_pago INT;

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
    SET @id_pago = SCOPE_IDENTITY(); -- Guardamos el ID del pago insertado
    --Insetertamos un pago detalle
    INSERT INTO pago_detalle (pago_id, membresia_id, clase_id)
    VALUES (@id_pago, @id_membresia, @id_clase);

    COMMIT TRANSACTION;--Si todo sale bien, confirmamos los cambios
    PRINT 'Transacción completada con éxito';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;--En caso de error, se revierte toda la transaccion
    -- Manejo de errores
    PRINT 'Error en transaccion! No se guardaron los cambios: ' + ERROR_MESSAGE();
END CATCH;

--VERIFICAR LOS DATOS EN LAS TABLAS INVOLUCRADAS PARA ASEGUR
SELECT * FROM persona WHERE id_persona = @id_persona;
SELECT * FROM socio WHERE id_socio = @id_persona;
SELECT * FROM membresia WHERE id_membresia = @id_membresia;
SELECT * FROM membresia_clase WHERE membresia_id = @id_membresia;
SELECT * FROM pago WHERE id_pago = @id_pago;
SELECT * FROM pago_detalle WHERE pago_id = @id_pago;

/*Conclusion
Una trasaccion es un conjunto de operaciones que se ejecutan como una unidad lógica de trabajo.
Si alguna de las operaciones falla, toda la transacción se revierte para mantener la integridad de los datos. A eso nos referimos que es atómica.
Evitando que exista una membresia sin socio, o un pago sin membresia, etc.
En el primer caso, al insertar datos válidos, todas las operaciones se completan con éxito y los cambios se confirman con COMMIT.
Se puede verificar que los datos fueron insertados correctamente en las tablas correspondientes usando el SELECT y obteniendo los registros.
En el segundo caso, al intentar insertar una persona con un DNI duplicado, se genera un error que provoca la reversión de toda la transacción usando ROLLBACK,
dejando la base en el mismo estado inicial. 
Lo unico por destacar que al momento de fallar una transaccion los atributos que poseen valores autogenerados (IDENTITY) no se revierten,
por lo que si se intenta insertar nuevamente una persona, el ID sera diferente al intento fallido. Pero no afecta a las tablas que no llegaron a
ejecutarse.
*/


