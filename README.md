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

Atualmente existem 144 demonstrações candidatas, de `A01` a `A144`.

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

## Regra de aprovação

A existência de um arquivo ou demonstração no repositório não significa aprovação.

Somente Kauã pode promover um candidato para modelo aprovado. Até isso acontecer, a IA deve tratar os efeitos `A01–A144` como opções disponíveis para análise e validação, não como preferências oficiais já consolidadas.
