# Como adicionar um modelo

1. Escolha um ID não utilizado.
2. Dê um nome claro e neutro quanto ao negócio.
3. Crie uma pasta dentro de `frontend/` ou `backend/`.
4. Para modelos visuais, inclua um `index.html` que funcione isoladamente quando possível.
5. Adicione a entrada em `dados/catalogo.json`.
6. Atualize `dados/catalogo.js` para refletir o mesmo conteúdo do JSON.
7. Crie/atualize a nota do Obsidian usando exatamente o campo `obsidian`.
8. Teste o `index.html` principal e a demonstração individual.

## Estados sugeridos

- `Teste`
- `Aprovado`
- `Antigo`
- `Descontinuado`

Somente componentes realmente aprovados devem ser tratados pela IA como padrão preferencial.
