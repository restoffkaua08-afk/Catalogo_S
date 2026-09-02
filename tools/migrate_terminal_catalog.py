from pathlib import Path
import json
import html
import re

ROOT = Path(__file__).resolve().parents[1]

CATEGORY_BY_PREFIX = {
    'LG': 'login',
    'DB': 'banco-de-dados',
    'I': 'telas-iniciais',
    'C': 'carrosseis',
    'E': 'telas',
    'L': 'listagens',
    'P': 'pesquisa',
}

ROLE_BY_PREFIX = {
    'I': ('pagina', 'inicio', 'index.html'),
    'L': ('pagina', 'produtos', 'produtos.html'),
    'LG': ('pagina', 'login', 'login.html'),
    'E': ('componente', 'secao', ''),
    'C': ('componente', 'carrossel', ''),
    'P': ('componente', 'pesquisa', ''),
}


def model_id(folder: Path):
    return folder.name.split('-', 1)[0].upper()


def prefix(mid: str):
    if mid.startswith('LG'):
        return 'LG'
    if mid.startswith('DB'):
        return 'DB'
    match = re.match(r'[A-Z]+', mid)
    return match.group(0) if match else ''


def human_name(folder: Path):
    parts = folder.name.split('-', 1)
    return (parts[1] if len(parts) > 1 else parts[0]).replace('-', ' ')


def load_active_names():
    path = ROOT / 'dados/categorias.json'
    if not path.exists():
        return {}
    data = json.loads(path.read_text(encoding='utf-8'))
    names = {}
    for category in data.get('categorias', []):
        for item in category.get('itens', []):
            names[item['id'].upper()] = item['nome']
    return names


ACTIVE_NAMES = load_active_names()


def ps_here_string(content: str):
    content = content.replace('\r\n', '\n').replace('\r', '\n')
    if re.search(r"(?m)^'@\s*$", content):
        import base64
        encoded = base64.b64encode(content.encode('utf-8')).decode('ascii')
        return "[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('" + encoded + "'))"
    return "@'\n" + content.rstrip('\n') + "\n'@"


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

function Rebuild-Components {
    Ensure-HostPage
    $index = Get-FullPath 'index.html'
    $html = [System.IO.File]::ReadAllText($index)
    $html = Ensure-Slots $html

    $componentDir = Get-FullPath 'components/catalogo-s'
    $sections = @()

    if (Test-Path -LiteralPath $componentDir) {
        $files = Get-ChildItem -LiteralPath $componentDir -Filter '*.html' -File | Sort-Object LastWriteTime, Name

        foreach ($file in $files) {
            $key = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
            $parts = $key -split '-'
            $id = $parts[0].ToUpperInvariant()
            $relative = 'components/catalogo-s/' + $file.Name
            $sections += "<section id=`"catalogo-s-$key`" data-catalogo-s-instance=`"$key`" data-catalogo-s-model=`"$id`" style=`"width:100%;min-height:100vh;overflow:hidden`"><iframe src=`"$relative`" title=`"$id`" loading=`"lazy`" style=`"display:block;width:100%;height:100vh;border:0`"></iframe></section>"
        }
    }

    $updated = Set-Slot $html 'COMPONENTES' ($sections -join "`r`n")
    Write-TextFile 'index.html' $updated
}
'''.strip()


def transform_login_html(source: str):
    out = source
    if 'assets/js/catalogo-s.config.js' not in out:
        out = re.sub(
            r'</head>',
            '<script src="assets/js/catalogo-s.config.js"></script>\n</head>',
            out,
            count=1,
            flags=re.I,
        )
    out = re.sub(
        r"const DESTINO_APOS_LOGIN\s*=\s*['\"][^'\"]*['\"]\s*;",
        "const DESTINO_APOS_LOGIN=window.CATALOGO_S_CONFIG?.auth?.afterLogin||'index.html';",
        out,
        count=1,
    )
    out = re.sub(
        r"const ENDPOINT_LOGIN\s*=\s*['\"][^'\"]*['\"]\s*;",
        "const ENDPOINT_LOGIN=window.CATALOGO_S_CONFIG?.auth?.loginEndpoint||'';",
        out,
        count=1,
    )
    out = re.sub(
        r"const ENDPOINT_CADASTRO\s*=\s*['\"][^'\"]*['\"]\s*;",
        "const ENDPOINT_CADASTRO=window.CATALOGO_S_CONFIG?.auth?.cadastroEndpoint||'';",
        out,
        count=1,
    )
    return out


def page_ps_script(mid: str, name: str, role: str, target: str, source: str):
    if role == 'login':
        source = transform_login_html(source)

    assignments = (
        f"$ModeloId = '{mid}'\n"
        f"$ModeloNome = '{name.replace(chr(39), chr(39) * 2)}'\n"
        f"$Papel = '{role}'\n"
        f"$ArquivoAlvo = '{target}'\n"
        f"$ConteudoModelo = {ps_here_string(source)}\n"
    )

    body = r'''
