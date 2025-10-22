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
  dni int,
  telefono int,
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
  id_socio int IDENTITY(1, 1),
  contacto_emergencia int,
  observaciones varchar(650),

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_socio PRIMARY KEY (id_socio),

  --CLAVES FORANEAS
  CONSTRAINT FK_socio_persona FOREIGN KEY (id_socio) REFERENCES persona(id_persona)
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
  fecha_inicio date,
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
  fecha date,
  total decimal,
  estado BIT DEFAULT 1,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_pago PRIMARY KEY (id_pago),

  --CLAVES FORANEAS
  CONSTRAINT FK_pago_membresia FOREIGN KEY (membresia_id) REFERENCES membresia(id_membresia),
  CONSTRAINT FK_pago_socio FOREIGN KEY (socio_id) REFERENCES socio(id_socio),
  CONSTRAINT FK_pago_tipo_pago FOREIGN KEY (tipo_pago_id) REFERENCES tipo_pago(id_tipo_pago)
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
  clase_id int IDENTITY(1, 1),
  dia_id int,
  
  --CLAVES PRIMARIAS
  CONSTRAINT PK_clase_dia PRIMARY KEY (clase_id, dia_id),

  --CLAVES FORANEAS
  CONSTRAINT FK_clase_dia_clase FOREIGN KEY (clase_id) REFERENCES clase(id_clase),
  CONSTRAINT FK_clase_dia_dia FOREIGN KEY (dia_id) REFERENCES dia(id_dia)
)

------------------------------
-- TABLA PROVEEDOR
------------------------------
CREATE TABLE proveedor (
  id_proveedor int IDENTITY(1, 1),
  nombre varchar(150) NOT NULL,
  cuit bigint NOT NULL,
  email varchar(200) NOT NULL,
  telefono int NOT NULL,
  estado BIT DEFAULT 1,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_proveedor PRIMARY KEY (id_proveedor),

  --RESTRICCIONES UNIQUE
  CONSTRAINT UQ_proveedor_cuit UNIQUE (cuit),
  CONSTRAINT UQ_proveedor_email UNIQUE (email),
  CONSTRAINT UQ_proveedor_telefono UNIQUE (telefono)
)

------------------------------
-- TABLA ESTADO DE LA COMPRA
------------------------------
CREATE TABLE estado_compra (
  id_estado int IDENTITY(1, 1),
  nombre varchar(100) NOT NULL -- PENDIENTE, APROBADA, RECIBIDA, CANCELADA

  -- CLAVES PRIMARIAS
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

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_orden_compra PRIMARY KEY (id_orden),

  --CLAVES FORANEAS
  CONSTRAINT FK_orden_compra_proveedor FOREIGN KEY (proveedor_id) REFERENCES proveedor(id_proveedor),
  CONSTRAINT FK_orden_compra_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id_usuario),
  CONSTRAINT FK_orden_compra_estado FOREIGN KEY (estado_id) REFERENCES estado_compra(id_estado)  
)

------------------------------
-- TABLA CATEGORIA DEL INVENTARIO
------------------------------
CREATE TABLE inventario_categoria (
  id_categoria int IDENTITY(1, 1),
  nombre varchar(200) NOT NULL,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_inventario_categoria PRIMARY KEY (id_categoria)
)

------------------------------
-- TABLA INVENTARIO
------------------------------
CREATE TABLE inventario (
  id_inventario int IDENTITY(1, 1),
  categoria_id int,
  nombre nvarchar(255),
  cantidad int,
  fecha_ingreso date,
  estado BIT,
  proveedor_id int,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_inventario PRIMARY KEY (id_inventario),

  -- CLAVES FORANEAS
  CONSTRAINT FK_inventario_inventario_categoria FOREIGN KEY (categoria_id) REFERENCES inventario_categoria(id_categoria),
  CONSTRAINT FK_inventario_proveedor FOREIGN KEY (proveedor_id) REFERENCES proveedor(id_proveedor),

  --RESTRICCIONES CHECK
  CONSTRAINT CK_cantidad CHECK (cantidad >= 0),
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

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_orden_compra_item PRIMARY KEY (id_item),
  --CLAVES FORANEAS
  CONSTRAINT FK_orden_compra_item_orden_compra FOREIGN KEY (orden_id) REFERENCES orden_compra(id_orden),
  CONSTRAINT FK_orden_compra_item_inventario FOREIGN KEY (inventario_id) REFERENCES inventario(id_inventario),
  --RESTRICCIONES CHECK
  CONSTRAINT CK_orden_compra_item_cantidad CHECK (cantidad > 0),
  CONSTRAINT CK_orden_compra_item_precio_compra CHECK (precio_compra > 0),
  CONSTRAINT UQ_orden_compra_item_inventario_orden UNIQUE (inventario_id, orden_id)
)

