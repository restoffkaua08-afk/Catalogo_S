# Autenticação e deploy do Catálogo S na Vercel

## Objetivo

O Catálogo S continua sendo um site estático, mas passa a ter uma camada server-side na Vercel para bloquear todas as rotas e liberar o conteúdo somente depois da confirmação por e-mail.

## Fluxo

1. A pessoa abre qualquer rota do Catálogo S.
2. O `middleware.js` verifica o cookie de sessão assinado.
3. Sem sessão válida, a pessoa é redirecionada para `/login.html`.
4. O e-mail informado é comparado com `AUTHORIZED_EMAILS`, que existe apenas no ambiente da Vercel.
5. Se autorizado, `/api/auth/request-code` gera um código aleatório de 6 números, cria um desafio assinado e envia o código por Resend.
6. `/api/auth/verify` valida o código. Quando correto, o desafio é apagado e um cookie de sessão `HttpOnly` é criado.
7. O cookie de sessão não recebe `Max-Age`, portanto funciona como cookie de sessão do navegador. Além disso, o token assinado possui expiração máxima configurável.
8. `/api/auth/logout` apaga todos os cookies de autenticação.

## Variáveis de ambiente

Copie as chaves de `.env.example` para Vercel > Project > Settings > Environment Variables.

Obrigatórias:

- `AUTHORIZED_EMAILS`: lista separada por vírgulas, ponto e vírgula ou linhas.
- `AUTH_SECRET`: segredo longo e aleatório usado para assinar os desafios e sessões.
- `RESEND_API_KEY`: chave da API do Resend.
- `AUTH_FROM_EMAIL`: remetente verificado no Resend, por exemplo `Catálogo S <acesso@seudominio.com>`.

Opcionais:

- `OTP_TTL_SECONDS`: padrão 300 segundos.
- `OTP_COOLDOWN_SECONDS`: padrão 45 segundos.
- `OTP_MAX_ATTEMPTS`: padrão 5.
- `SESSION_TTL_HOURS`: padrão 12 horas.

## Segurança adotada

- e-mails autorizados não ficam no frontend;
- desafio e sessão são assinados com HMAC-SHA256;
- cookies são `HttpOnly`, `Secure` e `SameSite`;
- o código tem validade curta;
- há limite de tentativas por desafio;
- há cooldown por navegador para reduzir spam de envio;
- middleware protege HTML, JS, JSON e URLs diretas das demos;
- respostas de autenticação usam `Cache-Control: no-store`.

## Limitação intencional da versão sem banco

A implementação é stateless. No fluxo normal, o código deixa de funcionar depois da validação porque o cookie de desafio é apagado. Porém, sem armazenamento server-side, não existe garantia matemática de uso único contra replay de um estado de desafio copiado antes da validação.

Quando o Catálogo S começar a ser comercializado em escala, a evolução recomendada é mover apenas os desafios OTP para um KV/Redis com TTL e consumo atômico. Isso não exige criar um banco completo de usuários.

## Deploy automático

Conecte o repositório `restoffkaua08-afk/Catalogo_S` ao projeto da Vercel e use `main` como Production Branch. Depois disso, cada commit na `main` gera automaticamente um novo deploy de produção.

Branches diferentes podem ser usadas para Preview Deployments antes de enviar mudanças para produção.

## Logout

- `POST /api/auth/logout` retorna JSON e remove a sessão.
- `GET /api/auth/logout` remove a sessão e redireciona para `/login.html`.

Um botão visual de logout pode apontar diretamente para `/api/auth/logout`.
