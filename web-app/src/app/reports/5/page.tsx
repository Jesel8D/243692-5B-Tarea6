import { query } from '@/lib/db';
import Link from 'next/link';
export const dynamic = 'force-dynamic';

export default async function Reporte5({
                                           searchParams,
                                       }: {
    searchParams: { page?: string };
}) {
    const limit = 3;
    const page = Number(searchParams.page) || 1;
    const offset = (page - 1) * limit;
    const res = await query(
        'SELECT dia, num_ventas, ticket_promedio FROM view_resumen_diario LIMIT $1 OFFSET $2',
        [limit, offset]
    );

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Resumen de Ventas Diarias</h1>

            <div className="bg-black rounded-lg shadow overflow-hidden border border-gray-700">
                <table className="w-full text-white">
                    <thead className="bg-gray-800 text-orange-400 text-left">
                    <tr>
                        <th className="p-3">Fecha</th>
                        <th className="p-3">Ventas Totales</th>
                        <th className="p-3">Ticket Promedio ($)</th>
                    </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-800">
                    {res.rows.map((row, i) => (
                        <tr key={i} className="hover:bg-gray-900 transition">
                            <td className="p-3">{new Date(row.dia).toLocaleDateString()}</td>
                            <td className="p-3">{row.num_ventas}</td>
                            <td className="p-3 text-green-400">${row.ticket_promedio}</td>
                        </tr>
                    ))}
                    </tbody>
                </table>
            </div>

            <div className="mt-4 flex justify-between items-center">
                <span className="text-sm text-gray-500 font-mono">Página: {page}</span>
                <div className="flex gap-2">
                    {page > 1 && <Link href={`?page=${page - 1}`} className="px-3 py-1 bg-orange-500 text-white rounded font-bold">Anterior</Link>}
                    <Link href={`?page=${page + 1}`} className="px-3 py-1 bg-orange-500 text-white rounded font-bold">Siguiente</Link>
                </div>
            </div>
        </div>
    );
}