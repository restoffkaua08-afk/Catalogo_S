# Instalador do Catálogo S

Status: **experimental / fundação validada**.

Este diretório contém a próxima geração do fluxo de uso do Catálogo S. Em vez de copiar blocos de código manualmente, o usuário executará comandos na raiz do projeto e o instalador criará, substituirá e conectará os arquivos compatíveis.

## Comando público atual

Enquanto o CLI não estiver publicado em um registry próprio, ele pode ser executado diretamente do GitHub:

```bash
npx --yes github:restoffkaua08-afk/Catalogo_S#main add LG01
```

Exemplo DB01:

```bash
npx --yes github:restoffkaua08-afk/Catalogo_S#main add DB01
```

O projeto atualmente declara Node 24.x.

## Modelos já cobertos pela prova técnica

- `LG01` — cria `login.html`, registra a página e cria configuração compartilhada.
- `DB01` — cria schema, adaptador de banco e endpoints; ao encontrar LG01, atualiza automaticamente os endpoints usados pela tela.

A ordem LG01 → DB01 e DB01 → LG01 é testada por GitHub Actions.

## Estado local

O instalador cria:

```text
.catalogo-s/
├─ projeto.json
└─ backups/
```

`projeto.json` é a fonte de verdade local dos modelos instalados. Backups são gerados antes de arquivos gerenciados serem substituídos.

## Comandos internos atuais

```text
catalogo-s init
catalogo-s add <ID>
catalogo-s list
catalogo-s reconcile
catalogo-s doctor
```

## Próximas migrações

1. telas iniciais e páginas canônicas;
2. produtos, Sobre e Contato;
3. menus e rodapés com reconciliação automática;
4. componentes repetíveis;
5. efeitos;
6. troca da interface do Catálogo S para exibir comandos em vez de blocos de código.

A arquitetura completa está em `documentacao/ARQUITETURA-INSTALADOR-TERMINAL.md`.
