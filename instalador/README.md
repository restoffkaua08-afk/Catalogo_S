# Instalador do Catálogo S

Status: **integrado**.

Todos os modelos existentes são instalados pelo mesmo comando:

```bash
npx --yes github:restoffkaua08-afk/Catalogo_S#main add <ID>
```

O CLI cria `.catalogo-s/projeto.json`, mantém backups, usa nomes canônicos de páginas e reconcilia automaticamente componentes e integrações compatíveis. Telas iniciais usam `index.html`, listagens usam `produtos.html`, login usa `login.html`, e componentes repetíveis são registrados em `components/catalogo-s/`.

Comandos: `init`, `add <ID>`, `list`, `reconcile` e `doctor`.
