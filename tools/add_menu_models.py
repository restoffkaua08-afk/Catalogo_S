from pathlib import Path
import base64, gzip, html, json, re
ROOT = Path(__file__).resolve().parents[1]
MODELS = [{'id': 'NS01', 'nome': 'Barra Superior Institucional Centralizada', 'folder': 'NS01-Barra-Superior-Institucional-Centralizada', 'papel': 'navegacao-superior', 'parte': 'superior', 'fusionavel': False, 'compativeis': []}, {'id': 'NS02', 'nome': 'Barra Superior Minimal com Drawer', 'folder': 'NS02-Barra-Superior-Minimal-com-Drawer', 'papel': 'navegacao-superior', 'parte': 'superior', 'fusionavel': True, 'compativeis': ['NL01', 'NL02']}, {'id': 'NS03', 'nome': 'Barra Superior Técnica de Aplicação', 'folder': 'NS03-Barra-Superior-Tecnica-de-Aplicacao', 'papel': 'navegacao-superior', 'parte': 'superior', 'fusionavel': True, 'compativeis': ['NL01', 'NL02']}, {'id': 'NL01', 'nome': 'Sidebar Overlay em Vidro', 'folder': 'NL01-Sidebar-Overlay-em-Vidro', 'papel': 'navegacao-lateral', 'parte': 'lateral', 'fusionavel': True, 'compativeis': ['NS02', 'NS03']}, {'id': 'NL02', 'nome': 'Sidebar Técnica Compacta', 'folder': 'NL02-Sidebar-Tecnica-Compacta', 'papel': 'navegacao-lateral', 'parte': 'lateral', 'fusionavel': True, 'compativeis': ['NS02', 'NS03']}, {'id': 'NL03', 'nome': 'Sidebar Fixa Profissional', 'folder': 'NL03-Sidebar-Fixa-Profissional', 'papel': 'navegacao-lateral', 'parte': 'lateral', 'fusionavel': False, 'compativeis': []}]
AUTO_LINK_JS = "<script>\n(()=>{const links=[...document.querySelectorAll('[data-catalogo-auto-link]')];\nif(!/^https?:$/.test(location.protocol))return;\nlinks.forEach(async a=>{try{const r=await fetch(a.getAttribute('href'),{method:'HEAD',cache:'no-store'});if(!r.ok)a.hidden=true}catch(_){}})})();\n</script>"
INSTALLER = '$ModeloId=\'{mid}\'\n$ModeloNome=\'{name}\'\n$Parte=\'{part}\'\n$Payload=\'{payload}\'\n$ms=New-Object IO.MemoryStream(,[Convert]::FromBase64String($Payload))\n$gz=New-Object IO.Compression.GzipStream($ms,[IO.Compression.CompressionMode]::Decompress)\n$sr=New-Object IO.StreamReader($gz,[Text.Encoding]::UTF8)\n$ConteudoModelo=$sr.ReadToEnd();$sr.Dispose();$gz.Dispose();$ms.Dispose()\n$ErrorActionPreference=\'Stop\'\n$Root=(Get-Location).Path\n$Utf8=New-Object System.Text.UTF8Encoding($false)\nfunction Full([string]$r){{[IO.Path]::GetFullPath((Join-Path $Root $r))}}\nfunction Backup([string]$r){{$p=Full $r;if(!(Test-Path -LiteralPath $p)){{return}};$bd=Full \'.catalogo-s/backups\';New-Item -ItemType Directory -Force -Path $bd|Out-Null;$safe=$r-replace\'[\\\\/:*?"<>|]\',\'__\';Copy-Item -LiteralPath $p -Destination (Join-Path $bd ((Get-Date -Format \'yyyyMMdd-HHmmssfff\')+\'__\'+$safe+\'.bak\')) -Force}}\nfunction Put([string]$r,[string]$c,[switch]$NoBackup){{$p=Full $r;$d=Split-Path -Parent $p;if($d-and!(Test-Path -LiteralPath $d)){{New-Item -ItemType Directory -Force -Path $d|Out-Null}};if(Test-Path -LiteralPath $p){{$old=[IO.File]::ReadAllText($p);if($old-eq$c){{return}};if(!$NoBackup){{Backup $r}}}};[IO.File]::WriteAllText($p,$c,$Utf8)}}\nfunction Slots([string]$h){{$menu="<!-- CATALOGO-S:SLOT:MENU:START -->`r`n<!-- CATALOGO-S:SLOT:MENU:END -->";$components="<!-- CATALOGO-S:SLOT:COMPONENTES:START -->`r`n<!-- CATALOGO-S:SLOT:COMPONENTES:END -->";$footer="<!-- CATALOGO-S:SLOT:RODAPE:START -->`r`n<!-- CATALOGO-S:SLOT:RODAPE:END -->";if($h-notmatch\'CATALOGO-S:SLOT:MENU:START\'){{$h=$h-replace\'(?i)<body([^>]*)>\',(\'<body$1>\'+"`r`n"+$menu)}};if($h-notmatch\'CATALOGO-S:SLOT:COMPONENTES:START\'){{$h=$h-replace\'(?i)</body>\',($components+"`r`n</body>")}};if($h-notmatch\'CATALOGO-S:SLOT:RODAPE:START\'){{$h=$h-replace\'(?i)</body>\',($footer+"`r`n</body>")}};return $h}}\nfunction SetSlot([string]$h,[string]$n,[string]$c){{$e=[Text.RegularExpressions.Regex]::Escape($n);$p=\'(?s)<!-- CATALOGO-S:SLOT:\'+$e+\':START -->.*?<!-- CATALOGO-S:SLOT:\'+$e+\':END -->\';$r="<!-- CATALOGO-S:SLOT:$n`:START -->`r`n$c`r`n<!-- CATALOGO-S:SLOT:$n`:END -->";return [Text.RegularExpressions.Regex]::Replace($h,$p,$r)}}\nfunction EnsureHost{{$p=Full \'index.html\';if(!(Test-Path -LiteralPath $p)){{$shell=\'<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Projeto</title><style>html,body{{margin:0;min-height:100%}}</style></head><body><main style="min-height:100vh"></main></body></html>\';Put \'index.html\' (Slots $shell) -NoBackup}}else{{$h=[IO.File]::ReadAllText($p);$s=Slots $h;if($s-ne$h){{Put \'index.html\' $s}}}}}}\nfunction RebuildMenu{{EnsureHost;$h=[IO.File]::ReadAllText((Full \'index.html\'));$h=Slots $h;$dir=Full \'components/catalogo-s/menu\';$parts=@();foreach($f in @(\'superior.html\',\'lateral.html\')){{$p=Join-Path $dir $f;if(Test-Path -LiteralPath $p){{$parts+=[IO.File]::ReadAllText($p)}}};$shared=@\'\n<style id="catalogo-s-menu-host">[data-catalogo-auto-link][hidden]{{display:none!important}}</style>\n{autojs}\n\'@;$content=$shared+"`r`n"+($parts-join"`r`n");Put \'index.html\' (SetSlot $h \'MENU\' $content)}}\n$dest=\'components/catalogo-s/menu/\'+$Parte+\'.html\'\nPut $dest $ConteudoModelo\nRebuildMenu\nWrite-Host "[Catálogo S] $ModeloId — $ModeloNome instalado como navegação $Parte."\nWrite-Host \'[Catálogo S] NSxx/NLxx recompõem juntos somente o slot MENU.\'\nWrite-Host \'[Catálogo S] Nenhum arquivo foi baixado do GitHub.\'\n'
DEMO = '<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{mid} — {name}</title><style>*{{box-sizing:border-box}}html,body{{margin:0;background:#080a0d;color:#f3f6f9;font-family:Arial,Helvetica,sans-serif;overflow-x:hidden}}.preview{{height:100svh;min-height:620px;background:linear-gradient(145deg,#171c24,#080a0d);position:relative;overflow:hidden}}.preview:before{{content:"";position:absolute;inset:0;background:radial-gradient(circle at 70% 30%,#5368ff24,transparent 32%),linear-gradient(115deg,transparent 0 48%,#ffffff04 48% 49%,transparent 49%);pointer-events:none}}iframe{{position:relative;display:block;width:100%;height:100%;border:0;overflow:hidden}}.install{{min-height:70svh;padding:54px 22px;border-top:1px solid #ffffff13;display:grid;place-items:center}}.box{{width:min(1180px,100%)}}.head{{display:flex;align-items:center;justify-content:space-between;gap:14px;margin-bottom:15px}}h1{{margin:0;font:500 clamp(25px,3vw,40px)/1.05 Georgia,serif}}button{{border:1px solid #ffffff22;border-radius:10px;background:#151922;color:#fff;padding:11px 15px;font-weight:800;cursor:pointer}}pre{{margin:0;max-height:70svh;overflow:auto;padding:22px;border:1px solid #ffffff17;border-radius:15px;background:#0b0e13;color:#dfe6ee;font:12px/1.58 Consolas,monospace;white-space:pre}}.back{{position:fixed;z-index:9999;left:16px;bottom:16px;width:44px;height:44px;border-radius:50%;display:grid;place-items:center;background:#080a0dc9;border:1px solid #ffffff20;color:#fff;text-decoration:none;backdrop-filter:blur(12px)}}@media(max-width:620px){{.head{{align-items:flex-start;flex-direction:column}}button{{width:100%}}pre{{font-size:10px}}}}</style><style id="catalogo-preview-stability">html,body{{overflow-x:hidden!important}}.preview{{max-width:100%;overflow:hidden!important}}.preview iframe{{max-width:100%;overflow:hidden}}.install,.box,pre{{min-width:0;max-width:100%}}</style></head><body><a class="back" href="../../index.html#categoria=menus" aria-label="Voltar">←</a><section class="preview"><iframe src="bloco-pronto.html" title="Demonstração {mid}" scrolling="no"></iframe></section><section class="install"><div class="box"><div class="head"><h1>{mid} — {name}</h1><button id="copy" type="button">Copiar código PowerShell</button></div><pre id="command">{escaped}</pre></div></section><script>const b=document.getElementById(\'copy\'),c=document.getElementById(\'command\');b.onclick=async()=>{{try{{await navigator.clipboard.writeText(c.textContent)}}catch{{const r=document.createRange();r.selectNodeContents(c);const s=getSelection();s.removeAllRanges();s.addRange(r);document.execCommand(\'copy\');s.removeAllRanges()}}b.textContent=\'Copiado\';setTimeout(()=>b.textContent=\'Copiar código PowerShell\',1200)}}</script><script id="catalogo-preview-stability-script">(()=>{{const f=document.querySelector(\'.preview iframe\'),p=document.querySelector(\'.preview\');if(!f||!p)return;const fit=()=>{{try{{const d=f.contentDocument,r=d.documentElement,b=d.body;r.style.margin=\'0\';r.style.width=\'100%\';r.style.overflow=\'hidden\';if(b){{b.style.margin=\'0\';b.style.width=\'100%\';b.style.overflow=\'hidden\'}}f.style.height=p.clientHeight+\'px\'}}catch(_){{}}}};f.addEventListener(\'load\',fit);addEventListener(\'resize\',fit)}})();</script></body></html>'
README = '{mid} — {name}\n\nINSTALAÇÃO PÚBLICA\nCopie o PowerShell exibido na demonstração e cole na raiz do projeto.\n\nCONTRATO\n- família: menus;\n- papel: {role};\n- parte persistida: components/catalogo-s/menu/{part}.html;\n- slot: CATALOGO-S:SLOT:MENU;\n- NS02/NS03 podem acionar NL01/NL02 via data-catalogo-s-menu-toggle;\n- instalar outro NSxx substitui somente a barra superior;\n- instalar outro NLxx substitui somente a barra lateral;\n- links usam os nomes canônicos index.html, produtos.html, sobre.html, contato.html e login.html;\n- sem npx, git clone ou download remoto.\n'

