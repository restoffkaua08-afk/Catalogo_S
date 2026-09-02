import { COOKIE_NAMES, clearCookie, json } from '../../lib/auth.js';

function logoutHeaders() {
  const headers = new Headers();
  headers.append('Set-Cookie', clearCookie(COOKIE_NAMES.session));
  headers.append('Set-Cookie', clearCookie(COOKIE_NAMES.challenge));
  headers.append('Set-Cookie', clearCookie(COOKIE_NAMES.cooldown));
  return headers;
}

export default {
  async fetch(request) {
    const headers = logoutHeaders();

    if (request.method === 'GET') {
      headers.set('Location', '/login.html');
      return new Response(null, { status: 303, headers });
    }

    if (request.method !== 'POST') {
      return json({ ok: false, message: 'Método não permitido.' }, 405, { Allow: 'GET, POST' });
    }

    return json({ ok: true }, 200, headers);
  },
};
