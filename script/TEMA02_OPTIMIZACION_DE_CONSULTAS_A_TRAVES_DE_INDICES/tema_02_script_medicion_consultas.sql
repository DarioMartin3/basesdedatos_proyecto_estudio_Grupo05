USE gimnasio_db;
GO

DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

DECLARE @desde DATETIME = '2024-01-01',
        @hasta DATETIME = '2025-03-01';

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT socio_id, tipo_pago_id, fecha, total, estado
FROM dbo.pago
WHERE fecha >= @desde AND fecha < @hasta
OPTION (RECOMPILE);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


-- 2.3 Crear el **CLUSTERED** por fecha
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

CREATE CLUSTERED INDEX CX_pago_fecha
ON dbo.pago(fecha);
GO

DECLARE @desde DATETIME = '2024-01-01',
        @hasta DATETIME = '2025-03-01';

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT socio_id, tipo_pago_id, fecha, total, estado
FROM dbo.pago
WHERE fecha >= @desde AND fecha < @hasta
OPTION (RECOMPILE);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


DROP INDEX CX_pago_fecha ON dbo.pago;
GO


DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;


CREATE NONCLUSTERED INDEX IX_pago_fecha_cover
ON dbo.pago(fecha)
INCLUDE (socio_id, tipo_pago_id, total, estado);
GO

-- Medici�n con �ndice covering
DECLARE @desde DATETIME = '2024-01-01',
        @hasta DATETIME = '2025-03-01';
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT socio_id, tipo_pago_id, fecha, total, estado
FROM dbo.pago
WHERE fecha >= @desde AND fecha < @hasta
OPTION (RECOMPILE);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

DROP INDEX IX_pago_fecha_cover ON dbo.pago;
GO

