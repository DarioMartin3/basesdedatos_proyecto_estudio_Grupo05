# **Procedimientos Almacenados y Funciones Definidas por el Usuario en SQL Server**

Asignatura: Bases de Datos I  
Tema: TEMA01 - Implementación de Lógica de Negocio en el Servidor  
Fuente Principal: Documentación Oficial de Microsoft (SQL Server 2022)

## **1. Introducción**

En el desarrollo de una base de datos relacional como gimnasio_db, la lógica de negocio se puede implementar directamente en el servidor de base de datos. SQL Server (Transact-SQL) proporciona dos herramientas principales para este fin: **Procedimientos Almacenados** y **Funciones Definidas por el Usuario (UDF)**.

Ambos son rutinas Transact-SQL precompiladas que se almacenan en la base de datos y se pueden invocar desde una aplicación. Su uso es fundamental para crear una capa de datos robusta, segura y eficiente.

## **2. Procedimientos Almacenados (Stored Procedures)**

Un procedimiento almacenado en SQL Server es un grupo de una o varias instrucciones Transact-SQL compiladas en un solo plan de ejecución.

Un procedimiento se asemeja a las construcciones de otros lenguajes de programación, ya que puede:

1. **Aceptar parámetros de entrada** (ej: el DNI de una persona).  
2. **Devolver múltiples valores** en forma de parámetros de salida (OUTPUT).  
3. **Contener instrucciones de programación** que realicen operaciones en la base de datos (DML).  
4. **Devolver un valor de estado** (un entero) para indicar éxito o error.

### **2.1. Ventajas de los Procedimientos Almacenados**

Según la documentación de Microsoft, las ventajas clave de encapsular la lógica en procedimientos son:

* **Rendimiento Mejorado (Improved performance):** Un procedimiento se compila *una sola vez* y el motor de base de datos crea un "plan de ejecución" que se almacena en caché. En ejecuciones posteriores, el procesador de consultas reutiliza este plan, ahorrando el costo de volver a compilar la consulta.  
* **Tráfico de Red Reducido:** Los comandos se ejecutan en un único lote en el servidor. La aplicación cliente solo envía la llamada EXECUTE, reduciendo drásticamente el tráfico de red en comparación con enviar cada línea de SQL individualmente.  
* **Seguridad Más Sólida (Stronger security):** Esta es una ventaja crucial. Un administrador puede conceder permisos EXECUTE sobre un procedimiento a un usuario (ej: un recepcionista) sin necesidad de que ese usuario tenga permisos INSERT, UPDATE o DELETE directos sobre las tablas subyacentes. El procedimiento controla la operación y protege las tablas.  
* **Reutilización del Código y Mantenimiento Sencillo:** Cualquier operación redundante (como registrar un nuevo socio) se escribe una vez. Si la lógica de negocio cambia (ej: se añade una nueva columna), solo se modifica el procedimiento en un lugar, y todas las aplicaciones que lo llaman heredan el cambio automáticamente.

### **2.2. Ejemplo de T-SQL (Proyecto gimnasio_db)**

El siguiente procedimiento implementa la operación INSERT para la tabla persona, encapsulando la lógica de negocio del alta.

```sql
/*  
  Documentación:  
  - Nombre: sp_InsertarPersona  
  - Objetivo: Da de alta una nueva persona en la tabla 'persona'.  
  - Plataforma: SQL Server (T-SQL)  
*/  
CREATE PROCEDURE sp_InsertarPersona  
    @nombre varchar(255),  
    @apellido varchar(255),  
    @dni bigint,  
    @telefono bigint,  
    @email varchar(200)  
AS  
BEGIN  
    SET NOCOUNT ON; -- Evita mensajes de "filas afectadas" al cliente

    INSERT INTO persona (nombre, apellido, dni, telefono, email)   
    VALUES (@nombre, @apellido, @dni, @telefono, @email);  
END  
GO
```

Invocación:

```sql
EXEC sp_InsertarPersona   
    @nombre = 'Juan',   
    @apellido = 'Pérez',   
    @dni = 30123456,   
    @telefono = 3794001122,   
    @email = 'juan.perez@mail.com';
```

## **3. Funciones Definidas por el Usuario (User-Defined Functions)**

Las Funciones Definidas por el Usuario (UDF) son rutinas Transact-SQL que aceptan parámetros, realizan una acción (generalmente un cálculo complejo) y **devuelven el resultado de esa acción como un valor**.

La principal diferencia con un procedimiento es que una función **debe devolver un valor** y no puede usarse para modificar el estado de la base de datos.

