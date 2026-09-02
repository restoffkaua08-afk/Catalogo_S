# Catálogo S

Biblioteca pessoal de componentes, pesquisas e efeitos reutilizáveis.

## Modelos aprovados

Os modelos oficialmente aprovados continuam sendo E01, C01, E02, C02, C03 e E03.

Candidatos não entram na contagem oficial até aprovação explícita de Kauã.

## Pesquisas

A família `P` representa componentes de pesquisa.

Atualmente existem 4 candidatos:

- `P01` — Barra de Pesquisa Minimalista em Linha
- `P02` — Barra de Pesquisa em Bloco
- `P03` — Barra de Pesquisa em Vidro Fosco
- `P04` — Barra de Pesquisa Expansível

Cada candidato possui `index.html`, `bloco-pronto.html`, `bloco-pronto.txt` e `LEIA-ME.txt`.

Os registros operacionais ficam em:

- `dados/pesquisas.json`
- `dados/pesquisas.js`

Na interface principal, o filtro `Pesquisa` mostra somente esses candidatos, mantendo-os separados dos modelos aprovados.

## Efeitos ativos

A biblioteca de efeitos está reduzida a 22 candidatos, divididos somente em: Fundos e telas, Ícones, Sombras e Elevação no hover.

O objetivo é qualidade e utilidade, não quantidade. Os efeitos removidos permanecem recuperáveis pelo histórico Git, mas não fazem parte da biblioteca ativa.

Cada efeito ativo possui `index.html`, `bloco-pronto.html` e `bloco-pronto.txt`.

## Listagens de produtos

A família `L` representa padrões completos de listagem de produtos / PLP para e-commerce.

Existem 4 candidatos:

- `L01` — Listagem MR em Grade com Filtro Compacto — adaptação standalone da listagem real do `mr-commerce-platform`.
- `L02` — Listagem Facetada com Barra Lateral Instantânea — filtros de checkbox em sidebar e atualização imediata.
- `L03` — Listagem Horizontal Comparativa — linhas com especificações para comparação técnica.
- `L04` — Grade Editorial com Filtros em Drawer — cards visuais, chips e painel lateral animado.

Cada candidato possui `index.html`, `bloco-pronto.html`, `bloco-pronto.txt` e `LEIA-ME.txt`. Os registros operacionais ficam em `dados/listagens.json` e `dados/listagens.js`.

Os quatro permanecem como **Candidatos** e não alteram a contagem dos 6 modelos oficiais aprovados.


## Autenticação na Vercel

O repositório inclui uma camada stateless de autenticação por e-mail para deploy na Vercel. A lista de e-mails autorizados e os segredos ficam em variáveis de ambiente, nunca no frontend. Consulte `documentacao/AUTENTICACAO-E-DEPLOY-VERCEL.md`.
