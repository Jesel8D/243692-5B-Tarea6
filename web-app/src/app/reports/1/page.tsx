import { query } from '@/lib/db';
export const dynamic = 'force-dynamic';
async function getReportData() {
    const res = await query('SELECT categoria, total_vendido, rentabilidad FROM view_ventas_por_categoria');
    return res.rows;
}

export default async function Reporte1() {
    const data = await getReportData();

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Rendimiento por Categoría</h1>
            <p className="mb-6 text-gray-600 italic">Este reporte utiliza una CTE (Common Table Expression) para pre-calcular los totales antes de unirlos con las categorías.</p>

            <div className="overflow-x-auto bg-black rounded-lg shadow">
                <table className="min-w-full table-auto">
                    <thead className="bg-orange-500 text-white">
                    <tr>
                        <th className="px-6 py-3 text-left">Categoría</th>
                        <th className="px-6 py-3 text-left">Total Vendido</th>
                        <th className="px-6 py-3 text-left">Rentabilidad</th>
                    </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-200">
                    {data.map((row, i) => (
                        <tr key={i}>
                            <td className="px-6 py-4">{row.categoria}</td>
                            <td className="px-6 py-4">${row.total_vendido}</td>
                            <td className="px-6 py-4">
                  <span className={`px-2 py-1 rounded text-xs font-bold ${row.rentabilidad === 'Alta' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'}`}>
                    {row.rentabilidad}
                  </span>
                            </td>
                        </tr>
                    ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}