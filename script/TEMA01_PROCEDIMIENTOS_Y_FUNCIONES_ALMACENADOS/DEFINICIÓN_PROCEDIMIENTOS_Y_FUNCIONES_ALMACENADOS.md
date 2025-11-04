# 📘 Procedimientos y Funciones Almacenadas en Bases de Datos

## 1. Introducción

En el contexto del diseño y administración de bases de datos relacionales, los **procedimientos almacenados** (*Stored Procedures*) y las **funciones almacenadas** (*Stored Functions*) constituyen herramientas avanzadas que permiten encapsular lógica de negocio dentro del propio Sistema Gestor de Base de Datos (SGBD). Su propósito es **optimizar el rendimiento, garantizar la integridad de los datos y centralizar las operaciones complejas**, evitando la repetición de código y reduciendo el acoplamiento con las capas de aplicación.

A diferencia de las sentencias SQL ejecutadas de manera aislada desde una aplicación externa, los procedimientos y funciones almacenadas son **rutinas precompiladas** que residen en el servidor de base de datos y se ejecutan en su propio contexto transaccional. De esta manera, disminuyen la carga de procesamiento en el cliente y favorecen la coherencia de las operaciones sobre los datos.

En entornos empresariales o de desarrollo web, estas rutinas suelen ser invocadas desde el backend de la aplicación (por ejemplo, mediante Node.js, PHP, Python o Java), constituyendo un puente eficiente entre la capa lógica de negocio y la capa de persistencia de datos.

---

## 2. Procedimientos Almacenados

### 2.1 Definición

Un **procedimiento almacenado** es un conjunto de sentencias SQL precompiladas que se almacenan y ejecutan directamente en el servidor de base de datos. Su principal finalidad es **realizar operaciones que modifiquen el estado de la base de datos**, tales como inserciones, actualizaciones o eliminaciones de registros, además de permitir la ejecución de procesos complejos, transaccionales o automatizados.

Los procedimientos pueden aceptar **parámetros de entrada (IN)**, **salida (OUT)** o **entrada/salida (INOUT)**, lo que facilita la comunicación bidireccional entre la aplicación y la base de datos.

### 2.2 Sintaxis general

La sintaxis puede variar ligeramente según el SGBD (MySQL, PostgreSQL, SQL Server, Oracle), pero en general adopta la siguiente estructura:

```sql
CREATE PROCEDURE nombre_procedimiento (parametros)
BEGIN
    -- Bloque de instrucciones SQL
END;
```

### 2.3 Ejemplo

```sql
CREATE PROCEDURE sp_insertar_cliente(
    IN p_nombre VARCHAR(50),
    IN p_correo VARCHAR(100)
)
BEGIN
    INSERT INTO clientes (nombre, correo)
    VALUES (p_nombre, p_correo);
END;
```

En este ejemplo, el procedimiento `sp_insertar_cliente` encapsula la operación de inserción de registros en la tabla `clientes`. La ejecución se realiza mediante la instrucción:

```sql
CALL sp_insertar_cliente('Juan Pérez', 'juanperez@mail.com');
```

### Ejemplo en MySQL

```sql
DELIMITER //
CREATE PROCEDURE sp_insertar_cliente(
    IN p_nombre VARCHAR(50),
    IN p_correo VARCHAR(100)
)
BEGIN
    INSERT INTO clientes (nombre, correo)
    VALUES (p_nombre, p_correo);
END //
DELIMITER ;

CALL sp_insertar_cliente('Juan Pérez', 'juanperez@mail.com');
```

### Ejemplo en SQL Server

```sql
CREATE PROCEDURE sp_insertar_cliente
    @p_nombre NVARCHAR(50),
    @p_correo NVARCHAR(100)
AS
BEGIN
    INSERT INTO clientes (nombre, correo)
    VALUES (@p_nombre, @p_correo);
END

EXEC sp_insertar_cliente 'Juan Pérez', 'juanperez@mail.com';
```

### Ejemplo en PostgreSQL

```sql
CREATE OR REPLACE FUNCTION sp_insertar_cliente(
    p_nombre VARCHAR,
    p_correo VARCHAR
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO clientes (nombre, correo)
    VALUES (p_nombre, p_correo);
END;
$$ LANGUAGE plpgsql;

SELECT sp_insertar_cliente('Juan Pérez', 'juanperez@mail.com');
```

