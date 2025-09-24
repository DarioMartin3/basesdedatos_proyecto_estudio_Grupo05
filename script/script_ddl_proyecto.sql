------------------------------
-- CREACION DE BASE DE DATOS
------------------------------
CREATE DATABASE gimnasio_db;
GO
------------------------------
-- USO DE LA BASE DE DATOS
------------------------------
USE gimnasio_db;
GO

------------------------------
-- TABLA ROL
------------------------------
CREATE TABLE rol (
  id_rol int PRIMARY KEY IDENTITY(1, 1),
  nombre varchar(255),

  --CLAVES PRIMARIAS
  CONSTRAINT PK_rol PRIMARY KEY (id_rol)
)

------------------------------
-- TABLA PERSONA
------------------------------
CREATE TABLE persona (
  id_persona int PRIMARY KEY IDENTITY(1, 1),
  nombre varchar(255),
  apellido varchar(255),
  dni int,
  telefono int,
  email varchar(200),
  fecha_alta date,
  estado BIT

  --CLAVES PRIMARIAS
  CONSTRAINT PK_persona PRIMARY KEY (id_persona),

  --RESTRICCIONES UNIQUE
  CONSTRAINT UQ_dni UNIQUE (dni),
  CONSTRAINT UQ_email UNIQUE (email),
  CONSTRAINT UQ_telefono UNIQUE (telefono),

  --RESTRICCIONES CHECK
  CONSTRAINT CK_dni CHECK (LEN(dni) = 8),
  CONSTRAINT CK_fecha_alta CHECK (fecha_alta <= GETDATE()),

  --RESTRICCIONES DEFAULT
  CONSTRAINT DF_fecha_alta DEFAULT GETDATE(),
  CONSTRAINT DF_estado DEFAULT 1
)

------------------------------
-- TABLA USUARIO
------------------------------
CREATE TABLE usuario (
  id_usuario int ,
  username varchar(50),
  password varchar(255),
  rol_id int,

  --CLAVES PRIMARIAS
  CONSTRAINT PK_usuario PRIMARY KEY (id_usuario),

  --CLAVES FORANEAS
  CONSTRAINT FK_persona FOREIGN KEY (id_usuario) REFERENCES persona(id_persona),
  CONSTRAINT FK_rol FOREIGN KEY (rol_id) REFERENCES rol(id_rol),

  --RESTRICCIONES UNIQUE
  CONSTRAINT UQ_username UNIQUE (username)
)

------------------------------
-- TABLA SOCIO
------------------------------
CREATE TABLE socio (
  id_socio int,
  contacto_emergencia int,
  observaciones varchar(650),

  --CLAVES PRIMARIAS
  CONSTRAINT PK_socio PRIMARY KEY (id_socio),

  --CLAVES FORANEAS
  CONSTRAINT FK_socio_persona FOREIGN KEY (id_socio) REFERENCES persona(id_persona)
)

------------------------------
-- TABLA MEMBRESIA_TIPO
------------------------------
CREATE TABLE membresia_tipo (
  id_tipo int,
  nombre varchar(255),
  duracion_dias int,
  precio decimal

  --CLAVES PRIMARIAS
  CONSTRAINT PK_membresia_tipo PRIMARY KEY (id_tipo),

  --RESTRICCIONES CHECK
  CONSTRAINT CK_duracion_dias CHECK (duracion_dias > 0),
  CONSTRAINT CK_precio CHECK (precio > 0)
)

------------------------------
-- tabla membresia
------------------------------

CREATE TABLE membresia (
  id_membresia int PRIMARY KEY IDENTITY(1, 1),
  usuario_id int,
  tipo_id int,
  socio_id int,
  fecha_inicio date,
  fecha_fin date,
  estado boolean

  --CLAVES FORANEAS
  CONSTRAINT FK_membresia_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id_usuario),
  CONSTRAINT FK_membresia_tipo FOREIGN KEY (tipo_id) REFERENCES membresia_tipo(id_tipo),
  CONSTRAINT FK_membresia_socio FOREIGN KEY (socio_id) REFERENCES socio(id_socio)
)

-------------------------------
-- TABLA PAGO
-------------------------------

CREATE TABLE pago (
  id_pago int PRIMARY KEY IDENTITY(1, 1),
  membresia_id int,
  fecha date,
  monto decimal,
  medio_pago nvarchar(255),

  --CLAVES FORANEAS
  CONSTRAINT FK_pago_membresia FOREIGN KEY (membresia_id) REFERENCES membresia(id_membresia)
)

------------------------------
-- TABLA ACTIVIDAD
------------------------------

CREATE TABLE actividad (
  id_actividad int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255)
)

------------------------------
-- TABLA CLASE
------------------------------

