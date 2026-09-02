from pathlib import Path
import json
import shutil

ROOT = Path(__file__).resolve().parents[1]

# 1) Remove toda a família antiga de efeitos/modelos Axx.
effects = ROOT / 'efeitos'
if effects.exists():
    shutil.rmtree(effects)

for relative in [
    'dados/efeitos.json',
    'dados/efeitos.js',
    'dados/efeitos-arquivados.json',
    'documentacao/BIBLIOTECA-DE-EFEITOS.md',
    'documentacao/PADRAO-VISUAL-DOS-EFEITOS.md',
]:
    p = ROOT / relative
    if p.exists():
        p.unlink()

# 2) Remove a categoria Fundos e telas dos metadados públicos.
categories_file = ROOT / 'dados/categorias.json'
categories = json.loads(categories_file.read_text(encoding='utf-8'))
categories['categorias'] = [
    cat for cat in categories.get('categorias', [])
    if cat.get('slug') != 'fundos-e-telas'
]
categories['quantidade'] = len(categories['categorias'])
categories['versao'] = '2.1.0'
categories['atualizadoEm'] = '2026-09-02'
categories_file.write_text(
    json.dumps(categories, ensure_ascii=False, separators=(',', ':')),
    encoding='utf-8'
)
(ROOT / 'dados/categorias.js').write_text(
    'window.CATALOGO_CATEGORIAS=' + json.dumps(categories, ensure_ascii=False, separators=(',', ':')) + ';\n',
    encoding='utf-8'
)

# 3) Axx deixa de existir também no instalador.
registry_file = ROOT / 'instalador/modelos.json'
registry = json.loads(registry_file.read_text(encoding='utf-8'))
registry['modelos'] = {
    mid: model for mid, model in registry.get('modelos', {}).items()
    if not mid.startswith('A')
}
registry['geradoEm'] = '2026-09-02'
registry_file.write_text(json.dumps(registry, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# 4) Impede a migração automática de recriar a família removida.
migration_file = ROOT / 'tools/migrate_terminal_catalog.py'
migration = migration_file.read_text(encoding='utf-8')
migration = migration.replace(
    "    'E':'telas','L':'listagens','P':'pesquisa','A':'fundos-e-telas'\n",
    "    'E':'telas','L':'listagens','P':'pesquisa'\n"
)
migration = migration.replace("    'A':('componente','efeito',''),\n", '')
migration = migration.replace("for base in (ROOT/'frontend',ROOT/'efeitos'):", "for base in (ROOT/'frontend',):")
migration_file.write_text(migration, encoding='utf-8')

# 5) Documentação ativa acompanha a nova regra.
readme_file = ROOT / 'README.md'
readme = readme_file.read_text(encoding='utf-8')
readme = readme.replace(
    '- `Exx`, `Cxx`, `Pxx` e `Axx` → componentes repetíveis integrados ao projeto',
    '- `Exx`, `Cxx` e `Pxx` → componentes repetíveis integrados ao projeto'
)
readme_file.write_text(readme, encoding='utf-8')

ids_file = ROOT / 'documentacao/CONVENCAO-DE-IDS.md'
ids = ids_file.read_text(encoding='utf-8')
ids = ids.replace('- `A` — animação ou efeito visual\n', '')
if '## Prefixo A retirado' not in ids:
    ids += '\n## Prefixo A retirado\n\nA família `Axx` foi retirada do Catálogo S em 2026-09-02 por não corresponder ao padrão atual de construção composável de sites. IDs antigos continuam recuperáveis apenas pelo histórico Git e não devem ser reutilizados para outra finalidade.\n'
ids_file.write_text(ids, encoding='utf-8')

arch_file = ROOT / 'documentacao/ARQUITETURA-INSTALADOR-TERMINAL.md'
arch = arch_file.read_text(encoding='utf-8')
arch = arch.replace('`Exx`, `Cxx`, `Pxx` e `Axx` são tratados como componentes repetíveis.', '`Exx`, `Cxx` e `Pxx` são tratados como componentes repetíveis.')
if '## Remoção da família de efeitos' not in arch:
    arch += '\n\n## Remoção da família de efeitos\n\nEm 2026-09-02, a categoria `Fundos e telas` e toda a família `Axx` foram removidas do catálogo ativo, do registro do instalador e do código-fonte atual. Esses modelos não seguiam o padrão adotado de construção composável por páginas, seções, componentes funcionais e integrações. O histórico Git permanece como única fonte de recuperação.\n'
arch_file.write_text(arch, encoding='utf-8')

report_file = ROOT / 'documentacao/RELATORIO-MIGRACAO-TERMINAL-2026-09-02.md'
if report_file.exists():
    report = report_file.read_text(encoding='utf-8')
    if '## Ajuste posterior — família Axx removida' not in report:
        report += '\n\n## Ajuste posterior — família Axx removida\n\nApós a validação inicial de 43 modelos, os 22 modelos `Axx` de efeitos foram retirados por decisão de arquitetura. O registro operacional passa a conter 21 modelos. A categoria `Fundos e telas`, seus dados, documentação específica e fontes atuais foram removidos; o histórico Git preserva as versões anteriores.\n'
    report_file.write_text(report, encoding='utf-8')

print(f"Categorias restantes: {len(categories['categorias'])}")
print(f"Modelos restantes no instalador: {len(registry['modelos'])}")