### 2.4 Características principales

- Se ejecutan directamente en el servidor de base de datos.
- Pueden contener estructuras de control (condicionales, bucles, cursores).
- Permiten agrupar múltiples operaciones SQL dentro de una misma transacción.
- No devuelven un valor directo, aunque pueden devolver parámetros OUT.
- Pueden manejar errores y excepciones internas.

---

## 3. Funciones Almacenadas

### 3.1 Definición

Una **función almacenada** es una rutina definida en el SGBD que, a diferencia del procedimiento, retorna un valor único como resultado de su ejecución. Las funciones se emplean generalmente para cálculos, transformaciones, validaciones o derivaciones de datos, y pueden ser utilizadas dentro de otras sentencias SQL, como `SELECT`, `WHERE`, `ORDER BY` o `GROUP BY`.

### 3.2 Sintaxis general

```sql
CREATE FUNCTION nombre_funcion (parametros)
RETURNS tipo_dato
BEGIN
    -- Instrucciones SQL
    RETURN valor;
END;
```

### 3.3 Ejemplo

```sql
CREATE FUNCTION fn_calcular_edad(fecha_nacimiento DATE)
RETURNS INT
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
END;
```

La función `fn_calcular_edad` devuelve la edad calculada a partir de una fecha de nacimiento. Puede invocarse dentro de una consulta, por ejemplo:

```sql
SELECT nombre, fn_calcular_edad(fecha_nacimiento) AS edad FROM empleados;
```

### 3.4 Características principales

- Retornan un valor mediante la cláusula `RETURN`.
- Pueden ser utilizadas dentro de consultas SQL comunes.
- Están orientadas a la obtención o derivación de información.
- Son determinísticas (devuelven el mismo resultado ante los mismos parámetros).
- No deben modificar el estado de la base de datos (no deben ejecutar `INSERT`, `UPDATE` o `DELETE`).

---

## 4. Diferencias entre Procedimientos y Funciones

| **Criterio**              | **Procedimiento Almacenado**         | **Función Almacenada**            |
|---------------------------|---------------------------------------|------------------------------------|
| **Propósito**             | Ejecutar operaciones y modificar datos | Calcular y devolver un resultado  |
| **Valor de retorno**      | No devuelve valor (solo parámetros OUT) | Devuelve un valor mediante RETURN |
| **Uso en consultas SQL**  | No puede ser invocado dentro de un SELECT | Sí, puede ser utilizado en consultas |
| **Modificación de datos** | Permitida (INSERT, UPDATE, DELETE)    | No recomendada                    |
| **Transaccionalidad**     | Puede contener bloques transaccionales | Limitada o inexistente            |
| **Llamada**               | `CALL nombre_procedimiento(...)`      | `SELECT nombre_funcion(...)`      |

---

## 5. Aplicación en Operaciones CRUD

Los procedimientos almacenados son particularmente útiles para implementar operaciones CRUD (Create, Read, Update, Delete) de manera controlada y estandarizada. Por ejemplo:

```sql
-- Insertar registro
CALL sp_insertar_cliente('Ana Torres', 'ana@mail.com');

-- Modificar registro
CALL sp_modificar_cliente(3, 'Ana Torres', 'ana_actualizada@mail.com');

-- Eliminar registro
CALL sp_eliminar_cliente(3);
```

De este modo, la lógica de negocio se mantiene centralizada en la base de datos, reduciendo los riesgos de inconsistencia y mejorando la mantenibilidad del sistema.

---

## 6. Casos de Uso Profesionales

En entornos corporativos o de desarrollo web, el uso de procedimientos y funciones almacenadas se justifica en los siguientes escenarios:

### Automatización de procesos masivos:

- Actualización de precios o stocks.
- Generación automática de informes o cierres contables.
- Procesos nocturnos programados mediante jobs o cron tasks.

### Garantía de integridad y seguridad:

- Transacciones financieras, contables o logísticas que requieren ejecución atómica.
- Validación de reglas de negocio directamente en la base.
- Reducción de errores humanos mediante procedimientos predefinidos.

### Optimización del rendimiento:

- Menor tráfico entre la aplicación y el servidor.
- Ejecución precompilada y cacheada de planes SQL.
- Procesamiento local de datos, sin transferencia de grandes volúmenes.

### Centralización de la lógica:

