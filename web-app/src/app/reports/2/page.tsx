import { getProductRanking } from '@/lib/queries';
import { z } from 'zod';
import Link from 'next/link';

export const dynamic = 'force-dynamic';

const FilterSchema = z.object({
    limit: z.coerce.number().min(1).max(50).default(10),
});

export default async function Reporte2({ searchParams }: { searchParams: { [key: string]: string | string[] | undefined }; }) {
    const { limit } = FilterSchema.parse(searchParams);

    // LLAMADA LIMPIA AL REPOSITORIO
    const data = await getProductRanking(limit);
    const topProduct = data[0]; // Solo para mostrar el nombre del líder si quieres

    return (
        <div className="space-y-6">
            {/* ... Header y Filtros ... */}

            <div className="grid gap-3">
                {data.map((prod) => (
                    <div key={prod.producto} className="group flex items-center p-4 bg-black border border-gray-800 rounded-xl">
                        {/* ... Posición ... */}
                        <div className="flex-1 ml-4">
                            <h3 className="font-bold text-lg text-white">{prod.producto}</h3>
                            <div className="w-full bg-gray-900 rounded-full h-1.5 mt-2">
                                {/* AQUI ESTA LA MAGIA: Usamos el dato de DB directo */}
                                <div
                                    className="bg-orange-600 h-1.5 rounded-full"
                                    style={{ width: `${prod.porcentaje_visual_relativo}%` }}
                                ></div>
                            </div>
                        </div>
                        {/* ... */}
                    </div>
                ))}
            </div>
        </div>
    );
}