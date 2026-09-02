import { next } from '@vercel/functions';
import { COOKIE_NAMES, getCookie, json, verifyPayload } from './lib/auth.js';

function isPublicPath(pathname) {
  if (pathname === '/login.html') return true;
  if (pathname === '/favicon.ico' || pathname === '/robots.txt') return true;
  if (pathname.startsWith('/api/auth/')) return true;
  if (pathname.startsWith('/_vercel/')) return true;
  if (pathname.startsWith('/.well-known/')) return true;
  return false;
}

export default async function middleware(request) {
  const url = new URL(request.url);

  if (isPublicPath(url.pathname)) return next();

  const secret = process.env.AUTH_SECRET;
  if (!secret) {
    return new Response('Catálogo S: autenticação não configurada.', {
      status: 503,
      headers: { 'Content-Type': 'text/plain; charset=utf-8', 'Cache-Control': 'no-store' },
    });
  }

  const token = getCookie(request, COOKIE_NAMES.session);
  const session = await verifyPayload(token, secret, 'session');
  if (session) return next();

  if (url.pathname.startsWith('/api/')) {
    return json({ ok: false, code: 'UNAUTHORIZED', message: 'Acesso não autorizado.' }, 401);
  }

  const loginUrl = new URL('/login.html', request.url);
  const nextPath = `${url.pathname}${url.search}`;
  if (nextPath !== '/') loginUrl.searchParams.set('next', nextPath);
  return Response.redirect(loginUrl, 302);
}
