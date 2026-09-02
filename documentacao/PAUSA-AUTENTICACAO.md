# Pausa temporária da autenticação do Catálogo S

Data: 2026-09-02

## Estado atual

A autenticação por e-mail foi pausada temporariamente para que o desenvolvimento do catálogo continue sem depender de provider de e-mail.

O trabalho anterior NÃO foi removido.

Preservado no repositório:

- `login-email.html`: interface completa de autenticação por e-mail + OTP;
- `api/auth/request-code.js`: geração e envio do OTP;
- `api/auth/verify.js`: validação do OTP e criação da sessão;
- `api/auth/session.js`: leitura de sessão;
- `api/auth/logout.js`: logout;
- `lib/auth.js`: assinatura, cookies, allowlist, expiração e configuração;
- Mailjet como provider principal disponível;
- Resend como fallback disponível;
- documentação de autenticação e deploy existente.

## Modo temporário aberto

O Catálogo S agora usa `ACCESS_MODE=open` como comportamento padrão quando a variável não existe.

Fluxo atual:

```text
/catalogo-s.vercel.app
        |
        v
login.html
        |
        v
Entrar no Catálogo
        |
        v
/api/enter
        |
        v
cookie de sessão simples cls_catalog_open
        |
        v
/
        |
        v
Catálogo S
```

Esse botão NÃO é uma proteção de segurança. É somente uma tela de entrada visual enquanto a autenticação comercial está pausada.

## Retomar autenticação por e-mail

Quando o projeto voltar para o modelo comercial de acesso, configurar na Vercel:

```env
ACCESS_MODE=email
AUTHORIZED_EMAILS=...
AUTH_SECRET=...
EMAIL_PROVIDER=auto
MAILJET_API_KEY=...
MAILJET_SECRET_KEY=...
AUTH_FROM_EMAIL=...
```

Opcionalmente, manter Resend como fallback:

```env
RESEND_API_KEY=...
```

Com `ACCESS_MODE=email`, o middleware usa `login-email.html` e volta a proteger as rotas do catálogo com sessão assinada.

## Regra

Não apagar a implementação de autenticação por e-mail durante a fase aberta. Ela deve permanecer pronta para reativação quando o Catálogo S começar a vender acesso.
