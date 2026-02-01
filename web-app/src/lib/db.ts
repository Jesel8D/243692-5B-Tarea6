import { Pool } from 'pg';

// Configuramos el pool de conexiones
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
});

export const query = (text: string, params?: any[]) => {
    // SQL parametrizado
    return pool.query(text, params);
};