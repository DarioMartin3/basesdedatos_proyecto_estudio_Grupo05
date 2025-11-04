/*
Modificar una persona
*/

USE gimnasio_db;
GO

-- 1. Preparamos una "caja" (variable) para guardar el ID
DECLARE @ID_Usuario_Modificar INT;

-- 2. Buscamos el ID del usuario por DNI y lo guardamos en la variable
SELECT @ID_Usuario_Modificar = id_persona 
FROM persona 
WHERE dni = 41000111;

-- 3. Verificamos si la encontramos (buena práctica)
IF @ID_Usuario_Modificar IS NOT NULL
BEGIN
    PRINT 'Modificando a Usuario (ID: ' + CAST(@ID_Usuario_Modificar AS VARCHAR) + ')...';
    
    -- 4. Llamamos al "obrero" de modificar, pasándole el ID
    EXEC sp_ModificarPersona 
        @id_persona = @ID_Usuario_Modificar, 
        @telefono = 3794987654; -- El nuevo teléfono
        
    PRINT '¡Teléfono de Usuario modificado!';
END
ELSE
BEGIN
    PRINT 'Error: No se encontró la persona con ese DNI.';
END
GO

/*
Eliminar una persona (Baja lógica)
*/

USE gimnasio_db;
GO

-- 1. Preparamos una "caja" (variable) para guardar el ID
DECLARE @ID_Usuario_Borrar INT;

-- 2. Buscamos el ID de Usuario por DNI y lo guardamos en la variable
SELECT @ID_Usuario_Borrar = id_persona 
FROM persona 
WHERE dni = 41000333; -- <-- DNI Corregido (Usuario)

-- 3. Verificamos si la encontramos (buena práctica)
IF @ID_Usuario_Borrar IS NOT NULL
BEGIN
    PRINT 'Desactivando a Usuario (ID: ' + CAST(@ID_Usuario_Borrar AS VARCHAR) + ')...';
    
    -- 4. Llamamos al "obrero" de eliminar, pasándole el ID
    EXEC sp_BorrarPersona 
        @id_persona = @ID_Usuario_Borrar; -- <-- Coma eliminada
        
    PRINT '¡Usuario fue desactivada (borrado lógico)!';
END
ELSE
BEGIN
    PRINT 'Error: No se encontró la persona con ese DNI.';
END
GO

