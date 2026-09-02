import { COOKIE_NAMES, getCookie, json, verifyPayload } from '../../lib/auth.js';

export default {
  async fetch(request) {
    if (request.method !== 'GET') {
      return json({ ok: false, message: 'Método não permitido.' }, 405, { Allow: 'GET' });
    }

    const secret = process.env.AUTH_SECRET;
    const token = getCookie(request, COOKIE_NAMES.session);
    const session = await verifyPayload(token, secret, 'session');

    if (!session) return json({ ok: false, authenticated: false }, 401);
    return json({ ok: true, authenticated: true, email: session.email });
  },
};
