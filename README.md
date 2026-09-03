# Catálogo S

Biblioteca visual de modelos reutilizáveis de frontend e backend.

## Uso atual

Abra a demonstração do modelo desejado. Abaixo do preview existe um bloco com **todo o script PowerShell de instalação**.

1. clique em **Copiar código PowerShell**;
2. abra o PowerShell na pasta raiz do seu projeto;
3. cole o bloco inteiro;
4. execute.

Esse é o fluxo oficial.

O script é autocontido: o payload necessário do modelo já está dentro dele. A instalação pública não usa `npx`, não busca arquivos no GitHub e não exige que o computador esteja conectado à conta que possui o repositório.

## Comportamento

- páginas equivalentes usam nomes canônicos;
- arquivos substituídos recebem backup em `.catalogo-s/backups/`;
- componentes repetíveis ficam em `components/catalogo-s/`;
- ao trocar a tela inicial, os componentes locais existentes são recompostos;
- `LG01`–`LG05` detectam o `DB01` pelos mesmos arquivos locais;
- credenciais reais continuam fora do frontend.

## Convenções principais

- `Ixx` → tela inicial → `index.html`
- `Lxx` → página de produtos → `produtos.html`
- `LGxx` → login → `login.html`
- `Exx`, `Cxx` e `Pxx` → componentes repetíveis
- `DB01` → backend de autenticação compartilhado por `LG01`–`LG05`

## Demonstrações

Toda demonstração deve possuir preview, título, botão de cópia e script PowerShell completo. Um modelo sem bloco de instalação é considerado incompleto.

## Status

Os seis modelos historicamente aprovados continuam: `E01`, `C01`, `E02`, `C02`, `C03` e `E03`. Os demais mantêm seus IDs e status anteriores.

A interface pública continua hospedada na Vercel. O GitHub permanece como fonte de desenvolvimento do Catálogo S, mas não é dependência de execução dos scripts copiados pelo usuário.
