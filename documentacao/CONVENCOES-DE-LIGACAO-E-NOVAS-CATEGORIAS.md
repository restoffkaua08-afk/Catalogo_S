# Convenções de ligação e novas categorias — Catálogo S

## Estado

- Data: 2026-09-02
- Status: arquitetura definida; categorias criadas; modelos ainda não adicionados
- Objetivo: permitir que componentes do Catálogo S sejam combinados sem o usuário precisar descobrir manualmente onde alterar links, destinos, IDs e contratos de dados.

## 1. Novas categorias

Foram adicionadas ao catálogo:

- Login
- Banco de dados
- Rodapés
- Tela Sobre
- Tela Contato
- Menus
- Telas com botão

IDs reservados para os futuros modelos:

- `LG01`, `LG02`... — telas de login
- `DB01`, `DB02`... — banco/persistência relacionado ao login de mesmo número
- `F01`, `F02`... — rodapés
- `SOB01`, `SOB02`... — telas/seções Sobre
- `CT01`, `CT02`... — telas/seções Contato
- `N01`, `N02`... — menus e navegações
- `BTN01`, `BTN02`... — telas com botão

Os IDs existentes continuam imutáveis.

## 2. Login como página separada

Uma tela de login é diferente de uma seção comum. O usuário deve poder criar um arquivo separado, por exemplo:

```text
projeto/
├─ login.html
└─ index.html
```

O código pronto de cada `LGxx` deverá funcionar como uma página independente.

Todo modelo de login deve destacar claramente, no código copiável, o destino após autenticação:

```js
// ===== EDITE AQUI: TELA APÓS O LOGIN =====
const DESTINO_APOS_LOGIN = 'index.html';
```

Quando existir backend real, o endpoint também deve ficar destacado:

```js
// ===== EDITE AQUI: ENDPOINT DE LOGIN =====
const ENDPOINT_LOGIN = '/api/login';
```

Nenhum modelo aprovado deve esconder esses pontos em lógica difícil de localizar.

## 3. Pareamento Login ↔ Banco de dados

A numeração será pareada:

```text
LG01 ↔ DB01
LG02 ↔ DB02
LG03 ↔ DB03
```

O `DB01`, por exemplo, será o schema de referência do `LG01`.

Cada par deve compartilhar o mesmo contrato lógico de campos. Exemplo:

```text
LG01
- email
- senha

DB01
- email
- senha_hash
```

A senha é a única exceção proposital à igualdade literal dos nomes: uma senha nunca deve ser armazenada em texto puro. O formulário recebe `senha`; o backend transforma essa senha em hash e persiste `senha_hash`.

O modelo de banco deve fornecer no mínimo:

```text
backend/DB01-.../
├─ schema.sql
├─ bloco-pronto.sql
└─ LEIA-ME.txt
```

O SQL cria a estrutura de persistência. Ele não substitui o backend de autenticação: validação de senha, hashing, sessão e acesso ao banco precisam ocorrer no servidor, nunca diretamente no JavaScript público do navegador.

## 4. Regra global de IDs para seções

Para facilitar menus e botões, telas e seções reutilizáveis devem ter um `id` HTML simples, previsível e objetivo.

Exemplos preferidos:

```html
<section id="inicio">...</section>
<section id="sobre">...</section>
<section id="servicos">...</section>
<section id="produtos">...</section>
<section id="galeria">...</section>
<section id="contato">...</section>
<footer id="rodape">...</footer>
```

A ligação deve usar o `id`, não o nome visual da classe CSS.

Para seção na mesma página:

```html
<a href="#sobre">Sobre</a>
<a href="#contato">Contato</a>
```

Para outra página:

```html
<a href="sobre.html">Sobre</a>
<a href="contato.html">Contato</a>
```

Esta passa a ser uma convenção global para novos modelos. Os modelos antigos poderão ser revisados em lote antes da criação dos primeiros menus para receber âncoras coerentes sem quebrar o visual existente.

## 5. Menus

A categoria `Menus` poderá conter, entre outros:

- barra fixa no topo;
- barra superior normal;
- menu lateral fixo;
- menu lateral recolhível;
- menu sanduíche;
- menu fullscreen;
- navegação por âncoras;
- navegação entre páginas.

Todo modelo `Nxx` deve destacar uma área simples para editar os itens:

```html
<!-- ===== EDITE AQUI: ITENS DO MENU ===== -->
<a href="#inicio">Início</a>
<a href="#sobre">Sobre</a>
<a href="#contato">Contato</a>
```

O texto visível e o destino devem ficar lado a lado para reduzir erro de integração.

## 6. Rodapés

Os modelos `Fxx` poderão incluir diferentes combinações de:

- navegação secundária;
- contato;
- redes sociais;
- copyright;
- endereço;
- links legais;
- CTA final.

Quando o rodapé for linkável pelo menu, deve usar por padrão:

```html
<footer id="rodape">
```

## 7. Tela Sobre e Tela Contato

`SOBxx` e `CTxx` podem existir tanto como seção copiável quanto como página completa, desde que o `LEIA-ME.txt` deixe claro o modo de uso.

Âncoras padrão:

```text
SOBxx → id="sobre"
CTxx  → id="contato"
```

Quando forem páginas separadas, os exemplos de nome serão `sobre.html` e `contato.html`.

## 8. Telas com botão

A categoria `Telas com botão` será destinada a composições nas quais o CTA é parte central do design.

Poderá haver modelos com:

- 1 botão;
- 2 botões;
- vários botões;
- botão sobre imagem;
- botão lateral;
- botões de ação principal/secundária;
- layouts editoriais e promocionais.

Todo `BTNxx` deve destacar no código onde alterar o texto e o destino/ação.

Exemplo por link:

```html
<!-- ===== EDITE AQUI: TEXTO E DESTINO DO BOTÃO ===== -->
<a class="botao-principal" href="#contato">Falar conosco</a>
```

Exemplo por JavaScript:

```js
// ===== EDITE AQUI: AÇÃO DO BOTÃO =====
const TEXTO_BOTAO = 'Ver projeto';
const DESTINO_BOTAO = '#projetos';
```

A demonstração não deve esconder a ação em código minificado ou espalhado por vários arquivos.

## 9. Regra para blocos prontos

Além de serem autocontidos sempre que possível, os blocos futuros dessas categorias devem usar marcadores visíveis como:

```text
===== EDITE AQUI =====
```

Esses marcadores devem apontar para:

- links entre páginas;
- âncoras de seção;
- destino após login;
- endpoint de backend;
- nome/texto de botão;
- ação de botão;
- campos esperados pelo banco;
- outros valores que o usuário normalmente precise personalizar.

## 10. Próxima etapa

As categorias estão criadas vazias de propósito. A criação dos modelos será feita separadamente, categoria por categoria, para que cada candidato seja demonstrável, copiável e tecnicamente coerente antes de entrar no catálogo ativo.
