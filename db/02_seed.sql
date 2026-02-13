-- 02_seed.sql
-- Inserción de datos de prueba masivos para Rollito Panadería

-- Limpiamos tablas en orden inverso para evitar FK constraints
TRUNCATE TABLE detalle_ventas RESTART IDENTITY CASCADE;
TRUNCATE TABLE ventas RESTART IDENTITY CASCADE;
TRUNCATE TABLE productos RESTART IDENTITY CASCADE;
TRUNCATE TABLE categorias RESTART IDENTITY CASCADE;

-- 1. CATEGORIAS (5)
INSERT INTO categorias (id, nombre) VALUES
 (1, 'Pan Dulce'),
 (2, 'Pan Salado'),
 (3, 'Pastelería Fina'),
 (4, 'Bebidas Calientes'),
 (5, 'Temporada');

-- 2. PRODUCTOS (~20)
-- Precios variados para probar view_estado_stock (Económico < 20, Estándar 20-100, Premium > 100)
INSERT INTO productos (id, nombre, precio, categoria_id) VALUES
 -- Pan Dulce
 (1, 'Concha de Vainilla', 18.00, 1),
 (2, 'Concha de Chocolate', 18.00, 1),
 (3, 'Oreja', 15.00, 1),
 (4, 'Dona Glaseada', 22.00, 1),
 (5, 'Rol de Canela', 28.00, 1),

 -- Pan Salado
 (6, 'Bolillo Tradicional', 8.00, 2),
 (7, 'Baguette Rústica', 35.00, 2),
 (8, 'Croissant de Mantequilla', 25.00, 2),
 (9, 'Hogaza de Masa Madre', 85.00, 2),

 -- Pastelería (Premium)
 (10, 'Pastel de Zanahoria (Rebanada)', 120.00, 3),
 (11, 'Cheesecake de Frutos Rojos', 145.00, 3),
 (12, 'Tartaleta de Limón', 95.00, 3),
 (13, 'Eclair de Café', 65.00, 3),

 -- Bebidas
 (14, 'Café Americano', 35.00, 4),
 (15, 'Capuchino', 45.00, 4),
 (16, 'Chocolate Abuelita', 40.00, 4),

 -- Temporada
 (17, 'Pan de Muerto Tradicional', 55.00, 5),
 (18, 'Pan de Muerto Relleno', 85.00, 5),
 (19, 'Rosca de Reyes (Individual)', 60.00, 5),
 (20, 'Rosca de Reyes (Familiar)', 350.00, 5);

-- 3. VENTAS Y DETALLES
-- Generamos transacciones históricas para view_resumen_diario y view_clientes_vip

-- Cliente VIP 1: Juan Pérez (Gasta mucho)
INSERT INTO ventas (fecha, cliente_nombre) VALUES ('2023-10-01 08:30:00', 'Juan Pérez'); -- ID 1
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES
 (1, 10, 2, 120.00), -- 240
 (1, 15, 2, 45.00);  -- 90 -> Total 330

INSERT INTO ventas (fecha, cliente_nombre) VALUES ('2023-10-02 09:00:00', 'Juan Pérez'); -- ID 2
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES
 (2, 20, 1, 350.00); -- Total 350

-- Cliente Regular: María López
INSERT INTO ventas (fecha, cliente_nombre) VALUES ('2023-10-01 10:15:00', 'María López'); -- ID 3
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES
 (3, 1, 3, 18.00),
 (3, 6, 5, 8.00);

-- Cliente Nuevo: Carlos Ruiz
INSERT INTO ventas (fecha, cliente_nombre) VALUES ('2023-10-03 16:20:00', 'Carlos Ruiz'); -- ID 4
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES
 (4, 14, 1, 35.00);

-- Relleno masivo para Ranking y Fechas
-- Fecha 1: 2023-10-04
INSERT INTO ventas (fecha, cliente_nombre) VALUES ('2023-10-04 08:00:00', 'Cliente A'); -- 5
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES (5, 5, 10, 28.00); -- Muchos Roles

INSERT INTO ventas (fecha, cliente_nombre) VALUES ('2023-10-04 09:00:00', 'Cliente B'); -- 6
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES (6, 5, 5, 28.00);

-- Fecha 2: 2023-10-05
INSERT INTO ventas (fecha, cliente_nombre) VALUES ('2023-10-05 11:00:00', 'Cliente C'); -- 7
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES 
 (7, 11, 1, 145.00),
 (7, 14, 2, 35.00);

-- Fecha 3: 2023-10-06 (Venta grande)
INSERT INTO ventas (fecha, cliente_nombre) VALUES ('2023-10-06 14:00:00', 'Empresa X'); -- 8
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES 
 (8, 6, 50, 8.00), -- 50 Bolillos
 (8, 1, 20, 18.00); -- 20 Conchas

-- Ajustamos secuencias por si acaso
SELECT setval('categorias_id_seq', (SELECT MAX(id) FROM categorias));
SELECT setval('productos_id_seq', (SELECT MAX(id) FROM productos));
SELECT setval('ventas_id_seq', (SELECT MAX(id) FROM ventas));
SELECT setval('detalle_ventas_id_seq', (SELECT MAX(id) FROM detalle_ventas));