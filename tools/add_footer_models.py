from pathlib import Path
import json
import html
import re

ROOT = Path(__file__).resolve().parents[1]

FOOTERS = [
    {"id":"F01","nome":"Rodapé Institucional Sólido","folder":"F01-Rodape-Institucional-Solido","altura":"560px"},
    {"id":"F02","nome":"Rodapé Editorial em Faixas","folder":"F02-Rodape-Editorial-em-Faixas","altura":"690px"},
    {"id":"F03","nome":"Mega Rodapé de E-commerce","folder":"F03-Mega-Rodape-de-Ecommerce","altura":"800px"},
    {"id":"F04","nome":"Rodapé em Vidro com Glow","folder":"F04-Rodape-em-Vidro-com-Glow","altura":"650px"},
    {"id":"F05","nome":"Rodapé Utilitário de Aplicação","folder":"F05-Rodape-Utilitario-de-Aplicacao","altura":"270px"},
]


def ps_here_string(content: str):
    content = content.replace("\r\n", "\n").replace("\r", "\n")
    if re.search(r"(?m)^'@\s*$", content):
        import base64
        encoded = base64.b64encode(content.encode("utf-8")).decode("ascii")
        return "[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('" + encoded + "'))"
    return "@'\n" + content.rstrip("\n") + "\n'@"


PS_COMMON = r'''
$ErrorActionPreference = 'Stop'
$Root = (Get-Location).Path
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Get-FullPath([string]$Relative) {
    return [System.IO.Path]::GetFullPath((Join-Path $Root $Relative))
}

function Backup-File([string]$Relative) {
    $full = Get-FullPath $Relative
    if (-not (Test-Path -LiteralPath $full)) { return }
    $backupDir = Get-FullPath '.catalogo-s/backups'
    if (-not (Test-Path -LiteralPath $backupDir)) {
        New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmssfff'
    $safe = $Relative -replace '[\\/:*?"<>|]', '__'
    $destination = Join-Path $backupDir ($stamp + '__' + $safe + '.bak')
    Copy-Item -LiteralPath $full -Destination $destination -Force
    Write-Host "[Catálogo S] backup: $Relative"
}

function Write-TextFile([string]$Relative, [string]$Content, [switch]$SemBackup) {
    $full = Get-FullPath $Relative
    $directory = Split-Path -Parent $full
    if ($directory -and -not (Test-Path -LiteralPath $directory)) {
        New-Item -ItemType Directory -Force -Path $directory | Out-Null
    }
    if (Test-Path -LiteralPath $full) {
        $current = [System.IO.File]::ReadAllText($full)
        if ($current -eq $Content) { return }
        if (-not $SemBackup) { Backup-File $Relative }
    }
    [System.IO.File]::WriteAllText($full, $Content, $Utf8NoBom)
    Write-Host "[Catálogo S] gravado: $Relative"
}

function Ensure-Slots([string]$Html) {
    $menu = "<!-- CATALOGO-S:SLOT:MENU:START -->`r`n<!-- CATALOGO-S:SLOT:MENU:END -->"
    $components = "<!-- CATALOGO-S:SLOT:COMPONENTES:START -->`r`n<!-- CATALOGO-S:SLOT:COMPONENTES:END -->"
    $footer = "<!-- CATALOGO-S:SLOT:RODAPE:START -->`r`n<!-- CATALOGO-S:SLOT:RODAPE:END -->"
    if ($Html -notmatch 'CATALOGO-S:SLOT:MENU:START') {
        $Html = $Html -replace '(?i)<body([^>]*)>', ('<body$1>' + "`r`n" + $menu)
    }
    if ($Html -notmatch 'CATALOGO-S:SLOT:COMPONENTES:START') {
        $Html = $Html -replace '(?i)</body>', ($components + "`r`n</body>")
    }
    if ($Html -notmatch 'CATALOGO-S:SLOT:RODAPE:START') {
        $Html = $Html -replace '(?i)</body>', ($footer + "`r`n</body>")
    }
    return $Html
}

function Set-Slot([string]$Html, [string]$Name, [string]$Content) {
    $escaped = [System.Text.RegularExpressions.Regex]::Escape($Name)
    $pattern = '(?s)<!-- CATALOGO-S:SLOT:' + $escaped + ':START -->.*?<!-- CATALOGO-S:SLOT:' + $escaped + ':END -->'
    $replacement = "<!-- CATALOGO-S:SLOT:$Name`:START -->`r`n$Content`r`n<!-- CATALOGO-S:SLOT:$Name`:END -->"
    return [System.Text.RegularExpressions.Regex]::Replace($Html, $pattern, $replacement)
}

function Ensure-HostPage {
    $index = Get-FullPath 'index.html'
    if (-not (Test-Path -LiteralPath $index)) {
        $shell = '<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Projeto</title></head><body></body></html>'
        Write-TextFile 'index.html' (Ensure-Slots $shell) -SemBackup
        return
    }
    $html = [System.IO.File]::ReadAllText($index)
    $prepared = Ensure-Slots $html
    if ($prepared -ne $html) {
        Write-TextFile 'index.html' $prepared
    }
}
'''.strip()


