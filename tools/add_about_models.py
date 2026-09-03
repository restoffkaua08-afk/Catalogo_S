from pathlib import Path
import base64, gzip, html, json, re

ROOT = Path(__file__).resolve().parents[1]
ABOUTS = [{'id': 'SOB01', 'nome': 'Sobre Split Fotográfico', 'folder': 'SOB01-Sobre-Split-Fotografico'}, {'id': 'SOB02', 'nome': 'Sobre Editorial com Texto Justificado', 'folder': 'SOB02-Sobre-Editorial-com-Texto-Justificado'}, {'id': 'SOB03', 'nome': 'Sobre com Carrossel Automático', 'folder': 'SOB03-Sobre-com-Carrossel-Automatico'}, {'id': 'SOB04', 'nome': 'Sobre Manifesto Tipográfico', 'folder': 'SOB04-Sobre-Manifesto-Tipografico'}, {'id': 'SOB05', 'nome': 'Sobre em Camadas com Painel de História', 'folder': 'SOB05-Sobre-em-Camadas-com-Painel-de-Historia'}]
INSTALLER_TEMPLATE = '# Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.\n# SOBxx já fornece um documento HTML completo para a página canônica sobre.html.\n$ModeloId=\'{mid}\'\n$ModeloNome=\'{name}\'\n$Payload=\'{payload}\'\n$ms=New-Object IO.MemoryStream(,[Convert]::FromBase64String($Payload))\n$gz=New-Object IO.Compression.GzipStream($ms,[IO.Compression.CompressionMode]::Decompress)\n$sr=New-Object IO.StreamReader($gz,[Text.Encoding]::UTF8)\n$ConteudoModelo=$sr.ReadToEnd();$sr.Dispose();$gz.Dispose();$ms.Dispose()\n$ErrorActionPreference=\'Stop\'\n$Root=(Get-Location).Path\n$Utf8=New-Object System.Text.UTF8Encoding($false)\nfunction Full([string]$r){{[IO.Path]::GetFullPath((Join-Path $Root $r))}}\nfunction Backup([string]$r){{$p=Full $r;if(!(Test-Path -LiteralPath $p)){{return}};$bd=Full \'.catalogo-s/backups\';New-Item -ItemType Directory -Force -Path $bd|Out-Null;$safe=$r-replace\'[\\\\/:*?"<>|]\',\'__\';Copy-Item -LiteralPath $p -Destination (Join-Path $bd ((Get-Date -Format \'yyyyMMdd-HHmmssfff\')+\'__\'+$safe+\'.bak\')) -Force}}\nfunction Put([string]$r,[string]$c){{$p=Full $r;$d=Split-Path -Parent $p;if($d-and!(Test-Path -LiteralPath $d)){{New-Item -ItemType Directory -Force -Path $d|Out-Null}};if(Test-Path -LiteralPath $p){{$old=[IO.File]::ReadAllText($p);if($old-eq$c){{return}};Backup $r}};[IO.File]::WriteAllText($p,$c,$Utf8);Write-Host "[Catálogo S] gravado: $r"}}\nPut \'sobre.html\' $ConteudoModelo\nWrite-Host ""\nWrite-Host "[Catálogo S] $ModeloId — $ModeloNome instalado em sobre.html."\nWrite-Host \'[Catálogo S] SOBxx é página canônica: outro SOBxx substitui somente sobre.html.\'\nWrite-Host \'[Catálogo S] Nenhum arquivo foi baixado do GitHub.\'\n'
DEMO_TEMPLATE = '<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{mid} — {title}</title>\n<style>*{{box-sizing:border-box}}html,body{{margin:0;background:#08090c;color:#f7f3e9;font-family:Arial,Helvetica,sans-serif;overflow-x:hidden}}.preview{{min-height:100svh;background:#e8ebef}}.preview iframe{{display:block;width:100%;height:100svh;border:0;overflow:hidden}}.install{{min-height:70svh;display:grid;place-items:center;padding:54px 22px;border-top:1px solid #ffffff14}}.box{{width:min(1180px,100%)}}.head{{display:flex;justify-content:space-between;gap:16px;align-items:center;margin-bottom:15px}}h1{{margin:0;font:500 clamp(25px,3.4vw,42px)/1.05 Georgia,serif}}button{{border:1px solid #ffffff26;background:#15181e;color:#f7f3e9;border-radius:10px;padding:11px 15px;font-weight:800;cursor:pointer}}pre{{margin:0;max-height:72svh;overflow:auto;border:1px solid #ffffff1a;border-radius:16px;background:#0b0d11;padding:22px;color:#ece8dd;font:13px/1.58 Consolas,monospace;white-space:pre}}.back{{position:fixed;z-index:50;left:16px;top:16px;width:44px;height:44px;display:grid;place-items:center;border-radius:50%;background:#08090cb3;border:1px solid #ffffff24;color:#fff;text-decoration:none;font-size:21px;backdrop-filter:blur(12px)}}@media(max-width:600px){{.head{{align-items:flex-start;flex-direction:column}}button{{width:100%}}pre{{font-size:11px}}}}</style>\n<style id="catalogo-preview-stability">.preview{{height:auto!important;overflow:visible!important;max-width:100%}}.preview iframe{{max-width:100%;overflow:hidden}}.install,.box,pre{{min-width:0;max-width:100%}}</style></head>\n<body><a class="back" href="../../index.html#categoria=tela-sobre" aria-label="Voltar">←</a><section class="preview"><iframe src="bloco-pronto.html" title="Demonstração {mid}" scrolling="no"></iframe></section><section class="install"><div class="box"><div class="head"><h1>{mid} — {title}</h1><button id="copy" type="button">Copiar código PowerShell</button></div><pre id="command">{escaped}</pre></div></section>\n<script>const b=document.getElementById(\'copy\'),c=document.getElementById(\'command\');b.onclick=async()=>{{try{{await navigator.clipboard.writeText(c.textContent)}}catch{{const r=document.createRange();r.selectNodeContents(c);const s=getSelection();s.removeAllRanges();s.addRange(r);document.execCommand(\'copy\');s.removeAllRanges()}}b.textContent=\'Copiado\';setTimeout(()=>b.textContent=\'Copiar código PowerShell\',1200)}}</script>\n<script id="catalogo-preview-stability-script">(()=>{{const f=document.querySelector(\'.preview iframe\'),p=document.querySelector(\'.preview\');if(!f||!p)return;const fit=()=>{{try{{const d=f.contentDocument,r=d.documentElement,b=d.body;r.style.margin=\'0\';r.style.overflow=\'hidden\';if(b){{b.style.margin=\'0\';b.style.overflow=\'hidden\'}}const h=Math.min(Math.max(innerHeight,r.scrollHeight,b?.scrollHeight||0),12000);f.style.height=p.style.height=h+\'px\'}}catch(_){{}}}};f.addEventListener(\'load\',()=>{{fit();setTimeout(fit,100);setTimeout(fit,300)}});addEventListener(\'resize\',fit)}})();</script></body></html>'
README_TEMPLATE = '{mid} — {name}\n\nINSTALAÇÃO PÚBLICA\nAbra a demonstração do modelo, copie o bloco PowerShell completo e cole no PowerShell aberto na raiz do projeto.\n\nCOMPORTAMENTO\n- instala/substitui a página canônica sobre.html;\n- cria backup antes de substituir um sobre.html existente;\n- não altera index.html, produtos.html, login.html nem componentes repetíveis;\n- outro SOBxx substitui somente sobre.html;\n- não usa npx, git clone nem consulta o GitHub.\n\nARQUIVOS\nbloco-pronto.html\nbloco-pronto.txt\nindex.html\ninstalar.ps1\nLEIA-ME.txt\n\nMODO\nPágina canônica — Sobre\n'
FORBIDDEN = ['npx ', 'github.com/', 'api.github.com', 'raw.githubusercontent.com', 'git clone', 'invoke-webrequest', 'invoke-restmethod']

