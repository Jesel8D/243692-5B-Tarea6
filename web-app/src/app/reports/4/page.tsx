import { query } from '@/lib/db';
import Link from 'next/link';
export const dynamic = 'force-dynamic';

export default async function Reporte4({
                                           searchParams,
                                       }: {
    searchParams: { page?: string };
}) {
    const limit = 2;
    const page = Number(searchParams.page) || 1;
    const offset = (page - 1) * limit;

    // Query parametrizada con LIMIT y OFFSET
    const res = await query(
        'SELECT nombre, precio, stock_simulado, categoria_precio FROM view_estado_stock LIMIT $1 OFFSET $2',
        [limit, offset]
    );

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Inventario Crítico</h1>
            <p className="mb-6 text-gray-600 italic font-mono text-sm">
                SQL: SELECT ... FROM view_estado_stock LIMIT {limit} OFFSET {offset}
            </p>

            <div className="grid gap-4 mb-6">
                {res.rows.map((item, i) => (
                    <div key={i} className="p-4 bg-black border-l-4 border-orange-500 shadow-sm rounded">
                        <h3 className="font-bold">{item.nombre}</h3>
                        <p className="text-sm text-gray-500">Precio: ${item.precio} - <span className="font-semibold text-blue-600">{item.categoria_precio}</span></p>
                    </div>
                ))}
            </div>

            <div className="flex gap-2">
                {page > 1 && (
                    <Link href={`?page=${page - 1}`} className="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300"> Anterior </Link>
                )}
                <Link href={`?page=${page + 1}`} className="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300"> Siguiente </Link>
            </div>
        </div>
    );
}