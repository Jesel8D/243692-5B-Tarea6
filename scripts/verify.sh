#!/bin/bash
# scripts/verify.sh

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "============================================="
echo "   Rollito Panadería - Verificación de DB    "
echo "============================================="

# Cargar variables de entorno si existen
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

CONTAINER_NAME="rollito_db"

echo -e "${GREEN}[1/3] Verificando contenedor de base de datos...${NC}"
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "✅ Contenedor $CONTAINER_NAME está corriendo."
else
    echo -e "${RED}❌ Contenedor $CONTAINER_NAME NO encontrado. Asegúrate de ejecutar 'docker compose up'.${NC}"
    exit 1
fi

echo -e "\n${GREEN}[2/3] Listando Vistas (Views) Disponibles...${NC}"
docker exec -e PGPASSWORD=$POSTGRES_PASSWORD -it $CONTAINER_NAME psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\dv"

echo -e "\n${GREEN}[3/3] Probando consultas rápidas (Smoke Test)...${NC}"

VIEWS=("view_ventas_por_categoria" "view_ranking_productos" "view_clientes_vip" "view_estado_stock" "view_resumen_diario" "view_kpi_dashboard")

for view in "${VIEWS[@]}"; do
    echo -n "Probando $view... "
    if docker exec -e PGPASSWORD=$POSTGRES_PASSWORD -it $CONTAINER_NAME psql -U $POSTGRES_USER -d $POSTGRES_DB -t -c "SELECT count(*) FROM $view;" > /dev/null 2>&1; then
        echo "✅ OK"
    else
        echo -e "${RED}❌ ERROR${NC}"
    fi
done

echo -e "\n============================================="
echo -e "${GREEN}Verificación completada.${NC}"
echo "============================================="
