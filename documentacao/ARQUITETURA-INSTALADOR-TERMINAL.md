# Arquitetura de instalação por terminal — Catálogo S

## Estado

- Data: 2026-09-02
- Status: **integrada e validada** para todos os modelos existentes no repositório.
- CLI: `instalador/catalogo-s.mjs`, schema de manifesto 2.
- Registro: `instalador/modelos.json`.

## Regra central

> O usuário escolhe modelos. O Catálogo S resolve arquivos, nomes, slots, rotas e ligações.

O fluxo de uso não é mais copiar HTML/CSS/JS/SQL manualmente. A demonstração entrega um comando:

```bash
npx --yes github:restoffkaua08-afk/Catalogo_S#main add <ID>
```

O código-fonte permanece auditável em `bloco-pronto.*`, mas funciona como payload interno do instalador.

## Estado local e segurança de alterações

Cada projeto recebe:

```text
.catalogo-s/
├─ projeto.json
└─ backups/
```

`projeto.json` registra páginas, modelos e instâncias. O CLI cria backup antes de substituir um arquivo gerenciado cujo conteúdo mudou.

## Páginas canônicas

| Papel | Arquivo |
|---|---|
| início | `index.html` |
| produtos | `produtos.html` |
| sobre | `sobre.html` |
| contato | `contato.html` |
| login | `login.html` |

Atualmente:

- `Ixx` instala/substitui `index.html`;
- `Lxx` instala/substitui `produtos.html`;
- `LGxx` instala/substitui `login.html`.

Novos `SOBxx` e `CTxx` deverão seguir os nomes canônicos acima.

## Identidade técnica e slots

Páginas gerenciadas recebem identidade independente do texto visual:

```html
<html data-catalogo-s-page="inicio" data-catalogo-s-model="I01">
```

E áreas seguras de composição:

```html
<!-- CATALOGO-S:SLOT:MENU:START -->
<!-- CATALOGO-S:SLOT:MENU:END -->

<!-- CATALOGO-S:SLOT:COMPONENTES:START -->
<!-- CATALOGO-S:SLOT:COMPONENTES:END -->

<!-- CATALOGO-S:SLOT:RODAPE:START -->
<!-- CATALOGO-S:SLOT:RODAPE:END -->
```

O reconciliador modifica somente áreas que pertencem ao Catálogo S.

## Singleton e componentes repetíveis

Páginas de um mesmo papel são singleton. Instalar `I02` depois de `I01`, por exemplo, troca a tela inicial canônica.

`Exx`, `Cxx` e `Pxx` são tratados como componentes repetíveis. Cada instalação cria uma instância em:

```text
components/catalogo-s/<id>-<numero>.html
```

As instâncias são reconciliadas no `index.html`. Trocar a tela inicial não apaga componentes já registrados.

## Reconciliação automática

Depois de cada `add` ou `reconcile`, o CLI lê o manifesto e recalcula as ligações que podem ser determinadas com segurança.

A ordem de instalação pode ser invertida quando o contrato permite. Uma dependência ausente fica registrada como pendente e é resolvida quando o modelo relacionado aparecer.

Essa mesma regra é a base para futuros menus, rodapés, Sobre, Contato e botões: esses modelos devem consultar papéis e slots, não tentar adivinhar arquivos por texto visual.

## LG01 ↔ DB01

A autenticação usa o fluxo:

```text
login.html
   ↓
assets/js/catalogo-s.config.js
   ↓
api/auth/login.js + api/auth/cadastro.js
   ↓
lib/catalogo-s-db.js
   ↓
database/schema.sql / banco configurado
```

`LG01` cria a tela e a configuração compartilhada. `DB01` cria schema, adaptador e endpoints. Quando os dois estão presentes, o CLI configura os endpoints automaticamente.

A ordem `LG01 → DB01` e `DB01 → LG01` é suportada. Credenciais reais do banco não são inventadas nem colocadas no frontend; `.env.example` apenas registra o formato esperado. Senhas são persistidas somente como hash.

## Contratos de modelo

`instalador/modelos.json` é o registro técnico usado pelo CLI. Cada entrada informa no mínimo:

```json
{
  "id": "I01",
  "nome": "...",
  "papel": "inicio",
  "modo": "pagina",
  "template": ".../bloco-pronto.html",
  "target": "index.html"
}
```

Ou, para componente:

```json
{
  "id": "C01",
  "papel": "carrossel",
  "modo": "componente",
  "template": ".../bloco-pronto.html",
  "destino": "inicio"
}
```

Backend pode declarar arquivos adicionais e pareamentos.

## Comandos

```text
catalogo-s init
catalogo-s add <ID>
catalogo-s list
catalogo-s reconcile
catalogo-s doctor
```

Durante o bootstrap público, a semântica é executada via `npx` diretamente do GitHub.

`doctor` verifica arquivos registrados, instâncias, configuração de login e artefatos esperados pelo backend.

## Demonstrações

Todas as páginas de demonstração foram padronizadas. A primeira área contém somente o preview visual. A área de instalação contém somente:

1. título simplificado;
2. botão `Copiar`;
3. bloco com o comando do modelo.

Textos explicativos, status, múltiplos botões de código e instruções manuais de linkagem foram removidos das demonstrações. Informação técnica detalhada permanece na documentação e nos fontes internos.

## Validação

O workflow `.github/workflows/teste-instalador.yml` valida automaticamente:

- todas as demonstrações padronizadas;
- instalação isolada de cada modelo registrado;
- composição de páginas e componentes;
- substituição de tela inicial preservando componentes;
- pareamento `LG01 ↔ DB01` nas duas ordens;
- execução pública do comando via `npx`.

Novos modelos só devem entrar como instaláveis quando respeitarem esses contratos e passarem pelo mesmo conjunto de validações.


## Remoção da família de efeitos

Em 2026-09-02, a categoria `Fundos e telas` e toda a família `Axx` foram removidas do catálogo ativo, do registro do instalador e do código-fonte atual. Esses modelos não seguiam o padrão adotado de construção composável por páginas, seções, componentes funcionais e integrações. O histórico Git permanece como única fonte de recuperação.