def footer_ps_script(mid, name, source):
    assignments = (
        f"$ModeloId = '{mid}'\n"
        f"$ModeloNome = '{name.replace(chr(39), chr(39) * 2)}'\n"
        f"$ConteudoModelo = {ps_here_string(source)}\n"
    )
    body = r'''
Ensure-HostPage
$footerRelative = 'components/catalogo-s/rodape/ativo.html'
Write-TextFile $footerRelative $ConteudoModelo
$index = Get-FullPath 'index.html'
$html = [System.IO.File]::ReadAllText($index)
$html = Ensure-Slots $html
$updated = Set-Slot $html 'RODAPE' $ConteudoModelo
Write-TextFile 'index.html' $updated
Write-Host ""
Write-Host "[Catálogo S] $ModeloId — $ModeloNome instalado como rodapé ativo."
Write-Host "[Catálogo S] Rodapés são singleton: instalar outro Fxx substitui apenas o rodapé."
Write-Host "[Catálogo S] Nenhum arquivo foi baixado do GitHub."
'''.strip()
    return assignments + "\n" + PS_COMMON + "\n\n" + body + "\n"


def preview_html(mid, name, source):
    return f'''<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Preview {html.escape(mid)}</title><style>*{{box-sizing:border-box}}html,body{{margin:0;min-height:100%;overflow-x:hidden;background:#e7eaee;font-family:Arial,Helvetica,sans-serif}}.demo-page{{min-height:38svh;display:grid;place-items:center;padding:32px;background:linear-gradient(135deg,#f7f8fa,#dfe5eb);color:#7a838e}}.demo-page div{{width:min(920px,90%);height:120px;border:1px dashed #aeb7c2;border-radius:20px;display:grid;place-items:center;font-size:11px;font-weight:900;letter-spacing:.16em;text-transform:uppercase}}</style></head><body><main class="demo-page"><div>Conteúdo da página acima do rodapé</div></main>{source}</body></html>'''


def demo_html(mid, name, script):
    title = f"{mid} — {name}"
    escaped_script = html.escape(script)
    return f'''<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{html.escape(title)}</title><style>*{{box-sizing:border-box}}html,body{{margin:0;background:#08090c;color:#f7f3e9;font-family:Arial,Helvetica,sans-serif}}body{{min-height:100svh}}.preview{{height:100svh;background:#e7eaee}}.preview iframe{{display:block;width:100%;height:100%;border:0}}.install{{min-height:70svh;display:grid;place-items:center;padding:54px 22px;border-top:1px solid rgba(255,255,255,.08)}}.box{{width:min(1180px,100%)}}.head{{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:15px}}h1{{margin:0;font:500 clamp(25px,3.4vw,42px)/1.05 Georgia,serif;letter-spacing:-.025em}}button{{border:1px solid rgba(255,255,255,.15);background:#15181e;color:#f7f3e9;border-radius:10px;padding:11px 15px;font-weight:800;cursor:pointer}}button:hover{{border-color:#d1ad73;color:#d1ad73}}pre{{margin:0;max-height:72svh;overflow:auto;border:1px solid rgba(255,255,255,.1);border-radius:16px;background:#0b0d11;padding:22px;color:#ece8dd;font:13px/1.58 Consolas,Monaco,monospace;white-space:pre;tab-size:2}}.back{{position:fixed;z-index:50;left:16px;top:16px;width:44px;height:44px;display:grid;place-items:center;border-radius:50%;background:rgba(8,9,12,.7);border:1px solid rgba(255,255,255,.14);color:#fff;text-decoration:none;font-size:21px;backdrop-filter:blur(12px)}}@media(max-width:600px){{.head{{align-items:flex-start;flex-direction:column}}button{{width:100%}}pre{{font-size:11px}}}}</style></head><body><a class="back" href="../../index.html#categoria=rodapes" aria-label="Voltar">←</a><section class="preview"><iframe src="preview.html" title="Demonstração {mid}" scrolling="no"></iframe></section><section class="install"><div class="box"><div class="head"><h1>{html.escape(title)}</h1><button id="copy" type="button">Copiar código PowerShell</button></div><pre id="command">{escaped_script}</pre></div></section><script>const b=document.getElementById('copy'),c=document.getElementById('command');b.addEventListener('click',async()=>{{try{{await navigator.clipboard.writeText(c.textContent)}}catch{{const r=document.createRange();r.selectNodeContents(c);const s=getSelection();s.removeAllRanges();s.addRange(r);document.execCommand('copy');s.removeAllRanges()}}b.textContent='Copiado';setTimeout(()=>b.textContent='Copiar código PowerShell',1200)}});</script></body></html>'''


