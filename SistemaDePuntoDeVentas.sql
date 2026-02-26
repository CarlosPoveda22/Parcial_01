CREATE DATABASE punto_ventas;
USE punto_ventas;

-- Tabla de oficinas
CREATE TABLE oficinas (
    id_oficina VARCHAR(10) PRIMARY KEY,
    ciudad VARCHAR(50),
    telefono VARCHAR(50),
    direccion VARCHAR(50),
    departamento VARCHAR(50),
    pais VARCHAR(50),
    codigoPostal VARCHAR(15),
    continente VARCHAR(10),

    tipo_oficina ENUM('Principal','Sucursal','Regional') NOT NULL,
    activa BOOLEAN NOT NULL,
    codigo_unico VARCHAR(20) UNIQUE
);

-- Tabla de empleados
CREATE TABLE empleados (
    documento INT PRIMARY KEY,
    apellido VARCHAR(50),
    nombre VARCHAR(50),
    extension VARCHAR(10),
    email VARCHAR(100) UNIQUE,
    id_oficina VARCHAR(10),
    jefe INT,
    cargo VARCHAR(50),

    tipo_contrato ENUM('Fijo','Temporal','Servicios') NOT NULL,
    activo BOOLEAN NOT NULL,

    FOREIGN KEY (id_oficina) REFERENCES oficinas(id_oficina)
);

-- Tabla de clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    empresa VARCHAR(50),
    apellido VARCHAR(50),
    nombre VARCHAR(50),
    telefono VARCHAR(50),
    direccion VARCHAR(50),
    ciudad VARCHAR(50),
    departamento VARCHAR(50),
    codigoPostal VARCHAR(15),
    pais VARCHAR(50),
    empleadoAtiende INT,
    limiteCredito DOUBLE,

    tipo_cliente ENUM('Minorista','Mayorista','Corporativo') NOT NULL,
    activo BOOLEAN NOT NULL,
    email VARCHAR(100) UNIQUE,

    FOREIGN KEY (empleadoAtiende) REFERENCES empleados(documento)
);

