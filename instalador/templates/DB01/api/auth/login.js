import bcrypt from 'bcryptjs';
import { localizarUsuarioPorEmail } from '../../lib/catalogo-s-db.js';

function json(data, status = 200) {
  return Response.json(data, {
    status,
    headers: { 'Cache-Control': 'no-store' },
  });
}

export default {
  async fetch(request) {
    if (request.method !== 'POST') {
      return json({ ok: false, message: 'Método não permitido.' }, 405);
    }

    let body;
    try {
      body = await request.json();
    } catch {
      return json({ ok: false, message: 'JSON inválido.' }, 400);
    }

    const email = String(body?.email || '').trim().toLowerCase();
    const senha = String(body?.senha || '');

    if (!email || !senha) {
      return json({ ok: false, message: 'Informe e-mail e senha.' }, 400);
    }

    try {
      const usuario = await localizarUsuarioPorEmail(email);
      if (!usuario) {
        return json({ ok: false, message: 'Credenciais inválidas.' }, 401);
      }

      const valida = await bcrypt.compare(senha, usuario.senha_hash);
      if (!valida) {
        return json({ ok: false, message: 'Credenciais inválidas.' }, 401);
      }

      return json({
        ok: true,
        usuario: {
          id: usuario.id,
          nome: usuario.nome,
          email: usuario.email,
        },
      });
    } catch (error) {
      console.error('[DB01 login]', error);
      return json({ ok: false, message: 'Não foi possível entrar.' }, 500);
    }
  },
};