def readme(mid, name):
    return f'''{mid} — {name}\n\nINSTALAÇÃO PÚBLICA\nAbra a demonstração do modelo, copie o bloco PowerShell completo e cole no PowerShell aberto na raiz do projeto.\n\nCOMPORTAMENTO\n- instala o rodapé no slot CATALOGO-S:SLOT:RODAPE;\n- mantém somente um rodapé ativo por site;\n- trocar Fxx substitui apenas o rodapé;\n- o rodapé ativo é preservado quando uma nova tela inicial Ixx é instalada;\n- cria backup antes de substituir arquivos existentes;\n- não usa npx e não consulta o GitHub.\n\nARQUIVO AUDITÁVEL\ninstalar.ps1\n\nMODO\nRodapé singleton\n'''


def patch_home_installers():
    marker = '# CATALOGO-S:REBUILD-RODAPE'
    old = "if ($Papel -eq 'inicio') {\n    Rebuild-Components\n}"
    new = """if ($Papel -eq 'inicio') {
    Rebuild-Components

    # CATALOGO-S:REBUILD-RODAPE
    $footerRelative = 'components/catalogo-s/rodape/ativo.html'
    $footerFull = Get-FullPath $footerRelative
    if (Test-Path -LiteralPath $footerFull) {
        $footerContent = [System.IO.File]::ReadAllText($footerFull)
        $index = Get-FullPath 'index.html'
        $html = [System.IO.File]::ReadAllText($index)
        $html = Ensure-Slots $html
        $updated = Set-Slot $html 'RODAPE' $footerContent
        Write-TextFile 'index.html' $updated
    }
}"""
    for folder in sorted((ROOT / 'frontend').glob('I*-*')):
        installer = folder / 'instalar.ps1'
        if not installer.exists():
            continue
        text = installer.read_text(encoding='utf-8')
        if marker in text:
            continue
        if old not in text:
            raise RuntimeError(f'Trecho de recomposição não encontrado em {installer}')
        installer.write_text(text.replace(old, new, 1), encoding='utf-8')


def update_registry():
    path = ROOT / 'instalador/modelos.json'
    data = json.loads(path.read_text(encoding='utf-8'))
    models = data['modelos']
    for model in FOOTERS:
        mid = model['id']
        folder = model['folder']
        models[mid] = {
            'id': mid, 'nome': model['nome'], 'tipo': 'frontend', 'papel': 'rodape', 'modo': 'rodape',
            'template': f'frontend/{folder}/bloco-pronto.html',
            'instaladorPublico': f'frontend/{folder}/instalar.ps1',
            'destino': 'inicio', 'slot': 'RODAPE', 'altura': model['altura'],
        }
    data['modelos'] = dict(sorted(models.items()))
    data['geradoEm'] = '2026-09-03'
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def update_categories():
    path = ROOT / 'dados/categorias.json'
    data = json.loads(path.read_text(encoding='utf-8'))
    category = next(c for c in data['categorias'] if c.get('slug') == 'rodapes')
    category['descricao'] = 'Rodapés profissionais para encerramento, navegação secundária, confiança, contato e ações finais.'
    category['itens'] = [
        {'id':m['id'],'nome':m['nome'],'caminho':f"frontend/{m['folder']}/index.html",'situacao':'Candidato','instalacao':'PowerShell autocontido na demonstração'}
        for m in FOOTERS
    ]
    data['versao'] = '3.2.0'
    data['atualizadoEm'] = '2026-09-03'
    data['quantidade'] = len(data['categorias'])
    compact = json.dumps(data, ensure_ascii=False, separators=(',', ':'))
    path.write_text(compact, encoding='utf-8')
    (ROOT / 'dados/categorias.js').write_text('window.CATALOGO_CATEGORIAS=' + compact + ';\n', encoding='utf-8')


