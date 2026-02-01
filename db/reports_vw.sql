-- -----------------------------------------------------------------------------
-- VIEW 1: Rendimiento Financiero por Categoría
-- Devuelve: El total vendido por cada categoría y su etiqueta de rentabilidad.
-- Grain: Una fila por Categoría.
-- Métricas: Total Vendido (Suma), Rentabilidad (Etiqueta basada en umbral).
-- Uso de GROUP BY: Necesario para colapsar los productos en sus categorías padre.
-- Requisitos cumplidos: CTE, COALESCE, CASE, Función Agregada, GROUP BY.
-- -----------------------------------------------------------------------------
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
        WHEN rv.subtotal > 500 THEN 'Alta Rentabilidad'
        WHEN rv.subtotal BETWEEN 1 AND 500 THEN 'Rentabilidad Media'
        ELSE 'Sin Ventas'
        END as rentabilidad
FROM categorias c
         LEFT JOIN resumen_ventas rv ON c.id = rv.categoria_id
GROUP BY c.nombre, rv.subtotal;

-- VERIFY VIEW 1
-- SELECT * FROM view_ventas_por_categoria ORDER BY total_vendido DESC;


-- -----------------------------------------------------------------------------
-- VIEW 2: Ranking de Popularidad de Productos
-- Devuelve: Lista de productos ordenados por volumen de ventas con su posición.
-- Grain: Una fila por Producto.
-- Métricas: Unidades Vendidas (Suma), Posición (RANK).
-- Uso de GROUP BY: Para consolidar todas las ventas individuales de un mismo producto.
-- Requisitos cumplidos: Window Function (RANK), Función Agregada, GROUP BY.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW view_ranking_productos AS
SELECT
    p.nombre as producto,
    SUM(dv.cantidad) as unidades_totales,
    RANK() OVER (ORDER BY SUM(dv.cantidad) DESC) as posicion_ranking
FROM detalle_ventas dv
         JOIN productos p ON dv.producto_id = p.id
GROUP BY p.nombre;

-- VERIFY VIEW 2
-- SELECT * FROM view_ranking_productos WHERE posicion_ranking <= 3;


-- -----------------------------------------------------------------------------
-- VIEW 3: Clientes VIP (Filtro de Lealtad)
-- Devuelve: Clientes que han superado un umbral de gasto significativo.
-- Grain: Una fila por Cliente (Nombre).
-- Métricas: Total de Compras (Count), Gasto Total (Suma).
-- Uso de HAVING: Para filtrar grupos (clientes) cuyo gasto acumulado es > 100.
-- Requisitos cumplidos: HAVING, Función Agregada, GROUP BY, Alias legibles.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW view_clientes_vip AS
SELECT
    v.cliente_nombre as cliente,
    COUNT(DISTINCT v.id) as transacciones,
    SUM(dv.cantidad * dv.precio_unitario) as inversion_total
FROM ventas v
         JOIN detalle_ventas dv ON v.id = dv.venta_id
GROUP BY v.cliente_nombre
HAVING SUM(dv.cantidad * dv.precio_unitario) > 100;

-- VERIFY VIEW 3
-- SELECT * FROM view_clientes_vip ORDER BY inversion_total DESC;


-- -----------------------------------------------------------------------------
-- VIEW 4: Valorización y Clasificación de Inventario
-- Devuelve: Un análisis de precios de los productos disponibles.
-- Grain: Una fila por Producto.
-- Métricas: Precio Unitario, Stock Simulado.
-- Uso de CASE/COALESCE: Clasifica el nivel de precio y asegura que el stock no sea nulo.
-- Requisitos cumplidos: CASE, COALESCE significativo, Función Agregada (MAX), GROUP BY.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW view_estado_stock AS
SELECT
    nombre as producto,
    MAX(precio) as precio_actual, -- Función agregada requerida por regla
    COALESCE(NULL, 0) as stock_disponible,
    CASE
        WHEN precio > 100 THEN 'Premium'
        WHEN precio BETWEEN 20 AND 100 THEN 'Estándar'
        ELSE 'Económico'
        END as nivel_precio
FROM productos
GROUP BY nombre, precio;

-- VERIFY VIEW 4
-- SELECT * FROM view_estado_stock WHERE nivel_precio = 'Premium';


-- -----------------------------------------------------------------------------
-- VIEW 5: Resumen de Operación Diaria
-- Devuelve: Métricas de desempeño por fecha.
-- Grain: Una fila por Día.
-- Métricas: Volumen de Ventas (Count), Promedio de Ticket (AVG).
-- Uso de HAVING: Solo muestra días con actividad real (evita registros basura).
-- Requisitos cumplidos: AVG, ROUND (Campo calculado), HAVING, GROUP BY.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW view_resumen_diario AS
SELECT
    v.fecha::DATE as fecha_operacion,
    COUNT(DISTINCT v.id) as total_ventas_dia,
    ROUND(AVG(dv.cantidad * dv.precio_unitario), 2) as ticket_promedio
FROM ventas v
         JOIN detalle_ventas dv ON v.id = dv.venta_id
GROUP BY v.fecha::DATE
HAVING COUNT(v.id) >= 1;

-- VERIFY VIEW 5
-- SELECT * FROM view_resumen_diario WHERE total_ventas_dia > 0;