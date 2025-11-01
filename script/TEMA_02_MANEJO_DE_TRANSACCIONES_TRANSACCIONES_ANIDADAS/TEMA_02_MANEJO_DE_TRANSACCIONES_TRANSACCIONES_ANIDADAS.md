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
Las transacciones anidadas se aplican cuando dentro de una transacción principal se ejecutan otras transacciones internas.  
En SQL Server, solo la transacción externa controla el resultado final, es decir, el COMMIT o ROLLBACK global.  
Las transacciones internas pueden utilizar puntos de guardado (SAVEPOINT) que permiten revertir parcialmente un bloque sin deshacer toda la transacción principal.  
Este enfoque se usa cuando un proceso complejo puede fallar en pasos intermedios, pero se desea conservar las partes correctas ya ejecutadas.

## Comparación

| Aspecto | Transacción simple | Transacción anidada |
|----------|--------------------|---------------------|
| Nivel de control | General | Parcial |
| Estructura | Un único bloque | Múltiples niveles |
| Uso de SAVEPOINT | No necesario | Recomendado |
| Manejo de errores | Reversión total | Reversión parcial posible |

## Conclusión
Las transacciones simples garantizan la ejecución completa o nula de un conjunto de operaciones, asegurando la coherencia de los datos.  
Las transacciones anidadas, en cambio, ofrecen mayor control y flexibilidad, permitiendo manejar errores locales sin cancelar toda la operación.  
En ambos casos, su correcta implementación es esencial para mantener la integridad y confiabilidad de la base de datos.
