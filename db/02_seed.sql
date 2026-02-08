-- Limpiar datos previos para evitar errores de llave primaria
TRUNCATE detalle_ventas, ventas, productos, categorias RESTART IDENTITY CASCADE;

-- 1. Categorías
INSERT INTO categorias (nombre) VALUES
                                    ('Pan Dulce'), ('Salado'), ('Pasteleria'), ('Bebidas'), ('Galleteria');

-- 2. Productos
INSERT INTO productos (nombre, precio, categoria_id) VALUES
                                                         ('Concha Vainilla', 15.00, 1),
                                                         ('Cuernito', 18.00, 1),
                                                         ('Beso de Nuez', 22.00, 1),
                                                         ('Baguette Grande', 45.00, 2),
                                                         ('Bolillo Extra', 5.00, 2),
                                                         ('Chapatta', 25.00, 2),
                                                         ('Pastel de Chocolate', 450.00, 3),
                                                         ('Cheesecake Frambuesa', 380.00, 3),
                                                         ('Cafe Americano', 35.00, 4),
                                                         ('Chocolate Caliente', 45.00, 4),
                                                         ('Galletas Avena (10 pz)', 65.00, 5);

-- 3. Ventas (Distribuidas en varios días para probar reportes diarios)
INSERT INTO ventas (fecha, cliente_nombre) VALUES
                                               (NOW() - INTERVAL '5 days', 'Juan Perez'),
                                               (NOW() - INTERVAL '4 days', 'Maria Lopez'),
                                               (NOW() - INTERVAL '3 days', 'Roberto Gomez'),
                                               (NOW() - INTERVAL '3 days', 'Ana Karen'),
                                               (NOW() - INTERVAL '2 days', 'Juan Perez'), -- Cliente recurrente
                                               (NOW() - INTERVAL '1 day', 'Don Pancho (VIP)'),
                                               (NOW(), 'Doña Lupe'),
                                               (NOW(), 'Cliente Anonimo'),
                                               (NOW(), 'Pasteleria Eventos S.A.');

-- 4. Detalle de Ventas (Calculados para disparar los filtros)
INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES
-- Venta 1: Juan compra pan dulce
(1, 1, 10, 15.00), (1, 2, 5, 18.00),
-- Venta 2: Maria compra baguette
(2, 4, 2, 45.00),
-- Venta 3: Roberto compra pastel (Venta grande)
(3, 7, 1, 450.00),
-- Venta 4: Ana compra cafe y pan
(4, 9, 2, 35.00), (4, 1, 4, 15.00),
-- Venta 5: Juan regresa por mas bolillos
(5, 5, 20, 5.00),
-- Venta 6: Don Pancho compra mucho pan (VIP)
(6, 1, 30, 15.00), (6, 2, 20, 18.00), (6, 6, 10, 25.00), -- Total alto
-- Venta 7: Doña Lupe compra cheesecake
(7, 8, 1, 380.00),
-- Venta 8: Cliente anonimo
(8, 10, 2, 45.00),
-- Venta 9: Venta corporativa (Muy grande)
(9, 7, 3, 450.00), (9, 11, 10, 65.00);