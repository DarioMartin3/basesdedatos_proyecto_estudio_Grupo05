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

## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS

### Diagrama relacional
![der](https://github.com/DarioMartin3/basesdedatos_proyecto_estudio_Grupo05/blob/main/doc/diagrama_ER.png)

### Diccionario de datos

Acceso al documento [PDF](https://github.com/DarioMartin3/basesdedatos_proyecto_estudio_Grupo05/blob/main/doc/diccionario_datos.pdf) del diccionario de datos.