def patch_once(path, needle, replacement):
    text = path.read_text(encoding='utf-8')
    if replacement in text:
        return
    if needle not in text:
        raise RuntimeError(f'Trecho esperado não encontrado em {path}')
    path.write_text(text.replace(needle, replacement, 1), encoding='utf-8')


def update_docs():
    patch_once(ROOT / 'README.md', '- `Exx`, `Cxx` e `Pxx` → componentes repetíveis\n', '- `Exx`, `Cxx` e `Pxx` → componentes repetíveis\n- `Fxx` → rodapé singleton → slot `RODAPE`\n')
    patch_once(ROOT / 'README.md', '- ao trocar a tela inicial, os componentes locais existentes são recompostos;\n', '- ao trocar a tela inicial, os componentes locais existentes são recompostos;\n- o rodapé `Fxx` ativo é recomposto no slot `RODAPE` e não é perdido ao trocar `Ixx`;\n')
    patch_once(ROOT / 'instalador/README.md', '- recompõe os componentes ao trocar a tela inicial;\n', '- recompõe os componentes ao trocar a tela inicial;\n- mantém um único `Fxx` ativo em `components/catalogo-s/rodape/ativo.html` e o recompõe no slot `RODAPE`;\n')
    patch_once(ROOT / 'documentacao/COMO-ADICIONAR-UM-MODELO.md', '- componentes repetíveis são criados em `components/catalogo-s/` e inseridos no slot de componentes;\n', '- componentes repetíveis são criados em `components/catalogo-s/` e inseridos no slot de componentes;\n- rodapés `Fxx` são singleton, usam `components/catalogo-s/rodape/ativo.html` e ocupam o slot `RODAPE`;\n')
    arch = ROOT / 'documentacao/ARQUITETURA-INSTALADOR-TERMINAL.md'
    text = arch.read_text(encoding='utf-8')
    if '## Rodapés Fxx' not in text:
        marker = '## LG01–LG05 ↔ DB01\n'
        section = '''## Rodapés Fxx

`Fxx` é uma família singleton. O rodapé ativo fica em:

```text
components/catalogo-s/rodape/ativo.html
```

O instalador injeta o conteúdo no slot `CATALOGO-S:SLOT:RODAPE`. Instalar outro `Fxx` substitui somente esse arquivo e esse slot. Ao trocar uma tela inicial `Ixx`, o instalador recompõe o rodapé ativo a partir do arquivo local, preservando-o sem acesso remoto.

'''
        if marker not in text:
            raise RuntimeError('Ponto de inserção não encontrado na arquitetura.')
        arch.write_text(text.replace(marker, section + marker, 1), encoding='utf-8')


