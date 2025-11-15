# Proyecto de Estudio    

# PRESENTACIÓN (Proyecto GymanagerPro)

**Asignatura**: Bases de Datos I (FaCENA-UNNE)

**Integrantes**:
 * Gonzales, Facundo Nicolas 
 * Maidana, Pablo Gaston
 * Martín, Carlos Dario
 * Martinez Castro, Gustavo Nahim

**Año**: 2025

## CAPÍTULO I: INTRODUCCIÓN

### a) Tema
**Diseño e implementación de una base de datos relacional para la gestión integral de un gimnasio.**  
El trabajo aborda la modelación y construcción de un esquema en SQL Server que soporte procesos clave: administración de personas y usuarios con roles, socios y membresías, pagos, actividades y clases con horarios e inscripciones, inventario y compras a proveedores.

#### b) Definición o planteamiento del problema
Los gimnasios medianos suelen operar con planillas aisladas y registros manuales que generan duplicación de datos, errores y demoras en tareas críticas: alta de socios, control de vencimientos de membresías, cupos de clases, registro de pagos, control de stock y trazabilidad de compras.  
**Problema central:** no existe una base de datos integrada y normalizada que garantice integridad, disponibilidad y consistencia de la información operativa del gimnasio.

### c) Objetivo del Trabajo Práctico

#### i. Objetivo General
Diseñar y construir una base de datos relacional en SQL Server para la gestión integral de un gimnasio, aplicando principios de normalización e integridad referencial, y materializando reglas de negocio mediante claves, restricciones y relaciones.

#### ii. Objetivos Específicos
1. **Modelar** el dominio identificando entidades, atributos y relaciones: persona, usuario, rol, socio, membresía, tipo de membresía, pago, actividad, clase, día/horario, inscripción, proveedor, estado de compra, orden de compra, inventario, categoría y movimiento.
2. **Normalizar** las tablas hasta 3FN, eliminando redundancias y anomalías de actualización.
3. **Implementar integridad** con PK, FK y restricciones `CHECK`, `UNIQUE` y `DEFAULT` para:
   - Unicidad de DNI, email y teléfono.
   - Rango válido de DNI y fechas (`fecha_fin ≥ fecha_inicio`).
   - Cupos y montos positivos.
   - No duplicar producto dentro de la misma orden de compra.
4. **Definir catálogos y estados** controlados (por ejemplo, `estado_compra`) para mantener consistencia semántica.
5. **Optimizar consultas operativas** mediante claves y relaciones que habiliten reportes de: vencimientos de membresías, recaudación por período, ocupación de clases, inscriptos por actividad, stock disponible y trazabilidad de compras.
6. **Documentar** el esquema con diccionario de datos, diagrama entidad-relación y justificación de decisiones de diseño.
7. **Validar** el diseño con casos de uso: alta de socio, venta de membresía, registro de pago, programación de clase y horarios, inscripción, compra a proveedor, ingreso/egreso de inventario.

## CAPÍTULO II: MARCO CONCEPTUAL O REFERENCIAL

Este capítulo presenta los conceptos base que orientan el diseño e implementación de la base de datos en SQL Server para GymanagerPro. El objetivo es establecer un marco común y coherente que permita comprender las decisiones técnicas y su relación con los requerimientos del gimnasio: seguridad de acceso, correcta modelación del dominio, eficiencia en consultas, consistencia transaccional y continuidad operativa.

### Tema 1: Procedimientos y funciones almacenados

Los procedimientos almacenados encapsulan lógica de negocio y operaciones DML, mejorando seguridad, mantenimiento y rendimiento (plan de ejecución en caché). Las funciones (escalares o con valores de tabla) encapsulan cálculos y pueden integrarse en consultas, promoviendo reutilización y consistencia.

- Procedimientos: admiten DML, control de flujo, manejo de errores y transacciones; no requieren devolver valor; no se invocan dentro de un `SELECT`.
- Funciones: devuelven siempre un valor (escalar o tabla), son referenciables en consultas; no realizan DML sobre tablas.
- Aplicación al proyecto: `sp_insertarPersona`, alta de membresía e inscripción a clases como procedimientos; cálculo de fecha de vencimiento, monto calculado o cupos disponibles como funciones.

- Referencias del proyecto: `script/TEMA01_PROCEDIMIENTOS_Y_FUNCIONES_ALMACENADOS/DEFINICIÓN_PROCEDIMIENTOS_Y_FUNCIONES_ALMACENADOS.md`, `script/TEMA01_PROCEDIMIENTOS_Y_FUNCIONES_ALMACENADOS/LOTE_USANDO_PROCEDIMIENTO_sp_insertarPersona_Y_FORMA_TRADICIONAL.sql`, `script/TEMA01_PROCEDIMIENTOS_Y_FUNCIONES_ALMACENADOS/MODIFICAR_Y_ELIMINAR_USANDO_PROCEDIMIENTOS.sql`.

