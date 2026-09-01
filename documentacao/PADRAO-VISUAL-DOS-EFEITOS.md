# Padrão visual da biblioteca de efeitos

## Objetivo

A biblioteca de efeitos do Catálogo S usa uma composição visual fixa para que efeitos diferentes possam ser comparados sem que o conteúdo da demonstração interfira na percepção do resultado.

## Situação dos efeitos

Os efeitos `A01` até `A144` foram criados como **candidatos**.

Eles não representam preferência oficial de Kauã até que exista aprovação explícita.

Fluxo:

Candidato → validação visual → ajustes → aprovação explícita → modelo aprovado.

## Área de demonstração

A primeira área de cada página deve ocupar aproximadamente uma viewport inteira.

Cor-base atual:

```css
background: #393c41;
```

O cinza é proposital: deve ser escuro o suficiente para revelar brilhos, halos e transparências, mas claro o suficiente para tornar sombras e relevo visíveis.

Não trocar automaticamente essa área para preto, branco ou fundo decorativo específico sem necessidade técnica ou solicitação explícita.

## Composição dos três círculos

Toda demonstração usa três círculos como objeto visual padrão:

- círculo 1: centralizado acima;
- círculo 2: abaixo à esquerda;
- círculo 3: abaixo à direita.

A composição lembra visualmente um focinho de cachorro e permite observar o efeito em mais de um elemento ao mesmo tempo.

O efeito demonstrado deve ser aplicado prioritariamente aos círculos ou ao espaço diretamente relacionado a eles.

Mesmo efeitos de interação, profundidade, iluminação, scroll, máscara, textura ou movimento devem preservar os três círculos como referência visual sempre que tecnicamente possível.

## Área técnica

Após a demonstração, a página retorna ao padrão escuro do Catálogo S:

```css
background: #08090c;
```

A área técnica deve conter:

- ID e nome;
- família do efeito;
- situação de candidato;
- código completo necessário para a demonstração reutilizável;
- botão `Copiar código`;
- indicação de que o código é escopado pelo identificador do efeito.

## Escopo do código

Cada efeito utiliza um wrapper próprio:

```text
#efeito-a01
#efeito-a02
...
#efeito-a144
```

O objetivo é reduzir colisões de CSS quando o trecho for copiado para outro documento.

Evitar regras globais destrutivas dentro do bloco copiável.

## Movimento e acessibilidade

Páginas com transições ou animações devem considerar `prefers-reduced-motion`.

A demonstração pode utilizar JavaScript quando o efeito realmente depende de cursor, clique, scroll ou outra interação, mas não deve adicionar dependências desnecessárias.

## Identificadores

A família `A` representa animações e efeitos visuais.

Os IDs atuais vão de `A01` a `A144`.

Um ID não deve ser reutilizado para outro efeito diferente.

## Aprovação

A geração das demonstrações não equivale a aprovação.

Somente Kauã pode declarar um efeito aprovado.

Até a aprovação, os registros devem continuar com:

```text
situacao: Candidato
```

Uma IA pode sugerir melhorias ou variantes, mas não deve promover um candidato por conta própria.

## Integração com o índice principal

O filtro `Efeitos` no `index.html` principal lê `dados/efeitos.js`.

Os efeitos ficam separados dos seis modelos atualmente aprovados. Assim, abrir o catálogo sem selecionar `Efeitos` não mistura candidatos com a biblioteca oficial.

## Fonte operacional

- Metadados: `dados/efeitos.json`
- Dados para uso local via `file://`: `dados/efeitos.js`
- Demonstrações: `efeitos/Axx-.../index.html`

Esta documentação descreve o padrão da biblioteca; cada página continua sendo a fonte executável de sua própria demonstração.
