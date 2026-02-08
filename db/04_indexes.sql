
CREATE INDEX idx_productos_categoria ON productos(categoria_id);

CREATE INDEX idx_ventas_fecha ON ventas(fecha);

CREATE INDEX idx_detalle_producto ON detalle_ventas(producto_id);