def make_installer(mid,name,source):
    payload=base64.b64encode(gzip.compress(source.encode('utf-8'),compresslevel=9)).decode()
    return INSTALLER_TEMPLATE.format(mid=mid,name=name,payload=payload)

def make_demo(mid,name,ps):
    return DEMO_TEMPLATE.format(mid=mid,title=html.escape(name),escaped=html.escape(ps))

def generate():
    for m in ABOUTS:
        folder=ROOT/'frontend'/m['folder']
        src_path=folder/'bloco-pronto.html'
        if not src_path.exists(): raise RuntimeError(f'Fonte ausente: {src_path}')
        source=src_path.read_text(encoding='utf-8')
        ps=make_installer(m['id'],m['nome'],source)
        (folder/'bloco-pronto.txt').write_text(source,encoding='utf-8')
        (folder/'instalar.ps1').write_text(ps,encoding='utf-8')
        (folder/'index.html').write_text(make_demo(m['id'],m['nome'],ps),encoding='utf-8')
        (folder/'LEIA-ME.txt').write_text(README_TEMPLATE.format(mid=m['id'],name=m['nome']),encoding='utf-8')

def update_registry():
    path=ROOT/'instalador/modelos.json'
    data=json.loads(path.read_text(encoding='utf-8'))
    models=data['modelos']
    for m in ABOUTS:
        folder=m['folder']; mid=m['id']
        models[mid]={'id':mid,'nome':m['nome'],'tipo':'frontend','papel':'sobre','modo':'pagina','template':f'frontend/{folder}/bloco-pronto.html','instaladorPublico':f'frontend/{folder}/instalar.ps1','target':'sobre.html','rotulo':'Sobre'}
    data['modelos']=dict(sorted(models.items())); data['geradoEm']='2026-09-03'
    path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

