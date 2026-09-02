import bcrypt from 'bcryptjs';
import { criarUsuario, localizarUsuarioPorEmail } from '../../../lib/catalogo-s-db.js';

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

    const nome = String(body?.nome || '').trim();
    const email = String(body?.email || '').trim().toLowerCase();
    const senha = String(body?.senha || '');
    const confirmarSenha = String(body?.confirmarSenha || '');

    if (!nome || !email || !senha || !confirmarSenha) {
      return json({ ok: false, message: 'Preencha todos os campos.' }, 400);
    }

    if (senha !== confirmarSenha) {
      return json({ ok: false, message: 'As senhas não coincidem.' }, 400);
    }

    if (senha.length < 8) {
      return json({ ok: false, message: 'A senha precisa ter pelo menos 8 caracteres.' }, 400);
    }

    try {
      const existente = await localizarUsuarioPorEmail(email);
      if (existente) {
        return json({ ok: false, message: 'Já existe uma conta com este e-mail.' }, 409);
      }

      const senhaHash = await bcrypt.hash(senha, 12);
      const usuario = await criarUsuario({ nome, email, senhaHash });

      return json({
        ok: true,
        usuario: {
          id: usuario.id,
          nome: usuario.nome,
          email: usuario.email,
        },
      }, 201);
    } catch (error) {
      console.error('[DB01 cadastro]', error);
      return json({ ok: false, message: 'Não foi possível criar a conta.' }, 500);
    }
  },
};
