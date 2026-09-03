from pathlib import Path
import base64, gzip, html, json, re

ROOT = Path(__file__).resolve().parents[1]
CONTACTS = [
    {'id':'CT01','nome':'Contato Direto por E-mail','folder':'CT01-Contato-Direto-por-Email'},
    {'id':'CT02','nome':'Contato Social em Vidro','folder':'CT02-Contato-Social-em-Vidro'},
    {'id':'CT03','nome':'Central de Contato por Intenção','folder':'CT03-Central-de-Contato-por-Intencao'},
    {'id':'CT04','nome':'Contato Bento com Disponibilidade','folder':'CT04-Contato-Bento-com-Disponibilidade'},
    {'id':'CT05','nome':'Contato Conversacional em Etapas','folder':'CT05-Contato-Conversacional-em-Etapas'},
]
FORBIDDEN=['npx ','github.com/','api.github.com','raw.githubusercontent.com','git clone','invoke-webrequest','invoke-restmethod']

INSTALLER_TEMPLATE = '''$ModeloId='{mid}'
$ModeloNome='{name}'
$Payload='{payload}'
$ms=New-Object IO.MemoryStream(,[Convert]::FromBase64String($Payload))
$gz=New-Object IO.Compression.GzipStream($ms,[IO.Compression.CompressionMode]::Decompress)
$sr=New-Object IO.StreamReader($gz,[Text.Encoding]::UTF8)
$ConteudoModelo=$sr.ReadToEnd();$sr.Dispose();$gz.Dispose();$ms.Dispose()
$ErrorActionPreference='Stop'
$Root=(Get-Location).Path
$Utf8=New-Object System.Text.UTF8Encoding($false)
function Full([string]$r){{[IO.Path]::GetFullPath((Join-Path $Root $r))}}
function Backup([string]$r){{$p=Full $r;if(!(Test-Path -LiteralPath $p)){{return}};$bd=Full '.catalogo-s/backups';New-Item -ItemType Directory -Force -Path $bd|Out-Null;$safe=$r-replace'[\\/:*?"<>|]','__';Copy-Item -LiteralPath $p -Destination (Join-Path $bd ((Get-Date -Format 'yyyyMMdd-HHmmssfff')+'__'+$safe+'.bak')) -Force}}
function Put([string]$r,[string]$c){{$p=Full $r;$d=Split-Path -Parent $p;if($d-and!(Test-Path -LiteralPath $d)){{New-Item -ItemType Directory -Force -Path $d|Out-Null}};if(Test-Path -LiteralPath $p){{$old=[IO.File]::ReadAllText($p);if($old-eq$c){{return}};Backup $r}};[IO.File]::WriteAllText($p,$c,$Utf8)}}
if($env:CATALOGO_S_CONTACT_EMAIL){{$e=$env:CATALOGO_S_CONTACT_EMAIL.Trim();if($e){{$ConteudoModelo=[Text.RegularExpressions.Regex]::Replace($ConteudoModelo,'[A-Za-z]+@empresa\\.com',[Text.RegularExpressions.MatchEvaluator]{{param($m)$e}})}}}}
if($env:CATALOGO_S_CONTACT_ENDPOINT){{$e=$env:CATALOGO_S_CONTACT_ENDPOINT.Trim();if($e){{$s=[System.Net.WebUtility]::HtmlEncode($e);$ConteudoModelo=$ConteudoModelo.Replace('data-contact-endpoint=""','data-contact-endpoint="'+$s+'"')}}}}
if($env:CATALOGO_S_WHATSAPP){{$ConteudoModelo=$ConteudoModelo.Replace('https://wa.me/5500000000000',$env:CATALOGO_S_WHATSAPP.Trim())}}
if($env:CATALOGO_S_INSTAGRAM){{$ConteudoModelo=$ConteudoModelo.Replace('https://instagram.com/',$env:CATALOGO_S_INSTAGRAM.Trim())}}
if($env:CATALOGO_S_FACEBOOK){{$ConteudoModelo=$ConteudoModelo.Replace('https://facebook.com/',$env:CATALOGO_S_FACEBOOK.Trim())}}
Put 'contato.html' $ConteudoModelo
Write-Host "[Catálogo S] $ModeloId — $ModeloNome instalado em contato.html."
Write-Host '[Catálogo S] CTxx substitui somente contato.html e cria backup quando necessário.'
Write-Host '[Catálogo S] Nenhum arquivo foi baixado do GitHub.'
'''