if ($Papel -eq 'inicio') {
    $ConteudoModelo = Ensure-Slots $ConteudoModelo
}

Write-TextFile $ArquivoAlvo $ConteudoModelo

if ($Papel -eq 'inicio') {
    Rebuild-Components
}

if ($Papel -eq 'login') {
    $loginApi = Test-Path -LiteralPath (Get-FullPath 'api/auth/login.js')
    $cadastroApi = Test-Path -LiteralPath (Get-FullPath 'api/auth/cadastro.js')

    $loginEndpoint = ''
    $cadastroEndpoint = ''
    if ($loginApi -and $cadastroApi) {
        $loginEndpoint = '/api/auth/login'
        $cadastroEndpoint = '/api/auth/cadastro'
    }

    $config = "// Gerado localmente pelo Catálogo S.`r`nwindow.CATALOGO_S_CONFIG={auth:{afterLogin:'index.html',loginEndpoint:'$loginEndpoint',cadastroEndpoint:'$cadastroEndpoint'}};`r`n"
    Write-TextFile 'assets/js/catalogo-s.config.js' $config
}

Write-Host ""
Write-Host "[Catálogo S] $ModeloId — $ModeloNome instalado com sucesso."
Write-Host "[Catálogo S] Nenhum arquivo foi baixado do GitHub."
'''.strip()

    return assignments + "\n" + PS_COMMON + "\n\n" + body + "\n"


def component_ps_script(mid: str, name: str, source: str):
    assignments = (
        f"$ModeloId = '{mid}'\n"
        f"$ModeloNome = '{name.replace(chr(39), chr(39) * 2)}'\n"
        f"$ConteudoModelo = {ps_here_string(source)}\n"
    )

    body = r'''
Ensure-HostPage

$componentDir = Get-FullPath 'components/catalogo-s'
if (-not (Test-Path -LiteralPath $componentDir)) {
    New-Item -ItemType Directory -Force -Path $componentDir | Out-Null
}

$base = $ModeloId.ToLowerInvariant()
$numero = 1
do {
    $arquivo = "$base-$numero.html"
    $relative = 'components/catalogo-s/' + $arquivo
    $full = Get-FullPath $relative
    $numero++
} while (Test-Path -LiteralPath $full)

Write-TextFile $relative $ConteudoModelo -SemBackup
Rebuild-Components

Write-Host ""
Write-Host "[Catálogo S] $ModeloId — $ModeloNome instalado como componente."
Write-Host "[Catálogo S] Arquivo criado: $relative"
Write-Host "[Catálogo S] Nenhum arquivo foi baixado do GitHub."
'''.strip()

    return assignments + "\n" + PS_COMMON + "\n\n" + body + "\n"


def db_ps_script(db: Path):
    schema = (db / 'schema.sql').read_text(encoding='utf-8')
    files = {
        'database/schema.sql': schema,
        'lib/catalogo-s-db.js': (ROOT / 'instalador/templates/DB01/lib/catalogo-s-db.js').read_text(encoding='utf-8'),
        'api/auth/login.js': (ROOT / 'instalador/templates/DB01/api/auth/login.js').read_text(encoding='utf-8'),
        'api/auth/cadastro.js': (ROOT / 'instalador/templates/DB01/api/auth/cadastro.js').read_text(encoding='utf-8'),
    }

    assignments = "$ModeloId = 'DB01'\n$ModeloNome = 'Banco do LG01'\n"
    for index, (relative, content) in enumerate(files.items(), start=1):
        assignments += f"$Arquivo{index} = '{relative}'\n$Conteudo{index} = {ps_here_string(content)}\n"

    writes = []
    for index, _relative in enumerate(files.keys(), start=1):
        writes.append(f"Write-TextFile $Arquivo{index} $Conteudo{index}")
    write_block = "\n".join(writes)

    body = f'''
{write_block}