------------------------------
-- TABLA MOVIMIENTO DE INVENTARIO
------------------------------
CREATE TABLE inventario_movimiento (
  id_movimiento int IDENTITY(1, 1),
  inventario_id int,
  fecha date DEFAULT GETDATE(),
  tipo nvarchar(255),
  cantidad int,
  compra_id int,

  -- CLAVES PRIMARIAS 
  CONSTRAINT PK_inventario_movimiento PRIMARY KEY (id_movimiento),

  -- CLAVES FORANEAS
  CONSTRAINT FK_inventario_movimiento_inventario FOREIGN KEY (inventario_id) REFERENCES inventario(id_inventario),
  CONSTRAINT FK_inventario_movimiento_compra FOREIGN KEY (compra_id) REFERENCES orden_compra(id_orden)

  --RESTRICCIONES CHECK
  CONSTRAINT CK_inventario_movimiento_cantidad CHECK (cantidad > 0)
)

------------------------------
-- TABLA INSCRIPCION A CLASE
------------------------------
CREATE TABLE clase_inscripcion (
  id_inscripcion int IDENTITY(1, 1),
  socio_id int,
  clase_id int,

  -- CLAVES PRIMARIAS
  CONSTRAINT PK_clase_inscripcion PRIMARY KEY (id_inscripcion),

  -- CLAVES FORANEAS
  CONSTRAINT FK_clase_inscripcion_socio FOREIGN KEY (socio_id) REFERENCES socio(id_socio),
  CONSTRAINT FK_clase_inscripcion_clase FOREIGN KEY (clase_id) REFERENCES clase(id_clase)
)

------------------------------
-- INSERTS PARA TABLA ROL
------------------------------
INSERT INTO rol (nombre) VALUES 
('ADMINISTRADOR'),
('COACH'),
('RECEPCIONISTA');

------------------------------
-- INSERTS PARA TABLA PERSONA
------------------------------
INSERT INTO persona (nombre, apellido, dni, telefono, email) VALUES 
('Juan', 'Pérez', 30123456, 1156789012, 'juan.perez@gmail.com'),
('María', 'Gómez', 32123456, 1156789013, 'maria.gomez@gmail.com'),
('Carlos', 'López', 34123456, 1156789014, 'carlos.lopez@gmail.com'),
('Ana', 'Martínez', 36123456, 1156789015, 'ana.martinez@gmail.com'),
('Pedro', 'Rodríguez', 38123456, 1156789016, 'pedro.rodriguez@gmail.com'),
('Laura', 'García', 40123456, 1156789017, 'laura.garcia@gmail.com'),
('Diego', 'Fernández', 42123456, 1156789018, 'diego.fernandez@gmail.com'),
('Sofía', 'Díaz', 44123456, 1156789019, 'sofia.diaz@gmail.com');

------------------------------
-- INSERTS PARA TABLA USUARIO
------------------------------
INSERT INTO usuario (id_usuario, username, password, rol_id) VALUES 
(1, 'juan.admin', 'admin123', 1),  -- ADMINISTRADOR
(2, 'maria.coach', 'coach123', 2),  -- COACH
(3, 'carlos.recep', 'recep123', 3), -- RECEPCIONISTA
(4, 'ana.coach', 'coach456', 2);    -- COACH

------------------------------
-- INSERTS PARA TABLA SOCIO
------------------------------
INSERT INTO socio (id_socio, contacto_emergencia, observaciones) VALUES 
(5, 1156789020, 'Sin observaciones'),
(6, 1156789021, 'Alérgico a frutos secos'),
(7, 1156789022, 'Lesión leve en rodilla izquierda'),
(8, 1156789023, 'Sin observaciones');

------------------------------
-- INSERTS PARA TABLA MEMBRESIA_TIPO
------------------------------
INSERT INTO membresia_tipo (nombre, duracion_dias, precio) VALUES 
('Mensual', 30, 15000.00),
('Semanal', 7, 9000.00),
('Diaria', 1, 1000.00);


------------------------------
-- INSERTS PARA TABLA MEMBRESIA
------------------------------
INSERT INTO membresia (usuario_id, tipo_id, socio_id, fecha_inicio, fecha_fin, estado) VALUES 
(3, 1, 1, '2024-01-01', '2024-01-31', 1),
(3, 2, 2, '2024-01-01', '2024-01-31', 1),
(3, 3, 3, '2024-01-01', '2024-03-31', 1),


