# Arquitetura de instalação PowerShell autocontida — Catálogo S

## Estado

- Data: 2026-09-03
- Status: arquitetura pública migrada para PowerShell autocontido.
- Dependência pública do GitHub: nenhuma.
- Dependência pública de `npx`: nenhuma.
- Payload auditável por modelo: `instalar.ps1`.

## Regra central

> A demonstração precisa carregar tudo que o computador precisa para instalar o modelo.

O usuário não recebe um comando que baixa o Catálogo S. Ele recebe o script completo. Por isso, tornar o repositório privado não quebra instalações copiadas do site.

## Fluxo

```text
Demonstração na Vercel
        ↓
Copiar código PowerShell
        ↓
PowerShell aberto na raiz do projeto
        ↓
script autocontido
        ↓
arquivos locais do modelo
```

Nenhuma etapa exige autenticação no GitHub.

## Backups

Antes de substituir um arquivo existente, o instalador cria cópia em:

```text
.catalogo-s/backups/
```

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

## Slots

Telas iniciais recebem slots locais:

```html
<!-- CATALOGO-S:SLOT:MENU:START -->
<!-- CATALOGO-S:SLOT:MENU:END -->

<!-- CATALOGO-S:SLOT:COMPONENTES:START -->
<!-- CATALOGO-S:SLOT:COMPONENTES:END -->

<!-- CATALOGO-S:SLOT:RODAPE:START -->
<!-- CATALOGO-S:SLOT:RODAPE:END -->
```

`Exx`, `Cxx` e `Pxx` são componentes repetíveis. Cada execução cria:

```text
components/catalogo-s/<id>-<numero>.html
```

O script recompõe o slot `COMPONENTES` usando os arquivos locais. Assim, substituir `I01` por `I02`, por exemplo, não exige consultar manifesto remoto nem recuperar componentes do GitHub.

## Rodapés Fxx

`Fxx` é uma família singleton. O rodapé ativo fica em:

```text
components/catalogo-s/rodape/ativo.html
```

O instalador injeta o conteúdo no slot `CATALOGO-S:SLOT:RODAPE`. Instalar outro `Fxx` substitui somente esse arquivo e esse slot. Ao trocar uma tela inicial `Ixx`, o instalador recompõe o rodapé ativo a partir do arquivo local, preservando-o sem acesso remoto.

## LG01–LG05 ↔ DB01

Todas as telas `LGxx` usam:

```text
assets/js/catalogo-s.config.js
```

Ao instalar qualquer uma das telas `LG01`–`LG05`, o script verifica se os endpoints do `DB01` já existem. Ao instalar `DB01`, o script grava a configuração com os endpoints. Portanto as duas ordens continuam possíveis e trocar somente a interface de login não duplica o banco.

O `DB01` inclui no próprio script:

- `database/schema.sql`;
- `lib/catalogo-s-db.js`;
- `api/auth/login.js`;
- `api/auth/cadastro.js`;
- atualização de `.env.example`.

Dependências npm do backend podem ser instaladas pelo próprio script, mas isso não envolve o GitHub.

## Regra para todos os modelos

Cada pasta de modelo deve possuir:

```text
bloco-pronto.*
index.html
instalar.ps1
LEIA-ME.txt
```

`index.html` precisa mostrar o conteúdo completo de `instalar.ps1` e oferecer um único botão de cópia.

## Ferramentas internas

O CLI Node anterior pode permanecer no repositório como ferramenta interna de contrato e regressão. Ele não faz parte do caminho de instalação pública e não deve aparecer como instrução nas demonstrações.

## Validação

A CI deve rejeitar qualquer modelo ativo quando:

- faltar `instalar.ps1`;
- faltar bloco de código ou botão de cópia na demonstração;
- o script público contiver `npx`, `git clone` ou URL/chamada para o GitHub;
- o script não puder ser executado em um projeto temporário;
- a página do modelo não exibir exatamente o mesmo script salvo em `instalar.ps1`.

## Remoção da família de efeitos

A família `Axx` permanece removida. Os IDs não serão reutilizados.
