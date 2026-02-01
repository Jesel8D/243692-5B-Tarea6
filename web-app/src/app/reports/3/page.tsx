import { query } from '@/lib/db';
import { z } from 'zod';
export const dynamic = 'force-dynamic';

const FilterSchema = z.object({
    min: z.coerce.number().catch(100), // Si no hay número o es texto, por defecto 100
});

export default async function Reporte3({
                                           searchParams,
                                       }: {
    searchParams: { [key: string]: string | string[] | undefined };
}) {
    const { min } = FilterSchema.parse(searchParams);

    const res = await query(
        'SELECT cliente_nombre, total_compras, total_gastado FROM view_clientes_vip WHERE total_gastado >= $1',
        [min]
    );

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Clientes VIP</h1>

            <div className="mb-6 p-4 bg-blue-50 rounded-md border border-blue-200">
                <p className="text-sm text-blue-800 mb-2 font-semibold">Filtro de Gasto Mínimo:</p>
                <div className="flex gap-2">
                    {[50, 100, 200, 500].map((val) => (
                        <a key={val} href={`?min=${val}`}
                           className={`px-3 py-1 rounded-full border ${min === val ? 'bg-blue-600 text-white' : 'bg-white text-blue-600'}`}>
                            ${val}+
                        </a>
                    ))}
                </div>
            </div>

            <table className="w-full bg-amber-400 shadow rounded-lg">
                <thead>
                <tr className="bg-black border-b">
                    <th className="p-3 text-left">Cliente</th>
                    <th className="p-3 text-left">Compras</th>
                    <th className="p-3 text-left">Total Gastado</th>
                </tr>
                </thead>
                <tbody>
                {res.rows.map((row, i) => (
                    <tr key={i} className="border-b">
                        <td className="p-3 font-medium">{row.cliente_nombre}</td>
                        <td className="p-3">{row.total_compras}</td>
                        <td className="p-3 text-green-600">${row.total_gastado}</td>
                    </tr>
                ))}
                </tbody>
            </table>
        </div>
    );
}