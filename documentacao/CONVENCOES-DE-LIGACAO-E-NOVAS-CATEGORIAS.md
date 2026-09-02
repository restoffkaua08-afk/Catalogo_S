# Convenções de ligação e categorias — Catálogo S

## Estado

- Data: 2026-09-02
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

A interface para o usuário é sempre um comando de terminal:

```bash
npx --yes github:restoffkaua08-afk/Catalogo_S#main add <ID>
```

Os arquivos `bloco-pronto.*` são fontes internas do modelo. Não é necessário copiá-los manualmente.

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

O instalador registra o projeto em `.catalogo-s/projeto.json` e usa marcadores `CATALOGO-S:SLOT:*` como áreas seguras de reconciliação. Antes de substituir conteúdo gerenciado, cria backup em `.catalogo-s/backups/`.

Componentes repetíveis são registrados como instâncias e podem coexistir. Páginas singleton são substituídas por papel sem apagar as instâncias já registradas.

## Login e banco

O pareamento continua por número:

```text
LG01 <-> DB01
LG02 <-> DB02
```

A ligação é automática pelo CLI. Para `LG01 + DB01`, o instalador cria a configuração compartilhada, schema, adaptador de banco e endpoints. A ordem de instalação não precisa ser fixa: se um dos dois estiver ausente, a integração fica pendente e é concluída na próxima reconciliação quando o par aparecer.

A senha nunca é persistida em texto puro. O formulário recebe `senha`; o backend gera hash e persiste `senha_hash`. Credenciais reais permanecem em variáveis de ambiente.

## Menus, rodapés e páginas futuras

Quando modelos `Nxx`, `Fxx`, `SOBxx`, `CTxx` e `BTNxx` forem criados, devem declarar seus contratos no registro do instalador. O CLI deve resolver destinos usando o manifesto e os papéis canônicos, e não texto visual ou nomes de classes CSS.

## Demonstrações

Toda demonstração segue um único padrão:

- preview do modelo;
- título simplificado acima do bloco;
- botão `Copiar`;
- comando de terminal.

Não deve haver instruções extensas de integração na tela de demonstração. A complexidade fica no instalador e na documentação técnica.
