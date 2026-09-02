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

function textTemplate(code, ttlSeconds) {
  const minutes = Math.max(1, Math.round(ttlSeconds / 60));
  return `CLS · Catálogo S\n\nSeu código de acesso é ${code}.\nEle expira em ${minutes} minutos.\n\nSe você não solicitou este código, ignore esta mensagem.`;
}

function senderIdentity() {
  const raw = String(process.env.AUTH_FROM_EMAIL || '').trim();
  const match = raw.match(/^\s*(.*?)\s*<([^<>]+)>\s*$/);
  if (match) {
    return {
      email: match[2].trim(),
      name: match[1].trim() || 'Catálogo S',
      raw,
    };
  }
  return {
    email: raw,
    name: String(process.env.AUTH_FROM_NAME || 'Catálogo S').trim() || 'Catálogo S',
    raw,
  };
}

async function sendWithMailjet({ email, code, ttlSeconds }) {
  const sender = senderIdentity();
  const credentials = btoa(`${process.env.MAILJET_API_KEY}:${process.env.MAILJET_SECRET_KEY}`);
  const response = await fetch('https://api.mailjet.com/v3.1/send', {
    method: 'POST',
    headers: {
      Authorization: `Basic ${credentials}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      Messages: [
        {
          From: { Email: sender.email, Name: sender.name },
          To: [{ Email: email }],
          Subject: `${code} é seu código do Catálogo S`,
          TextPart: textTemplate(code, ttlSeconds),
          HTMLPart: emailTemplate(code, ttlSeconds),
          CustomID: `cls-otp-${Date.now()}`,
        },
      ],
    }),
    signal: AbortSignal.timeout(8000),
  });

  const detail = await response.text().catch(() => '');
  if (!response.ok) {
    console.error('Mailjet request failed', response.status, detail.slice(0, 700));
    throw new Error('MAILJET_PROVIDER_ERROR');
  }

  try {
    const payload = JSON.parse(detail);
    const status = payload?.Messages?.[0]?.Status;
    if (status && status !== 'success') {
      console.error('Mailjet message rejected', detail.slice(0, 700));
      throw new Error('MAILJET_MESSAGE_REJECTED');
    }
  } catch (error) {
    if (error?.message === 'MAILJET_MESSAGE_REJECTED') throw error;
  }
}

async function sendWithResend({ email, code, ttlSeconds }) {
  const sender = senderIdentity();
  const from = sender.raw.includes('<') ? sender.raw : `${sender.name} <${sender.email}>`;
  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${process.env.RESEND_API_KEY}`,
      'Content-Type': 'application/json',
      'Idempotency-Key': `cls-otp/${email}/${Date.now()}`,
    },
    body: JSON.stringify({
      from,
      to: [email],
      subject: `${code} é seu código do Catálogo S`,
      text: textTemplate(code, ttlSeconds),
      html: emailTemplate(code, ttlSeconds),
    }),
    signal: AbortSignal.timeout(8000),
  });

  if (!response.ok) {
    const detail = await response.text().catch(() => '');
    console.error('Resend request failed', response.status, detail.slice(0, 700));
    throw new Error('RESEND_PROVIDER_ERROR');
  }
}

async function sendEmail({ email, code, ttlSeconds, providers }) {
  let lastError = null;
  for (const provider of providers) {
    try {
      if (provider === 'mailjet') {
        await sendWithMailjet({ email, code, ttlSeconds });
        return 'mailjet';
      }
      if (provider === 'resend') {
        await sendWithResend({ email, code, ttlSeconds });
        return 'resend';
      }
    } catch (error) {
      lastError = error;
      console.error(`OTP provider ${provider} failed; trying fallback if available.`);
    }
  }
  throw lastError || new Error('EMAIL_PROVIDER_ERROR');
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

    let provider;
    try {
      provider = await sendEmail({ email, code, ttlSeconds, providers: config.emailProviders });
    } catch {
      return json({ ok: false, code: 'EMAIL_SEND_FAILED', message: 'Não foi possível enviar o código agora. Tente novamente em instantes.' }, 502);
    }

    const headers = new Headers();
    headers.append('Set-Cookie', serializeCookie(COOKIE_NAMES.challenge, challenge, { maxAge: ttlSeconds, sameSite: 'Strict' }));
    headers.append('Set-Cookie', serializeCookie(COOKIE_NAMES.cooldown, '1', { maxAge: otpCooldownSeconds(), sameSite: 'Strict' }));

    return json({ ok: true, email, expiresIn: ttlSeconds, provider }, 200, headers);
  },
};
