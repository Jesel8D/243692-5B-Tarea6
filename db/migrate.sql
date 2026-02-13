-- migrate.sql
-- Archivo destinado a migraciones de esquema (ALTER TABLE, CREATE TABLE nuevos)
-- que ocurran después del despliegue inicial.
--
-- En este laboratorio, el esquema base ya está definido en 01_schema.sql.
-- Este archivo se conserva para cumplir con la estructura solicitada y para
-- futuros cambios evolutivos (ej. agregar columna 'email' a clientes).

-- Ejemplo de migración futura (Comentada):
-- ALTER TABLE ventas ADD COLUMN metodo_pago VARCHAR(20) DEFAULT 'Efectivo';
