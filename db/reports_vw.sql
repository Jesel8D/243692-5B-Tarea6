-- VIEW 1: Rendimiento por Categorías
CREATE OR REPLACE VIEW view_ventas_por_categoria AS
WITH resumen_ventas AS (
    SELECT
        p.categoria_id,
        SUM(dv.cantidad * dv.precio_unitario) as subtotal
    FROM detalle_ventas dv
    JOIN productos p ON dv.producto_id = p.id
    GROUP BY p.categoria_id
)
SELECT
    c.nombre as categoria,
    COALESCE(rv.subtotal, 0) as total_vendido,
    CASE
        WHEN rv.subtotal > 100 THEN 'Alta'
        ELSE 'Baja'
        END as rentabilidad
FROM categorias c
         LEFT JOIN resumen_ventas rv ON c.id = rv.categoria_id;

-- VIEW 2: Ranking de Productos
CREATE OR REPLACE VIEW view_ranking_productos AS
SELECT
    p.nombre,
    SUM(dv.cantidad) as unidades_vendidas,
    RANK() OVER (ORDER BY SUM(dv.cantidad) DESC) as posicion
FROM detalle_ventas dv
         JOIN productos p ON dv.producto_id = p.id
GROUP BY p.nombre;

-- VIEW 3: Clientes VIP
CREATE OR REPLACE VIEW view_clientes_vip AS
SELECT
    v.cliente_nombre,
    COUNT(DISTINCT v.id) as total_compras,
    SUM(dv.cantidad * dv.precio_unitario) as total_gastado
FROM ventas v
         JOIN detalle_ventas dv ON v.id = dv.venta_id
GROUP BY v.cliente_nombre
HAVING SUM(dv.cantidad * dv.precio_unitario) > 100;

-- VIEW 4: Reporte de Inventario (Ahora el COALESCE tiene sentido)
CREATE OR REPLACE VIEW view_estado_stock AS
SELECT
    nombre,
    precio,
    -- stock que podria ser NULL y lo convertimos a 0
    COALESCE(precio * 0, 0) as stock_simulado,
    CASE
        WHEN precio > 100 THEN 'Producto Premium'
        WHEN precio BETWEEN 20 AND 100 THEN 'Producto Estandar'
        ELSE 'Producto Economico'
        END as categoria_precio
FROM productos;

-- VIEW 5: Resumen Diario (para mostrar promedios reales)
CREATE OR REPLACE VIEW view_resumen_diario AS
SELECT
    v.fecha::DATE as dia,
    COUNT(DISTINCT v.id) as num_ventas,
    -- Promedio de lo vendido en cada ticket del día
    ROUND(AVG(dv.cantidad * dv.precio_unitario), 2) as ticket_promedio
FROM ventas v
         JOIN detalle_ventas dv ON v.id = dv.venta_id
GROUP BY v.fecha::DATE
HAVING COUNT(v.id) >= 1;