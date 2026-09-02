$ModeloId = 'L04'
$ModeloNome = 'Grade Editorial com Filtros em Drawer'
$Papel = 'produtos'
$ArquivoAlvo = 'produtos.html'
$ConteudoModelo = @'
<style>
#l04{--ink:#f5f1e8;--muted:#9d998f;--line:#ffffff17;--surface:#111318;--accent:#d2ad72;max-width:1360px;margin:auto;color:var(--ink);font-family:Arial,sans-serif;position:relative}#l04 *{box-sizing:border-box}#l04 .top{display:flex;justify-content:space-between;align-items:center;gap:18px;margin-bottom:20px}#l04 .chips{display:flex;gap:8px;flex-wrap:wrap}#l04 .chip,#l04 .open-filter{padding:10px 15px;border:1px solid var(--line);border-radius:999px;background:transparent;color:var(--muted);cursor:pointer}#l04 .chip.active{color:#111;background:var(--accent);border-color:var(--accent)}#l04 .open-filter{color:var(--ink);background:var(--surface)}#l04 .grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:26px 18px}#l04 .card{position:relative;min-width:0}#l04 .visual{position:relative;aspect-ratio:4/5;overflow:hidden;background:#17191e}#l04 img{width:100%;height:100%;object-fit:cover;display:block;transition:transform .65s cubic-bezier(.2,.7,.2,1),filter .4s}#l04 .card:hover img{transform:scale(1.035);filter:brightness(.88)}#l04 .quick{position:absolute;left:14px;right:14px;bottom:14px;display:flex;gap:8px;transform:translateY(16px);opacity:0;transition:.28s}#l04 .card:hover .quick{transform:none;opacity:1}#l04 .quick button{flex:1;padding:11px;border:0;border-radius:7px;background:#f4f1e8;color:#111;font-weight:800;cursor:pointer}#l04 .info{padding:14px 2px}#l04 .meta{display:flex;justify-content:space-between;color:var(--muted);font-size:10px;text-transform:uppercase;letter-spacing:.1em}#l04 h3{margin:8px 0 8px;font:500 19px Georgia,serif}#l04 .price{font-weight:800}#l04 .card[hidden]{display:none}#l04 .scrim{position:fixed;inset:0;z-index:90;background:#0008;opacity:0;pointer-events:none;transition:.3s}#l04 .scrim.open{opacity:1;pointer-events:auto}#l04 .drawer{position:fixed;z-index:91;top:0;right:0;width:min(390px,92vw);height:100vh;padding:28px;background:#111318;border-left:1px solid var(--line);transform:translateX(102%);transition:transform .34s cubic-bezier(.2,.8,.2,1);box-shadow:-30px 0 80px #0008}#l04 .drawer.open{transform:none}#l04 .drawer-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:25px}#l04 .drawer h3{margin:0;font:500 30px Georgia,serif}#l04 .close{width:38px;height:38px;border:1px solid var(--line);border-radius:50%;background:transparent;color:var(--ink);cursor:pointer}#l04 .facet{padding:18px 0;border-top:1px solid var(--line)}#l04 .facet b{display:block;margin-bottom:12px;font-size:11px;text-transform:uppercase;letter-spacing:.12em}#l04 .facet label{display:flex;align-items:center;gap:10px;margin:11px 0;color:var(--muted);font-size:13px}#l04 input{accent-color:var(--accent)}@media(max-width:900px){#l04 .grid{grid-template-columns:repeat(2,1fr)}}@media(max-width:580px){#l04 .top{align-items:flex-start;flex-direction:column}#l04 .grid{grid-template-columns:1fr}}</style>
<section id="l04"><div class="top"><div class="chips"><button class="chip active" data-cat="Todos">Todos</button><button class="chip" data-cat="Moda">Moda</button><button class="chip" data-cat="Eletrônicos">Tech</button><button class="chip" data-cat="Casa">Casa</button></div><button class="open-filter" id="l04-open">Filtros avançados · ☷</button></div><div class="grid" id="l04-grid"><article class="card" data-cat="Moda" data-brand="Atelier"><div class="visual"><img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80" alt="Tênis Studio 01"><div class="quick"><button>Quick view</button><button>♡</button></div></div><div class="info"><div class="meta"><span>Atelier</span><span>Moda</span></div><h3>Tênis Studio 01</h3><span class="price">R$ 429</span></div></article><article class="card" data-cat="Acessórios" data-brand="North"><div class="visual"><img src="https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=80" alt="Relógio Arc Steel"><div class="quick"><button>Quick view</button><button>♡</button></div></div><div class="info"><div class="meta"><span>North</span><span>Acessórios</span></div><h3>Relógio Arc Steel</h3><span class="price">R$ 799</span></div></article><article class="card" data-cat="Eletrônicos" data-brand="Vertex"><div class="visual"><img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=80" alt="Headphone Pro"><div class="quick"><button>Quick view</button><button>♡</button></div></div><div class="info"><div class="meta"><span>Vertex</span><span>Eletrônicos</span></div><h3>Headphone Pro</h3><span class="price">R$ 649</span></div></article><article class="card" data-cat="Casa" data-brand="Forma"><div class="visual"><img src="https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=900&q=80" alt="Poltrona Mono"><div class="quick"><button>Quick view</button><button>♡</button></div></div><div class="info"><div class="meta"><span>Forma</span><span>Casa</span></div><h3>Poltrona Mono</h3><span class="price">R$ 1.890</span></div></article><article class="card" data-cat="Moda" data-brand="Atelier"><div class="visual"><img src="https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=900&q=80" alt="Bolsa Frame"><div class="quick"><button>Quick view</button><button>♡</button></div></div><div class="info"><div class="meta"><span>Atelier</span><span>Moda</span></div><h3>Bolsa Frame</h3><span class="price">R$ 559</span></div></article><article class="card" data-cat="Eletrônicos" data-brand="Vertex"><div class="visual"><img src="https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=900&q=80" alt="Câmera Compact X"><div class="quick"><button>Quick view</button><button>♡</button></div></div><div class="info"><div class="meta"><span>Vertex</span><span>Eletrônicos</span></div><h3>Câmera Compact X</h3><span class="price">R$ 2.390</span></div></article></div><div class="scrim" id="l04-scrim"></div><aside class="drawer" id="l04-drawer"><div class="drawer-head"><h3>Filtros</h3><button class="close" id="l04-close">×</button></div><div class="facet"><b>Marca</b><label><input type="checkbox" name="l04-brand" value="Atelier"> Atelier</label><label><input type="checkbox" name="l04-brand" value="Vertex"> Vertex</label><label><input type="checkbox" name="l04-brand" value="Forma"> Forma</label><label><input type="checkbox" name="l04-brand" value="North"> North</label></div><div class="facet"><b>Disponibilidade</b><label><input type="checkbox" checked> Somente em estoque</label></div></aside></section><script>(function(){const r=document.getElementById('l04'),drawer=r.querySelector('#l04-drawer'),scrim=r.querySelector('#l04-scrim'),cards=[...r.querySelectorAll('.card')],chips=[...r.querySelectorAll('.chip')];let cat='Todos';function open(v){drawer.classList.toggle('open',v);scrim.classList.toggle('open',v)}function run(){const brands=[...r.querySelectorAll('input[name=l04-brand]:checked')].map(x=>x.value);cards.forEach(c=>c.hidden=!((cat==='Todos'||c.dataset.cat===cat)&&(!brands.length||brands.includes(c.dataset.brand))))}r.querySelector('#l04-open').onclick=()=>open(true);r.querySelector('#l04-close').onclick=()=>open(false);scrim.onclick=()=>open(false);chips.forEach(c=>c.onclick=()=>{cat=c.dataset.cat;chips.forEach(x=>x.classList.toggle('active',x===c));run()});r.querySelectorAll('input[name=l04-brand]').forEach(i=>i.onchange=run)})();</script>
'@

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