def installer(m, source):
    payload = base64.b64encode(gzip.compress(source.encode('utf-8'), 9)).decode()
    return INSTALLER.format(mid=m['id'], name=m['nome'], part=m['parte'], payload=payload, autojs=AUTO_LINK_JS)

def generate_files():
    for m in MODELS:
        folder = ROOT / 'frontend' / m['folder']
        source = (folder / 'bloco-pronto.html').read_text(encoding='utf-8')
        (folder / 'bloco-pronto.txt').write_text(source, encoding='utf-8')
        ps = installer(m, source)
        (folder / 'instalar.ps1').write_text(ps, encoding='utf-8')
        (folder / 'index.html').write_text(DEMO.format(mid=m['id'], name=html.escape(m['nome']), escaped=html.escape(ps)), encoding='utf-8')
        (folder / 'LEIA-ME.txt').write_text(README.format(mid=m['id'], name=m['nome'], role=m['papel'], part=m['parte']), encoding='utf-8')

def update_registry():
    p = ROOT / 'instalador/modelos.json'
    d = json.loads(p.read_text(encoding='utf-8'))
    for m in MODELS:
        folder = m['folder']
        d['modelos'][m['id']] = {'id': m['id'], 'nome': m['nome'], 'tipo': 'frontend', 'papel': m['papel'], 'modo': 'menu', 'template': f'frontend/{folder}/bloco-pronto.html', 'instaladorPublico': f'frontend/{folder}/instalar.ps1', 'destino': 'inicio', 'slot': 'MENU', 'parteMenu': m['parte'], 'fusionavel': m['fusionavel'], 'compativeisCom': m['compativeis'], 'altura': '100vh'}
    d['modelos'] = dict(sorted(d['modelos'].items()))
    d['geradoEm'] = '2026-09-03'
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

