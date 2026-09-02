from pathlib import Path
import json
import html
import re

ROOT=Path(__file__).resolve().parents[1]
COMMAND='npx --yes github:restoffkaua08-afk/Catalogo_S#main add {id}'

CATEGORY_BY_PREFIX={
    'LG':'login','DB':'banco-de-dados','I':'telas-iniciais','C':'carrosseis',
    'E':'telas','L':'listagens','P':'pesquisa','A':'fundos-e-telas'
}
ROLE_BY_PREFIX={
    'I':('pagina','inicio','index.html'),
    'L':('pagina','produtos','produtos.html'),
    'LG':('pagina','login','login.html'),
    'E':('componente','secao',''),
    'C':('componente','carrossel',''),
    'P':('componente','pesquisa',''),
    'A':('componente','efeito',''),
}

def model_id(folder:Path):
    return folder.name.split('-',1)[0].upper()

def prefix(mid:str):
    if mid.startswith('LG'): return 'LG'
    if mid.startswith('DB'): return 'DB'
    return re.match(r'[A-Z]+',mid).group(0)

def human_name(folder:Path):
    parts=folder.name.split('-',1)
    return (parts[1] if len(parts)>1 else parts[0]).replace('-',' ')

def load_active_names():
    p=ROOT/'dados/categorias.json'
    if not p.exists(): return {}
    data=json.loads(p.read_text(encoding='utf-8'))
    names={}
    for cat in data.get('categorias',[]):
        for item in cat.get('itens',[]): names[item['id'].upper()]=item['nome']
    return names

ACTIVE_NAMES=load_active_names()

def command_for(mid): return COMMAND.format(id=mid)

def demo_html(mid,name,preview,category):
    title=f'{mid} — {name}'
    cmd=command_for(mid)
    return f'''<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{html.escape(title)}</title>
<style>
*{{box-sizing:border-box}}html,body{{margin:0;background:#08090c;color:#f7f3e9;font-family:Arial,Helvetica,sans-serif}}body{{min-height:100svh}}.preview{{height:100svh;background:#050607}}.preview iframe{{display:block;width:100%;height:100%;border:0}}.install{{min-height:52svh;display:grid;place-items:center;padding:54px 22px;border-top:1px solid rgba(255,255,255,.08)}}.box{{width:min(1100px,100%)}}.head{{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:15px}}h1{{margin:0;font:500 clamp(25px,3.4vw,42px)/1.05 Georgia,serif;letter-spacing:-.025em}}button{{border:1px solid rgba(255,255,255,.15);background:#15181e;color:#f7f3e9;border-radius:10px;padding:11px 15px;font-weight:800;cursor:pointer}}button:hover{{border-color:#d1ad73;color:#d1ad73}}pre{{margin:0;overflow:auto;border:1px solid rgba(255,255,255,.1);border-radius:16px;background:#0b0d11;padding:22px;color:#ece8dd;font:14px/1.65 Consolas,Monaco,monospace;white-space:pre-wrap;word-break:break-word}}.back{{position:fixed;z-index:50;left:16px;top:16px;width:44px;height:44px;display:grid;place-items:center;border-radius:50%;background:rgba(8,9,12,.7);border:1px solid rgba(255,255,255,.14);color:#fff;text-decoration:none;font-size:21px;backdrop-filter:blur(12px)}}@media(max-width:600px){{.head{{align-items:flex-start;flex-direction:column}}button{{width:100%}}}}
</style>
</head>
<body>
<a class="back" href="../../index.html#categoria={category}" aria-label="Voltar">←</a>
<section class="preview"><iframe src="{preview}" title="Demonstração {mid}"></iframe></section>
<section class="install"><div class="box"><div class="head"><h1>{html.escape(title)}</h1><button id="copy" type="button">Copiar</button></div><pre id="command">{html.escape(cmd)}</pre></div></section>
<script>
const b=document.getElementById('copy'),c=document.getElementById('command');
b.addEventListener('click',async()=>{{try{{await navigator.clipboard.writeText(c.textContent.trim())}}catch{{const r=document.createRange();r.selectNodeContents(c);const s=getSelection();s.removeAllRanges();s.addRange(r);document.execCommand('copy');s.removeAllRanges()}}b.textContent='Copiado';setTimeout(()=>b.textContent='Copiar',1200)}});
</script>
</body>
</html>
'''