$envExamplePath = Get-FullPath '.env.example'
$envCurrent = ''
if (Test-Path -LiteralPath $envExamplePath) {{
    $envCurrent = [System.IO.File]::ReadAllText($envExamplePath)
}}

if ($envCurrent -notmatch '(?m)^DATABASE_URL=') {{
    $separator = ''
    if ($envCurrent.Trim().Length -gt 0) {{ $separator = "`r`n`r`n" }}
    $envUpdated = $envCurrent.TrimEnd() + $separator + "# DB01 — banco`r`nDATABASE_URL=mysql://USUARIO:SENHA@HOST:3306/catalogo_login_lg01`r`n"
    Write-TextFile '.env.example' $envUpdated
}}

$config = "// Gerado localmente pelo Catálogo S.`r`nwindow.CATALOGO_S_CONFIG={{auth:{{afterLogin:'index.html',loginEndpoint:'/api/auth/login',cadastroEndpoint:'/api/auth/cadastro'}}}};`r`n"
Write-TextFile 'assets/js/catalogo-s.config.js' $config

$packagePath = Get-FullPath 'package.json'
if (-not (Test-Path -LiteralPath $packagePath)) {{
    $package = "{{`r`n  `"private`": true,`r`n  `"type`": `"module`"`r`n}}`r`n"
    Write-TextFile 'package.json' $package -SemBackup
}} else {{
    try {{
        $packageObject = [System.IO.File]::ReadAllText($packagePath) | ConvertFrom-Json
        if ($null -eq $packageObject.type) {{
            $packageObject | Add-Member -NotePropertyName type -NotePropertyValue 'module' -Force
            $packageJson = ($packageObject | ConvertTo-Json -Depth 30) + "`r`n"
            Write-TextFile 'package.json' $packageJson
        }} elseif ($packageObject.type -ne 'module') {{
            Write-Warning 'DB01 usa módulos ESM. O package.json atual possui type diferente de module; revise antes de publicar.'
        }}
    }} catch {{
        Write-Warning 'Não foi possível analisar package.json. Os arquivos do DB01 foram instalados, mas revise o tipo de módulo manualmente.'
    }}
}}

if ($env:CATALOGO_S_SKIP_DEPS -eq '1') {{
    Write-Host '[Catálogo S] instalação de dependências ignorada por CATALOGO_S_SKIP_DEPS=1.'
}} elseif (Get-Command npm -ErrorAction SilentlyContinue) {{
    Write-Host '[Catálogo S] instalando mysql2 e bcryptjs pelo npm...'
    & npm install mysql2 bcryptjs --save
    if ($LASTEXITCODE -ne 0) {{
        throw 'Falha ao instalar mysql2 e bcryptjs.'
    }}
}} else {{
    Write-Warning 'npm não encontrado. Instale manualmente os pacotes mysql2 e bcryptjs antes de executar o backend.'
}}

Write-Host ""
Write-Host '[Catálogo S] DB01 — Banco do LG01 instalado.'
Write-Host '[Catálogo S] Nenhum arquivo foi baixado do GitHub.'
'''.strip()

    return assignments + "\n" + PS_COMMON + "\n\n" + body + "\n"


def demo_html(mid: str, name: str, preview: str, category: str, script: str):
    title = f'{mid} — {name}'
    escaped_script = html.escape(script)
    return f'''<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{html.escape(title)}</title>
