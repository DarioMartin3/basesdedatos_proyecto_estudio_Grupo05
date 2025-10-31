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
  id_rol int,
  nombre varchar(255),

  --CLAVES PRIMARIAS
  CONSTRAINT PK_rol PRIMARY KEY (id_rol)
)

------------------------------
-- TABLA PERSONA
------------------------------
CREATE TABLE persona (
  id_persona int IDENTITY(1, 1),
  nombre varchar(255),
  apellido varchar(255),
  dni bigint,
  telefono bigint,
  email varchar(200),
  fecha_alta date CONSTRAINT DF_persona_fecha_alta DEFAULT GETDATE(),
  estado BIT CONSTRAINT DF_persona_estado DEFAULT (1),

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_persona PRIMARY KEY (id_persona),

  --RESTRICCIONES UNIQUE
  CONSTRAINT UQ_persona_dni UNIQUE (dni),
  CONSTRAINT UQ_persona_email UNIQUE (email),
  CONSTRAINT UQ_persona_telefono UNIQUE (telefono),

  --RESTRICCIONES CHECK
  CONSTRAINT CK_persona_dni CHECK (dni BETWEEN 10000000 AND 99999999),
  CONSTRAINT CK_persona_fecha_alta CHECK (fecha_alta <= GETDATE()),

)

------------------------------
-- TABLA USUARIO
------------------------------
CREATE TABLE usuario (
  id_usuario int,
  username varchar(50),
  contraseña varchar(255),
  rol_id int,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_usuario PRIMARY KEY (id_usuario),

  --CLAVES FORANEAS
  CONSTRAINT FK_usuario_persona FOREIGN KEY (id_usuario) REFERENCES persona(id_persona),
  CONSTRAINT FK_usuario_rol FOREIGN KEY (rol_id) REFERENCES rol(id_rol),

  --RESTRICCIONES UNIQUE
  CONSTRAINT UQ_usuario_username UNIQUE (username)
)

------------------------------
-- TABLA SOCIO
------------------------------
CREATE TABLE socio (
  id_socio int,
  contacto_emergencia bigint,
  observaciones varchar(650),

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_socio PRIMARY KEY (id_socio),

  --CLAVES FORANEAS
  CONSTRAINT FK_socio_persona FOREIGN KEY (id_socio) REFERENCES persona(id_persona)
)

------------------------------
-- TABLA ACTIVIDAD
------------------------------

CREATE TABLE actividad (
  id_actividad int IDENTITY(1, 1),
  nombre nvarchar(255),

  --CLAVES PRIMARIAS
  CONSTRAINT PK_actividad PRIMARY KEY (id_actividad)
)

------------------------------
-- TABLA CLASE
------------------------------

CREATE TABLE clase (
  id_clase int IDENTITY(1, 1),
  actividad_id int,
  usuario_id int,
  precio decimal(10,2),
  hora_desde date,
  hora_hasta date,
  cupo int,

  --CLAVES PRIMARIAS
  CONSTRAINT PK_clase PRIMARY KEY (id_clase),

  --CLAVES FORANEAS
  CONSTRAINT FK_clase_actividad FOREIGN KEY (actividad_id) REFERENCES actividad(id_actividad),
  CONSTRAINT FK_clase_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id_usuario),

  --RESTRICCIONES CHECK
  CONSTRAINT CK_clase_cupo CHECK (cupo > 0)
)

------------------------------
-- TABLA MEMBRESIA_TIPO
------------------------------
CREATE TABLE membresia_tipo (
  id_tipo int IDENTITY(1, 1),
  nombre varchar(255),
  duracion_dias int,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_membresia_tipo PRIMARY KEY (id_tipo),

  --RESTRICCIONES CHECK
  CONSTRAINT CK_membresia_tipo_duracion_dias CHECK (duracion_dias > 0),

)

------------------------------
-- TABLA MEMBRESIA
------------------------------

CREATE TABLE membresia (
  id_membresia int IDENTITY(1, 1),
  usuario_id int,
  tipo_id int,
  socio_id int,
  fecha_inicio date CONSTRAINT DF_membresia_fecha_inicio DEFAULT GETDATE(),
  estado BIT,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_membresia PRIMARY KEY (id_membresia),

  --CLAVES FORANEAS
  CONSTRAINT FK_membresia_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id_usuario),
  CONSTRAINT FK_membresia_tipo FOREIGN KEY (tipo_id) REFERENCES membresia_tipo(id_tipo),
  CONSTRAINT FK_membresia_socio FOREIGN KEY (socio_id) REFERENCES socio(id_socio)
)

-------------------------------
-- TABLA MEMBRESIA_CLASE
-------------------------------
CREATE TABLE membresia_clase (
  membresia_id int,
  clase_id int,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_membresia_clase PRIMARY KEY (membresia_id, clase_id),

  --CLAVES FORANEAS
  CONSTRAINT FK_membresia_clase_membresia FOREIGN KEY (membresia_id) REFERENCES membresia(id_membresia),
  CONSTRAINT FK_membresia_clase_clase FOREIGN KEY (clase_id) REFERENCES clase(id_clase)
)

-------------------------------
-- TABLA TIPO_PAGO
-------------------------------
CREATE TABLE tipo_pago (
  id_tipo_pago int,
  nombre nvarchar(255),

  --CLAVES PRIMARIAS
  CONSTRAINT PK_tipo_pago PRIMARY KEY (id_tipo_pago)
)


-------------------------------
-- TABLA PAGO
-------------------------------

CREATE TABLE pago (
  id_pago int IDENTITY(1, 1),
  socio_id int,
  tipo_pago_id int,
  fecha date CONSTRAINT DF_pago_fecha DEFAULT GETDATE(),
  total decimal,
  estado BIT DEFAULT 1,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_pago PRIMARY KEY (id_pago),

  --CLAVES FORANEAS
  CONSTRAINT FK_pago_socio FOREIGN KEY (socio_id) REFERENCES socio(id_socio),
  CONSTRAINT FK_pago_tipo_pago FOREIGN KEY (tipo_pago_id) REFERENCES tipo_pago(id_tipo_pago)
)

-------------------------------
-- TABLA PAGO_DETALLE
-------------------------------
CREATE TABLE pago_detalle (
  id_detalle int IDENTITY(1, 1),
  pago_id int,
  membresia_id int,
  clase_id int,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_pago_detalle PRIMARY KEY (id_detalle),

  --CLAVES FORANEAS
  CONSTRAINT FK_pago_detalle_pago FOREIGN KEY (pago_id) REFERENCES pago(id_pago),
  CONSTRAINT FK_pago_detalle_membresia FOREIGN KEY (membresia_id) REFERENCES membresia(id_membresia),
  CONSTRAINT FK_pago_detalle_clase FOREIGN KEY (clase_id) REFERENCES clase(id_clase)
)

------------------------------
-- TABLA DIA
------------------------------
CREATE TABLE dia (
  id_dia int,
  nombre varchar(50),

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_dia PRIMARY KEY (id_dia)
)

------------------------------
-- RELACION ENTRE CLASE Y DIA
------------------------------
CREATE TABLE clase_dia (
  clase_id int,
  dia_id int,
  
  --CLAVES PRIMARIAS
  CONSTRAINT PK_clase_dia PRIMARY KEY (clase_id, dia_id),

  --CLAVES FORANEAS
  CONSTRAINT FK_clase_dia_clase FOREIGN KEY (clase_id) REFERENCES clase(id_clase),
  CONSTRAINT FK_clase_dia_dia FOREIGN KEY (dia_id) REFERENCES dia(id_dia)
)



