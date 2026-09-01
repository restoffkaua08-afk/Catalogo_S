from pathlib import Path
import html
import json
import re
import shutil
import subprocess

ROOT = Path('.')
FRONT = ROOT / 'frontend'
DATA = ROOT / 'dados'
DOC = ROOT / 'documentacao'

MODELS = [
    {
        'id': 'L01',
        'nome': 'Listagem MR em Grade com Filtro Compacto',
        'folder': 'L01-Listagem-MR-em-Grade-com-Filtro-Compacto',
        'descricao': 'Grade de quatro colunas derivada da listagem real do projeto MR, com cards bordados, foto vertical, marca/categoria, favorito, busca, filtro compacto e elevação no hover.',
        'origem': 'restoffkaua08-afk/mr-commerce-platform',
        'origem_arquivos': ['web/src/app/page.tsx', 'web/src/app/globals.css'],
        'natureza': 'adaptação standalone de React/Next para HTML, CSS e JavaScript autocontidos',
    },
    {
        'id': 'L02',
        'nome': 'Listagem Facetada com Barra Lateral Instantânea',
        'folder': 'L02-Listagem-Facetada-com-Barra-Lateral-Instantanea',
        'descricao': 'Barra lateral compacta e fixa com checkboxes de categoria e marca; a grade de produtos é atualizada instantaneamente conforme os filtros são marcados.',
        'origem': 'Catálogo S',
        'natureza': 'modelo novo criado para demonstração e futura validação',
    },
    {
        'id': 'L03',
        'nome': 'Listagem Horizontal Comparativa',
        'folder': 'L03-Listagem-Horizontal-Comparativa',
        'descricao': 'Produtos apresentados em linhas horizontais com foto, resumo, especificações, preço e CTA, facilitando comparação de atributos técnicos.',
        'origem': 'Catálogo S',
        'natureza': 'modelo novo criado para demonstração e futura validação',
    },
    {
        'id': 'L04',
        'nome': 'Grade Editorial com Filtros em Drawer',
        'folder': 'L04-Grade-Editorial-com-Filtros-em-Drawer',
        'descricao': 'Grade visual editorial com chips de categoria, ações rápidas no hover e painel lateral animado para filtros avançados.',
        'origem': 'Catálogo S',
        'natureza': 'modelo novo criado para demonstração e futura validação',
    },
]

PAGE_STYLE = '''
*{box-sizing:border-box}html,body{margin:0;min-height:100%;background:#08090c;color:#f7f3e9;font-family:Arial,Helvetica,sans-serif}body{overflow-x:hidden}.head{padding:34px clamp(20px,4vw,58px) 26px;border-bottom:1px solid #ffffff12}.back{display:inline-block;color:#d1ad73;text-decoration:none;font-size:12px;margin-bottom:20px}.id{color:#d1ad73;font-size:11px;font-weight:800;letter-spacing:.16em}.head h1{margin:8px 0 10px;font:500 clamp(34px,5vw,62px) Georgia,serif;line-height:1}.head p{max-width:880px;margin:0;color:#aaa69e;line-height:1.7}.demo{padding:42px clamp(18px,4vw,58px) 70px;background:#08090c;min-height:72vh}.code{padding:56px clamp(20px,5vw,70px) 70px;background:#050609;border-top:1px solid #ffffff12}.code-wrap{max-width:1320px;margin:auto}.code-head{display:flex;align-items:flex-end;justify-content:space-between;gap:18px;flex-wrap:wrap;margin-bottom:18px}.code h2{margin:0;font:500 clamp(30px,4vw,48px) Georgia,serif}.code p{max-width:760px;color:#aaa69e;line-height:1.65}.actions{display:flex;gap:8px;flex-wrap:wrap}.action{display:inline-flex;align-items:center;justify-content:center;padding:10px 14px;border:1px solid #ffffff20;border-radius:8px;background:#111318;color:#f7f3e9;text-decoration:none;font-size:12px;font-weight:700;cursor:pointer}.action:hover{border-color:#c59b5d}.source{width:100%;min-height:470px;padding:20px;border:1px solid #ffffff18;border-radius:14px;background:#0d0f13;color:#d9dbe0;font:12px/1.6 Consolas,monospace;resize:vertical;white-space:pre;tab-size:2}.note{margin-top:14px;color:#77736c;font-size:12px;line-height:1.6}@media(max-width:600px){.demo{padding-left:14px;padding-right:14px}.source{min-height:360px}}
'''