### Tema 2: Optimización de consultas a través de índices

Los índices (agrupados y no agrupados) aceleran búsquedas y filtros al costo de mayor escritura y almacenamiento. Índices compuestos y columnas incluidas pueden reducir lecturas. Mantener estadísticas actualizadas y revisar planes de ejecución.

- Índice agrupado: define el orden físico de la tabla; suele ubicarse en claves de acceso predominante y únicas.
- Índices no agrupados: optimizan filtros/joins frecuentes; evaluar impacto en inserciones/actualizaciones.
- Aplicación al proyecto: índices sobre `persona(dni)`, `socio(id_persona)`, `membresia(fecha_fin, id_socio)` para vencimientos, `clase(id_actividad, fecha_hora)` y claves foráneas más consultadas. Evitar excesos en tablas con alta tasa de escritura como movimientos de inventario o pagos.

- Referencias del proyecto: `script/TEMA02_OPTIMIZACION_DE_CONSULTAS_A_TRAVES_DE_INDICES/tema_02_script_medicion_consultas.sql`; generadores de datos de prueba `script/TEMA02_OPTIMIZACION_DE_CONSULTAS_A_TRAVES_DE_INDICES/membresia_insert.py`, `membresia_clase_insert.py`, `pagos_insert.py`, `pago_detalle_insert.py`.

### Tema 3: Manejo de transacciones (simples y anidadas)

Las transacciones garantizan atomicidad, consistencia y durabilidad. En SQL Server pueden anidarse y controlarse con `TRY...CATCH`, `BEGIN/COMMIT/ROLLBACK`.

- Atomicidad operativa: alta de pago + detalle + actualización de membresía y, de corresponder, movimiento de inventario, todo confirmado o revertido en conjunto.
- Concurrencia: elección de aislamiento acorde a consultas de ocupación de clases.
- Aplicación al proyecto: scripts de TEMA 03 demuestran transacción simple y anidada con manejo de errores para preservar consistencia en casos de fallas parciales.

- Referencias del proyecto: `script/TEMA03_MANEJO_DE_TRANSACCIONES_TRANSACCIONES_ANIDADAS/script_transacccion_simple.sql`, `script/TEMA03_MANEJO_DE_TRANSACCIONES_TRANSACCIONES_ANIDADAS/script_transaccion_anidada.sql`.

### Tema 4: Backup y restore (backup en línea)

La continuidad operativa depende de una estrategia de copias de seguridad alineada. En modelo de recuperación `FULL`, los backups de log habilitan restauración a punto en el tiempo, incluso con copias “en línea” mientras la base está disponible.

- Tipos: completo, log de transacciones; opciones `WITH NORECOVERY/RECOVERY` para secuencias de restauración.
- Prácticas: verificar integridad de backups, monitorear tamaño del log y planificar truncamiento/backup de log.
- Configuración: el tener la base de datos en el modo FULL es muy importante para permitir o tener una forma de poder volver atras a momentos específicos.

- Referencias del proyecto: `script/TEMA04_BACKUP_Y_RESTORE_BACKUP_EN_LINEA/tema04_script.sql`.

## CAPÍTULO III: METODOLOGIA SEGUIDA

Lo primero que hicimos en este trabajo fue definir el tema que ibamos a trabajar, y con ello su respectivo modelo de datos, siempre intentando seguir con las formas normales dadas en la materia.
Una vez tuvimos los temas, realizamos una división de los mismos, un tema cada uno para investigarlos. Siempre manteniendo una comunicacion entre nosotros, ya sea por nuestro grupo de WhatsApp o mediante llamadas en discord para debatir.

Las herramientas que utilizamos:
-SQL SERVER
-SQL SERVER MANAGMENT EXPRESS (SSMS).
-GITHUB como nuestro repositorio remoto
-GIT para llevar un control de versiones
-DISCORD para debates
-WHATSAPP para comunicación

## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS

### Diagrama relacional
![der](https://github.com/DarioMartin3/basesdedatos_proyecto_estudio_Grupo05/blob/main/doc/diagrama_ER.png)

### Diccionario de datos

Acceso al documento [PDF](https://github.com/DarioMartin3/basesdedatos_proyecto_estudio_Grupo05/blob/main/doc/diccionario_datos.pdf) del diccionario de datos.