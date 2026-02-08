#!/bin/bash
set -e

# Imprimir mensaje de log para depuración
echo "EJECUTANDO SCRIPT DE ROLES SEGURO..."

# Usamos las variables de entorno inyectadas por Docker Compose
# ${APP_USER} y ${APP_PASSWORD} vienen del .env

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- 1. Crear el usuario de la app si no existe
    DO \$\$
    BEGIN
      IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$APP_USER') THEN
         CREATE ROLE "$APP_USER" WITH LOGIN PASSWORD '$APP_PASSWORD';
      END IF;
    END \$\$;

    -- 2. Permisos básicos
    GRANT CONNECT ON DATABASE "$POSTGRES_DB" TO "$APP_USER";
    GRANT USAGE ON SCHEMA public TO "$APP_USER";

    -- 3. SEGURIDAD: Revocar acceso a tablas base (Principio de menor privilegio)
    REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM "$APP_USER";
    REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM "$APP_USER";

    -- 4. Dar permiso SOLO a las vistas (Hardcoded views names are fine, or dynamic)
    GRANT SELECT ON view_ventas_por_categoria TO "$APP_USER";
    GRANT SELECT ON view_ranking_productos TO "$APP_USER";
    GRANT SELECT ON view_clientes_vip TO "$APP_USER";
    GRANT SELECT ON view_estado_stock TO "$APP_USER";
    GRANT SELECT ON view_resumen_diario TO "$APP_USER";

    -- 5. Configurar search_path
    ALTER ROLE "$APP_USER" SET search_path TO public;
EOSQL

echo "USUARIO $APP_USER CREADO Y SECURIZADO CORRECTAMENTE."