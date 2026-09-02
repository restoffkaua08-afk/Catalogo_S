import fs from 'node:fs/promises';
import mysql from 'mysql2/promise';
import cadastro from './api/auth/cadastro.js';
import login from './api/auth/login.js';

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

async function call(handler, body, method = 'POST') {
  const request = new Request('http://local.test/api/test', {
    method,
    headers: { 'Content-Type': 'application/json' },
    body: method === 'GET' ? undefined : JSON.stringify(body),
  });
  const response = await handler.fetch(request);
  const payload = await response.json().catch(() => ({}));
  return { status: response.status, body: payload, headers: response.headers };
}

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  assert(databaseUrl, 'DATABASE_URL ausente no teste');
  const parsed = new URL(databaseUrl);

  const admin = await mysql.createConnection({
    host: parsed.hostname,
    port: Number(parsed.port || 3306),
    user: decodeURIComponent(parsed.username),
    password: decodeURIComponent(parsed.password),
    multipleStatements: true,
  });

  const schema = await fs.readFile('./database/schema.sql', 'utf8');
  await admin.query(schema);
  await admin.query('USE catalogo_login_lg01');
  await admin.query('DELETE FROM usuarios');

  const email = 'TESTE.DB01@EXEMPLO.COM';
  const senha = 'SenhaTeste123';

  let result = await call(cadastro, {
    nome: 'Pessoa Teste',
    email,
    senha,
    confirmarSenha: senha,
  });
  assert(result.status === 201, `cadastro deveria retornar 201, retornou ${result.status}`);
  assert(result.body.ok === true, 'cadastro não retornou ok=true');
  assert(result.body.usuario.email === 'teste.db01@exemplo.com', 'e-mail não foi normalizado');
  assert(result.headers.get('cache-control') === 'no-store', 'cadastro sem Cache-Control no-store');

  const [rows] = await admin.query(
    'SELECT id, nome, email, senha_hash FROM usuarios WHERE email = ? LIMIT 1',
    ['teste.db01@exemplo.com']
  );
  assert(rows.length === 1, 'usuário não foi persistido');
  assert(rows[0].senha_hash !== senha, 'senha foi armazenada em texto puro');
  assert(/^\$2[aby]\$/.test(rows[0].senha_hash), 'senha_hash não é bcrypt');

  result = await call(login, { email: 'teste.db01@exemplo.com', senha });
  assert(result.status === 200 && result.body.ok === true, 'login correto falhou');
  assert(result.body.usuario.email === 'teste.db01@exemplo.com', 'login retornou usuário incorreto');
  assert(result.headers.get('cache-control') === 'no-store', 'login sem Cache-Control no-store');

  result = await call(login, { email: 'teste.db01@exemplo.com', senha: 'SenhaErrada123' });
  assert(result.status === 401, `senha incorreta deveria retornar 401, retornou ${result.status}`);

  result = await call(cadastro, {
    nome: 'Pessoa Duplicada',
    email: 'teste.db01@exemplo.com',
    senha,
    confirmarSenha: senha,
  });
  assert(result.status === 409, `cadastro duplicado deveria retornar 409, retornou ${result.status}`);

  result = await call(cadastro, {
    nome: 'Pessoa Teste',
    email: 'outro@exemplo.com',
    senha,
    confirmarSenha: 'OutraSenha123',
  });
  assert(result.status === 400, `senhas divergentes deveriam retornar 400, retornou ${result.status}`);

  result = await call(login, {}, 'GET');
  assert(result.status === 405, `GET em login deveria retornar 405, retornou ${result.status}`);

  await admin.end();
  console.log('DB01: schema, cadastro, bcrypt, persistência, login e erros esperados validados.');
}

main().then(() => process.exit(0)).catch((error) => {
  console.error(error);
  process.exit(1);
});
