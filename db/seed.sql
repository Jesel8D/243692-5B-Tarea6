INSERT INTO categorias (nombre) VALUES ('Pan Dulce'), ('Salado'), ('Pastelería');

INSERT INTO productos (nombre, precio, categoria_id) VALUES
                                                         ('Concha Vainilla', 15.00, 1),
                                                         ('Cuernito', 18.00, 1),
                                                         ('Baguette', 35.00, 2),
                                                         ('Pastel Chocolate', 350.00, 3);

INSERT INTO ventas (fecha, cliente_nombre) VALUES (NOW(), 'Juan Perez'), (NOW() - INTERVAL '1 day', 'Maria Lopez');

INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES
                                                                                  (1, 1, 5, 15.00), (1, 2, 2, 18.00), (2, 3, 1, 35.00);