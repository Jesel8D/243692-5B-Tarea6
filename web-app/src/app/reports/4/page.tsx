import { getStockInventory } from '@/lib/queries';
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

    const stockItems = await getStockInventory(limit, offset);

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4 text-white">Inventario Crítico</h1>
            <p className="mb-6 text-gray-500 italic font-mono text-sm">
                SQL: SELECT ... FROM view_estado_stock LIMIT {limit} OFFSET {offset}
            </p>

            <div className="grid gap-4 mb-6">
                {stockItems.map((item, i) => (
                    <div key={i} className="p-4 bg-black border border-gray-800 border-l-4 border-l-orange-500 shadow-sm rounded">
                        <h3 className="font-bold text-white text-lg">{item.producto}</h3>
                        <p className="text-sm text-gray-400">
                            Precio: <span className="text-white">${item.precio_actual}</span> -
                            Estado: <span className="font-semibold text-orange-400">{item.nivel_precio}</span>
                        </p>
                        <p className="text-xs text-gray-600">Stock Simulado: {item.stock_disponible}</p>
                    </div>
                ))}
            </div>

            <div className="flex gap-2">
                {page > 1 && (
                    <Link href={`?page=${page - 1}`} className="px-4 py-2 bg-gray-800 text-white rounded hover:bg-gray-700 border border-gray-700"> Anterior </Link>
                )}
                <Link href={`?page=${page + 1}`} className="px-4 py-2 bg-gray-800 text-white rounded hover:bg-gray-700 border border-gray-700"> Siguiente </Link>
            </div>
        </div>
    );
}