def update_categories():
    path=ROOT/'dados/categorias.json'; data=json.loads(path.read_text(encoding='utf-8'))
    category=next(c for c in data['categorias'] if c.get('slug')=='tela-sobre')
    category['descricao']='Telas com foco em uma narrativa curta para apresentar a empresa, projeto, produto ou ensinar rapidamente como algo funciona.'
    category['itens']=[{'id':m['id'],'nome':m['nome'],'caminho':f"frontend/{m['folder']}/index.html",'situacao':'Candidato','instalacao':'PowerShell autocontido na demonstração'} for m in ABOUTS]
    data['versao']='3.3.0'; data['atualizadoEm']='2026-09-03'; data['quantidade']=len(data['categorias'])
    compact=json.dumps(data,ensure_ascii=False,separators=(',',':')); path.write_text(compact,encoding='utf-8')
    (ROOT/'dados/categorias.js').write_text('window.CATALOGO_CATEGORIAS='+compact+';\n',encoding='utf-8')

def patch_tests():
    gate=ROOT/'.github/workflows/teste-instalador.yml'
    text=gate.read_text(encoding='utf-8')
    text=re.sub(r"assert len\(models\)==(?:25|30|35), f'esperados (?:25|30|35) modelos, encontrados \{len\(models\)\}'", "assert len(models)==35, f'esperados 35 modelos, encontrados {len(models)}'", text)
    text=re.sub(r"print\('(?:25|30|35) modelos: contrato, metadados, previews, scroll e códigos sincronizados\.'\)", "print('35 modelos: contrato, metadados, previews, scroll e códigos sincronizados.')", text)
    gate.write_text(text,encoding='utf-8')
    smoke=ROOT/'tests/browser_smoke.py'; text=smoke.read_text(encoding='utf-8')
    text=re.sub(r"assert checked == len\(MODELS\) == (?:25|30|35), f'esperados (?:25|30|35) modelos, validados \{checked\}'", "assert checked == len(MODELS) == 35, f'esperados 35 modelos, validados {checked}'", text)
    smoke.write_text(text,encoding='utf-8')

def patch_docs():
    p=ROOT/'README.md'; text=p.read_text(encoding='utf-8'); line='- `SOBxx` → página Sobre → `sobre.html`\n'; anchor='- `LGxx` → login → `login.html`\n'
    if line not in text and anchor in text: text=text.replace(anchor,anchor+line,1)
    p.write_text(text,encoding='utf-8')
    p=ROOT/'documentacao/COMO-ADICIONAR-UM-MODELO.md'; text=p.read_text(encoding='utf-8'); line='- telas `SOBxx` substituem a página canônica `sobre.html` e não exigem edição manual de links;\n'; anchor='- páginas canônicas escrevem seus arquivos (`index.html`, `produtos.html`, `login.html`);\n'
    if line not in text and anchor in text: text=text.replace(anchor,anchor+line,1)
    p.write_text(text,encoding='utf-8')

def validate():
    registry=json.loads((ROOT/'instalador/modelos.json').read_text(encoding='utf-8'))['modelos']
    if len(registry)!=35: raise RuntimeError(f'esperados 35 modelos após SOBxx; encontrados {len(registry)}')
    for m in ABOUTS:
        folder=ROOT/'frontend'/m['folder']; source=(folder/'bloco-pronto.html').read_text(encoding='utf-8')
        if source!=(folder/'bloco-pronto.txt').read_text(encoding='utf-8'): raise RuntimeError(f"{m['id']}: HTML/TXT divergentes")
        ps=(folder/'instalar.ps1').read_text(encoding='utf-8'); low=ps.lower()
        for token in FORBIDDEN:
            if token in low: raise RuntimeError(f"{m['id']}: dependência proibida {token}")
        detail=(folder/'index.html').read_text(encoding='utf-8'); match=re.search(r'<pre id="command">([\s\S]*?)</pre>',detail)
        if not match or html.unescape(match.group(1))!=ps: raise RuntimeError(f"{m['id']}: demo e instalar.ps1 divergentes")
        if registry[m['id']].get('target')!='sobre.html': raise RuntimeError(f"{m['id']}: target canônico incorreto")

generate(); update_registry(); update_categories(); patch_tests(); patch_docs(); validate()
print('SOB01–SOB05 gerados, registrados e validados como páginas canônicas sobre.html.')