def patch_tests():
    path = ROOT / '.github/workflows/teste-instalador.yml'
    text = path.read_text(encoding='utf-8')
    text = text.replace("assert len(models)==25, f'esperados 25 modelos, encontrados {len(models)}'", "assert len(models)==30, f'esperados 30 modelos, encontrados {len(models)}'")
    text = text.replace("print('25 modelos: contrato, metadados, previews, scroll e códigos sincronizados.')", "print('30 modelos: contrato, metadados, previews, scroll e códigos sincronizados.')")
    text = text.replace("assert checked == len(MODELS) == 25, f'esperados 25 modelos, validados {checked}'", "assert checked == len(MODELS) == 30, f'esperados 30 modelos, validados {checked}'")

    anchor = "          login_ids={'LG01','LG02','LG03','LG04','LG05'}\n          db=models['DB01']"
    repl = """          login_ids={'LG01','LG02','LG03','LG04','LG05'}
          footer_ids={'F01','F02','F03','F04','F05'}
          assert footer_ids.issubset(models), 'família Fxx incompleta'
          for footer_id in footer_ids:
              footer=models[footer_id]
              assert footer.get('modo')=='rodape', f'{footer_id}: modo deve ser rodape'
              assert footer.get('slot')=='RODAPE', f'{footer_id}: slot incorreto'
          db=models['DB01']"""
    if "footer_ids={'F01'" not in text:
        if anchor not in text:
            raise RuntimeError('Âncora de Fxx não encontrada nos testes.')
        text = text.replace(anchor, repl, 1)

    if '              rodape)' not in text:
        needle = '              banco)\n'
        insert = '''              rodape)
                test -f "$projeto/components/catalogo-s/rodape/ativo.html"
                grep -q 'CATALOGO-S:SLOT:RODAPE:START' "$projeto/index.html"
                grep -q "data-catalogo-s-model=\"$id\"" "$projeto/index.html"
                grep -q "data-catalogo-s-model=\"$id\"" "$projeto/components/catalogo-s/rodape/ativo.html"
                ;;
              banco)
'''
        if needle not in text:
            raise RuntimeError('Case banco não encontrado nos testes.')
        text = text.replace(needle, insert, 1)

    cmd_anchor = '          pwsh -NoProfile -File "$ROOT/backend/DB01-Banco-do-LG01/instalar.ps1"\n\n          for id in C01 E01 P01; do'
    cmd_repl = '          pwsh -NoProfile -File "$ROOT/backend/DB01-Banco-do-LG01/instalar.ps1"\n          pwsh -NoProfile -File "$ROOT/frontend/F01-Rodape-Institucional-Solido/instalar.ps1"\n\n          for id in C01 E01 P01; do'
    if 'F01-Rodape-Institucional-Solido/instalar.ps1' not in text:
        if cmd_anchor not in text:
            raise RuntimeError('Âncora de composição F01 não encontrada.')
        text = text.replace(cmd_anchor, cmd_repl, 1)

    p_anchor = '          test -f database/schema.sql\n          grep -q "loginEndpoint:\'/api/auth/login\'" assets/js/catalogo-s.config.js'
    p_repl = '          test -f database/schema.sql\n          test -f components/catalogo-s/rodape/ativo.html\n          grep -q \'data-catalogo-s-model="F01"\' index.html\n          grep -q "loginEndpoint:\'/api/auth/login\'" assets/js/catalogo-s.config.js'
    if 'test -f components/catalogo-s/rodape/ativo.html' not in text:
        if p_anchor not in text:
            raise RuntimeError('Âncora de preservação F01 não encontrada.')
        text = text.replace(p_anchor, p_repl, 1)

    post_i02 = '''          pwsh -NoProfile -File "$ROOT/frontend/I02-Tela-Inicial-com-Imagem-Cobertura-Total/instalar.ps1"
          for id in C01 E01 P01; do
            grep -q "data-catalogo-s-model=\"$id\"" index.html
          done
          test "$(grep -o 'scrolling=\"no\"' index.html | wc -l)" -ge 3'''
    expanded = post_i02 + '''
          grep -q 'data-catalogo-s-model="F01"' index.html

          pwsh -NoProfile -File "$ROOT/frontend/F02-Rodape-Editorial-em-Faixas/instalar.ps1"
          grep -q 'data-catalogo-s-model="F02"' index.html
          ! grep -q 'data-catalogo-s-model="F01"' index.html'''
    if 'F02-Rodape-Editorial-em-Faixas/instalar.ps1' not in text:
        if post_i02 not in text:
            raise RuntimeError('Âncora de troca F01/F02 não encontrada.')
        text = text.replace(post_i02, expanded, 1)

    path.write_text(text, encoding='utf-8')


def generate_footers():
    for model in FOOTERS:
        folder = ROOT / 'frontend' / model['folder']
        source_path = folder / 'bloco-pronto.html'
        if not source_path.exists():
            raise RuntimeError(f'Fonte ausente: {source_path}')
        source = source_path.read_text(encoding='utf-8')
        (folder / 'bloco-pronto.txt').write_text(source, encoding='utf-8')
        script = footer_ps_script(model['id'], model['nome'], source)
        (folder / 'instalar.ps1').write_text(script, encoding='utf-8')
        (folder / 'preview.html').write_text(preview_html(model['id'], model['nome'], source), encoding='utf-8')
        (folder / 'index.html').write_text(demo_html(model['id'], model['nome'], script), encoding='utf-8')
        (folder / 'LEIA-ME.txt').write_text(readme(model['id'], model['nome']), encoding='utf-8')


generate_footers()
patch_home_installers()
update_registry()
update_categories()
update_docs()
patch_tests()
print('F01–F05 gerados, registrados e integrados ao slot RODAPE.')
