# Instalação do Catálogo S

## Fluxo público

A instalação pública não depende mais do GitHub nem de `npx`.

Cada demonstração contém um bloco **PowerShell autocontido** com todo o payload necessário para instalar aquele modelo. O usuário copia o bloco inteiro e cola no PowerShell aberto na raiz do projeto.

O script:
- cria os arquivos do modelo localmente;
- cria backups em `.catalogo-s/backups/` antes de substituir arquivos;
- mantém componentes repetíveis em `components/catalogo-s/`;
- recompõe os componentes ao trocar a tela inicial;
- conecta qualquer tela `LG01`–`LG05` ao mesmo `DB01` quando os arquivos de backend existem;
- não baixa nenhum arquivo do repositório durante a instalação.

Cada modelo também guarda a mesma versão auditável em `instalar.ps1`.

## Ferramentas internas

`instalador/catalogo-s.mjs` e `instalador/modelos.json` permanecem como ferramentas internas de desenvolvimento, contrato e testes do Catálogo S. Eles não são requisito para quem instala um modelo pelo site.
