CREATE TABLE categorias (
                            id SERIAL PRIMARY KEY,
                            nombre VARCHAR(50) NOT NULL
);

CREATE TABLE productos (
                           id SERIAL PRIMARY KEY,
                           nombre VARCHAR(100) NOT NULL,
                           precio DECIMAL(10,2) NOT NULL,
                           categoria_id INT REFERENCES categorias(id)
);

CREATE TABLE ventas (
                        id SERIAL PRIMARY KEY,
                        fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        cliente_nombre VARCHAR(100)
);

CREATE TABLE detalle_ventas (
                                id SERIAL PRIMARY KEY,
                                venta_id INT REFERENCES ventas(id),
                                producto_id INT REFERENCES productos(id),
                                cantidad INT NOT NULL,
                                precio_unitario DECIMAL(10,2) NOT NULL
);