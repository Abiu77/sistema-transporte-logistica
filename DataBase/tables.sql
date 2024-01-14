CREATE DATABASE transporte;
USE transporte;

CREATE TABLE IF NOT EXISTS clientes (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  telefono VARCHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS rutas (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  origen VARCHAR(100) NOT NULL,
  destino VARCHAR(100) NOT NULL,
  distancia FLOAT NOT NULL
);

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

CREATE TABLE IF NOT EXISTS conductores (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  licencia VARCHAR(15) NOT NULL
);

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
  cmp_pais VARCHAR(50) NOT NULL,
  cmp_capital VARCHAR(30) NOT NULL,
  cmp_codigo_iso VARCHAR(10) NOT NULL COMMENT 'ejm: Perú: PER; Bolivia: BOL',
  cmp_moneda VARCHAR(30) COMMENT 'Peru: Soles; Mexico: Pesos mexicanos'
);

-- Tabla de provincia
CREATE TABLE IF NOT EXISTS provincia (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_pais INT,
  cmp_codigo_postal VARCHAR(20) NOT NULL,
  cmp_provincia VARCHAR(50) NOT NULL,
  cmp_distrito VARCHAR(50) NOT NULL, 
  FOREIGN KEY (id_pais) REFERENCES erpo_pais(id)
);

-- Tabla de documento de identidad
CREATE TABLE IF NOT EXISTS tipodocidentidad (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  cmp_detalle VARCHAR(100) NULL COMMENT 'detalle del documento de identidad',
  cmp_tipo_docidentidad VARCHAR(100) NOT NULL COMMENT 'dni, passport, cedula de identidad, ruc,'
);

-- Tabla de empresa
CREATE TABLE IF NOT EXISTS empresa (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_tipodocidentidad INT,
  cmp_razon_social VARCHAR(100) NOT NULL,
  cmp_direccion VARCHAR(30) NOT NULL,
  cmp_telefono VARCHAR(15),
  cmp_email VARCHAR(100),
  cmp_logo LONGBLOB NOT NULL COMMENT 'Logo en formato img'
);

-- Tabla de cliente
CREATE TABLE IF NOT EXISTS cliente (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_tipodocidentidad INT,
  id_pais INT,
  id_provincia INT,
  cmp_telefono VARCHAR(15),
  cmp_email VARCHAR(150),
  cmp_docidentidad VARCHAR(50) COMMENT 'dni: 2020344576, ruc: 10..., 20..., ',
  cmp_nombre VARCHAR(200),
  cmp_apellido VARCHAR(50),
  cmp_direccion VARCHAR(30) NOT NULL,
  cmp_tipo_cliente VARCHAR (100) NULL COMMENT 'persona natural, corporativo, asegurado, etc', 
  FOREIGN KEY (id_tipodocidentidad) REFERENCES erpo_tipodocidentidad(id),
  FOREIGN KEY (id_pais) REFERENCES erpo_pais(id),
  FOREIGN KEY (id_provincia) REFERENCES erpo_provincia(id)
);

-- Tabla de producto
CREATE TABLE IF NOT EXISTS producto (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_umedida INT,
  id_proveedor INT,
  cmp_nombre VARCHAR(30) NOT NULL,
  cmp_descripcion TEXT NOT NULL,
  cmp_precio INT NOT NULL,
  FOREIGN KEY (id_umedida) REFERENCES erpo_umedida(id),
  FOREIGN KEY (id_proveedor) REFERENCES erpo_proveedor(id)
);

-- Tabla de personal
CREATE TABLE IF NOT EXISTS personal (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_provincia INT,
  id_tipodocidentidad INT,
  cmp_nombre VARCHAR(50) NOT NULL,
  cmp_apellido VARCHAR(100) NOT NULL,
  cmp_fecha_nac DATE,
  cmp_t_fijo VARCHAR(12) NOT NULL,
  cmp_t_movil VARCHAR(12) NOT NULL,
  cmp_t_familiar VARCHAR(12) NOT NULL,
  cmp_t_descr_tfamiliar VARCHAR(12) NOT NULL,
  cmp_email VARCHAR(50) NOT NULL UNIQUE,
  cmp_area VARCHAR(30) NOT NULL,
  cmp_cargo VARCHAR(100) NOT NULL,
  FOREIGN KEY (id_provincia) REFERENCES erpo_provincia(id),
  FOREIGN KEY (id_tipodocidentidad) REFERENCES erpo_tipodocidentidad(id)
);

-- Tabla de pagos
CREATE TABLE IF NOT EXISTS pagos (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_usomaterial INT,
  cmp_fecha_pago DATE NOT NULL,
  cmp_monto_pago INT NOT NULL,
  cmp_metodo_pago VARCHAR(30) NOT NULL COMMENT 'Efectivo, tarjeta de credito, tarjeta de debito, transferencia bancaria, deposito bancario, cheque',
  FOREIGN KEY (id_usomaterial) REFERENCES erpo_usomaterial(id)
);

-- Tabla de comprobante pago
CREATE TABLE IF NOT EXISTS comprobante_pago (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_pago INT,
  id_cita INT,
  id_producto INT,
  id_proveedor INT,
  id_cliente INT,
  cmp_fecha_emision DATE,
  cmp_monto DECIMAL(10, 2),
  cmp_estaddo_pago VARCHAR(20),
  FOREIGN KEY (id_pago) REFERENCES erpo_pagos(id),
  FOREIGN KEY (id_cita) REFERENCES erpo_cita(id),
  FOREIGN KEY (id_producto) REFERENCES erpo_producto(id),
  FOREIGN KEY (id_proveedor) REFERENCES erpo_proveedor(id),
  FOREIGN KEY (id_cliente) REFERENCES erpo_cliente(id)
);

-- Tabla factura
CREATE TABLE IF NOT EXISTS factura (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_factura VARCHAR(20),
  id_comprobante_pago INT,
  FOREIGN KEY (id_comprobante_pago) REFERENCES erpo_comprobante_pago(id)
);

-- Tabla boleta
CREATE TABLE IF NOT EXISTS boleta (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY, 
  id_comprobante INT,
  FOREIGN KEY (id_comprobante) REFERENCES erpo_comprobante_pago(id)
);

-- Tabla de rol
CREATE TABLE IF NOT EXISTS rol (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  cmp_rol VARCHAR(50) NOT NULL,
  cmp_descripcion VARCHAR(150) NOT NULL
);

-- Tabla de usuario de sistema
CREATE TABLE IF NOT EXISTS usersistema (
  id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
  id_personal INT,
  id_rol INT,
  cmp_username VARCHAR(30) NOT NULL UNIQUE,
  cmp_pass VARBINARY(60) NOT NULL COMMENT 'seguridad con hash',
  cmp_fingerprint VARBINARY(60) NOT NULL COMMENT 'seguridad con huella dactilar',
  FOREIGN KEY (id_personal) REFERENCES erpo_personal(id),
  FOREIGN KEY (id_rol) REFERENCES erpo_rol(id)
);