DEMO_TEMPLATE = '''<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{mid} — {title}</title><style>*{{box-sizing:border-box}}html,body{{margin:0;background:#08090c;color:#f7f3e9;font-family:Arial,Helvetica,sans-serif;overflow-x:hidden}}.preview{{min-height:100svh;background:#e8ebef}}.preview iframe{{display:block;width:100%;height:100svh;border:0;overflow:hidden}}.install{{min-height:70svh;display:grid;place-items:center;padding:54px 22px;border-top:1px solid #ffffff14}}.box{{width:min(1180px,100%)}}.head{{display:flex;justify-content:space-between;gap:16px;align-items:center;margin-bottom:15px}}h1{{margin:0;font:500 clamp(25px,3.4vw,42px)/1.05 Georgia,serif}}button{{border:1px solid #ffffff26;background:#15181e;color:#f7f3e9;border-radius:10px;padding:11px 15px;font-weight:800;cursor:pointer}}pre{{margin:0;max-height:72svh;overflow:auto;border:1px solid #ffffff1a;border-radius:16px;background:#0b0d11;padding:22px;color:#ece8dd;font:13px/1.58 Consolas,monospace;white-space:pre}}.back{{position:fixed;z-index:50;left:16px;top:16px;width:44px;height:44px;display:grid;place-items:center;border-radius:50%;background:#08090cb3;border:1px solid #ffffff24;color:#fff;text-decoration:none;font-size:21px;backdrop-filter:blur(12px)}}@media(max-width:600px){{.head{{align-items:flex-start;flex-direction:column}}button{{width:100%}}pre{{font-size:11px}}}}</style><style id="catalogo-preview-stability">.preview{{height:auto!important;overflow:visible!important;max-width:100%}}.preview iframe{{max-width:100%;overflow:hidden}}.install,.box,pre{{min-width:0;max-width:100%}}</style></head><body><a class="back" href="../../index.html#categoria=tela-contato" aria-label="Voltar">←</a><section class="preview"><iframe src="bloco-pronto.html" title="Demonstração {mid}" scrolling="no"></iframe></section><section class="install"><div class="box"><div class="head"><h1>{mid} — {title}</h1><button id="copy" type="button">Copiar código PowerShell</button></div><pre id="command">{escaped}</pre></div></section><script>const b=document.getElementById('copy'),c=document.getElementById('command');b.onclick=async()=>{{try{{await navigator.clipboard.writeText(c.textContent)}}catch{{const r=document.createRange();r.selectNodeContents(c);const s=getSelection();s.removeAllRanges();s.addRange(r);document.execCommand('copy');s.removeAllRanges()}}b.textContent='Copiado';setTimeout(()=>b.textContent='Copiar código PowerShell',1200)}}</script><script id="catalogo-preview-stability-script">(()=>{{const f=document.querySelector('.preview iframe'),p=document.querySelector('.preview');if(!f||!p)return;const fit=()=>{{try{{const d=f.contentDocument,r=d.documentElement,b=d.body;r.style.margin='0';r.style.overflow='hidden';if(b){{b.style.margin='0';b.style.overflow='hidden'}}const h=Math.min(Math.max(innerHeight,r.scrollHeight,b?.scrollHeight||0),12000);f.style.height=p.style.height=h+'px'}}catch(_){{}}}};f.addEventListener('load',()=>{{fit();setTimeout(fit,100);setTimeout(fit,300)}});addEventListener('resize',fit)}})();</script></body></html>'''

README_TEMPLATE = '''{mid} — {name}\n\nINSTALAÇÃO PÚBLICA\nCopie o PowerShell exibido na demonstração e cole na raiz do projeto.\n\nCOMPORTAMENTO\n- instala/substitui contato.html;\n- cria backup antes de substituir;\n- outro CTxx substitui apenas contato.html;\n- sem npx, git clone ou download remoto.\n\nCONFIGURAÇÃO OPCIONAL SEM EDITAR HTML\nCATALOGO_S_CONTACT_EMAIL\nCATALOGO_S_CONTACT_ENDPOINT\nCATALOGO_S_WHATSAPP\nCATALOGO_S_INSTAGRAM\nCATALOGO_S_FACEBOOK\n'''

BROWSER_INSERT = '''    if mid == 'CT01':\n        page.locator('#ct01-name').fill('Pessoa Teste')\n        page.locator('#ct01-email').fill('teste@example.com')\n        page.locator('#ct01-message').fill('Mensagem de teste')\n        page.locator('#ct01-form button[type="submit"]').click()\n        page.wait_for_function("document.querySelector('#ct01-status')?.textContent.length > 0")\n        return\n    if mid == 'CT02':\n        assert page.locator('.stack .card').count() == 4\n        return\n    if mid == 'CT03':\n        page.locator('.route').nth(1).click()\n        page.wait_for_function("document.querySelector('#ct03-panel h2')?.textContent.includes('Suporte')")\n        return\n    if mid == 'CT04':\n        page.locator('#ct04-name').fill('Pessoa Teste')\n        page.locator('#ct04-email').fill('teste@example.com')\n        page.locator('#ct04-message').fill('Mensagem de teste')\n        page.locator('#ct04-form button[type="submit"]').click()\n        page.wait_for_function("document.querySelector('#ct04-state')?.textContent.includes('preparada')")\n        return\n    if mid == 'CT05':\n        page.locator('.choice').first.click()\n        page.locator('#ct05-name').fill('Pessoa Teste')\n        page.locator('#ct05-email').fill('teste@example.com')\n        page.locator('.step.active .next').click()\n        page.locator('#ct05-message').fill('Mensagem de teste')\n        page.locator('.step.active .next').click()\n        page.locator('.step[data-step="3"].active').wait_for(timeout=3000)\n        return\n\n'''

