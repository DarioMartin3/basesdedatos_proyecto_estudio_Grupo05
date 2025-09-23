------------------------------
-- TABLA ROL
------------------------------
CREATE TABLE rol (
  id_rol int PRIMARY KEY IDENTITY(1, 1),
  nombre varchar(255),

  --CLAVES PRIMARIAS
  CONSTRAINT PK_rol PRIMARY KEY (id_rol)
)
GO

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
  CONSTRAINT UQ_email UNIQUE (email),

  --RESTRICCIONES CHECK
  CONSTRAINT CK_dni CHECK (LEN(dni) = 8),
  CONSTRAINT CK_fecha_alta CHECK (fecha_alta <= GETDATE()),

  --RESTRICCIONES DEFAULT
  CONSTRAINT DF_fecha_alta DEFAULT GETDATE(),
  CONSTRAINT DF_estado DEFAULT 1
)
GO

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
GO

------------------------------
-- TABLA SOCIO
------------------------------
CREATE TABLE socio (
  id_socio int,
  contacto_emergencia varchar(16),
  observaciones varchar(650),

  --CLAVES PRIMARIAS
  CONSTRAINT PK_socio PRIMARY KEY (id_socio),

  --CLAVES FORANEAS
  CONSTRAINT FK_socio_persona FOREIGN KEY (id_socio) REFERENCES persona(id_persona)
)
GO

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
GO

CREATE TABLE [membresia] (
  [id_membresia] int PRIMARY KEY IDENTITY(1, 1),
  [usuario_id] int,
  [tipo_id] int,
  [socio_id] int,
  [fecha_inicio] date,
  [fecha_fin] date,
  [estado] boolean
)
GO

CREATE TABLE [pago] (
  [id_pago] int PRIMARY KEY IDENTITY(1, 1),
  [membresia_id] int,
  [fecha] date,
  [monto] decimal,
  [medio_pago] nvarchar(255)
)
GO

CREATE TABLE [actividad] (
  [id_actividad] int PRIMARY KEY IDENTITY(1, 1),
  [nombre] nvarchar(255)
)
GO

CREATE TABLE [clase] (
  [id_clase] int PRIMARY KEY IDENTITY(1, 1),
  [actividad_id] int,
  [usuario_id] int,
  [cupo] int
)
GO

CREATE TABLE [clase_dia] (
  [clase_id] int,
  [dias_id] int
)
GO

CREATE TABLE [proveedor] (
  [id_proveedor] int PRIMARY KEY IDENTITY(1, 1),
  [nombre] nvarchar(255),
  [cuit] int,
  [email] nvarchar(255),
  [telefono] int
)
GO

CREATE TABLE [orden_compra] (
  [id_orden] int PRIMARY KEY IDENTITY(1, 1),
  [proveedor_id] int,
  [usuario_id] int,
  [fecha] date,
  [estado] nvarchar(255)
)
GO

CREATE TABLE [orden_compra_item] (
  [id_item] int PRIMARY KEY IDENTITY(1, 1),
  [orden_id] int,
  [item_tipo] int,
  [cantidad] int,
  [precio_compra] decimal(10,2)
)
GO

CREATE TABLE [inventario_categoria] (
  [id_categoria] int PRIMARY KEY IDENTITY(1, 1),
  [nombre] nvarchar(255)
)
GO

CREATE TABLE [inventario] (
  [id_inventario] int PRIMARY KEY IDENTITY(1, 1),
  [categoria_id] int,
  [nombre] nvarchar(255),
  [cantidad] int,
  [fecha_ingreso] date,
  [estado] boolean
)
GO

CREATE TABLE [dias] (
  [id_dias] int PRIMARY KEY IDENTITY(1, 1),
  [dias] tinyint,
  [hora_desde] time,
  [hora_hasta] time
)
GO

CREATE TABLE [inventario_movimiento] (
  [id_movimiento] int PRIMARY KEY IDENTITY(1, 1),
  [inventario_id] int,
  [fecha] date,
  [tipo] nvarchar(255),
  [cantidad] int,
  [compra_id] int
)
GO

CREATE TABLE [clase_inscripcion] (
  [id_inscripcion] int PRIMARY KEY IDENTITY(1, 1),
  [socio_id] int,
  [clase_id] int
)
GO

ALTER TABLE [usuario] ADD FOREIGN KEY ([id_usuario]) REFERENCES [persona] ([id_persona])
GO

ALTER TABLE [socio] ADD FOREIGN KEY ([id_socio]) REFERENCES [persona] ([id_persona])
GO

ALTER TABLE [usuario] ADD FOREIGN KEY ([rol_id]) REFERENCES [rol] ([id_rol])
GO

ALTER TABLE [membresia] ADD FOREIGN KEY ([socio_id]) REFERENCES [socio] ([id_socio])
GO

ALTER TABLE [membresia] ADD FOREIGN KEY ([tipo_id]) REFERENCES [membresia_tipo] ([id_tipo])
GO

ALTER TABLE [pago] ADD FOREIGN KEY ([membresia_id]) REFERENCES [membresia] ([id_membresia])
GO

ALTER TABLE [clase] ADD FOREIGN KEY ([actividad_id]) REFERENCES [actividad] ([id_actividad])
GO

ALTER TABLE [orden_compra] ADD FOREIGN KEY ([proveedor_id]) REFERENCES [proveedor] ([id_proveedor])
GO

ALTER TABLE [orden_compra_item] ADD FOREIGN KEY ([orden_id]) REFERENCES [orden_compra] ([id_orden])
GO

ALTER TABLE [inventario] ADD FOREIGN KEY ([categoria_id]) REFERENCES [inventario_categoria] ([id_categoria])
GO

ALTER TABLE [orden_compra_item] ADD FOREIGN KEY ([item_tipo]) REFERENCES [inventario] ([id_inventario])
GO

ALTER TABLE [membresia] ADD FOREIGN KEY ([usuario_id]) REFERENCES [usuario] ([id_usuario])
GO

ALTER TABLE [orden_compra] ADD FOREIGN KEY ([usuario_id]) REFERENCES [usuario] ([id_usuario])
GO

ALTER TABLE [clase] ADD FOREIGN KEY ([usuario_id]) REFERENCES [usuario] ([id_usuario])
GO

ALTER TABLE [clase_inscripcion] ADD FOREIGN KEY ([socio_id]) REFERENCES [socio] ([id_socio])
GO

ALTER TABLE [clase_inscripcion] ADD FOREIGN KEY ([clase_id]) REFERENCES [clase] ([id_clase])
GO

ALTER TABLE [inventario_movimiento] ADD FOREIGN KEY ([inventario_id]) REFERENCES [inventario] ([id_inventario])
GO

ALTER TABLE [inventario_movimiento] ADD FOREIGN KEY ([compra_id]) REFERENCES [orden_compra] ([id_orden])
GO

ALTER TABLE [dias] ADD FOREIGN KEY ([id_dias]) REFERENCES [clase_dia] ([dias_id])
GO

ALTER TABLE [clase] ADD FOREIGN KEY ([id_clase]) REFERENCES [clase_dia] ([clase_id])
GO
