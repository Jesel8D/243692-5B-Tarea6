import { query } from '@/lib/db';
export const dynamic = 'force-dynamic';

export default async function Reporte2() {
    const res = await query('SELECT nombre, unidades_vendidas, posicion FROM view_ranking_productos');
    const data = res.rows;

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4">Ranking de Popularidad</h1>
            <p className="mb-6 text-gray-600">
                Este reporte usa una Window Function (RANK) para determinar la posición de cada producto según sus ventas.
            </p>

            <div className="grid gap-4">
                {data.map((prod) => (
                    <div key={prod.nombre} className="flex items-center p-4 bg-black border rounded-lg shadow-sm">
                        <div className="text-3xl font-bold mr-4 text-orange-400">#{prod.posicion}</div>
                        <div className="flex-1">
                            <h3 className="font-bold text-lg">{prod.nombre}</h3>
                            <p className="text-gray-500">{prod.unidades_vendidas} unidades vendidas</p>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
}