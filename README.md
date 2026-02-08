# Rollito Panadería - Lab Reportes SQL

Sistema de reportes de ventas para una panadería utilizando **Next.js**, **PostgreSQL** y **Docker Compose**.
Guia
## Tecnologías
- **Frontend:** Next.js 14 (App Router), Tailwind CSS.
- **Backend:** Node.js (Server Components).
- **DB:** PostgreSQL 15.
- **Seguridad:** Zod (Validación) y Roles de usuario limitados.
- **Infraestructura:** Docker Compose.

## Instalación y Ejecución
1. Clonar el repositorio.
2. Asegurarse de tener Docker instalado.
3. Ejecutar el comando:
   ```bash
   docker compose up --build


## Justificación de Índices (db/04_indexes.sql)
Se implementaron 3 índices estratégicos analizados con `EXPLAIN ANALYZE`:

1. **idx_productos_categoria:** Optimiza el `LEFT JOIN` en la View 1. Sin él, Postgres haría un scan secuencial de la tabla productos para encontrar los IDs de categoría.
2. **idx_ventas_fecha:** Vital para la View 5. Permite que el `GROUP BY v.fecha::DATE` sea mucho más rápido al tener las fechas ordenadas en el disco.
3. **idx_detalle_producto:** Acelera las Views 2 y 3. Al agrupar por producto para sumar cantidades (`SUM(cantidad)`), el índice permite localizar todas las filas de un producto sin recorrer toda la tabla de detalles.