def readme(mid,name,kind):
    return f'''{mid} — {name}

INSTALAÇÃO
{command_for(mid)}

MODO
{kind}

O Catálogo S cria os arquivos, registra o modelo em .catalogo-s/projeto.json e executa a reconciliação automática.
Os arquivos bloco-pronto.* permanecem como fonte interna do modelo e não precisam ser copiados manualmente.
'''

def db_preview():
    rows=[
        ('id','BIGINT UNSIGNED','PRIMARY KEY · AUTO_INCREMENT','Identificador'),
        ('nome','VARCHAR(120)','NOT NULL','Cadastro'),
        ('email','VARCHAR(190)','UNIQUE · NOT NULL','Cadastro / login'),
        ('senha_hash','VARCHAR(255)','NOT NULL','Hash da senha'),
        ('criado_em','TIMESTAMP','DEFAULT CURRENT_TIMESTAMP','Criação'),
        ('atualizado_em','TIMESTAMP','ON UPDATE','Atualização'),
    ]
    body=''.join(f'<tr><td>{a}</td><td>{b}</td><td>{c}</td><td>{d}</td></tr>' for a,b,c,d in rows)
    return f'''<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>DB01</title><style>*{{box-sizing:border-box}}html,body{{margin:0;min-height:100%;background:#08090c;color:#eee;font-family:Arial,sans-serif}}body{{min-height:100svh;display:grid;place-items:center;padding:24px}}.wrap{{width:min(1100px,100%);overflow:auto;border:1px solid rgba(255,255,255,.1);border-radius:18px}}table{{width:100%;border-collapse:collapse;min-width:760px;background:#101218}}th,td{{padding:16px;text-align:left;border-bottom:1px solid rgba(255,255,255,.08)}}th{{color:#d1ad73;font-size:11px;text-transform:uppercase;letter-spacing:.08em}}td{{font-size:13px}}tr:last-child td{{border-bottom:0}}</style></head><body><div class="wrap"><table><thead><tr><th>Coluna</th><th>Tipo</th><th>Chave / atributo</th><th>Uso</th></tr></thead><tbody>{body}</tbody></table></div></body></html>'''

def build_registry(folders):
    models={}
    for folder in folders:
        mid=model_id(folder); pref=prefix(mid); name=ACTIVE_NAMES.get(mid,human_name(folder))
        source=(folder/'bloco-pronto.html').relative_to(ROOT).as_posix()
        if pref not in ROLE_BY_PREFIX: continue
        mode,role,target=ROLE_BY_PREFIX[pref]
        item={'id':mid,'nome':name,'tipo':'frontend','papel':role,'modo':mode,'template':source}
        if mode=='pagina':
            item['target']=target; item['rotulo']={'inicio':'Início','produtos':'Produtos','login':'Login'}.get(role,name)
        else:
            item['destino']='inicio';item['altura']='100vh'
        models[mid]=item
    db=ROOT/'backend/DB01-Banco-do-LG01'
    if db.exists():
        models['DB01']={'id':'DB01','nome':'Banco do LG01','tipo':'backend','papel':'auth-db','modo':'banco','pareadoCom':'LG01','schemaTemplate':'backend/DB01-Banco-do-LG01/schema.sql','arquivos':[
            {'origem':'instalador/templates/DB01/lib/catalogo-s-db.js','destino':'lib/catalogo-s-db.js'},
            {'origem':'instalador/templates/DB01/api/auth/login.js','destino':'api/auth/login.js'},
            {'origem':'instalador/templates/DB01/api/auth/cadastro.js','destino':'api/auth/cadastro.js'}
        ]}
    return {'schema':2,'geradoEm':'2026-09-02','modelos':dict(sorted(models.items()))}

