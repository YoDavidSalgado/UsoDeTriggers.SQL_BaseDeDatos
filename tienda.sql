CREATE DATABASE IF NOT EXISTS `local`;
USE `local`;

CREATE TABLE IF NOT EXISTS `producto` (
    `codigoProducto` INT(11) NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(100),
    `precio` DECIMAL(18,2),
    PRIMARY KEY (`codigoProducto`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `venta` (
    `codigoVenta` INT(11) NOT NULL AUTO_INCREMENT,
    `cliente` VARCHAR(100),
    `fecha` DATETIME,
    PRIMARY KEY (`codigoVenta`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `detalleventa` (
    `codigoVenta` INT(11) NOT NULL,
    `codigoProducto` INT(11) NOT NULL,
    `cantidad` DECIMAL(18,2),
    `descuento` DECIMAL(18,2),
    FOREIGN KEY (`codigoVenta`) REFERENCES `venta` (`codigoVenta`),
    FOREIGN KEY (`codigoProducto`) REFERENCES `producto` (`codigoProducto`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tb_seguridad_detalleventa` (
    `codigoVenta` INT(11) NOT NULL,
    `codigoProducto` INT(11) NOT NULL,
    `cantidad` DECIMAL(18,2),
    `descuento` DECIMAL(18,2),
    `fechaAccion` DATE,
    `accion` VARCHAR(11)
) ENGINE=InnoDB;

DELIMITER @

CREATE TRIGGER tr_insert_detalleventa BEFORE INSERT ON detalleventa FOR EACH ROW
BEGIN
    INSERT INTO tb_seguridad_detalleventa (codigoVenta, codigoProducto, cantidad,
    descuento, fechaAccion, accion) 
    VALUES (NEW.codigoVenta, NEW.codigoProducto, NEW.cantidad, NEW.descuento,
    CURDATE(), 'Agregado');
END;
@

CREATE TRIGGER tr_update_detalleventa BEFORE UPDATE ON detalleventa FOR EACH ROW
BEGIN
    INSERT INTO tb_seguridad_detalleventa (codigoVenta, codigoProducto, cantidad,
    descuento, fechaAccion, accion) 
    VALUES (NEW.codigoVenta, NEW.codigoProducto, NEW.cantidad, NEW.descuento,
    CURDATE(), 'Modificado');
END;
@

CREATE TRIGGER tr_delete_detalleventa BEFORE DELETE ON detalleventa FOR EACH ROW
BEGIN
    INSERT INTO tb_seguridad_detalleventa (codigoVenta, codigoProducto, cantidad,
    descuento, fechaAccion, accion) 
    VALUES (OLD.codigoVenta, OLD.codigoProducto, OLD.cantidad, OLD.descuento,
    CURDATE(), 'Eliminado');
END;
@
DELIMITER ;

INSERT INTO producto (nombre, precio) VALUES ('Laptop Acer', 699.99);
INSERT INTO producto (nombre, precio) VALUES ('Teléfono Samsung Galaxy', 399.99);
INSERT INTO producto (nombre, precio) VALUES ('Smartwatch Fitbit', 149.99);
INSERT INTO producto (nombre, precio) VALUES ('Auriculares Bluetooth', 49.99);
INSERT INTO producto (nombre, precio) VALUES ('Impresora HP', 129.99);

INSERT INTO venta (cliente, fecha) VALUES ('Juan Pérez', '2024-03-23 10:30:00');
INSERT INTO venta (cliente, fecha) VALUES ('María Rodríguez', '2024-03-22 14:45:00');
INSERT INTO venta (cliente, fecha) VALUES ('Luis García', '2024-03-21 11:20:00');
INSERT INTO venta (cliente, fecha) VALUES ('Ana Martínez', '2024-03-20 09:15:00');
INSERT INTO venta (cliente, fecha) VALUES ('Pedro López', '2024-03-19 16:00:00');

INSERT INTO detalleventa (codigoVenta, codigoProducto, cantidad, descuento) VALUES (1, 2, 3, 0.50);
INSERT INTO detalleventa (codigoVenta, codigoProducto, cantidad, descuento) VALUES (2, 4, 2, 0.25);
INSERT INTO detalleventa (codigoVenta, codigoProducto, cantidad, descuento) VALUES (3, 1, 1, 0);
INSERT INTO detalleventa (codigoVenta, codigoProducto, cantidad, descuento) VALUES (4, 5, 4, 1.75);
INSERT INTO detalleventa (codigoVenta, codigoProducto, cantidad, descuento) VALUES (5, 3, 2, 0.50);

UPDATE detalleventa SET cantidad=7, descuento=0.75 WHERE codigoVenta = 2;
DELETE FROM detalleventa WHERE codigoVenta = 3;
INSERT INTO detalleventa (codigoVenta, codigoProducto, cantidad, descuento) VALUES (2, 3, 23, 0.75);

select * from venta;
select * from producto;
select * from detalleventa;
select * from tb_seguridad_detalleventa;

CREATE VIEW vista_venta_detalle AS
SELECT v.codigoVenta, v.cliente, v.fecha, dv.codigoProducto, p.nombre AS nombre_producto,
 dv.cantidad, dv.descuento
FROM venta v
JOIN detalleventa dv ON v.codigoVenta = dv.codigoVenta
JOIN producto p ON dv.codigoProducto = p.codigoProducto;

CREATE VIEW vista_seguridad_detalleventa AS
SELECT codigoVenta, codigoProducto, cantidad, descuento, fechaAccion, accion
FROM tb_seguridad_detalleventa;

CREATE VIEW vista_venta_cantidad_superior AS
SELECT v.codigoVenta, v.cliente, v.fecha, dv.codigoProducto, p.nombre AS nombre_producto, dv.cantidad, dv.descuento
FROM venta v
JOIN detalleventa dv ON v.codigoVenta = dv.codigoVenta
JOIN producto p ON dv.codigoProducto = p.codigoProducto
WHERE dv.cantidad > 5;

select * from vista_venta_detalle;
select * from vista_seguridad_detalleventa;
select * from vista_venta_cantidad_superior;

Show triggers;

Drop trigger tb_cliente;
