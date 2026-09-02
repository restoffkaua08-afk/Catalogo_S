# Arquitetura de instalação por terminal — Catálogo S

## Estado

- Data: 2026-09-02
- Status: arquitetura oficial para a próxima geração do Catálogo S
- Objetivo: substituir o fluxo de copiar/colar blocos manualmente por instalação automática, composável e reversível via terminal.

## 1. Mudança de paradigma

O Catálogo S deixa de entregar ao usuário apenas HTML/CSS/JS/SQL para copiar manualmente.

Cada modelo passa a entregar um **comando de instalação**. O usuário abre o terminal na pasta do projeto e executa comandos como:

```text
catalogo-s add I01
catalogo-s add N01
catalogo-s add LG01
catalogo-s add DB01
```

A forma pública final do comando pode usar um bootstrap via `npx`/GitHub enquanto o CLI não estiver publicado como pacote estável. A semântica oficial é sempre `catalogo-s add <ID>`.

O instalador é responsável por:

1. detectar ou inicializar o projeto;
2. criar o arquivo correto;
3. gravar o código do modelo;
4. registrar o modelo instalado;
5. localizar modelos relacionados;
6. criar ou atualizar links entre arquivos;
7. reconciliar menus, rodapés, rotas, autenticação e dependências;
8. validar o resultado;
9. criar backup antes de substituir conteúdo existente.

O usuário não deve precisar descobrir manualmente qual arquivo editar para ligar dois modelos compatíveis.

---

## 2. Memória local do projeto

Todo projeto gerenciado pelo Catálogo S terá:

```text
.catalogo-s/
├─ projeto.json
└─ backups/
```

`projeto.json` é a fonte de verdade local sobre o que foi instalado.

Exemplo conceitual:

```json
{
  "schema": 1,
  "modelos": {
    "I01": { "tipo": "pagina", "papel": "inicio", "arquivo": "index.html" },
    "SOB01": { "tipo": "pagina", "papel": "sobre", "arquivo": "sobre.html" },
    "N01": { "tipo": "componente-global", "papel": "menu" },
    "LG01": { "tipo": "pagina", "papel": "login", "arquivo": "login.html" },
    "DB01": { "tipo": "backend", "papel": "auth-db", "pareadoCom": "LG01" }
  }
}
```

O instalador consulta primeiro esse manifesto. Se ele estiver ausente ou incompleto, pode usar marcadores Catálogo S nos arquivos para reconstruir o estado.

---

## 3. Nomes canônicos de arquivos

Modelos do mesmo papel devem convergir para o mesmo nome de arquivo. Isso permite trocar o design sem quebrar as integrações.

### Páginas canônicas

| Papel | Arquivo padrão |
|---|---|
| início | `index.html` |
| produtos | `produtos.html` |
| sobre | `sobre.html` |
| contato | `contato.html` |
| login | `login.html` |

Um `I01`, `I02`, `I03` etc. instala/substitui o papel `inicio`, portanto trabalha com `index.html`.

Um `L01`, `L02`, `L03` etc. instala/substitui o papel `produtos`, portanto trabalha com `produtos.html` quando usado como página completa.

`SOBxx`, `CTxx` e `LGxx` seguem os arquivos canônicos acima.

### Arquivos técnicos canônicos

```text
assets/
├─ css/catalogo-s.css
├─ js/catalogo-s.js
└─ js/catalogo-s.config.js

api/
└─ auth/
   ├─ login.js
   └─ cadastro.js

lib/
└─ catalogo-s-db.js

database/
└─ schema.sql
```

Nem todo projeto terá todos esses arquivos. Eles aparecem quando um modelo realmente precisa deles.

---

## 4. Identidade técnica das páginas

Além do nome canônico, páginas criadas pelo Catálogo S recebem marcadores que não dependem do texto visível ou das classes de estilo.

Exemplo:

```html
<html data-catalogo-s-page="inicio" data-catalogo-s-model="I01">
```

Seções instaladas dentro de uma página recebem:

```html
<section data-catalogo-s-section="sobre" data-catalogo-s-model="SOB01" id="sobre">
```

O instalador nunca deve depender de um título como “Sobre nós” para entender o papel da seção.

---

## 5. Slots de composição

Arquivos gerenciados recebem pontos seguros de edição.

Exemplo:

```html
<!-- CATALOGO-S:SLOT:MENU:START -->
<!-- CATALOGO-S:SLOT:MENU:END -->

<!-- CATALOGO-S:SLOT:CONTEUDO:START -->
<!-- CATALOGO-S:SLOT:CONTEUDO:END -->

<!-- CATALOGO-S:SLOT:RODAPE:START -->
<!-- CATALOGO-S:SLOT:RODAPE:END -->
```

Esses marcadores permitem ao CLI substituir somente a área que pertence ao Catálogo S, preservando o restante do arquivo.

Antes de qualquer substituição, o instalador cria backup em `.catalogo-s/backups/`.

---

## 6. Tipos de instalação

### 6.1 Singleton por papel

Só existe um ativo por papel no projeto.

Exemplos:

- tela inicial;
- página de produtos principal;
- login;
- menu global;
- rodapé global;
- banco pareado ao login.

Instalar outro modelo do mesmo papel substitui o anterior depois de criar backup e atualizar o manifesto.

### 6.2 Repetível

Pode haver vários no mesmo projeto.

Exemplos:

- carrosséis;
- seções genéricas;
- blocos com botão;
- alguns efeitos;
- galerias.

O manifesto registra uma instância para cada inserção.

---

## 7. Reconciliação automática