def make_installer(mid,name,source):
    payload=base64.b64encode(gzip.compress(source.encode('utf-8'),9)).decode()
    return INSTALLER_TEMPLATE.format(mid=mid,name=name,payload=payload)

def generate():
    for m in CONTACTS:
        folder=ROOT/'frontend'/m['folder']; source=(folder/'bloco-pronto.html').read_text(encoding='utf-8')
        ps=make_installer(m['id'],m['nome'],source)
        (folder/'bloco-pronto.txt').write_text(source,encoding='utf-8')
        (folder/'instalar.ps1').write_text(ps,encoding='utf-8')
        (folder/'index.html').write_text(DEMO_TEMPLATE.format(mid=m['id'],title=html.escape(m['nome']),escaped=html.escape(ps)),encoding='utf-8')
        (folder/'LEIA-ME.txt').write_text(README_TEMPLATE.format(mid=m['id'],name=m['nome']),encoding='utf-8')

def update_registry():
    p=ROOT/'instalador/modelos.json'; d=json.loads(p.read_text(encoding='utf-8')); models=d['modelos']
    for m in CONTACTS:
        mid=m['id']; folder=m['folder']
        models[mid]={'id':mid,'nome':m['nome'],'tipo':'frontend','papel':'contato','modo':'pagina','template':f'frontend/{folder}/bloco-pronto.html','instaladorPublico':f'frontend/{folder}/instalar.ps1','target':'contato.html','rotulo':'Contato'}
    d['modelos']=dict(sorted(models.items())); d['geradoEm']='2026-09-03'
    p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

def update_categories():
    p=ROOT/'dados/categorias.json'; d=json.loads(p.read_text(encoding='utf-8'))
    c=next(x for x in d['categorias'] if x.get('slug')=='tela-contato')
    c['descricao']='Telas profissionais para contato direto, redes sociais, roteamento de atendimento, disponibilidade e formulários guiados.'
    c['itens']=[{'id':m['id'],'nome':m['nome'],'caminho':f"frontend/{m['folder']}/index.html",'situacao':'Candidato','instalacao':'PowerShell autocontido na demonstração'} for m in CONTACTS]
    d['versao']='3.4.0'; d['atualizadoEm']='2026-09-03'; d['quantidade']=len(d['categorias'])
    compact=json.dumps(d,ensure_ascii=False,separators=(',',':')); p.write_text(compact,encoding='utf-8')
    (ROOT/'dados/categorias.js').write_text('window.CATALOGO_CATEGORIAS='+compact+';\n',encoding='utf-8')

def patch_browser():
    p=ROOT/'tests/browser_smoke.py'; t=p.read_text(encoding='utf-8')
    t=re.sub(r"assert checked == len\(MODELS\) == \d+, f'esperados \d+ modelos, validados \{checked\}'","assert checked == len(MODELS), f'validados {checked} de {len(MODELS)} modelos'",t)
    if "if mid == 'CT01':" not in t:
        anchor="    if mid.startswith('LG'):\n"
        if anchor not in t: raise RuntimeError('Âncora LG ausente em browser_smoke.py')
        t=t.replace(anchor,BROWSER_INSERT+anchor,1)
    p.write_text(t,encoding='utf-8')

def patch_docs():
    p=ROOT/'README.md'; t=p.read_text(encoding='utf-8'); line='- `CTxx` → página Contato → `contato.html`\n'
    if line not in t:
        for a in ['- `SOBxx` → página Sobre → `sobre.html`\n','- `LGxx` → login → `login.html`\n']:
            if a in t: t=t.replace(a,a+line,1); break
    p.write_text(t,encoding='utf-8')

def validate():
    models=json.loads((ROOT/'instalador/modelos.json').read_text(encoding='utf-8'))['modelos']
    for m in CONTACTS:
        folder=ROOT/'frontend'/m['folder']; src=(folder/'bloco-pronto.html').read_text(encoding='utf-8')
        assert src==(folder/'bloco-pronto.txt').read_text(encoding='utf-8')
        ps=(folder/'instalar.ps1').read_text(encoding='utf-8')
        for token in FORBIDDEN: assert token not in ps.lower()
        detail=(folder/'index.html').read_text(encoding='utf-8'); match=re.search(r'<pre id="command">([\s\S]*?)</pre>',detail)
        assert match and html.unescape(match.group(1))==ps
        model=models[m['id']]; assert model.get('target')=='contato.html' and model.get('papel')=='contato'
    cats=json.loads((ROOT/'dados/categorias.json').read_text(encoding='utf-8'))['categorias']; c=next(x for x in cats if x.get('slug')=='tela-contato')
    assert [i['id'] for i in c['itens']]==[m['id'] for m in CONTACTS]

generate(); update_registry(); update_categories(); patch_browser(); patch_docs(); validate()
print('CT01–CT05 gerados e validados em contato.html.')
