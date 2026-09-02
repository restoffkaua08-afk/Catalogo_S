import {
  COOKIE_NAMES,
  authConfigStatus,
  authorizedEmailSet,
  codeDigest,
  getCookie,
  isValidEmail,
  json,
  normalizeEmail,
  nowSeconds,
  otpCooldownSeconds,
  otpTtlSeconds,
  randomCode,
  randomId,
  serializeCookie,
  signPayload,
} from '../../lib/auth.js';

function emailTemplate(code, ttlSeconds) {
  const minutes = Math.max(1, Math.round(ttlSeconds / 60));
  return `<!doctype html><html><body style="margin:0;background:#08090c;color:#f7f3e9;font-family:Arial,sans-serif;padding:32px"><div style="max-width:520px;margin:auto;border:1px solid #ffffff1f;border-radius:24px;padding:32px;background:#111318"><div style="font-size:12px;letter-spacing:.22em;color:#d1ad73;margin-bottom:26px">CLS · CATÁLOGO S</div><h1 style="font-size:30px;margin:0 0 12px">Seu código de acesso</h1><p style="color:#aaa69e;line-height:1.6;margin:0 0 24px">Use o código abaixo para entrar. Ele expira em ${minutes} minutos.</p><div style="font-size:42px;letter-spacing:.22em;font-weight:700;color:#fff;padding:20px 22px;border-radius:16px;background:#08090c;border:1px solid #d1ad7350;text-align:center">${code}</div><p style="font-size:12px;color:#77736c;line-height:1.6;margin:24px 0 0">Se você não solicitou este código, ignore esta mensagem.</p></div></body></html>`;
}

async function sendEmail({ email, code, ttlSeconds }) {
  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${process.env.RESEND_API_KEY}`,
      'Content-Type': 'application/json',
      'Idempotency-Key': `cls-otp/${email}/${Date.now()}`,
    },
    body: JSON.stringify({
      from: process.env.AUTH_FROM_EMAIL,
      to: [email],
      subject: `${code} é seu código do Catálogo S`,
      html: emailTemplate(code, ttlSeconds),
    }),
    signal: AbortSignal.timeout(8000),
  });

  if (!response.ok) {
    const detail = await response.text().catch(() => '');
    console.error('Resend request failed', response.status, detail.slice(0, 500));
    throw new Error('EMAIL_PROVIDER_ERROR');
  }
}

export default {
  async fetch(request) {
    if (request.method !== 'POST') {
      return json({ ok: false, message: 'Método não permitido.' }, 405, { Allow: 'POST' });
    }

    const config = authConfigStatus();
    if (!config.ok) {
      console.error('Missing auth configuration:', config.missing.join(', '));
      return json({ ok: false, message: 'A autenticação ainda não foi configurada no servidor.' }, 503);
    }

    if (getCookie(request, COOKIE_NAMES.cooldown)) {
      return json({ ok: false, code: 'WAIT', message: 'Aguarde alguns segundos antes de pedir outro código.' }, 429);
    }

    let payload;
    try {
      payload = await request.json();
    } catch {
      return json({ ok: false, message: 'Requisição inválida.' }, 400);
    }

    const email = normalizeEmail(payload?.email);
    if (!isValidEmail(email)) {
      return json({ ok: false, code: 'INVALID_EMAIL', message: 'Digite um e-mail válido.' }, 400);
    }

    if (!authorizedEmailSet().has(email)) {
      return json({ ok: false, code: 'EMAIL_NOT_AUTHORIZED', message: 'Este e-mail não possui acesso ao Catálogo S.' }, 403);
    }

    const secret = process.env.AUTH_SECRET;
    const code = randomCode();
    const nonce = randomId();
    const ttlSeconds = otpTtlSeconds();
    const exp = nowSeconds() + ttlSeconds;
    const digest = await codeDigest({ email, code, nonce, secret });
    const challenge = await signPayload({ typ: 'otp', email, nonce, digest, attempts: 0, exp }, secret);

    try {
      await sendEmail({ email, code, ttlSeconds });
    } catch {
      return json({ ok: false, code: 'EMAIL_SEND_FAILED', message: 'Não foi possível enviar o código agora. Tente novamente em instantes.' }, 502);
    }

    const headers = new Headers();
    headers.append('Set-Cookie', serializeCookie(COOKIE_NAMES.challenge, challenge, { maxAge: ttlSeconds, sameSite: 'Strict' }));
    headers.append('Set-Cookie', serializeCookie(COOKIE_NAMES.cooldown, '1', { maxAge: otpCooldownSeconds(), sameSite: 'Strict' }));

    return json({ ok: true, email, expiresIn: ttlSeconds }, 200, headers);
  },
};
