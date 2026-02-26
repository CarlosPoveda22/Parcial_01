CREATE DATABASE empresa_servicios;
USE empresa_servicios;

-- Tabla de usuarios
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    fecha_registro DATETIME NOT NULL,
    estado ENUM('Activo','Inactivo') NOT NULL,
    verificado BOOLEAN NOT NULL,
    codigo_cliente VARCHAR(20) UNIQUE
);

-- Tabla de autenticacion
CREATE TABLE autenticacion (
    id_autenticacion INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    ultimo_login DATETIME,
    intentos_fallidos INT DEFAULT 0 CHECK (intentos_fallidos >= 0),
    tipo_usuario ENUM('Admin','Cliente') NOT NULL,
    bloqueado BOOLEAN NOT NULL,
    id_usuario INT NOT NULL UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Tabla de servicio
CREATE TABLE servicio (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    categoria ENUM('Streaming','Cloud','Soporte','Software') NOT NULL,
    activo BOOLEAN NOT NULL,
    codigo_servicio VARCHAR(20) UNIQUE
);

-- Tabla servicio_contratado
CREATE TABLE servicio_contratado (
    id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    fecha_contratacion DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    estado ENUM('Activo','Cancelado','Suspendido') NOT NULL,
    renovacion_automatica BOOLEAN NOT NULL,
    numero_contrato VARCHAR(30) UNIQUE,
    id_usuario INT NOT NULL,
    id_servicio INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
);

-- Tabla de pago
CREATE TABLE pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    fecha_pago DATETIME NOT NULL,
    monto DECIMAL(10,2) NOT NULL CHECK (monto > 0),
    metodo_pago ENUM('Tarjeta','Transferencia','PayPal') NOT NULL,
    confirmado BOOLEAN NOT NULL,
    numero_factura VARCHAR(30) UNIQUE,
    id_contrato INT NOT NULL,
    FOREIGN KEY (id_contrato) REFERENCES servicio_contratado(id_contrato)
);