------------------------------
-- INSERTS PARA TABLA PAGO
------------------------------
INSERT INTO pago (membresia_id, fecha, monto, medio_pago) VALUES 
(1, '2024-01-01', 15000.00, 'EFECTIVO'),
(2, '2024-01-01', 25000.00, 'TARJETA CRÉDITO'),
(3, '2024-01-01', 40000.00, 'TRANSFERENCIA'),
(4, '2024-01-01', 120000.00, 'TARJETA DÉBITO');

------------------------------
-- INSERTS PARA TABLA ACTIVIDAD
------------------------------
INSERT INTO actividad (nombre) VALUES 
('CrossFit'),
('Yoga'),
('Spinning'),
('Boxeo'),
('Musculación');

------------------------------
-- INSERTS PARA TABLA CLASE
------------------------------
INSERT INTO clase (actividad_id, usuario_id, cupo) VALUES 
(1, 2, 20),  -- CrossFit con María
(2, 4, 15),  -- Yoga con Ana
(3, 2, 25),  -- Spinning con María
(4, 4, 10);  -- Boxeo con Ana

------------------------------
-- INSERTS PARA TABLA DIAS
------------------------------
INSERT INTO dias (dias, hora_desde, hora_hasta) VALUES 
(1, '08:00', '09:00'),  -- Lunes
(2, '10:00', '11:00'),  -- Martes
(3, '18:00', '19:00'),  -- Miércoles
(4, '19:00', '20:00');  -- Jueves

------------------------------
-- INSERTS PARA TABLA CLASE_DIA
------------------------------
INSERT INTO clase_dia (clase_id, dias_id) VALUES 
(1, 1),  -- CrossFit los Lunes
(1, 3),  -- CrossFit los Miércoles
(2, 2),  -- Yoga los Martes
(3, 4),  -- Spinning los Jueves
(4, 1);  -- Boxeo los Lunes

------------------------------
-- INSERTS PARA TABLA PROVEEDOR
------------------------------
INSERT INTO proveedor (nombre, cuit, email, telefono) VALUES 
('Proveedor Deportes SA', 30123456789, 'ventas@deportessa.com', 1145678901),
('Equipamiento Gym SL', 30234567890, 'info@gymequipment.com', 1145678902);

------------------------------
-- INSERTS PARA TABLA ESTADO_COMPRA
------------------------------
INSERT INTO estado_compra (nombre) VALUES 
('PENDIENTE'),
('APROBADA'),
('RECIBIDA'),
('CANCELADA');

------------------------------
-- INSERTS PARA TABLA ORDEN_COMPRA
------------------------------
INSERT INTO orden_compra (proveedor_id, usuario_id, estado_id, fecha) VALUES 
(1, 1, 2, '2024-01-01'),
(2, 1, 1, '2024-01-02');

------------------------------
-- INSERTS PARA TABLA INVENTARIO_CATEGORIA
------------------------------
INSERT INTO inventario_categoria (nombre) VALUES 
('Equipamiento Cardio'),
('Pesas y Mancuernas'),
('Barras');

------------------------------
-- INSERTS PARA TABLA INVENTARIO
------------------------------
INSERT INTO inventario (categoria_id, nombre, cantidad, fecha_ingreso, estado) VALUES 
(1, 'Cinta de Correr', 5, '2024-01-01', 1),
(1, 'Bicicleta Spinning', 10, '2024-01-01', 1),
(2, 'Mancuernas 5kg', 20, '2024-01-01', 1),;

------------------------------
-- INSERTS PARA TABLA ORDEN_COMPRA_ITEM
------------------------------
INSERT INTO orden_compra_item (orden_id, inventario_id, cantidad, precio_compra) VALUES 
(1, 1, 2, 500000.00),
(1, 2, 5, 300000.00),
(2, 3, 10, 15000.00);

------------------------------
-- INSERTS PARA TABLA INVENTARIO_MOVIMIENTO
------------------------------
INSERT INTO inventario_movimiento (inventario_id, tipo, cantidad, compra_id) VALUES 
(1, 'ENTRADA', 2, 1),
(2, 'ENTRADA', 5, 1),
(3, 'ENTRADA', 10, 2);

------------------------------
-- INSERTS PARA TABLA CLASE_INSCRIPCION
------------------------------
INSERT INTO clase_inscripcion (socio_id, clase_id) VALUES 
(1, 1),  -- Socio 1 en CrossFit
(2, 2),  -- Socio 2 en Yoga
(3, 3),  -- Socio 3 en Spinning
(4, 4);  -- Socio 4 en Boxeo