Depois de qualquer `add`, `replace` ou `remove`, o CLI executa uma etapa de **reconciliação**.

A reconciliação verifica todos os modelos instalados e atualiza dependências automaticamente.

### Exemplo: menu

Se `N01` estiver instalado, o CLI consulta as páginas registradas:

```text
index.html     → Início
produtos.html  → Produtos
sobre.html     → Sobre
contato.html   → Contato
```

E gera os itens do menu automaticamente.

Se `sobre.html` for instalado depois do menu, o menu é regenerado sem o usuário editar HTML.

### Exemplo: rodapé

Se `F01` estiver instalado, novas páginas recebem o rodapé automaticamente na próxima reconciliação.

### Exemplo: botões

Um `BTNxx` pode declarar um destino sem conhecer o caminho físico. Exemplo lógico:

```text
destino: contato
```

O reconciliador resolve `contato` para `contato.html` ou `#contato`, de acordo com a estrutura registrada do projeto.

---

## 8. Login e banco de dados

A ligação oficial deixa de depender de edição manual do HTML.

### LG01

Ao instalar `LG01`, o CLI cria:

```text
login.html
assets/js/catalogo-s.config.js
```

A tela consulta a configuração central, em vez de exigir que o usuário procure constantes espalhadas no HTML.

### DB01

Ao instalar `DB01`, o CLI:

1. verifica se `LG01` está instalado;
2. valida o contrato de campos;
3. cria `database/schema.sql`;
4. cria o adaptador/backend previsto pelo modelo;
5. cria/atualiza `.env.example` quando necessário;
6. atualiza `assets/js/catalogo-s.config.js` com os endpoints corretos;
7. registra `LG01 ↔ DB01` no manifesto;
8. valida se as rotas e arquivos esperados existem.

Fluxo:

```text
login.html
   ↓
assets/js/catalogo-s.config.js
   ↓
/api/auth/login + /api/auth/cadastro
   ↓
lib/catalogo-s-db.js
   ↓
database/schema.sql / banco configurado
```

O instalador pode automatizar a ligação de arquivos, nomes de rotas e dependências locais. Credenciais reais de serviços externos ou do banco continuam sendo fornecidas pelo usuário em variáveis de ambiente; elas nunca são inventadas ou gravadas no catálogo.

---

## 9. Contratos de modelo

Cada modelo passa a ter metadados de instalação, além da demonstração visual.

Exemplo conceitual:

```json
{
  "id": "LG01",
  "tipo": "pagina",
  "papel": "login",
  "target": "login.html",
  "singleton": true,
  "fornece": ["auth-ui"],
  "compatibilidade": {
    "bancoPreferido": "DB01"
  }
}
```

Exemplo DB01:

```json
{
  "id": "DB01",
  "tipo": "backend",
  "papel": "auth-db",
  "singleton": true,
  "requer": ["LG01"],
  "pareadoCom": "LG01",
  "grava": [
    "database/schema.sql",
    "api/auth/login.js",
    "api/auth/cadastro.js",
    "lib/catalogo-s-db.js"
  ]
}
```

O instalador usa contratos; não tenta adivinhar dependências pelo nome visual do modelo.

---

## 10. Comandos do CLI

Interface planejada:

```text
catalogo-s init
catalogo-s add LG01
catalogo-s add DB01
catalogo-s add N01
catalogo-s remove N01
catalogo-s replace I01 I03
catalogo-s list
catalogo-s doctor
catalogo-s reconcile
```

### `doctor`

Verifica:

- arquivos canônicos ausentes;
- manifesto divergente;
- slots quebrados;
- dependências ausentes;
- links para páginas inexistentes;
- login sem backend quando configurado como real;
- banco incompatível com o login instalado;
- arquivos modificados fora das áreas gerenciadas quando isso comprometer uma atualização.

---

## 11. Experiência no site do Catálogo S

A página de cada modelo deixa de priorizar “Copiar HTML”.

O fluxo principal passa a ser:

1. visualizar a demonstração;
2. ver “O que este modelo cria/altera”;
3. copiar **um comando de terminal**;
4. executar na raiz do projeto.

Exemplo conceitual:

```text
catalogo-s add LG01
```

Para modelos que possuem dependência, a interface mostra isso de forma curta:

```text
DB01
Pareado: LG01
Cria: database/schema.sql + backend de autenticação
Integração: automática
```

O código-fonte continua existindo no repositório para auditoria e manutenção, mas deixa de ser a principal interface de instalação para o usuário final.

---

## 12. Migração do catálogo atual

A migração será feita nesta ordem:

1. criar núcleo do instalador;
2. criar manifesto/contrato de modelos;
3. migrar `LG01` e `DB01` como prova completa de integração;
4. migrar páginas canônicas (`Ixx`, `Lxx`, `SOBxx`, `CTxx`);
5. migrar componentes globais (`Nxx`, `Fxx`);
6. migrar blocos repetíveis (`Cxx`, `Exx`, `BTNxx`, `Pxx`);
7. migrar efeitos;
8. trocar as páginas do catálogo de “copiar código” para “copiar comando”;
9. executar `doctor` sobre todos os modelos e cenários de ordem de instalação.

Nenhum modelo antigo perde seu ID.

---

## 13. Regra central

> O usuário escolhe modelos. O Catálogo S resolve arquivos, nomes, slots, rotas e ligações.

Quando uma integração puder ser determinada com segurança pelo contrato dos modelos, ela deve ser automática.

Quando houver informação impossível de inferir — por exemplo uma credencial de banco, domínio externo ou chave de API — o instalador deve pedir somente esse dado específico, sem mandar o usuário editar vários arquivos manualmente.
