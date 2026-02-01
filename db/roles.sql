-- 1. Crear el usuario (usando un bloque anónimo por si el script se corre dos veces)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'webapp_user') THEN
CREATE ROLE webapp_user WITH LOGIN PASSWORD 'rollito_password';
END IF;
END $$;

-- 2. Permiso de conexion a la base de datos
GRANT CONNECT ON DATABASE rollito_db TO webapp_user;

-- 3. Permiso de uso del esquema
GRANT USAGE ON SCHEMA public TO webapp_user;

-- 4. Permiso de lectura (SELECT)
-- En PostgreSQL, las VIEW se consideran "relaciones" igual que las tablas.
-- Para asegurar que funcione con Next.js, otorgamos SELECT en el esquema public.
GRANT SELECT ON ALL TABLES IN SCHEMA public TO webapp_user;

-- 5. Asegurar que futuras vistas tambien sean legibles
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO webapp_user;

-- 6. Por seguridad: Revocar permisos de escritura (INSERT, UPDATE, DELETE)
-- Esto garantiza que el usuario de la app solo pueda leer
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM webapp_user;