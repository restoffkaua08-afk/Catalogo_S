# Catálogo S

Biblioteca pessoal de componentes reutilizáveis de frontend, backend e efeitos visuais.

## Regra da interface principal

O catálogo deve ser produtivo e simples. A página principal mostra somente:

- título e descrição curta;
- filtros: Backend, Frontend, Telas, Carrosséis e Efeitos;
- cards simples com ID + nome do modelo.

Não adicionar busca, favoritos, métricas, badges, descrições longas, status visuais ou enfeites na página principal sem solicitação explícita.

## Uso

Abra `index.html` diretamente no navegador.

Cada modelo aprovado possui uma página própria com:

1. demonstração;
2. código pronto para copiar;
3. botão de cópia;
4. `bloco-pronto.html` e `bloco-pronto.txt` quando aplicável.

Os nomes e IDs devem permanecer iguais aos usados no Obsidian.

## Modelos aprovados atuais

- E01 — Seção de Navegação Visual
- C01 — Carrossel de Destaques
- E02 — Seção de Destaque Lateral
- C02 — Carrossel Compacto Lateral
- C03 — Carrossel Orbital 3D
- E03 — Seção de Galeria Sobreposta

Total aprovado: 6 modelos.

## Biblioteca de efeitos

A família `A` representa animações e efeitos visuais reutilizáveis.

Atualmente existem **75 efeitos candidatos ativos**, selecionados a partir da primeira pesquisa de 144 ideias.

Esses efeitos **não são modelos aprovados automaticamente**. Eles permanecem com situação `Candidato` até validação e aprovação explícita de Kauã.

Cada efeito possui um `index.html` independente com:

1. área de demonstração em cinza-escuro;
2. três círculos em composição triangular para representar o efeito;
3. área técnica preta;
4. código do efeito;
5. botão para copiar o código;
6. suporte a `prefers-reduced-motion` quando há movimento.

Os registros operacionais da biblioteca ficam em:

- `dados/efeitos.json`
- `dados/efeitos.js`
- `efeitos/Axx-.../index.html`

O padrão visual e as regras de validação estão documentados em `documentacao/PADRAO-VISUAL-DOS-EFEITOS.md`.

## Subfiltros dos efeitos

Ao clicar no filtro principal `Efeitos`, a interface mostra abaixo dele botões com as famílias já registradas nos próprios efeitos.

Esses botões são gerados automaticamente a partir do campo `familia` de `dados/efeitos.js`. Assim, as categorias exibidas sempre acompanham a organização real da biblioteca e não precisam ser duplicadas manualmente no `index.html`.

Ao selecionar uma família, somente os efeitos daquela categoria são exibidos. Clicar novamente na mesma família remove o subfiltro e volta a mostrar todos os efeitos.

Ao sair do filtro `Efeitos`, os subfiltros são ocultados automaticamente.

## Regra de aprovação

A existência de um arquivo ou demonstração no repositório não significa aprovação.

Somente Kauã pode promover um candidato para modelo aprovado. Até isso acontecer, a IA deve tratar os efeitos `A01–A144` como opções disponíveis para análise e validação, não como preferências oficiais já consolidadas.

## Curadoria da biblioteca de efeitos

A primeira versão gerou 144 candidatos. Após revisão, a biblioteca principal foi reduzida para **75 efeitos ativos**. Os demais não foram reutilizados com novos IDs: foram registrados em `dados/efeitos-arquivados.json` para preservar histórico sem poluir a navegação.

As demonstrações deixaram de usar três círculos universais. Agora cada efeito recebe um contexto coerente: fundos ocupam o fundo, tipografia usa texto, scroll usa uma viewport rolável, 3D usa uma cena em perspectiva, mouse usa elementos interativos, e assim por diante.

O fundo externo das demonstrações é preto. Elementos internos podem usar cinza ou outras cores somente quando isso é necessário para tornar sombra, transparência, contraste ou material perceptível.
