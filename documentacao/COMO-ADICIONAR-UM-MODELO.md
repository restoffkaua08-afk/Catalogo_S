# Como adicionar um modelo ao Catálogo S

Todo modelo precisa de ID estável, `bloco-pronto.html`, `index.html` de demonstração e contrato no instalador. O código apresentado ao usuário é sempre um comando `catalogo-s add <ID>`, nunca um bloco manual para colar em arquivos.

Páginas usam nomes canônicos; componentes repetíveis são adicionados ao manifesto e reconciliados no slot `CATALOGO-S:SLOT:COMPONENTES`; integrações entre modelos devem ser resolvidas pelo CLI.
