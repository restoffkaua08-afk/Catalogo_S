# Convenções de ligação e categorias — Catálogo S

## Estado

- Data: 2026-09-03
- Status: integrado à arquitetura por terminal.
- Fonte normativa principal: `ARQUITETURA-INSTALADOR-TERMINAL.md`.

As antigas instruções de localizar manualmente `href`, endpoints, arquivos e blocos `EDITE AQUI` foram substituídas pelo instalador do Catálogo S.

## IDs e categorias

Os IDs existentes são permanentes. Famílias atuais e reservadas incluem:

- `Ixx` — telas iniciais;
- `Exx` — seções/telas reutilizáveis;
- `Cxx` — carrosséis;
- `Lxx` — listagens de produtos;
- `Pxx` — pesquisas;
- `Axx` — efeitos;
- `LGxx` — login;
- `DBxx` — banco/backend pareado;
- `Nxx` — menus;
- `Fxx` — rodapés;
- `SOBxx` — Sobre;
- `CTxx` — Contato;
- `BTNxx` — telas/blocos com botão.

Categorias sem modelos ainda podem permanecer vazias; não são preenchidas com exemplos artificiais.

## Instalação

A interface para o usuário é sempre o bloco PowerShell autocontido exibido abaixo da demonstração. Ele deve ser copiado por inteiro e colado no PowerShell aberto na pasta desejada.

Os arquivos `bloco-pronto.*` são fontes internas do modelo. O usuário não precisa criar arquivos, copiar HTML manualmente nem editar uma linha de código.

## Arquivos canônicos

Modelos do mesmo papel convergem para nomes estáveis:

```text
inicio    -> index.html
produtos  -> produtos.html
sobre     -> sobre.html
contato   -> contato.html
login     -> login.html
```

Arquivos técnicos são criados somente quando necessários, por exemplo:

```text
assets/js/catalogo-s.config.js
api/auth/login.js
api/auth/cadastro.js
lib/catalogo-s-db.js
database/schema.sql
```

## Manifesto e slots

Os instaladores usam marcadores `CATALOGO-S:SLOT:*` como áreas seguras de reconciliação. Antes de substituir conteúdo gerenciado, criam backup em `.catalogo-s/backups/`.

Componentes repetíveis são registrados como instâncias e podem coexistir. Páginas singleton são substituídas por papel sem apagar as instâncias já registradas.

## Login e banco

O número da interface não obriga a criação de um novo banco. `DB01` representa o contrato de autenticação `auth-email-senha-v1` e é compartilhado por `LG01`, `LG02`, `LG03`, `LG04` e `LG05`.

A ligação é automática pelos arquivos locais. Cada instalador `LGxx` detecta os endpoints já instalados; o `DB01` também grava a configuração compartilhada quando é instalado. Assim, a ordem não precisa ser fixa e trocar apenas o visual do login não duplica schema, adaptador nem endpoints.

A senha nunca é persistida em texto puro. O formulário recebe `senha`; o backend gera hash e persiste `senha_hash`. Credenciais reais permanecem em variáveis de ambiente.

## Menus, rodapés e páginas futuras

Quando modelos `Nxx`, `Fxx`, `SOBxx`, `CTxx` e `BTNxx` forem criados, devem declarar seus contratos no registro do instalador. A reconciliação do menu deverá ser executada depois da instalação de qualquer página: ela identifica os papéis canônicos presentes na pasta e regenera os links automaticamente, sem pedir que o usuário edite `href`, classes ou JavaScript.

## Demonstrações

Toda demonstração segue um único padrão:

- preview do modelo;
- título simplificado acima do bloco;
- botão `Copiar código PowerShell`;
- script PowerShell autocontido completo.

Não deve haver instruções extensas de integração na tela de demonstração. A complexidade fica no instalador e na documentação técnica.
