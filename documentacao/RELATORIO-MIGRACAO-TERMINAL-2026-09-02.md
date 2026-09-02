# Relatório final — migração para instalação por terminal

Data: 2026-09-02

## Resultado

A migração do Catálogo S para instalação via terminal foi concluída.

- 43 demonstrações foram padronizadas e validadas.
- 43 modelos presentes no registro do instalador foram instalados individualmente em diretórios temporários durante a validação automática.
- A composição integrada `I01 + C01 + E01 + P01 + A01 + L01 + LG01 + DB01` passou pelo `doctor` sem inconsistências.
- A substituição `I01 -> I02` preservou os componentes já instalados.
- O pareamento `LG01 -> DB01` e a ordem inversa `DB01 -> LG01` foram validados.
- O comando público via `npx` foi executado em diretório vazio e criou corretamente uma tela `I03` e o manifesto do projeto.

Workflow de validação: `Teste integral do Catálogo S`, run `33657607407`, conclusão `success`.

## Interface das demonstrações

Todas as páginas de detalhe migradas usam o mesmo contrato visual:

1. preview do modelo;
2. título simplificado;
3. botão `Copiar`;
4. bloco com um único comando de terminal.

Foram removidos das áreas de instalação textos explicativos, status de candidato, botões extras para HTML/TXT/SQL e instruções manuais de linkagem.

## Instalação

Forma pública atual:

```bash
npx --yes github:restoffkaua08-afk/Catalogo_S#main add <ID>
```

O instalador cria os arquivos, registra `.catalogo-s/projeto.json`, cria backups quando substitui conteúdo gerenciado e executa a reconciliação automática.

## Publicação

A migração de conteúdo foi aplicada pelo commit `5c467ace5580a6931b570c6252dbd451929ba991`.

O workflow integral foi definido no commit `42539fee28eadf89e323deaacc611581ea6ad68a` e terminou com sucesso.

A documentação normativa foi atualizada posteriormente para refletir o estado integrado da arquitetura.
