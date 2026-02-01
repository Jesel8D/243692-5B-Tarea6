import { query } from '@/lib/db';
import { z } from 'zod';
export const dynamic = 'force-dynamic';

const FilterSchema = z.object({
    min: z.coerce.number().catch(100),
});

export default async function Reporte3({
                                           searchParams,
                                       }: {
    searchParams: { [key: string]: string | string[] | undefined };
}) {
    const { min } = FilterSchema.parse(searchParams);

    const res = await query(
        'SELECT cliente, transacciones, inversion_total FROM view_clientes_vip WHERE inversion_total >= $1',
        [min]
    );

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4 text-white">Clientes VIP</h1>

            <div className="mb-6 p-4 bg-gray-900 rounded-md border border-gray-700">
                <p className="text-sm text-gray-300 mb-2 font-semibold">Filtro de Gasto Mínimo:</p>
                <div className="flex gap-2">
                    {[50, 100, 200, 500].map((val) => (
                        <a key={val} href={`?min=${val}`}
                           className={`px-3 py-1 rounded-full border ${min === val ? 'bg-orange-500 text-white border-orange-500' : 'bg-black text-gray-400 border-gray-700'}`}>
                            ${val}+
                        </a>
                    ))}
                </div>
            </div>

            <div className="overflow-hidden rounded-lg border border-gray-700">
                <table className="w-full bg-black text-white">
                    <thead>
                    <tr className="bg-gray-800 border-b border-gray-700">
                        <th className="p-3 text-left text-orange-400">Cliente</th>
                        <th className="p-3 text-left text-orange-400">Compras</th>
                        <th className="p-3 text-left text-orange-400">Total Gastado</th>
                    </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-800">
                    {res.rows.map((row, i) => (
                        <tr key={i} className="hover:bg-gray-900">
                            <td className="p-3 font-medium">{row.cliente}</td>
                            <td className="p-3">{row.transacciones}</td>
                            <td className="p-3 text-green-400">${row.inversion_total}</td>
                        </tr>
                    ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}