def page_for(model, block):
    escaped = html.escape(block, quote=False)
    return f'''<!doctype html>
<html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{model['id']} — {model['nome']}</title><style>{PAGE_STYLE}</style></head>
<body><header class="head"><a class="back" href="../../index.html">← Voltar ao Catálogo S</a><div class="id">{model['id']} · CANDIDATO</div><h1>{model['nome']}</h1><p>{model['descricao']}</p></header><main><section class="demo">{block}</section><section class="code"><div class="code-wrap"><div class="code-head"><div><h2>Código pronto</h2><p>Bloco autocontido da demonstração acima. Copie inteiro ou abra os arquivos dedicados.</p></div><div class="actions"><button class="action" id="copy">Copiar código</button><a class="action" href="bloco-pronto.html">HTML</a><a class="action" href="bloco-pronto.txt">TXT</a></div></div><textarea class="source" id="source" spellcheck="false">{escaped}</textarea><div class="note">Imagens usadas somente para demonstração visual. Em produção, substitua pelas imagens reais do catálogo.</div></div></section></main><script>document.getElementById('copy').onclick=async function(){{const s=document.getElementById('source').value;try{{await navigator.clipboard.writeText(s)}}catch(e){{const t=document.getElementById('source');t.select();document.execCommand('copy')}}this.textContent='Copiado';setTimeout(()=>this.textContent='Copiar código',1200)}};</script></body></html>'''

for model in MODELS:
    folder = FRONT / model['folder']
    block_file = folder / 'bloco-pronto.html'
    if not block_file.exists():
        raise SystemExit(f'Faltando {block_file}')
    block = block_file.read_text(encoding='utf-8')
    (folder / 'bloco-pronto.txt').write_text(block, encoding='utf-8')
    (folder / 'index.html').write_text(page_for(model, block), encoding='utf-8')
    readme = [
        f"{model['id']} — {model['nome']}",
        '',
        'Situação: Candidato',
        'Categoria: Listagem de produtos / PLP',
        f"Origem: {model['origem']}",
        f"Natureza: {model['natureza']}",
    ]
    if model.get('origem_arquivos'):
        readme += ['Arquivos de origem: ' + ' + '.join(model['origem_arquivos'])]
        readme += ['', 'Importante: a versão do Catálogo S é uma adaptação standalone; não deve ser descrita como cópia literal do código original.']
    readme += ['', model['descricao'], '']
    (folder / 'LEIA-ME.txt').write_text('\n'.join(readme), encoding='utf-8')

registry = {
    'versao': '0.1.0',
    'atualizadoEm': '2026-09-01',
    'situacao': 'candidatos',
    'quantidade': len(MODELS),
    'itens': []
}
for model in MODELS:
    item = {
        'id': model['id'],
        'nome': model['nome'],
        'tipo': 'Frontend',
        'categoria': 'Listagem de produtos',
        'familia': 'Listagens',
        'situacao': 'Candidato',
        'versao': '0.1',
        'caminho': f"frontend/{model['folder']}/index.html",
        'descricao': model['descricao'],
        'bloco_pronto': f"frontend/{model['folder']}/bloco-pronto.html",
        'codigo_copiavel': True,
        'origem': model['origem'],
        'natureza': model['natureza'],
    }
    if model.get('origem_arquivos'):
        item['origem_arquivos'] = model['origem_arquivos']
    registry['itens'].append(item)
