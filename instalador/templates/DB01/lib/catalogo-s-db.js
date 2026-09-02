import mysql from 'mysql2/promise';

let pool;

function banco() {
  if (pool) return pool;

  const url = process.env.DATABASE_URL;
  if (!url) {
    throw new Error('DATABASE_URL não configurada. Use o formato indicado em .env.example.');
  }

  pool = mysql.createPool(url);
  return pool;
}

export async function localizarUsuarioPorEmail(email) {
  const [linhas] = await banco().execute(
    'SELECT id, nome, email, senha_hash FROM usuarios WHERE email = ? LIMIT 1',
    [email]
  );

  return linhas[0] || null;
}

export async function criarUsuario({ nome, email, senhaHash }) {
  const [resultado] = await banco().execute(
    'INSERT INTO usuarios (nome, email, senha_hash) VALUES (?, ?, ?)',
    [nome, email, senhaHash]
  );

  return {
    id: resultado.insertId,
    nome,
    email,
  };
}
