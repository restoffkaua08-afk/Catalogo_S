# Catálogo S

Biblioteca visual e instalador composável de modelos reutilizáveis de frontend e backend.

## Uso atual

O fluxo oficial não é mais copiar grandes blocos manualmente. Abra o terminal na pasta do projeto e execute o comando exibido na demonstração do modelo:

```bash
npx --yes github:restoffkaua08-afk/Catalogo_S#main add I01
```

Troque `I01` pelo ID desejado.

O instalador:

- cria os arquivos necessários;
- usa nomes canônicos para páginas equivalentes;
- registra o estado em `.catalogo-s/projeto.json`;
- cria backups antes de substituir arquivos gerenciados;
- reconcilia componentes instalados;
- conecta integrações compatíveis automaticamente;
- oferece `doctor` para validar o projeto.

## Convenções principais

- `Ixx` → tela inicial → `index.html`
- `Lxx` → página de produtos → `produtos.html`
- `LGxx` → login → `login.html`
- `Exx`, `Cxx` e `Pxx` → componentes repetíveis integrados ao projeto
- `DB01` → backend/banco pareado ao `LG01`

A instalação de uma nova tela inicial substitui a anterior sem remover componentes já registrados. Componentes repetíveis recebem instâncias próprias em `components/catalogo-s/`.

## Login e banco

`LG01` e `DB01` são pareados. O instalador pode receber qualquer um primeiro; ao encontrar os dois, reconcilia automaticamente os endpoints da tela com o backend. Credenciais reais do banco permanecem em variáveis de ambiente e nunca são gravadas no frontend.

## Demonstrações

Todas as demonstrações seguem o mesmo padrão:

1. preview visual;
2. título simplificado;
3. botão **Copiar**;
4. um único comando de terminal.

Os arquivos `bloco-pronto.*` continuam no repositório como fonte interna e auditável dos modelos, mas não são a interface principal de instalação.

## Status dos modelos

Os seis modelos historicamente aprovados continuam: `E01`, `C01`, `E02`, `C02`, `C03` e `E03`. Os demais mantêm seus IDs e status anteriores. A migração para o instalador não promove candidatos automaticamente.

## Documentação

- `documentacao/ARQUITETURA-INSTALADOR-TERMINAL.md` — arquitetura e contratos.
- `documentacao/COMO-ADICIONAR-UM-MODELO.md` — padrão para novos modelos.
- `instalador/README.md` — uso do CLI.

A interface pública continua hospedada na Vercel e o código fonte permanece no GitHub.