- Reutilización de rutinas comunes en distintas aplicaciones o módulos.
- Mantenimiento simplificado de reglas de negocio.
- Independencia del lenguaje de programación del backend.

### Cálculos o transformaciones frecuentes:

- Funciones que calculan totales, promedios, impuestos o indicadores.
- Evaluaciones de estado (por ejemplo, determinar si un producto está disponible).
- Conversión y formateo de valores.

---

## 7. Interacción con el Backend

En una arquitectura web típica, el backend (implementado en Node.js, PHP, Python, Java, etc.) actúa como intermediario entre el cliente y la base de datos. El backend invoca procedimientos o funciones mediante sentencias SQL o métodos del controlador de base de datos.

### Ejemplo en Node.js (con PostgreSQL)

```javascript
await pool.query('CALL sp_insertar_cliente($1, $2)', [nombre, correo]);
```

### Ejemplo en PHP (con MySQL)

```php
$stmt = $pdo->prepare("CALL sp_insertar_cliente(:nombre, :correo)");
$stmt->execute(['nombre' => $nombre, 'correo' => $correo]);
```

En ambos casos, el procedimiento se ejecuta directamente en el servidor de base de datos, y el backend solo gestiona la respuesta. Esto permite reducir el número de consultas, aumentar la seguridad y mantener la consistencia de los datos.

---

## 8. Ventajas y Desventajas

| **Ventajas**                                      | **Desventajas**                                      |
|--------------------------------------------------|----------------------------------------------------|
| Mejora del rendimiento al ejecutarse en el servidor | Dependencia del SGBD (baja portabilidad)           |
| Reutilización y estandarización de lógica         | Dificultad para versionar y mantener en grandes proyectos |
| Seguridad mediante control interno de datos       | Menor flexibilidad en depuración y testing         |
| Reducción del tráfico entre backend y base        | Lógica más dispersa entre capas                    |
| Ejecución atómica de operaciones                  | Curva de aprendizaje mayor para mantenimiento      |

---

## 9. Comparación de Eficiencia

Diversos estudios empíricos y pruebas de rendimiento demuestran que la ejecución de operaciones mediante procedimientos almacenados es generalmente más eficiente que las consultas directas enviadas desde la aplicación. Esto se debe a:

- **Compilación previa**: el motor SQL ya dispone del plan de ejecución optimizado.
- **Reducción de viajes cliente-servidor**: se ejecutan varias operaciones en una sola llamada.
- **Procesamiento interno**: los datos no se trasladan innecesariamente a la capa de aplicación.
- **Aprovechamiento del caché del SGBD**: los resultados y planes se reutilizan en llamadas posteriores.

No obstante, en arquitecturas modernas basadas en microservicios, APIs RESTful o sistemas distribuidos, la tendencia es mantener la mayor parte de la lógica en el backend, reservando los procedimientos y funciones para operaciones que realmente requieren eficiencia o atomicidad.

---

## 10. Buenas Prácticas de Implementación

- Nombrar adecuadamente las rutinas según convención (`sp_` para procedimientos, `fn_` para funciones).
- Documentar cada bloque con comentarios sobre su propósito, parámetros y retornos.
- Evitar lógica redundante y mantener rutinas genéricas reutilizables.
- Usar transacciones explícitas en operaciones críticas.
- Validar parámetros antes de ejecutar operaciones de modificación.
- Registrar errores o excepciones para diagnóstico y auditoría.
- Medir tiempos de ejecución para evaluar la eficiencia.

---

## 11. Conclusión

El uso de procedimientos y funciones almacenadas constituye una práctica esencial en la ingeniería de bases de datos modernas. Estas estructuras permiten mejorar el rendimiento, garantizar la integridad de los datos y centralizar la lógica de negocio en un entorno controlado.

Desde una perspectiva académica y profesional, su aplicación debe analizarse cuidadosamente en función de la arquitectura del sistema y los requerimientos de mantenimiento, seguridad y escalabilidad. Mientras que los procedimientos almacenados resultan ideales para la ejecución de procesos complejos y críticos, las funciones almacenadas ofrecen un mecanismo eficiente para cálculos y transformaciones reutilizables.

El dominio de estas herramientas representa un paso fundamental hacia el diseño de sistemas robustos, eficientes y coherentes, integrando de manera armoniosa la capa de datos con las capas lógicas y de presentación de una aplicación moderna.
