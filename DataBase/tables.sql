CREATE DATABASE transporte;
USE transporte;

-- Tabla de clientes
CREATE TABLE IF NOT EXISTS clientes (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  telefono VARCHAR(15) NOT NULL
);

-- Tabla de rutas
CREATE TABLE IF NOT EXISTS rutas (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  origen VARCHAR(100) NOT NULL,
  destino VARCHAR(100) NOT NULL,
  distancia FLOAT NOT NULL
);

-- Tabla de encomiendas
CREATE TABLE IF NOT EXISTS encomiendas (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(15) NOT NULL,
  fecha DATE NOT NULL,
  destino VARCHAR(100) NOT NULL,
  peso FLOAT NOT NULL,
  cliente_id INT NOT NULL,
  ruta_id INT NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES clientes(id),
  FOREIGN KEY (ruta_id) REFERENCES rutas(id)
);

-- Tabla de conductores
CREATE TABLE IF NOT EXISTS conductores (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  licencia VARCHAR(15) NOT NULL
);

-- Tabla de vehiculos
CREATE TABLE IF NOT EXISTS vehiculos (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tipo VARCHAR(50) NOT NULL,
  placa VARCHAR(10) NOT NULL,
  conductor_id INT NOT NULL,
  FOREIGN KEY (conductor_id) REFERENCES conductores(id)
);

-- Tabla de pais
CREATE TABLE IF NOT EXISTS pais (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY, 
  pais VARCHAR(50) NOT NULL,
  capital VARCHAR(30) NOT NULL,
  codigo_iso VARCHAR(10) NOT NULL COMMENT 'ejm: Perú: PER; Bolivia: BOL',
  moneda VARCHAR(30) COMMENT 'Peru: Soles; Mexico: Pesos mexicanos'
);

-- Tabla de provincia
CREATE TABLE IF NOT EXISTS provincia (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_pais INT,
  codigo_postal VARCHAR(20) NOT NULL,
  provincia VARCHAR(50) NOT NULL,
  distrito VARCHAR(50) NOT NULL, 
  FOREIGN KEY (id_pais) REFERENCES pais(id)
);

-- Tabla de documento de identidad
CREATE TABLE IF NOT EXISTS tipodocidentidad (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  detalle VARCHAR(100) NULL COMMENT 'detalle del documento de identidad',
  tipo_docidentidad VARCHAR(100) NOT NULL COMMENT 'dni, passport, cedula de identidad, ruc,'
);

-- Tabla de empresa
CREATE TABLE IF NOT EXISTS empresa (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_tipodocidentidad INT,
  razon_social VARCHAR(100) NOT NULL,
  direccion VARCHAR(30) NOT NULL,
  telefono VARCHAR(15),
  email VARCHAR(100),
  logo LONGBLOB NOT NULL COMMENT 'Logo en formato img'
);

-- Tabla de cliente
CREATE TABLE IF NOT EXISTS cliente (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_tipodocidentidad INT,
  id_pais INT,
  id_provincia INT,
  telefono VARCHAR(15),
  email VARCHAR(150),
  docidentidad VARCHAR(50) COMMENT 'dni: 2020344576, ruc: 10..., 20..., ',
  nombre VARCHAR(200),
  apellido VARCHAR(50),
  direccion VARCHAR(30) NOT NULL,
  tipo_cliente VARCHAR (100) NULL COMMENT 'persona natural, corporativo, asegurado, etc', 
  FOREIGN KEY (id_tipodocidentidad) REFERENCES tipodocidentidad(id),
  FOREIGN KEY (id_pais) REFERENCES pais(id),
  FOREIGN KEY (id_provincia) REFERENCES provincia(id)
);

-- Tabla de producto
CREATE TABLE IF NOT EXISTS producto (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  nombre VARCHAR(30) NOT NULL,
  descripcion TEXT NOT NULL,
  precio INT NOT NULL
);

-- Tabla de personal
CREATE TABLE IF NOT EXISTS personal (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_provincia INT,
  id_tipodocidentidad INT,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  fecha_nac DATE,
  t_fijo VARCHAR(12) NOT NULL,
  t_movil VARCHAR(12) NOT NULL,
  t_familiar VARCHAR(12) NOT NULL,
  t_descr_tfamiliar VARCHAR(12) NOT NULL,
  email VARCHAR(50) NOT NULL UNIQUE,
  area VARCHAR(30) NOT NULL,
  cargo VARCHAR(100) NOT NULL,
  FOREIGN KEY (id_provincia) REFERENCES provincia(id),
  FOREIGN KEY (id_tipodocidentidad) REFERENCES tipodocidentidad(id)
);

-- Tabla de pagos
CREATE TABLE IF NOT EXISTS pagos (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  fecha_pago DATE NOT NULL,
  monto_pago INT NOT NULL,
  metodo_pago VARCHAR(30) NOT NULL COMMENT 'Efectivo, tarjeta de credito, tarjeta de debito, transferencia bancaria, deposito bancario, cheque'
);

-- Tabla de comprobante pago
CREATE TABLE IF NOT EXISTS comprobante_pago (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_pago INT,
  id_producto INT,
  id_cliente INT,
  fecha_emision DATE,
  monto DECIMAL(10, 2),
  estaddo_pago VARCHAR(20),
  FOREIGN KEY (id_pago) REFERENCES pagos(id),
  FOREIGN KEY (id_producto) REFERENCES producto(id),
  FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);

-- Tabla factura
CREATE TABLE IF NOT EXISTS factura (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_factura VARCHAR(20),
  id_comprobante_pago INT,
  FOREIGN KEY (id_comprobante_pago) REFERENCES comprobante_pago(id)
);

-- Tabla boleta
CREATE TABLE IF NOT EXISTS boleta (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY, 
  id_comprobante INT,
  FOREIGN KEY (id_comprobante) REFERENCES comprobante_pago(id)
);

-- Tabla de rol
CREATE TABLE IF NOT EXISTS rol (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  rol VARCHAR(50) NOT NULL,
  descripcion VARCHAR(150) NOT NULL
);

-- Tabla de usuario de sistema
-- Tabla de usuario de sistema
CREATE TABLE IF NOT EXISTS usersistema (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_personal INT,
  id_rol INT,
  nombre VARCHAR(80),
  apellido VARCHAR(100),
  username VARCHAR(30) NOT NULL UNIQUE,
  correo VARCHAR(100),
  contrasenia VARBINARY(60) NOT NULL COMMENT 'seguridad con hash',
  fingerprint VARBINARY(60) NOT NULL COMMENT 'seguridad con huella dactilar',
  FOREIGN KEY (id_personal) REFERENCES personal(id),
  FOREIGN KEY (id_rol) REFERENCES rol(id)
);
