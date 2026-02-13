import { getSalesByCategory, getDashboardKPIs } from '@/lib/queries';

export const dynamic = 'force-dynamic';

export default async function Reporte1() {
    // Parallel fetching: Traemos los dos datasets al mismo tiempo
    const [data, kpis] = await Promise.all([
        getSalesByCategory(),
        getDashboardKPIs()
    ]);

    return (
        <div className="space-y-6">
            <header>
                <h1 className="text-3xl font-bold text-white">Rendimiento por Categoría</h1>
            </header>

            {/* KPI SECTION (Dato viene listo de DB) */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="bg-gray-900 border border-gray-800 p-6 rounded-xl">
                    <h3 className="text-sm font-medium text-gray-400">Ventas Totales</h3>
                    <p className="text-3xl font-bold text-green-400 mt-2">
                        ${new Intl.NumberFormat('es-MX').format(Number(kpis.venta_total_global))}
                    </p>
                </div>
            </div>

            {/* Tabla estándar... */}
            {/* ... renderiza 'data' normalmente ... */}
        </div>
    );
}