def update_categories():
    p = ROOT / 'dados/categorias.json'
    d = json.loads(p.read_text(encoding='utf-8'))
    cat = next((x for x in d['categorias'] if x.get('slug') == 'menus'))
    cat['descricao'] = 'Barras superiores e laterais profissionais. NS02/NS03 e NL01/NL02 são combináveis; NS01 e NL03 funcionam completos sozinhos.'
    cat['itens'] = [{'id': m['id'], 'nome': m['nome'], 'caminho': f"frontend/{m['folder']}/index.html", 'situacao': 'Candidato', 'instalacao': 'PowerShell autocontido na demonstração'} for m in MODELS]
    d['versao'] = '3.5.0'
    d['atualizadoEm'] = '2026-09-03'
    d['quantidade'] = len(d['categorias'])
    compact = json.dumps(d, ensure_ascii=False, separators=(',', ':'))
    p.write_text(compact, encoding='utf-8')
    (ROOT / 'dados/categorias.js').write_text('window.CATALOGO_CATEGORIAS=' + compact + ';\n', encoding='utf-8')

def patch_docs():
    p = ROOT / 'README.md'
    t = p.read_text(encoding='utf-8')
    line = '- `NSxx` / `NLxx` → navegação superior/lateral → slot `MENU`\n'
    if line not in t:
        anchor = '- `Fxx` → rodapé → slot `RODAPE`\n'
        if anchor in t:
            t = t.replace(anchor, anchor + line, 1)
        else:
            t += '\n' + line
    p.write_text(t, encoding='utf-8')

