# **Informe: Transacciones simples y anidadas en SQL Server**
## Introducción: ¿Qué es una Transacción?

Una transacción es una secuencia de una o más operaciones (como inserciones, actualizaciones o eliminaciones) que se ejecutan como una única unidad de trabajo lógica. El principio fundamental de una transacción es "todo o nada", todas las operaciones dentro de ella se completan y confirman exitosamente o ninguna de ellas se aplica.

Algunos conceptos que son parte de una transaccion
* **Atomicidad:** Garantiza que la transacción es indivisible. Ocurre en su totalidad o no ocurre en absoluto.
* **Consistencia:** Asegura que la base de datos pasa de un estado válido a otro estado válido.
* **Aislamiento:** Protege las transacciones que se ejecutan simultáneamente, evitando que interfieran entre sí.
* **Durabilidad:** Una vez que una transacción se confirma, sus cambios son permanentes, incluso si el sistema falla.

## Transacciones Simples

Una transacción simple es el tipo más común. Es un único bloque de trabajo que se inicia explícitamente, ejecuta sus comandos y luego finaliza con una confirmación o una reversión.
Componentes de una transaccion
* `BEGIN TRANSACTION`: Marca el inicio de la transacción.
* `COMMIT TRANSACTION`: Aplica permanentemente todos los cambios realizados dentro de la transacción.
* `ROLLBACK TRANSACTION`: Deshace todos los cambios realizados dentro de la transacción, revirtiendo la base de datos a su estado anterior.

## Transacciones Anidadas 

Las transacciones anidadas se utilizan cuando, dentro de una transacción principal, se ejecutan otras transacciones internas. Esto ocurre comúnmente por **modularidad**, como cuando un procedimiento almacenado (que tiene su propia transacción) llama a otro.

Internamente, SQL Server administra los niveles mediante la variable de sistema **`@@TRANCOUNT`**, que aumenta con cada `BEGIN TRANSACTION`.
El comportamiento clave es el de **"todo o nada" absoluto**:

1.  **`COMMIT` Asimétrico:** Un `COMMIT` interno solo decrementa `@@TRANCOUNT`. La transacción solo se confirma realmente cuando el `COMMIT` externo lleva `@@TRANCOUNT` a cero.
2.  **`ROLLBACK` Absoluto:** Un `ROLLBACK` ejecutado en **cualquier nivel** (interno o externo) revierte **toda la transacción completa** hasta el inicio y establece `@@TRANCOUNT` en 0.

Este mecanismo asegura que si un subproceso falla, todo el trabajo se deshace, garantizando la consistencia atómica de la operación completa.

## Comparación 

| Aspecto | Transacción simple | Transacción anidada |
|--------|--------------------|----------------------|
| Cantidad de niveles | Un solo nivel | Múltiples niveles lógicos |
| `@@TRANCOUNT` | 0 → 1 → 0 | 0 → 1 → 2 → … → 0 |
| Confirmación (`COMMIT`) | Confirma inmediatamente | Solo decrementa `@@TRANCOUNT`; la confirmación real ocurre cuando vuelve a 0 |
| Reversión (`ROLLBACK`) | Revierte toda la transacción | Revierte toda la cadena, sin importar el nivel |
| Modularidad | Baja | Alta (SP llamando a SP) |
| Aislamiento de errores | No | Parcial con `SAVEPOINT`, pero no separa transacciones reales |
| Riesgos principales | Olvidar ROLLBACK en errores | Pensar que una subtransacción es independiente |
| Uso típico | Bloques simples | Procesos complejos y modularizados |

## Errores comunes al trabajar con transacciones anidadas

### 1. Creer que una transacción interna es independiente
Cualquier `ROLLBACK`, ya sea interno o externo, revierte toda la transacción completa.

### 2. Pensar que `COMMIT` interno confirma los cambios
El `COMMIT` interno solo reduce `@@TRANCOUNT`; no confirma nada por sí mismo.

### 3. No usar bloques `TRY/CATCH`
Si ocurre un error sin manejo adecuado, la transacción queda abierta y bloquea la sesión.

### 4. Usar `SAVEPOINT` como si fuera una subtransacción real
El savepoint permite volver a un punto seguro, pero no aísla transacciones internas frente al rollback global.

### 5. Hacer `ROLLBACK` dentro de un procedimiento almacenado
Esto revierte toda la transacción, incluso si el SP fue llamado dentro de otra transacción mayor.

## Conclusión
Las transacciones simples garantizan la ejecución completa o nula de un conjunto de operaciones, asegurando la coherencia de los datos.
Las transacciones anidadas , en cambio, refuerzan esta atomicidad en procesos modulares; **no** ofrecen control flexible, sino que un `ROLLBACK` local **cancela toda la operación principal**.
En ambos casos, su correcta implementación es esencial para mantener la integridad y confiabilidad de la base de datos.