CREATE TABLE clase (
  id_clase int PRIMARY KEY IDENTITY(1, 1),
  actividad_id int,
  usuario_id int,
  cupo int
  --CLAVES FORANEAS
  CONSTRAINT FK_clase_actividad FOREIGN KEY (actividad_id) REFERENCES actividad(id_actividad),
  CONSTRAINT FK_clase_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id_usuario),
  --RESTRICCIONES CHECK
  CONSTRAINT CK_cupo CHECK (cupo > 0)
)

------------------------------
-- RELACION ENTRE CLASE Y DIA
------------------------------
CREATE TABLE clase_dia (
  clase_id int,
  dias_id int,
  --CLAVES PRIMARIAS
  CONSTRAINT PK_clase_dia PRIMARY KEY (clase_id, dias_id),
)

------------------------------
-- TABLA PROVEEDOR
------------------------------
CREATE TABLE proveedor (
  id_proveedor int IDENTITY(1, 1),
  nombre varchar(150) NOT NULL,
  cuit int NOT NULL,
  email varchar(200) NOT NULL,
  telefono int NOT NULL,
  --CLAVES PRIMARIAS
  CONSTRAINT PK_proveedor PRIMARY KEY (id_proveedor),
  --RESTRICCIONES UNIQUE
  CONSTRAINT UQ_cuit UNIQUE (cuit),
  CONSTRAINT UQ_email UNIQUE (email),
  CONSTRAINT UQ_telefono UNIQUE (telefono)
)

------------------------------
-- TABLA ESTADO DE LA COMPRA
------------------------------
CREATE TABLE estado_compra (
  id_estado int IDENTITY(1, 1),
  nombre varchar(100) NOT NULL, -- PENDIENTE, APROBADA, RECIBIDA, CANCELADA
  --CLAVES PRIMARIAS
  CONSTRAINT PK_estado_compra PRIMARY KEY (id_estado)
) 
  
------------------------------
-- TABLA CABECERA DEL ORDEN DE COMPRA
------------------------------
CREATE TABLE orden_compra (
  id_orden int IDENTITY(1, 1),
  proveedor_id int,
  usuario_id int,
  estado_id int,
  fecha date DEFAULT GETDATE(),  
  --CLAVES PRIMARIAS
  CONSTRAINT PK_orden_compra PRIMARY KEY (id_orden),
  --CLAVES FORANEAS
  CONSTRAINT FK_orden_compra_proveedor FOREIGN KEY (proveedor_id) REFERENCES proveedor(id_proveedor),
  CONSTRAINT FK_orden_compra_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id_usuario),
  CONSTRAINT FK_orden_compra_estado FOREIGN KEY (estado_id) REFERENCES estado_compra(id_estado)  
)

------------------------------
-- TABLA DETALLE DEL ORDEN DE COMPRA
------------------------------
CREATE TABLE orden_compra_item (
  id_item int IDENTITY(1, 1),
  orden_id int,
  inventario_id int,
  cantidad int NOT NULL,
  precio_compra decimal(10,2) NOT NULL,
  --CLAVES PRIMARIAS
  CONSTRAINT PK_orden_compra_item PRIMARY KEY (id_item),
  --CLAVES FORANEAS
  CONSTRAINT FK_orden_compra_item_orden_compra FOREIGN KEY (orden_id) REFERENCES orden_compra(id_orden),
  CONSTRAINT FK_orden_compra_item_inventario FOREIGN KEY (inventario_id) REFERENCES inventario(id_inventario),
  --RESTRICCIONES CHECK
  CONSTRAINT CK_cantidad CHECK (cantidad > 0),
  CONSTRAINT CK_precio_compra CHECK (precio_compra > 0),
  CONSTRAINT UQ_inventario_orden UNIQUE (inventario_id, orden_id)
)

------------------------------
-- TABLA CATEGORIA DEL INVENTARIO
------------------------------
CREATE TABLE inventario_categoria (
  id_categoria int IDENTITY(1, 1),
  nombre varchar(200) NOT NULL,
  --CLAVES PRIMARIAS
  CONSTRAINT PK_inventario_categoria PRIMARY KEY (id_categoria)
)


CREATE TABLE [inventario] (
  [id_inventario] int PRIMARY KEY IDENTITY(1, 1),
  [categoria_id] int,
  [nombre] nvarchar(255),
  [cantidad] int,
  [fecha_ingreso] date,
  [estado] boolean
)


CREATE TABLE [dias] (
  [id_dias] int PRIMARY KEY IDENTITY(1, 1),
  [dias] tinyint,
  [hora_desde] time,
  [hora_hasta] time
)


CREATE TABLE [inventario_movimiento] (
  [id_movimiento] int PRIMARY KEY IDENTITY(1, 1),
  [inventario_id] int,
  [fecha] date,
  [tipo] nvarchar(255),
  [cantidad] int,
  [compra_id] int
)


CREATE TABLE [clase_inscripcion] (
  [id_inscripcion] int PRIMARY KEY IDENTITY(1, 1),
  [socio_id] int,
  [clase_id] int
)

