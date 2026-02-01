import { query } from '@/lib/db';
export const dynamic = 'force-dynamic';

export default async function Reporte2() {
    const res = await query('SELECT producto, unidades_totales, posicion_ranking FROM view_ranking_productos');
    const data = res.rows;

    return (
        <div className="p-8">
            <h1 className="text-2xl font-bold mb-4 text-white">Ranking de Popularidad</h1>
            <p className="mb-6 text-gray-400">
                Este reporte usa una Window Function (RANK) para determinar la posición de cada producto según sus ventas.
            </p>

            <div className="grid gap-4">
                {data.map((prod) => (
                    <div key={prod.producto} className="flex items-center p-4 bg-black border border-gray-800 rounded-lg shadow-sm">
                        <div className="text-3xl font-bold mr-4 text-orange-400">#{prod.posicion_ranking}</div>
                        <div className="flex-1">
                            <h3 className="font-bold text-lg text-white">{prod.producto}</h3>
                            <p className="text-gray-500">{prod.unidades_totales} unidades vendidas</p>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
}