DATA.mkdir(exist_ok=True)
(DATA / 'listagens.json').write_text(json.dumps(registry, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
(DATA / 'listagens.js').write_text('window.CATALOGO_LISTAGENS = ' + json.dumps(registry, ensure_ascii=False, indent=2) + ';\n', encoding='utf-8')

index_file = ROOT / 'index.html'
index = index_file.read_text(encoding='utf-8')
if 'data-filter="listagem"' not in index:
    index = index.replace('<button class="filter-btn" data-filter="carrossel" type="button">Carrosséis</button>', '<button class="filter-btn" data-filter="carrossel" type="button">Carrosséis</button><button class="filter-btn" data-filter="listagem" type="button">Listagens</button>')
if 'dados/listagens.js' not in index:
    index = index.replace('<script src="dados/pesquisas.js"></script>', '<script src="dados/listagens.js"></script><script src="dados/pesquisas.js"></script>')
if 'const listagens=' not in index:
    index = index.replace('const pesquisas=(window.CATALOGO_PESQUISAS&&window.CATALOGO_PESQUISAS.itens)||[];', 'const listagens=(window.CATALOGO_LISTAGENS&&window.CATALOGO_LISTAGENS.itens)||[];\nconst pesquisas=(window.CATALOGO_PESQUISAS&&window.CATALOGO_PESQUISAS.itens)||[];')
if 'listagem:cat.includes' not in index:
    index = index.replace("carrossel:cat.includes('carrossel')||id.startsWith('C'),", "carrossel:cat.includes('carrossel')||id.startsWith('C'),\n    listagem:cat.includes('listagem')||id.startsWith('L'),")
if "if(filtroAtual==='listagem')base=listagens;" not in index:
    index = index.replace("if(filtroAtual==='efeito')base=efeitos;", "if(filtroAtual==='efeito')base=efeitos;\n  if(filtroAtual==='listagem')base=listagens;")
index_file.write_text(index, encoding='utf-8')

conv = DOC / 'CONVENCAO-DE-IDS.md'
text = conv.read_text(encoding='utf-8')
if '- `L` — listagem de produtos / PLP' not in text:
    text = text.replace('- `P` — pesquisa/busca\n', '- `P` — pesquisa/busca\n- `L` — listagem de produtos / PLP\n')
text = text.replace('Itens com situação `Candidato`, como P01–P04, só passam para o conjunto oficial após aprovação explícita de Kauã.', 'Itens com situação `Candidato`, incluindo P01–P04 e L01–L04, só passam para o conjunto oficial após aprovação explícita de Kauã.')
conv.write_text(text, encoding='utf-8')

readme = ROOT / 'README.md'
rt = readme.read_text(encoding='utf-8')
if '## Listagens de produtos' not in rt:
    section = '''\n## Listagens de produtos\n\nA família `L` representa padrões completos de listagem de produtos / PLP para e-commerce.\n\nExistem 4 candidatos:\n\n- `L01` — Listagem MR em Grade com Filtro Compacto — adaptação standalone da listagem real do `mr-commerce-platform`.\n- `L02` — Listagem Facetada com Barra Lateral Instantânea — filtros de checkbox em sidebar e atualização imediata.\n- `L03` — Listagem Horizontal Comparativa — linhas com especificações para comparação técnica.\n- `L04` — Grade Editorial com Filtros em Drawer — cards visuais, chips e painel lateral animado.\n\nCada candidato possui `index.html`, `bloco-pronto.html`, `bloco-pronto.txt` e `LEIA-ME.txt`. Os registros operacionais ficam em `dados/listagens.json` e `dados/listagens.js`.\n\nOs quatro permanecem como **Candidatos** e não alteram a contagem dos 6 modelos oficiais aprovados.\n'''
    rt += section
readme.write_text(rt, encoding='utf-8')

# Validação estrutural
for model in MODELS:
    folder = FRONT / model['folder']
    for name in ['index.html', 'bloco-pronto.html', 'bloco-pronto.txt', 'LEIA-ME.txt']:
        if not (folder / name).exists() or (folder / name).stat().st_size == 0:
            raise SystemExit(f'Arquivo inválido: {folder / name}')
    block = (folder / 'bloco-pronto.html').read_text(encoding='utf-8')
    for n, script in enumerate(re.findall(r'<script>(.*?)</script>', block, re.S), 1):
        tmp = Path(f'/tmp/{model["id"]}-{n}.js')
        tmp.write_text(script, encoding='utf-8')
        subprocess.run(['node', '--check', str(tmp)], check=True)

check_registry = json.loads((DATA / 'listagens.json').read_text(encoding='utf-8'))
if check_registry['quantidade'] != 4 or [x['id'] for x in check_registry['itens']] != ['L01','L02','L03','L04']:
    raise SystemExit('Registro de listagens inválido')
if 'data-filter="listagem"' not in index_file.read_text(encoding='utf-8'):
    raise SystemExit('Filtro Listagens não integrado')
print('VALIDAÇÃO OK: 4 listagens, 16 arquivos de modelo, registro e filtro integrados.')