### **3.1. Restricción Clave de las Funciones**

Según Microsoft, la regla fundamental es: **Las funciones definidas por el usuario no pueden usarse para realizar acciones que modifiquen el estado de la base de datos.**

Esto significa que una función **NO PUEDE** contener sentencias INSERT, UPDATE, DELETE o CREATE que afecten a tablas permanentes. Su propósito es la consulta y el cálculo.

### **3.2. Tipos de Funciones en SQL Server**

1. **Funciones Escalares:** Devuelven un **único valor** (ej: int, varchar(100), date). Son ideales para cálculos.  
2. **Funciones con Valores de Tabla:** Devuelven un **conjunto de resultados** (una tabla). Son una alternativa poderosa a las Vistas, ya que pueden aceptar parámetros.

### **3.3. Ventajas de las Funciones**

* **Programación Modular:** Al igual que los procedimientos, permiten crear la lógica una vez y llamarla varias veces.  
* **Ejecución más Rápida:** También cachean los planes de ejecución para optimizar el rendimiento.  
* **Flexibilidad en Consultas:** Su principal ventaja es que pueden ser invocadas *dentro* de sentencias SELECT (en la lista de columnas) o en cláusulas WHERE y JOIN, permitiendo consultas más limpias y potentes.

### **3.4. Ejemplo de T-SQL (Proyecto gimnasio_db)**

La siguiente función *escalar* calcula el nombre completo de una persona, permitiendo reutilizar esta lógica de formato en todas las consultas.

```sql
/*  
  Documentación:  
  - Nombre: fn_GetNombreCompleto  
  - Objetivo: Devuelve "Apellido, Nombre" de una persona.  
  - Plataforma: SQL Server (T-SQL)  
  - Tipo: Función Escalar  
*/  
CREATE FUNCTION fn_GetNombreCompleto  
(  
    @id_persona int  
)  
RETURNS VARCHAR(511) -- Retorna un único valor  
AS  
BEGIN  
    DECLARE @NombreCompleto VARCHAR(511);

    SELECT @NombreCompleto = apellido + ', ' + nombre  
    FROM persona  
    WHERE id_persona = @id_persona;

    RETURN @NombreCompleto; -- Siempre debe retornar un valor  
END  
GO
```

Invocación (dentro de un SELECT):

```sql
SELECT   
    id_socio,  
    dbo.fn_GetNombreCompleto(id_socio) AS NombreSocio  
FROM   
    socio  
WHERE  
    id_socio = 26;
```

## **4. Apartado de Analogías: El Obrero vs. La Calculadora**

Para simplificar estos conceptos técnicos, podemos usar las siguientes analogías:

* **Procedimiento Almacenado = El "Obrero" 👷**  
  * **Propósito:** Lo llamás (EXEC) para que **haga un trabajo** o ejecute una acción.  
  * **Acción:** Su trabajo es modificar el estado de la base de datos (el CRUD: INSERT, UPDATE, DELETE).  
  * **Retorno:** No está obligado a devolverte un dato. Su éxito se mide por el *trabajo completado*.  
* **Función Definida por el Usuario = La "Calculadora" 📏**  
  * **Propósito:** La usás *dentro* de otra orden (como un SELECT) para **obtener un valor**.  
  * **Acción:** Su trabajo es calcular un resultado (fn_GetNombreCompleto, fn_CalcularFechaVencimiento).  
  * **Retorno:** Está **obligada** a devolverte un único resultado. No puede modificar datos.

## **5. Tabla Comparativa (SQL Server)**

| Característica | Procedimiento Almacenado (SP) | Función Definida por el Usuario (UDF) |
| :---- | :---- | :---- |
| **Término Microsoft** | Stored Procedure | User-Defined Function |
| **Propósito Principal** | **Ejecutar una acción** (un proceso) | **Calcular un valor** (un dato) |
| **Modificar Datos (DML)** | **Sí** (INSERT, UPDATE, DELETE) | **No** (Prohibido modificar el estado de la BD) |
| **Valor de Retorno** | Opcional (Puede ser 0, 1 o N SELECTs, o parámetros OUTPUT). | **Obligatorio** (Debe devolver 1 valor escalar o 1 tabla). |
| **Invocación (T-SQL)** | EXEC sp_Nombre(...) | SELECT ... dbo.fn_Nombre(...) |
| **Uso en SELECT** | **No** se puede usar en la lista de un SELECT o WHERE. | **Sí**, es su uso principal. |
| **Analogía** | Obrero 👷 | Calculadora 📏 |

