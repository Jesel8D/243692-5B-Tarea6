import { query } from '@/lib/db';
import { z } from 'zod';

// ==========================================
// TYPES (Contratos de Datos)
// ==========================================
export type KPIReport = {
    venta_total_global: string; // Postgres SUM devuelve string en JS
    total_transacciones: string;
    producto_top: string;
};

export type CategoryReport = {
    categoria: string;
    total_vendido: string;
    rentabilidad: string;
};

export type ProductRanking = {
    producto: string;
    unidades_totales: string;
    posicion_ranking: number;
    porcentaje_visual_relativo: number; // Ya calculado en DB
};

export type ClientVIP = {
    cliente: string;
    transacciones: string;
    inversion_total: string;
};

export type StockItem = {
    producto: string;
    precio_actual: string;
    stock_disponible: number;
    nivel_precio: string;
};

export type DailySummary = {
    fecha_operacion: Date;
    total_ventas_dia: string;
    ticket_promedio: string;
};

// ==========================================
// QUERIES (Data Access Layer)
// ==========================================

// Reporte 1 + KPI Dashboard
export const getDashboardKPIs = async (): Promise<KPIReport> => {
    const res = await query('SELECT * FROM view_kpi_dashboard LIMIT 1');
    return res.rows[0];
};

export const getSalesByCategory = async (): Promise<CategoryReport[]> => {
    const res = await query('SELECT categoria, total_vendido, rentabilidad FROM view_ventas_por_categoria');
    return res.rows;
};

// Reporte 2: Ranking (Parametrizado)
export const getProductRanking = async (limit: number): Promise<ProductRanking[]> => {
    // Validacion extra por seguridad, aunque Zod ya lo hace arriba
    const safeLimit = Math.max(1, Math.min(limit, 50));
    const res = await query(
        'SELECT producto, unidades_totales, posicion_ranking, porcentaje_visual_relativo FROM view_ranking_productos LIMIT $1',
        [safeLimit]
    );
    return res.rows;
};

// Reporte 3: VIPs (Parametrizado)
export const getVIPClients = async (minAmount: number): Promise<ClientVIP[]> => {
    const res = await query(
        'SELECT cliente, transacciones, inversion_total FROM view_clientes_vip WHERE inversion_total >= $1',
        [minAmount]
    );
    return res.rows;
};

// Reporte 4: Stock (Paginado)
export const getStockInventory = async (limit: number, offset: number): Promise<StockItem[]> => {
    const res = await query(
        'SELECT producto, precio_actual, stock_disponible, nivel_precio FROM view_estado_stock LIMIT $1 OFFSET $2',
        [limit, offset]
    );
    return res.rows;
};

// Reporte 5: Diario (Paginado)
export const getDailySummary = async (limit: number, offset: number): Promise<DailySummary[]> => {
    const res = await query(
        'SELECT fecha_operacion, total_ventas_dia, ticket_promedio FROM view_resumen_diario ORDER BY fecha_operacion DESC LIMIT $1 OFFSET $2',
        [limit, offset]
    );
    return res.rows;
};