def update_categories():
    p=ROOT/'dados/categorias.json'
    data=json.loads(p.read_text(encoding='utf-8'))
    data['versao']='2.0.0';data['atualizadoEm']='2026-09-02'
    for cat in data.get('categorias',[]):
        for item in cat.get('itens',[]): item['comando']=command_for(item['id'])
    p.write_text(json.dumps(data,ensure_ascii=False,separators=(',',':')),encoding='utf-8')
    (ROOT/'dados/categorias.js').write_text('window.CATALOGO_CATEGORIAS='+json.dumps(data,ensure_ascii=False,separators=(',',':'))+';\n',encoding='utf-8')

def docs():
    (ROOT/'instalador/README.md').write_text('''# Instalador do Catálogo S\n\nStatus: **integrado**.\n\nTodos os modelos existentes são instalados pelo mesmo comando:\n\n```bash\nnpx --yes github:restoffkaua08-afk/Catalogo_S#main add <ID>\n```\n\nO CLI cria `.catalogo-s/projeto.json`, mantém backups, usa nomes canônicos de páginas e reconcilia automaticamente componentes e integrações compatíveis. Telas iniciais usam `index.html`, listagens usam `produtos.html`, login usa `login.html`, e componentes repetíveis são registrados em `components/catalogo-s/`.\n\nComandos: `init`, `add <ID>`, `list`, `reconcile` e `doctor`.\n''',encoding='utf-8')
    (ROOT/'documentacao/COMO-ADICIONAR-UM-MODELO.md').write_text('''# Como adicionar um modelo ao Catálogo S\n\nTodo modelo precisa de ID estável, `bloco-pronto.html`, `index.html` de demonstração e contrato no instalador. O código apresentado ao usuário é sempre um comando `catalogo-s add <ID>`, nunca um bloco manual para colar em arquivos.\n\nPáginas usam nomes canônicos; componentes repetíveis são adicionados ao manifesto e reconciliados no slot `CATALOGO-S:SLOT:COMPONENTES`; integrações entre modelos devem ser resolvidas pelo CLI.\n''',encoding='utf-8')

folders=[]
for base in (ROOT/'frontend',ROOT/'efeitos'):
    if base.exists():
        for folder in sorted(p for p in base.iterdir() if p.is_dir()):
            block=folder/'bloco-pronto.html'
            if not block.exists(): continue
            folders.append(folder)
            mid=model_id(folder);name=ACTIVE_NAMES.get(mid,human_name(folder));pref=prefix(mid);category=CATEGORY_BY_PREFIX.get(pref,'telas')
            (folder/'index.html').write_text(demo_html(mid,name,'bloco-pronto.html',category),encoding='utf-8')
            (folder/'LEIA-ME.txt').write_text(readme(mid,name,'Página canônica' if ROLE_BY_PREFIX.get(pref,('','',''))[0]=='pagina' else 'Componente repetível'),encoding='utf-8')

# DB01 recebe a mesma interface, com uma tabela como demonstração visual.
db=ROOT/'backend/DB01-Banco-do-LG01'
if db.exists():
    (db/'preview.html').write_text(db_preview(),encoding='utf-8')
    (db/'index.html').write_text(demo_html('DB01','Banco do LG01','preview.html','banco-de-dados'),encoding='utf-8')
    (db/'LEIA-ME.txt').write_text(readme('DB01','Banco do LG01','Backend pareado automaticamente ao LG01'),encoding='utf-8')

(ROOT/'instalador/modelos.json').write_text(json.dumps(build_registry(folders),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
update_categories()
docs()
print(f'Migração aplicada a {len(folders)} modelos visuais + DB01.')
