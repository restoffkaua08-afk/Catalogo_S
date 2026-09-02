import {
  COOKIE_NAMES,
  clearCookie,
  codeDigest,
  getCookie,
  json,
  nowSeconds,
  otpMaxAttempts,
  randomId,
  serializeCookie,
  sessionTtlSeconds,
  signPayload,
  verifyPayload,
} from '../../lib/auth.js';

function secureEqual(a, b) {
  if (typeof a !== 'string' || typeof b !== 'string' || a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i += 1) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

export default {
  async fetch(request) {
    if (request.method !== 'POST') {
      return json({ ok: false, message: 'Método não permitido.' }, 405, { Allow: 'POST' });
    }

    const secret = process.env.AUTH_SECRET;
    if (!secret) return json({ ok: false, message: 'A autenticação ainda não foi configurada no servidor.' }, 503);

    const challengeToken = getCookie(request, COOKIE_NAMES.challenge);
    const challenge = await verifyPayload(challengeToken, secret, 'otp');
    if (!challenge) {
      const headers = new Headers();
      headers.append('Set-Cookie', clearCookie(COOKIE_NAMES.challenge));
      return json({ ok: false, code: 'EXPIRED', message: 'Esse código expirou. Solicite um novo.' }, 401, headers);
    }

    let payload;
    try {
      payload = await request.json();
    } catch {
      return json({ ok: false, message: 'Requisição inválida.' }, 400);
    }

    const code = String(payload?.code || '').replace(/\D/g, '').slice(0, 6);
    if (code.length !== 6) {
      return json({ ok: false, code: 'INVALID_CODE', message: 'Digite os 6 números do código.' }, 400);
    }

    const maxAttempts = otpMaxAttempts();
    const attempts = Number.isFinite(challenge.attempts) ? challenge.attempts : 0;
    if (attempts >= maxAttempts) {
      const headers = new Headers();
      headers.append('Set-Cookie', clearCookie(COOKIE_NAMES.challenge));
      return json({ ok: false, code: 'TOO_MANY_ATTEMPTS', message: 'Muitas tentativas. Solicite um novo código.' }, 429, headers);
    }

    const digest = await codeDigest({
      email: challenge.email,
      code,
      nonce: challenge.nonce,
      secret,
    });

    if (!secureEqual(digest, challenge.digest)) {
      const nextAttempts = attempts + 1;
      const remainingSeconds = Math.max(1, challenge.exp - nowSeconds());
      const headers = new Headers();

      if (nextAttempts >= maxAttempts) {
        headers.append('Set-Cookie', clearCookie(COOKIE_NAMES.challenge));
        return json({ ok: false, code: 'TOO_MANY_ATTEMPTS', message: 'Muitas tentativas. Solicite um novo código.' }, 429, headers);
      }

      const updated = await signPayload({ ...challenge, attempts: nextAttempts }, secret);
      headers.append('Set-Cookie', serializeCookie(COOKIE_NAMES.challenge, updated, { maxAge: remainingSeconds, sameSite: 'Strict' }));
      return json({ ok: false, code: 'WRONG_CODE', message: 'Código incorreto.', attemptsRemaining: maxAttempts - nextAttempts }, 401, headers);
    }

    const issuedAt = nowSeconds();
    const session = await signPayload(
      {
        typ: 'session',
        email: challenge.email,
        sid: randomId(),
        iat: issuedAt,
        exp: issuedAt + sessionTtlSeconds(),
      },
      secret,
    );

    const headers = new Headers();
    // Sem Max-Age: cookie de sessão. Ao encerrar a sessão do navegador, o usuário precisa entrar novamente.
    headers.append('Set-Cookie', serializeCookie(COOKIE_NAMES.session, session, { sameSite: 'Lax' }));
    headers.append('Set-Cookie', clearCookie(COOKIE_NAMES.challenge));
    headers.append('Set-Cookie', clearCookie(COOKIE_NAMES.cooldown));

    return json({ ok: true, email: challenge.email }, 200, headers);
  },
};
