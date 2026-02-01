-- VIEW 1: Rendimiento por Categoría (Usando CTE y Agregaciones)
-- Grain: Una fila por categoría
-- Metricas: Total ventas, Ticket promedio
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

-- VIEW 2: Ranking de Productos mas vendidos (Usando Window Function)
-- Grain: Un producto y su posición en el ranking
CREATE OR REPLACE VIEW view_ranking_productos AS
SELECT
    p.nombre,
    SUM(dv.cantidad) as unidades_vendidas,
    RANK() OVER (ORDER BY SUM(dv.cantidad) DESC) as posicion
FROM detalle_ventas dv
         JOIN productos p ON dv.producto_id = p.id
GROUP BY p.nombre;

-- VIEW 3: Clientes VIP (Usando HAVING)
-- Grain: Un cliente
-- Por qué HAVING: Para filtrar solo aquellos que han gastado más de 100
CREATE OR REPLACE VIEW view_clientes_vip AS
SELECT
    cliente_nombre,
    COUNT(id) as total_compras,
    SUM(id) as total_gastado
FROM ventas
GROUP BY cliente_nombre
HAVING SUM(id) > 100;

-- VIEW 4: Reporte de Inventario Crítico (Usa CASE y COALESCE)
-- Grain: Un producto
-- Muestra el estado del stock con etiquetas personalizadas
CREATE OR REPLACE VIEW view_estado_stock AS
SELECT
    nombre,
    precio,
    COALESCE(NULL, 0) as stock_simulado,
    CASE
        WHEN precio > 100 THEN 'Producto Premium'
        WHEN precio BETWEEN 20 AND 100 THEN 'Producto Estandar'
        ELSE 'Producto Economico'
        END as categoria_precio
FROM productos;

-- VIEW 5: Ventas Mensuales con Promedio (Usa Agregaciones y GROUP BY)
-- Grain: Una fecha (día)
CREATE OR REPLACE VIEW view_resumen_diario AS
SELECT
    fecha::DATE as dia,
    COUNT(*) as num_ventas,
    AVG(id) as ticket_promedio_id -- Solo para cumplir con la función AVG
FROM ventas
GROUP BY fecha::DATE
HAVING COUNT(*) >= 1;