<style>
*{{box-sizing:border-box}}html,body{{margin:0;background:#08090c;color:#f7f3e9;font-family:Arial,Helvetica,sans-serif}}body{{min-height:100svh}}.preview{{height:100svh;background:#050607}}.preview iframe{{display:block;width:100%;height:100%;border:0}}.install{{min-height:70svh;display:grid;place-items:center;padding:54px 22px;border-top:1px solid rgba(255,255,255,.08)}}.box{{width:min(1180px,100%)}}.head{{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:15px}}h1{{margin:0;font:500 clamp(25px,3.4vw,42px)/1.05 Georgia,serif;letter-spacing:-.025em}}button{{border:1px solid rgba(255,255,255,.15);background:#15181e;color:#f7f3e9;border-radius:10px;padding:11px 15px;font-weight:800;cursor:pointer}}button:hover{{border-color:#d1ad73;color:#d1ad73}}pre{{margin:0;max-height:72svh;overflow:auto;border:1px solid rgba(255,255,255,.1);border-radius:16px;background:#0b0d11;padding:22px;color:#ece8dd;font:13px/1.58 Consolas,Monaco,monospace;white-space:pre;tab-size:2}}.back{{position:fixed;z-index:50;left:16px;top:16px;width:44px;height:44px;display:grid;place-items:center;border-radius:50%;background:rgba(8,9,12,.7);border:1px solid rgba(255,255,255,.14);color:#fff;text-decoration:none;font-size:21px;backdrop-filter:blur(12px)}}@media(max-width:600px){{.head{{align-items:flex-start;flex-direction:column}}button{{width:100%}}pre{{font-size:11px}}}}
</style>
</head>
<body>
<a class="back" href="../../index.html#categoria={category}" aria-label="Voltar">←</a>
<section class="preview"><iframe src="{preview}" title="Demonstração {mid}"></iframe></section>
<section class="install"><div class="box"><div class="head"><h1>{html.escape(title)}</h1><button id="copy" type="button">Copiar código PowerShell</button></div><pre id="command">{escaped_script}</pre></div></section>
<script>
const b=document.getElementById('copy'),c=document.getElementById('command');
b.addEventListener('click',async()=>{{try{{await navigator.clipboard.writeText(c.textContent)}}catch{{const r=document.createRange();r.selectNodeContents(c);const s=getSelection();s.removeAllRanges();s.addRange(r);document.execCommand('copy');s.removeAllRanges()}}b.textContent='Copiado';setTimeout(()=>b.textContent='Copiar código PowerShell',1200)}});
</script>
</body>
</html>
'''


def readme(mid: str, name: str, kind: str):
    return f'''{mid} — {name}

INSTALAÇÃO PÚBLICA
Abra a demonstração do modelo, copie o bloco PowerShell completo e cole no PowerShell aberto na raiz do projeto.

O script exibido na demonstração é autocontido:
- contém o payload necessário do modelo;
- não usa npx;
- não consulta o GitHub;
- não exige acesso ao repositório do Catálogo S;
- cria backup antes de substituir arquivos existentes.

ARQUIVO AUDITÁVEL
instalar.ps1

MODO
{kind}
'''


def db_preview():
    rows = [
        ('id', 'BIGINT UNSIGNED', 'PRIMARY KEY · AUTO_INCREMENT', 'Identificador'),
        ('nome', 'VARCHAR(120)', 'NOT NULL', 'Cadastro'),
        ('email', 'VARCHAR(190)', 'UNIQUE · NOT NULL', 'Cadastro / login'),
        ('senha_hash', 'VARCHAR(255)', 'NOT NULL', 'Hash da senha'),
        ('criado_em', 'TIMESTAMP', 'DEFAULT CURRENT_TIMESTAMP', 'Criação'),
        ('atualizado_em', 'TIMESTAMP', 'ON UPDATE', 'Atualização'),
    ]
    body = ''.join(f'<tr><td>{a}</td><td>{b}</td><td>{c}</td><td>{d}</td></tr>' for a, b, c, d in rows)
    return f'''<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>DB01</title><style>*{{box-sizing:border-box}}html,body{{margin:0;min-height:100%;background:#08090c;color:#eee;font-family:Arial,sans-serif}}body{{min-height:100svh;display:grid;place-items:center;padding:24px}}.wrap{{width:min(1100px,100%);overflow:auto;border:1px solid rgba(255,255,255,.1);border-radius:18px}}table{{width:100%;border-collapse:collapse;min-width:760px;background:#101218}}th,td{{padding:16px;text-align:left;border-bottom:1px solid rgba(255,255,255,.08)}}th{{color:#d1ad73;font-size:11px;text-transform:uppercase;letter-spacing:.08em}}td{{font-size:13px}}tr:last-child td{{border-bottom:0}}</style></head><body><div class="wrap"><table><thead><tr><th>Coluna</th><th>Tipo</th><th>Chave / atributo</th><th>Uso</th></tr></thead><tbody>{body}</tbody></table></div></body></html>'''


def build_registry(folders):
    models = {}
    for folder in folders:
        mid = model_id(folder)
        pref = prefix(mid)
        name = ACTIVE_NAMES.get(mid, human_name(folder))
        source = (folder / 'bloco-pronto.html').relative_to(ROOT).as_posix()
        if pref not in ROLE_BY_PREFIX:
            continue
        mode, role, target = ROLE_BY_PREFIX[pref]
        item = {
            'id': mid,
            'nome': name,
            'tipo': 'frontend',
            'papel': role,
            'modo': mode,
            'template': source,
            'instaladorPublico': (folder / 'instalar.ps1').relative_to(ROOT).as_posix(),
        }
        if mode == 'pagina':
            item['target'] = target
            item['rotulo'] = {'inicio': 'Início', 'produtos': 'Produtos', 'login': 'Login'}.get(role, name)
        else:
            item['destino'] = 'inicio'
            item['altura'] = '100vh'
        models[mid] = item

    db = ROOT / 'backend/DB01-Banco-do-LG01'
    if db.exists():
        models['DB01'] = {
            'id': 'DB01',
            'nome': 'Banco do LG01',
            'tipo': 'backend',
            'papel': 'auth-db',
            'modo': 'banco',
            'pareadoCom': 'LG01',
            'schemaTemplate': 'backend/DB01-Banco-do-LG01/schema.sql',
            'instaladorPublico': 'backend/DB01-Banco-do-LG01/instalar.ps1',
            'arquivos': [
                {'origem': 'instalador/templates/DB01/lib/catalogo-s-db.js', 'destino': 'lib/catalogo-s-db.js'},
                {'origem': 'instalador/templates/DB01/api/auth/login.js', 'destino': 'api/auth/login.js'},
                {'origem': 'instalador/templates/DB01/api/auth/cadastro.js', 'destino': 'api/auth/cadastro.js'},
            ],
        }

    return {
        'schema': 3,
        'geradoEm': '2026-09-02',
        'instalacaoPublica': 'powershell-autocontido',
        'modelos': dict(sorted(models.items())),
    }


def update_categories():
    path = ROOT / 'dados/categorias.json'
    data = json.loads(path.read_text(encoding='utf-8'))
    data['versao'] = '3.0.0'
    data['atualizadoEm'] = '2026-09-02'
    data['quantidade'] = len(data.get('categorias', []))

    for category in data.get('categorias', []):
        for item in category.get('itens', []):
            item.pop('comando', None)
            item['instalacao'] = 'PowerShell autocontido na demonstração'

    compact = json.dumps(data, ensure_ascii=False, separators=(',', ':'))
    path.write_text(compact, encoding='utf-8')
    (ROOT / 'dados/categorias.js').write_text('window.CATALOGO_CATEGORIAS=' + compact + ';\n', encoding='utf-8')


def docs():
    (ROOT / 'instalador/README.md').write_text('''# Instalação do Catálogo S

## Fluxo público

A instalação pública não depende mais do GitHub nem de `npx`.

Cada demonstração contém um bloco **PowerShell autocontido** com todo o payload necessário para instalar aquele modelo. O usuário copia o bloco inteiro e cola no PowerShell aberto na raiz do projeto.

O script:
- cria os arquivos do modelo localmente;
- cria backups em `.catalogo-s/backups/` antes de substituir arquivos;
- mantém componentes repetíveis em `components/catalogo-s/`;
- recompõe os componentes ao trocar a tela inicial;
- conecta `LG01` e `DB01` quando os dois existem;
- não baixa nenhum arquivo do repositório durante a instalação.

Cada modelo também guarda a mesma versão auditável em `instalar.ps1`.

## Ferramentas internas

`instalador/catalogo-s.mjs` e `instalador/modelos.json` permanecem como ferramentas internas de desenvolvimento, contrato e testes do Catálogo S. Eles não são requisito para quem instala um modelo pelo site.
''', encoding='utf-8')

    (ROOT / 'documentacao/COMO-ADICIONAR-UM-MODELO.md').write_text('''# Como adicionar um modelo ao Catálogo S

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
''', encoding='utf-8')

    (ROOT / 'README.md').write_text('''# Catálogo S

Biblioteca visual de modelos reutilizáveis de frontend e backend.

## Uso atual

Abra a demonstração do modelo desejado. Abaixo do preview existe um bloco com **todo o script PowerShell de instalação**.

1. clique em **Copiar código PowerShell**;
2. abra o PowerShell na pasta raiz do seu projeto;
3. cole o bloco inteiro;
4. execute.

Esse é o fluxo oficial.

O script é autocontido: o payload necessário do modelo já está dentro dele. A instalação pública não usa `npx`, não busca arquivos no GitHub e não exige que o computador esteja conectado à conta que possui o repositório.

## Comportamento

- páginas equivalentes usam nomes canônicos;
- arquivos substituídos recebem backup em `.catalogo-s/backups/`;
- componentes repetíveis ficam em `components/catalogo-s/`;
- ao trocar a tela inicial, os componentes locais existentes são recompostos;
- `LG01` e `DB01` detectam um ao outro pelos arquivos locais;
- credenciais reais continuam fora do frontend.

## Convenções principais

- `Ixx` → tela inicial → `index.html`
- `Lxx` → página de produtos → `produtos.html`
- `LGxx` → login → `login.html`
- `Exx`, `Cxx` e `Pxx` → componentes repetíveis
- `DB01` → backend/banco pareado ao `LG01`

## Demonstrações

Toda demonstração deve possuir preview, título, botão de cópia e script PowerShell completo. Um modelo sem bloco de instalação é considerado incompleto.

## Status

Os seis modelos historicamente aprovados continuam: `E01`, `C01`, `E02`, `C02`, `C03` e `E03`. Os demais mantêm seus IDs e status anteriores.

A interface pública continua hospedada na Vercel. O GitHub permanece como fonte de desenvolvimento do Catálogo S, mas não é dependência de execução dos scripts copiados pelo usuário.
''', encoding='utf-8')

    (ROOT / 'documentacao/ARQUITETURA-INSTALADOR-TERMINAL.md').write_text('''# Arquitetura de instalação PowerShell autocontida — Catálogo S

## Estado

- Data: 2026-09-02
- Status: arquitetura pública migrada para PowerShell autocontido.
- Dependência pública do GitHub: nenhuma.
- Dependência pública de `npx`: nenhuma.
- Payload auditável por modelo: `instalar.ps1`.

## Regra central

> A demonstração precisa carregar tudo que o computador precisa para instalar o modelo.

O usuário não recebe um comando que baixa o Catálogo S. Ele recebe o script completo. Por isso, tornar o repositório privado não quebra instalações copiadas do site.

## Fluxo

```text
Demonstração na Vercel
        ↓
Copiar código PowerShell
        ↓
PowerShell aberto na raiz do projeto
        ↓
script autocontido
        ↓
arquivos locais do modelo
```

Nenhuma etapa exige autenticação no GitHub.

## Backups

Antes de substituir um arquivo existente, o instalador cria cópia em:

```text
.catalogo-s/backups/
```

## Páginas canônicas

| Papel | Arquivo |
|---|---|
| início | `index.html` |
| produtos | `produtos.html` |
| sobre | `sobre.html` |
| contato | `contato.html` |
| login | `login.html` |

Atualmente:

- `Ixx` instala/substitui `index.html`;
- `Lxx` instala/substitui `produtos.html`;
- `LGxx` instala/substitui `login.html`.

## Slots

Telas iniciais recebem slots locais:

```html
<!-- CATALOGO-S:SLOT:MENU:START -->
<!-- CATALOGO-S:SLOT:MENU:END -->

<!-- CATALOGO-S:SLOT:COMPONENTES:START -->
<!-- CATALOGO-S:SLOT:COMPONENTES:END -->

<!-- CATALOGO-S:SLOT:RODAPE:START -->
<!-- CATALOGO-S:SLOT:RODAPE:END -->
```

`Exx`, `Cxx` e `Pxx` são componentes repetíveis. Cada execução cria:

```text
components/catalogo-s/<id>-<numero>.html
```

O script recompõe o slot `COMPONENTES` usando os arquivos locais. Assim, substituir `I01` por `I02`, por exemplo, não exige consultar manifesto remoto nem recuperar componentes do GitHub.

## LG01 ↔ DB01

`LG01` usa:

```text
assets/js/catalogo-s.config.js
```

Ao instalar `LG01`, o script verifica se os endpoints do `DB01` já existem. Ao instalar `DB01`, o script grava a configuração com os endpoints. Portanto as duas ordens continuam possíveis.

O `DB01` inclui no próprio script:

- `database/schema.sql`;
- `lib/catalogo-s-db.js`;
- `api/auth/login.js`;
- `api/auth/cadastro.js`;
- atualização de `.env.example`.

Dependências npm do backend podem ser instaladas pelo próprio script, mas isso não envolve o GitHub.

## Regra para todos os modelos

Cada pasta de modelo deve possuir:

```text
bloco-pronto.*
index.html
instalar.ps1
LEIA-ME.txt
```

`index.html` precisa mostrar o conteúdo completo de `instalar.ps1` e oferecer um único botão de cópia.

## Ferramentas internas

O CLI Node anterior pode permanecer no repositório como ferramenta interna de contrato e regressão. Ele não faz parte do caminho de instalação pública e não deve aparecer como instrução nas demonstrações.

## Validação

A CI deve rejeitar qualquer modelo ativo quando:

- faltar `instalar.ps1`;
- faltar bloco de código ou botão de cópia na demonstração;
- o script público contiver `npx`, `git clone` ou URL/chamada para o GitHub;
- o script não puder ser executado em um projeto temporário;
- a página do modelo não exibir exatamente o mesmo script salvo em `instalar.ps1`.

## Remoção da família de efeitos

A família `Axx` permanece removida. Os IDs não serão reutilizados.
''', encoding='utf-8')


folders = []
for base in (ROOT / 'frontend',):
    if not base.exists():
        continue

    for folder in sorted(p for p in base.iterdir() if p.is_dir()):
        block = folder / 'bloco-pronto.html'
        if not block.exists():
            continue

        mid = model_id(folder)
        pref = prefix(mid)
        if pref not in ROLE_BY_PREFIX:
            continue

        folders.append(folder)
        name = ACTIVE_NAMES.get(mid, human_name(folder))
        mode, role, target = ROLE_BY_PREFIX[pref]
        source = block.read_text(encoding='utf-8')

        if mode == 'pagina':
            install_script = page_ps_script(mid, name, role, target, source)
            kind = 'Página canônica'
        else:
            install_script = component_ps_script(mid, name, source)
            kind = 'Componente repetível'

        (folder / 'instalar.ps1').write_text(install_script, encoding='utf-8')
        category = CATEGORY_BY_PREFIX.get(pref, 'telas')
        (folder / 'index.html').write_text(
            demo_html(mid, name, 'bloco-pronto.html', category, install_script),
            encoding='utf-8',
        )
        (folder / 'LEIA-ME.txt').write_text(readme(mid, name, kind), encoding='utf-8')

db = ROOT / 'backend/DB01-Banco-do-LG01'
if db.exists():
    install_script = db_ps_script(db)
    (db / 'instalar.ps1').write_text(install_script, encoding='utf-8')
    (db / 'preview.html').write_text(db_preview(), encoding='utf-8')
    (db / 'index.html').write_text(
        demo_html('DB01', 'Banco do LG01', 'preview.html', 'banco-de-dados', install_script),
        encoding='utf-8',
    )
    (db / 'LEIA-ME.txt').write_text(
        readme('DB01', 'Banco do LG01', 'Backend pareado ao LG01'),
        encoding='utf-8',
    )

(ROOT / 'instalador/modelos.json').write_text(
    json.dumps(build_registry(folders), ensure_ascii=False, indent=2) + '\n',
    encoding='utf-8',
)

update_categories()
docs()

print(f'PowerShell autocontido gerado para {len(folders)} modelos visuais + DB01.')
