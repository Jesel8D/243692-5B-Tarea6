import Link from 'next/link';

export default function Dashboard() {
  const reports = [
    { id: 1, name: 'Ventas por Categoría', desc: 'Resumen financiero usando CTE' },
    { id: 2, name: 'Ranking de Productos', desc: 'Top ventas con Window Functions' },
    { id: 3, name: 'Clientes VIP', desc: 'Filtro con HAVING y montos altos' },
    { id: 4, name: 'Inventario Crítico', desc: 'Estado de stock con CASE/COALESCE' },
    { id: 5, name: 'Resumen Diario', desc: 'Agregaciones por fecha' },
  ];

  return (
      <main className="p-8">
        <h1 className="text-3xl font-bold mb-6 text-orange-600">Rollito Panadería - Dashboard</h1>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {reports.map((report) => (
              <Link key={report.id} href={`/reports/${report.id}`}
                    className="block p-6 bg-white border border-gray-200 rounded-lg shadow hover:bg-gray-50 transition">
                <h5 className="mb-2 text-xl font-bold tracking-tight text-gray-900">{report.name}</h5>
                <p className="font-normal text-gray-700">{report.desc}</p>
              </Link>
          ))}
        </div>
      </main>
  );
}