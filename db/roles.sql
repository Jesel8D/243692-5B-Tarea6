-- 1. Creación del usuario de la aplicación
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'webapp_user') THEN
CREATE ROLE webapp_user WITH LOGIN PASSWORD 'rollito_password';
END IF;
END $$;

-- 2. Permisos de conexión y acceso al esquema
GRANT CONNECT ON DATABASE rollito_db TO webapp_user;
GRANT USAGE ON SCHEMA public TO webapp_user;

-- 3. REVOCAR cualquier permiso previo sobre tablas
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM webapp_user;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM webapp_user;

-- 4. CONCEDER acceso únicamente a las VIEWS requeridas
GRANT SELECT ON view_ventas_por_categoria TO webapp_user;
GRANT SELECT ON view_ranking_productos TO webapp_user;
GRANT SELECT ON view_clientes_vip TO webapp_user;
GRANT SELECT ON view_estado_stock TO webapp_user;
GRANT SELECT ON view_resumen_diario TO webapp_user;

-- 5. Configuración de seguridad adicional
ALTER ROLE webapp_user SET search_path TO public;