--Tabla de autoridad_acceso
CREATE TABLE auditoria_acceso (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME NOT NULL,
    direccion_ip VARCHAR(45) NOT NULL,
    tipo_evento ENUM('Login','Logout','IntentoFallido') NOT NULL,
    exitoso BOOLEAN NOT NULL,
    codigo_evento VARCHAR(30) UNIQUE,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Inserts para la base de datos

-- insertar usuarios
INSERT INTO usuario (nombre,apellido,email,telefono,fecha_registro,estado,verificado,codigo_cliente) VALUES
('Carlos','Poveda','carlos@empresa.com','6000-1001',NOW(),'Activo',1,'CLI-001'),
('Ana','Gomez','ana@empresa.com','6000-1002',NOW(),'Activo',1,'CLI-002'),
('Luis','Martinez','luis@empresa.com','6000-1003',NOW(),'Activo',0,'CLI-003'),
('Maria','Lopez','maria@empresa.com','6000-1004',NOW(),'Activo',1,'CLI-004'),
('Pedro','Sanchez','pedro@empresa.com','6000-1005',NOW(),'Inactivo',0,'CLI-005'),
('Laura','Diaz','laura@empresa.com','6000-1006',NOW(),'Activo',1,'CLI-006'),
('Jorge','Ruiz','jorge@empresa.com','6000-1007',NOW(),'Activo',1,'CLI-007'),
('Elena','Torres','elena@empresa.com','6000-1008',NOW(),'Activo',0,'CLI-008'),
('Miguel','Castro','miguel@empresa.com','6000-1009',NOW(),'Activo',1,'CLI-009'),
('Sofia','Rojas','sofia@empresa.com','6000-1010',NOW(),'Activo',1,'CLI-010');

-- insertar servicio
INSERT INTO servicio (nombre_servicio,descripcion,precio,categoria,activo,codigo_servicio) VALUES
('Streaming Pro','Plataforma streaming HD',15.99,'Streaming',1,'SER-001'),
('Cloud Basic','Almacenamiento 100GB',9.99,'Cloud',1,'SER-002'),
('Cloud Premium','Almacenamiento 1TB',19.99,'Cloud',1,'SER-003'),
('Soporte 24/7','Soporte tecnico permanente',29.99,'Soporte',1,'SER-004'),
('Antivirus','Proteccion empresarial',12.50,'Software',1,'SER-005'),
('ERP Empresarial','Sistema ERP completo',99.99,'Software',1,'SER-006'),
('Backup Online','Respaldo automatico',8.99,'Cloud',1,'SER-007'),
('Hosting Web','Hosting empresarial',14.99,'Cloud',1,'SER-008'),
('Licencia Office','Licencia anual office',45.00,'Software',1,'SER-009'),
('VPN Empresarial','Conexion segura remota',11.00,'Software',1,'SER-010');

-- insert autenticacion
INSERT INTO autenticacion (username,password_hash,ultimo_login,intentos_fallidos,tipo_usuario,bloqueado,id_usuario) VALUES
('carlos_admin','hash1',NOW(),0,'Admin',0,1),
('ana_user','hash2',NOW(),0,'Cliente',0,2),
('luis_user','hash3',NOW(),1,'Cliente',0,3),
('maria_user','hash4',NOW(),0,'Cliente',0,4),
('pedro_user','hash5',NOW(),2,'Cliente',0,5),
('laura_user','hash6',NOW(),0,'Cliente',0,6),
('jorge_user','hash7',NOW(),0,'Cliente',0,7),
('elena_user','hash8',NOW(),1,'Cliente',0,8),
('miguel_user','hash9',NOW(),0,'Cliente',0,9),
('sofia_user','hash10',NOW(),0,'Cliente',0,10);

-- insert servicio_contratado
INSERT INTO servicio_contratado (fecha_contratacion,fecha_vencimiento,estado,renovacion_automatica,numero_contrato,id_usuario,id_servicio) VALUES
('2026-01-01','2026-12-31','Activo',1,'CON-001',1,1),
('2026-01-02','2026-12-31','Activo',1,'CON-002',2,2),
('2026-01-03','2026-12-31','Activo',0,'CON-003',3,3),
('2026-01-04','2026-12-31','Suspendido',0,'CON-004',4,4),
('2026-01-05','2026-12-31','Activo',1,'CON-005',5,5),
('2026-01-06','2026-12-31','Activo',1,'CON-006',6,6),
('2026-01-07','2026-12-31','Activo',0,'CON-007',7,7),
('2026-01-08','2026-12-31','Cancelado',0,'CON-008',8,8),
('2026-01-09','2026-12-31','Activo',1,'CON-009',9,9),
('2026-01-10','2026-12-31','Activo',1,'CON-010',10,10);

-- insert pago
INSERT INTO pago (fecha_pago,monto,metodo_pago,confirmado,numero_factura,id_contrato) VALUES
(NOW(),15.99,'Tarjeta',1,'FAC-001',1),
(NOW(),9.99,'Transferencia',1,'FAC-002',2),
(NOW(),19.99,'Tarjeta',1,'FAC-003',3),
(NOW(),29.99,'PayPal',1,'FAC-004',4),
(NOW(),12.50,'Tarjeta',1,'FAC-005',5),
(NOW(),99.99,'Transferencia',1,'FAC-006',6),
(NOW(),8.99,'Tarjeta',1,'FAC-007',7),
(NOW(),14.99,'PayPal',1,'FAC-008',8),
(NOW(),45.00,'Tarjeta',1,'FAC-009',9),
(NOW(),11.00,'Transferencia',1,'FAC-010',10);

-- inser auditoria_acceso
INSERT INTO auditoria_acceso (fecha_hora,direccion_ip,tipo_evento,exitoso,codigo_evento,id_usuario) VALUES
(NOW(),'192.168.1.1','Login',1,'EV-001',1),
(NOW(),'192.168.1.2','Login',1,'EV-002',2),
(NOW(),'192.168.1.3','IntentoFallido',0,'EV-003',3),
(NOW(),'192.168.1.4','Login',1,'EV-004',4),
(NOW(),'192.168.1.5','Logout',1,'EV-005',5),
(NOW(),'192.168.1.6','Login',1,'EV-006',6),
(NOW(),'192.168.1.7','IntentoFallido',0,'EV-007',7),
(NOW(),'192.168.1.8','Login',1,'EV-008',8),
(NOW(),'192.168.1.9','Logout',1,'EV-009',9),
(NOW(),'192.168.1.10','Login',1,'EV-010',10);

--Opreaciones CRUD

-- CREATE Registra un nuevo usuario en la tabla de usuarios
INSERT INTO usuario (nombre,apellido,email,telefono,fecha_registro,estado,verificado,codigo_cliente)
VALUES ('Nuevo','Cliente','nuevo@empresa.com','6000-2020',NOW(),'Activo',1,'CLI-011');

-- READ Consulta usuarios activos, por ejemplo para analisis comerical
SELECT nombre, apellido, email
FROM usuario
WHERE estado = 'Activo';

-- UPDATE desactiva usuario sin eliminarlo, por ejemplo para mantener historial de contratos
UPDATE usuario
SET estado = 'Inactivo'
WHERE id_usuario = 3;

--DELETE no elimina fisicamente un usuario, sino que lo marca como inactivo para preservar integridad referencial
UPDATE usuario
SET estado = 'Inactivo'
WHERE id_usuario = 5;

-- VISTAS SQLS

-- Vista de negocio / utilidad: analiza el ingeso por usuario y servicio
CREATE VIEW vista_negocio AS
SELECT 
u.nombre,
u.apellido,
s.nombre_servicio,
p.monto,
p.fecha_pago
FROM usuario u
JOIN servicio_contratado sc ON u.id_usuario = sc.id_usuario
JOIN servicio s ON sc.id_servicio = s.id_servicio
JOIN pago p ON sc.id_contrato = p.id_contrato;

--Vista de seguridad  / utilidad: muestra la informacion sin exponer la password_hash
CREATE VIEW vista_seguridad AS
SELECT 
u.id_usuario,
u.nombre,
u.email,
a.username,
a.bloqueado
FROM usuario u
JOIN autenticacion a ON u.id_usuario = a.id_usuario;

-- Vista de auditoria / utilidad: monitorea los eventos sospechosos y tambien los accesos
CREATE VIEW vista_auditoria AS
SELECT 
u.nombre,
a.fecha_hora,
a.tipo_evento,
a.exitoso
FROM auditoria_acceso a
JOIN usuario u ON a.id_usuario = u.id_usuario;