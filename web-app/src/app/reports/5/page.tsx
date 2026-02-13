// src/app/reports/5/page.tsx
import { getDailySummary } from '@/lib/queries';
import Link from 'next/link';
import { z } from 'zod';

export const dynamic = 'force-dynamic';

const PageSchema = z.object({
    page: z.coerce.number().min(1).default(1),
});

export default async function Reporte5({
    searchParams,
}: {
    searchParams: { [key: string]: string | string[] | undefined };
}) {
    const { page } = PageSchema.parse(searchParams);
    const pageSize = 5;
    const offset = (page - 1) * pageSize;

    const dailySummary = await getDailySummary(pageSize, offset);

    const hasMore = dailySummary.length === pageSize;

    return (
        <div className="space-y-6">
            <header className="flex justify-between items-center">
                <div>
                    <h1 className="text-3xl font-bold text-white">Resumen Diario</h1>
                    <p className="text-gray-400">Agregaciones temporales con Paginación Server-Side.</p>
                </div>
            </header>

            <div className="bg-black rounded-xl border border-gray-800 overflow-hidden shadow-xl">
                <table className="min-w-full">
                    <thead className="bg-gray-900/50">
                        <tr>
                            <th className="px-6 py-4 text-left text-sm font-semibold text-orange-400">Fecha</th>
                            <th className="px-6 py-4 text-left text-sm font-semibold text-orange-400">Transacciones</th>
                            <th className="px-6 py-4 text-left text-sm font-semibold text-orange-400">Ticket Promedio</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-800">
                        {dailySummary.map((row, i) => (
                            <tr key={i} className="hover:bg-gray-900/30">
                                <td className="px-6 py-4 text-gray-300">
                                    {new Date(row.fecha_operacion).toLocaleDateString('es-MX', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}
                                </td>
                                <td className="px-6 py-4 font-mono text-white">{row.total_ventas_dia}</td>
                                <td className="px-6 py-4 text-green-400 font-bold">${row.ticket_promedio}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
                {dailySummary.length === 0 && (
                    <div className="p-8 text-center text-gray-500">
                        No hay registros en esta página.
                    </div>
                )}
            </div>

            {/* Paginación */}
            <div className="flex justify-center gap-4 pt-4">
                {page > 1 && (
                    <Link href={`?page=${page - 1}`} className="px-4 py-2 rounded-lg bg-gray-800 text-white hover:bg-gray-700 transition">
                        ← Anterior
                    </Link>
                )}
                <span className="px-4 py-2 text-gray-500 font-mono">Página {page}</span>
                {hasMore && (
                    <Link href={`?page=${page + 1}`} className="px-4 py-2 rounded-lg bg-orange-600 text-white hover:bg-orange-500 transition shadow-lg shadow-orange-900/20">
                        Siguiente →
                    </Link>
                )}
            </div>
        </div>
    );
}