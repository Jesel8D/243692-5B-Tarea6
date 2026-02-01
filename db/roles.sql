DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'webapp_user') THEN
CREATE ROLE webapp_user WITH LOGIN PASSWORD 'rollito_password';
END IF;
END $$;

GRANT CONNECT ON DATABASE rollito_db TO webapp_user;
GRANT USAGE ON SCHEMA public TO webapp_user;

-- REGLA ESTRICTA: Solo sobre las vistas
GRANT SELECT ON view_ventas_por_categoria TO webapp_user;
GRANT SELECT ON view_ranking_productos TO webapp_user;
GRANT SELECT ON view_clientes_vip TO webapp_user;
GRANT SELECT ON view_estado_stock TO webapp_user;
GRANT SELECT ON view_resumen_diario TO webapp_user;

-- Quitar permisos de las tablas base por si acaso
REVOKE SELECT ON categorias, productos, ventas, detalle_ventas FROM webapp_user;