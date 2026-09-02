import { serializeCookie } from '../lib/auth.js';

export default {
  async fetch(request) {
    if (request.method !== 'GET') {
      return new Response('Método não permitido.', {
        status: 405,
        headers: { Allow: 'GET', 'Cache-Control': 'no-store' },
      });
    }

    const headers = new Headers();
    headers.set('Location', '/');
    headers.set('Cache-Control', 'no-store');
    headers.append(
      'Set-Cookie',
      serializeCookie('cls_catalog_open', '1', {
        sameSite: 'Lax',
      }),
    );

    return new Response(null, { status: 303, headers });
  },
};