def validate():
    reg = json.loads((ROOT / 'instalador/modelos.json').read_text(encoding='utf-8'))['modelos']
    for m in MODELS:
        folder = ROOT / 'frontend' / m['folder']
        src = (folder / 'bloco-pronto.html').read_text(encoding='utf-8')
        assert src == (folder / 'bloco-pronto.txt').read_text(encoding='utf-8')
        ps = (folder / 'instalar.ps1').read_text(encoding='utf-8')
        low = ps.lower()
        for bad in ['npx ', 'github.com/', 'api.github.com', 'raw.githubusercontent.com', 'git clone', 'invoke-webrequest', 'invoke-restmethod']:
            assert bad not in low
        detail = (folder / 'index.html').read_text(encoding='utf-8')
        match = re.search('<pre id="command">([\\s\\S]*?)</pre>', detail)
        assert match and html.unescape(match.group(1)) == ps
        item = reg[m['id']]
        assert item['slot'] == 'MENU' and item['parteMenu'] == m['parte']
    cats = json.loads((ROOT / 'dados/categorias.json').read_text(encoding='utf-8'))['categorias']
    menu = next((x for x in cats if x.get('slug') == 'menus'))
    assert [x['id'] for x in menu['itens']] == [m['id'] for m in MODELS]
generate_files()
update_registry()
update_categories()
patch_docs()
validate()
print('NS01–NS03 e NL01–NL03 gerados e validados no slot MENU.')