-- Tabla de ordenes
CREATE TABLE ordenes (
    id_orden INT PRIMARY KEY,
    fechaRecibido DATE,
    fechaLimiteEntrega DATE,
    fechaEntrega DATE,
    estado VARCHAR(15),
    observacion TEXT,
    id_cliente INT,

    prioridad ENUM('Alta','Media','Baja') NOT NULL,
    facturada BOOLEAN NOT NULL,

    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

--Tabla de detallesordenes 
CREATE TABLE detallesordenes (
    id_orden INT,
    id_producto VARCHAR(15),
    cantidadPedida INT,
    valorUnitario DOUBLE,
    ordenEntrega INT,

    tipo_descuento ENUM('Ninguno','Promocion','ClienteFrecuente') NOT NULL,
    aplica_impuesto BOOLEAN NOT NULL,

    PRIMARY KEY (id_orden, id_producto),
    FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Tabla de lineasproductos
CREATE TABLE lineasproductos (
    id_lineaproducto INT PRIMARY KEY,
    nombreLinea VARCHAR(50),
    textoDescripcion VARCHAR(4000),
    htmlDescripcion VARCHAR(200),
    imagen VARCHAR(200),

    categoria ENUM('Electrico','Manual','Industrial') NOT NULL,
    disponible BOOLEAN NOT NULL,
    codigo_linea VARCHAR(20) UNIQUE
);

-- Tabla de productos
CREATE TABLE productos (
    id_producto VARCHAR(15) PRIMARY KEY,
    nombreProducto VARCHAR(70),
    id_lineaProducto INT,
    escala VARCHAR(10),
    cantidad INT,
    precioventa DOUBLE,
    MSRP DOUBLE,

    tipo_producto ENUM('Fisico','Digital','Servicio') NOT NULL,
    activo BOOLEAN NOT NULL,
    codigo_barra VARCHAR(50) UNIQUE,

    FOREIGN KEY (id_lineaProducto) REFERENCES lineasproductos(id_lineaproducto)
);

-- Tabla de pagos
CREATE TABLE pagos (
    id_pago INT PRIMARY KEY,
    id_cliente INT,
    numeroFactura VARCHAR(50) UNIQUE,
    fechaPago DATE,
    totalPago DOUBLE,

    metodo_pago ENUM('Efectivo','Tarjeta','Transferencia') NOT NULL,
    confirmado BOOLEAN NOT NULL,

    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Inserts para la base de datos

-- Insertar oficinas
INSERT INTO oficinas VALUES
('OF1','Panama','2222-1111','Via España','Panama','Panama','0801','America','Principal',1,'OF-001'),
('OF2','Colon','2222-2222','Zona Libre','Colon','Panama','0301','America','Sucursal',1,'OF-002'),
('OF3','David','2222-3333','Centro','Chiriqui','Panama','0401','America','Regional',1,'OF-003'),
('OF4','Santiago','2222-4444','Central','Veraguas','Panama','0501','America','Sucursal',1,'OF-004'),
('OF5','Chitre','2222-5555','Principal','Herrera','Panama','0601','America','Sucursal',1,'OF-005'),
('OF6','Penonome','2222-6666','Centro','Cocle','Panama','0701','America','Regional',1,'OF-006'),
('OF7','Bocas','2222-7777','Isla','Bocas','Panama','0901','America','Sucursal',1,'OF-007'),
('OF8','Las Tablas','2222-8888','Centro','Los Santos','Panama','1001','America','Sucursal',1,'OF-008'),
('OF9','Aguadulce','2222-9999','Principal','Cocle','Panama','1101','America','Regional',1,'OF-009'),
('OF10','Arraijan','2222-0000','Centro','Panama Oeste','Panama','1201','America','Sucursal',1,'OF-010');

-- Insertar empleados
INSERT INTO empleados VALUES
(1,'Perez','Juan','101','juan@empresa.com','OF1',NULL,'Gerente','Fijo',1),
(2,'Lopez','Ana','102','ana@empresa.com','OF2',1,'Supervisor','Fijo',1),
(3,'Gomez','Luis','103','luis@empresa.com','OF3',1,'Vendedor','Temporal',1),
(4,'Diaz','Maria','104','maria@empresa.com','OF4',2,'Vendedor','Servicios',1),
(5,'Torres','Carlos','105','carlos@empresa.com','OF5',2,'Vendedor','Fijo',1),
(6,'Ruiz','Laura','106','laura@empresa.com','OF6',1,'Supervisor','Fijo',1),
(7,'Mendez','Jose','107','jose@empresa.com','OF7',6,'Vendedor','Temporal',1),
(8,'Castro','Elena','108','elena@empresa.com','OF8',6,'Vendedor','Servicios',1),
(9,'Vega','Mario','109','mario@empresa.com','OF9',1,'Supervisor','Fijo',1),
(10,'Rojas','Sofia','110','sofia@empresa.com','OF10',9,'Vendedor','Temporal',1);

-- Insertar clientes
INSERT INTO clientes VALUES
(1,'TechCorp','Santos','Miguel','6000-0001','Dir1','Panama','Panama','0801','Panama',3,5000,'Corporativo',1,'c1@mail.com'),
(2,'Comercial SA','Diaz','Pedro','6000-0002','Dir2','Colon','Colon','0301','Panama',4,3000,'Mayorista',1,'c2@mail.com'),
(3,'Retail PTY','Lopez','Ana','6000-0003','Dir3','David','Chiriqui','0401','Panama',5,2000,'Minorista',1,'c3@mail.com'),
(4,'Distribuidora X','Perez','Luis','6000-0004','Dir4','Santiago','Veraguas','0501','Panama',7,4000,'Mayorista',1,'c4@mail.com'),
(5,'Global Inc','Martinez','Rosa','6000-0005','Dir5','Chitre','Herrera','0601','Panama',8,3500,'Corporativo',1,'c5@mail.com'),
(6,'Empresa 6','Ruiz','Mario','6000-0006','Dir6','Penonome','Cocle','0701','Panama',3,2500,'Minorista',1,'c6@mail.com'),
(7,'Empresa 7','Gomez','Laura','6000-0007','Dir7','Bocas','Bocas','0901','Panama',4,1500,'Mayorista',1,'c7@mail.com'),
(8,'Empresa 8','Torres','Jose','6000-0008','Dir8','Las Tablas','Los Santos','1001','Panama',5,2800,'Minorista',1,'c8@mail.com'),
(9,'Empresa 9','Castro','Elena','6000-0009','Dir9','Aguadulce','Cocle','1101','Panama',7,3200,'Corporativo',1,'c9@mail.com'),
(10,'Empresa 10','Rojas','Sofia','6000-0010','Dir10','Arraijan','Panama Oeste','1201','Panama',8,4100,'Mayorista',1,'c10@mail.com');

-- Insertar lineas de productos
INSERT INTO lineasproductos VALUES
(1,'Electronica','Desc1','html1','img1','Electrico',1,'L-001'),
(2,'Hogar','Desc2','html2','img2','Manual',1,'L-002'),
(3,'Industrial','Desc3','html3','img3','Industrial',1,'L-003'),
(4,'Oficina','Desc4','html4','img4','Manual',1,'L-004'),
(5,'Tecnologia','Desc5','html5','img5','Electrico',1,'L-005'),
(6,'Automotriz','Desc6','html6','img6','Industrial',1,'L-006'),
(7,'Salud','Desc7','html7','img7','Manual',1,'L-007'),
(8,'Construccion','Desc8','html8','img8','Industrial',1,'L-008'),
(9,'Deportes','Desc9','html9','img9','Manual',1,'L-009'),
(10,'Servicios','Desc10','html10','img10','Electrico',1,'L-010');

-- Insertar productos
INSERT INTO productos VALUES
('P1','Laptop',1,'Alta',50,800,900,'Fisico',1,'CB001'),
('P2','Mouse',1,'Media',100,20,25,'Fisico',1,'CB002'),
('P3','Impresora',4,'Alta',30,150,180,'Fisico',1,'CB003'),
('P4','Taladro',8,'Media',40,120,150,'Fisico',1,'CB004'),
('P5','Servicio IT',10,'N/A',0,500,600,'Servicio',1,'CB005'),
('P6','Monitor',5,'Alta',60,200,250,'Fisico',1,'CB006'),
('P7','Teclado',1,'Media',80,30,40,'Fisico',1,'CB007'),
('P8','Silla Oficina',4,'Alta',20,90,110,'Fisico',1,'CB008'),
('P9','Aceite Motor',6,'Media',200,15,20,'Fisico',1,'CB009'),
('P10','Consultoria',10,'N/A',0,1000,1200,'Servicio',1,'CB010');

-- Insertar ordenes
INSERT INTO ordenes VALUES
(1,'2026-01-01','2026-01-10','2026-01-08','Entregado','OK',1,'Alta',1),
(2,'2026-01-02','2026-01-11','2026-01-09','Entregado','OK',2,'Media',1),
(3,'2026-01-03','2026-01-12',NULL,'Pendiente','',3,'Baja',0),
(4,'2026-01-04','2026-01-13',NULL,'Pendiente','',4,'Alta',0),
(5,'2026-01-05','2026-01-14','2026-01-12','Entregado','OK',5,'Media',1),
(6,'2026-01-06','2026-01-15',NULL,'Pendiente','',6,'Alta',0),
(7,'2026-01-07','2026-01-16','2026-01-14','Entregado','OK',7,'Media',1),
(8,'2026-01-08','2026-01-17',NULL,'Pendiente','',8,'Baja',0),
(9,'2026-01-09','2026-01-18','2026-01-16','Entregado','OK',9,'Alta',1),
(10,'2026-01-10','2026-01-19',NULL,'Pendiente','',10,'Media',0);

-- Insertar detalles de ordenes
INSERT INTO detallesordenes VALUES
(1,'P1',2,800,1,'Ninguno',1),
(2,'P2',5,20,1,'Promocion',1),
(3,'P3',1,150,1,'Ninguno',1),
(4,'P4',3,120,1,'ClienteFrecuente',1),
(5,'P5',1,500,1,'Ninguno',0),
(6,'P6',2,200,1,'Promocion',1),
(7,'P7',4,30,1,'Ninguno',1),
(8,'P8',1,90,1,'ClienteFrecuente',1),
(9,'P9',10,15,1,'Ninguno',1),
(10,'P10',1,1000,1,'Promocion',0);

-- Insertar pagos
INSERT INTO pagos VALUES
(1,1,'F001','2026-01-08',1600,'Tarjeta',1),
(2,2,'F002','2026-01-09',100,'Efectivo',1),
(3,3,'F003','2026-01-10',150,'Transferencia',1),
(4,4,'F004','2026-01-11',360,'Tarjeta',1),
(5,5,'F005','2026-01-12',500,'Efectivo',1),
(6,6,'F006','2026-01-13',400,'Transferencia',1),
(7,7,'F007','2026-01-14',120,'Tarjeta',1),
(8,8,'F008','2026-01-15',90,'Efectivo',1),
(9,9,'F009','2026-01-16',150,'Transferencia',1),
(10,10,'F010','2026-01-17',1000,'Tarjeta',1);