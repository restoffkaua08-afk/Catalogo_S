const textEncoder = new TextEncoder();
const textDecoder = new TextDecoder();

export const COOKIE_NAMES = Object.freeze({
  challenge: 'cls_otp',
  session: 'cls_session',
  cooldown: 'cls_otp_cooldown',
});

export function nowSeconds() {
  return Math.floor(Date.now() / 1000);
}

export function clampInteger(value, fallback, min, max) {
  const parsed = Number.parseInt(String(value ?? ''), 10);
  if (!Number.isFinite(parsed)) return fallback;
  return Math.min(max, Math.max(min, parsed));
}

export function otpTtlSeconds() {
  return clampInteger(process.env.OTP_TTL_SECONDS, 300, 60, 900);
}

export function otpCooldownSeconds() {
  return clampInteger(process.env.OTP_COOLDOWN_SECONDS, 45, 15, 300);
}

export function otpMaxAttempts() {
  return clampInteger(process.env.OTP_MAX_ATTEMPTS, 5, 3, 10);
}

export function sessionTtlSeconds() {
  const hours = clampInteger(process.env.SESSION_TTL_HOURS, 12, 1, 48);
  return hours * 60 * 60;
}

export function normalizeEmail(value) {
  return String(value || '').trim().toLowerCase();
}

export function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) && email.length <= 254;
}

export function authorizedEmailSet() {
  const raw = String(process.env.AUTHORIZED_EMAILS || '');
  return new Set(
    raw
      .split(/[\n,;]+/)
      .map(normalizeEmail)
      .filter(Boolean),
  );
}

function bytesToBase64Url(bytes) {
  let binary = '';
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/g, '');
}

function base64UrlToBytes(value) {
  const base64 = value.replace(/-/g, '+').replace(/_/g, '/');
  const padded = base64 + '='.repeat((4 - (base64.length % 4)) % 4);
  const binary = atob(padded);
  return Uint8Array.from(binary, (char) => char.charCodeAt(0));
}

function encodeJson(value) {
  return bytesToBase64Url(textEncoder.encode(JSON.stringify(value)));
}

function decodeJson(value) {
  return JSON.parse(textDecoder.decode(base64UrlToBytes(value)));
}

async function hmacBytes(secret, value) {
  const key = await crypto.subtle.importKey(
    'raw',
    textEncoder.encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const signature = await crypto.subtle.sign('HMAC', key, textEncoder.encode(value));
  return new Uint8Array(signature);
}

export async function hmacBase64Url(secret, value) {
  return bytesToBase64Url(await hmacBytes(secret, value));
}

function safeEqual(a, b) {
  const aa = textEncoder.encode(String(a));
  const bb = textEncoder.encode(String(b));
  if (aa.length !== bb.length) return false;
  let diff = 0;
  for (let i = 0; i < aa.length; i += 1) diff |= aa[i] ^ bb[i];
  return diff === 0;
}

export async function signPayload(payload, secret) {
  const encoded = encodeJson(payload);
  const signature = await hmacBase64Url(secret, encoded);
  return `${encoded}.${signature}`;
}

export async function verifyPayload(token, secret, expectedType) {
  try {
    if (!token || !secret) return null;
    const [encoded, signature, extra] = String(token).split('.');
    if (!encoded || !signature || extra) return null;
    const expected = await hmacBase64Url(secret, encoded);
    if (!safeEqual(signature, expected)) return null;
    const payload = decodeJson(encoded);
    if (!payload || typeof payload !== 'object') return null;
    if (expectedType && payload.typ !== expectedType) return null;
    if (!Number.isFinite(payload.exp) || payload.exp <= nowSeconds()) return null;
    return payload;
  } catch {
    return null;
  }
}

export function randomCode() {
  const values = new Uint32Array(1);
  crypto.getRandomValues(values);
  return String(values[0] % 1_000_000).padStart(6, '0');
}

export function randomId(size = 18) {
  const bytes = new Uint8Array(size);
  crypto.getRandomValues(bytes);
  return bytesToBase64Url(bytes);
}

export async function codeDigest({ email, code, nonce, secret }) {
  return hmacBase64Url(secret, `cls-otp|${email}|${code}|${nonce}`);
}

export function getCookie(request, name) {
  const cookieHeader = request.headers.get('cookie') || '';
  for (const part of cookieHeader.split(';')) {
    const index = part.indexOf('=');
    if (index < 0) continue;
    const key = part.slice(0, index).trim();
    if (key !== name) continue;
    return decodeURIComponent(part.slice(index + 1).trim());
  }
  return null;
}

export function serializeCookie(name, value, options = {}) {
  const parts = [`${name}=${encodeURIComponent(value)}`];
  parts.push(`Path=${options.path || '/'}`);
  if (options.httpOnly !== false) parts.push('HttpOnly');
  if (options.secure !== false) parts.push('Secure');
  parts.push(`SameSite=${options.sameSite || 'Lax'}`);
  if (Number.isFinite(options.maxAge)) parts.push(`Max-Age=${Math.max(0, Math.floor(options.maxAge))}`);
  return parts.join('; ');
}

export function clearCookie(name) {
  return `${name}=; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=0`;
}

export function json(data, status = 200, extraHeaders) {
  const headers = new Headers(extraHeaders || {});
  headers.set('Content-Type', 'application/json; charset=utf-8');
  headers.set('Cache-Control', 'no-store, max-age=0');
  return new Response(JSON.stringify(data), { status, headers });
}

export function authConfigStatus() {
  const missing = [];
  if (!process.env.AUTH_SECRET) missing.push('AUTH_SECRET');
  if (!process.env.AUTHORIZED_EMAILS) missing.push('AUTHORIZED_EMAILS');
  if (!process.env.RESEND_API_KEY) missing.push('RESEND_API_KEY');
  if (!process.env.AUTH_FROM_EMAIL) missing.push('AUTH_FROM_EMAIL');
  return { ok: missing.length === 0, missing };
}
