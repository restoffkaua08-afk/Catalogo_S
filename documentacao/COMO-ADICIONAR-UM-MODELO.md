# Como adicionar um modelo ao Catálogo S

Todo modelo precisa de:

1. ID estável;
2. `bloco-pronto.html` ou payload equivalente;
3. `index.html` de demonstração;
4. `instalar.ps1` autocontido;
5. registro técnico interno quando aplicável.

## Regra obrigatória da demonstração

A primeira área mostra o preview visual. A área seguinte precisa conter:

- título do modelo;
- botão `Copiar código PowerShell`;
- bloco com o script PowerShell completo.

Não usar `npx github:...`, `git clone`, `Invoke-WebRequest` para o repositório, API do GitHub ou qualquer outra dependência de acesso ao repositório.

O código copiado precisa continuar funcionando mesmo se o repositório do Catálogo S estiver privado e o computador não estiver autenticado na conta do proprietário.

## Padrão de instalação

- páginas canônicas escrevem seus arquivos (`index.html`, `produtos.html`, `login.html`);
- componentes repetíveis são criados em `components/catalogo-s/` e inseridos no slot de componentes;
- arquivos existentes recebem backup antes da substituição;
- integrações devem ser resolvidas por presença de arquivos/contratos locais, nunca por acesso ao GitHub.
