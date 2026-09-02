$ModeloId = 'L01'
$ModeloNome = 'Listagem MR em Grade com Filtro Compacto'
$Papel = 'produtos'
$ArquivoAlvo = 'produtos.html'
$ConteudoModelo = @'
<style>
#l01{--bg:#090a0d;--surface:#111318;--ink:#f7f3e9;--muted:#a7a298;--gold:#e6d3b3;--gold2:#c59b5d;--line:rgba(255,255,255,.11);--shadow:0 28px 80px rgba(0,0,0,.42);max-width:1320px;margin:auto;color:var(--ink);font-family:Arial,Helvetica,sans-serif}#l01 *{box-sizing:border-box}#l01 .tools{display:grid;grid-template-columns:1fr 72px;gap:14px;align-items:end;margin-bottom:16px}#l01 .search{height:52px;display:flex;align-items:center;gap:12px;padding:0 16px;border:1px solid var(--line);background:var(--surface)}#l01 .search input{width:100%;border:0;outline:0;background:transparent;color:var(--ink)}#l01 .filter-control{display:grid;place-items:center;gap:7px}#l01 .filter-btn{width:52px;height:52px;border:1px solid var(--line);border-radius:50%;display:grid;place-items:center;background:var(--surface);color:var(--ink);cursor:pointer;transition:.2s}#l01 .filter-btn:hover,#l01 .filter-btn[aria-expanded=true]{border-color:var(--gold2);background:rgba(215,183,125,.1);transform:translateY(-2px)}#l01 .filter-control span{color:var(--muted);font-size:9px;font-weight:700;letter-spacing:.08em;text-transform:uppercase}#l01 .panel{display:none;margin:12px 0;border:1px solid var(--line);border-radius:12px;background:var(--surface);overflow:hidden}#l01 .panel.open{display:block}#l01 .panel h3{margin:0;padding:16px 20px;border-bottom:1px solid var(--line);font:500 22px Georgia,serif}#l01 .fields{padding:20px;display:grid;grid-template-columns:repeat(3,1fr);gap:16px}#l01 label{display:grid;gap:8px;color:var(--muted);font-size:10px;font-weight:700;letter-spacing:.08em;text-transform:uppercase}#l01 select{height:46px;padding:0 12px;color:var(--ink);border:1px solid var(--line);border-radius:7px;background:var(--bg)}#l01 .meta{display:flex;justify-content:space-between;padding:22px 0 16px;color:var(--muted);font-size:11px;text-transform:uppercase;letter-spacing:.1em}#l01 .grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:22px}#l01 .card{min-width:0;background:var(--surface);border:1px solid var(--line);transition:transform .3s,box-shadow .3s,border-color .3s}#l01 .card:hover{transform:translateY(-7px);border-color:rgba(182,139,76,.5);box-shadow:var(--shadow)}#l01 .media{position:relative;aspect-ratio:1/1.15;overflow:hidden;background:#edeae3}#l01 .media img{width:100%;height:100%;display:block;object-fit:cover;transition:transform .5s}#l01 .card:hover img{transform:scale(1.035)}#l01 .tag{position:absolute;z-index:2;left:14px;top:14px;padding:7px 10px;color:#111;background:var(--gold);font-size:9px;font-weight:800;letter-spacing:.1em;text-transform:uppercase}#l01 .heart{position:absolute;z-index:2;right:14px;top:14px;width:38px;height:38px;display:grid;place-items:center;border:1px solid rgba(0,0,0,.09);border-radius:50%;color:#111;background:rgba(255,255,255,.87)}#l01 .content{padding:20px}#l01 .pmeta{display:flex;justify-content:space-between;color:var(--gold2);font-size:10px;font-weight:700;letter-spacing:.12em;text-transform:uppercase}#l01 .pmeta span:last-child{color:var(--muted)}#l01 h4{min-height:48px;margin:14px 0 18px;font:500 19px/1.25 Georgia,serif}#l01 .link{border:0;background:transparent;color:var(--ink);padding:0;font-weight:700;cursor:pointer}#l01 .card[hidden]{display:none}@media(max-width:1050px){#l01 .grid{grid-template-columns:repeat(2,1fr)}}@media(max-width:620px){#l01 .grid{grid-template-columns:1fr}#l01 .fields{grid-template-columns:1fr}}
</style>
<section id="l01"><div class="tools"><label class="search"><span>⌕</span><input id="l01-q" placeholder="Pesquisar produtos"></label><div class="filter-control"><button class="filter-btn" id="l01-filter" aria-expanded="false">☷</button><span>Filtrar</span></div></div><div class="panel" id="l01-panel"><h3>Filtros</h3><div class="fields"><label>Marca<select id="l01-brand"><option>Todas</option><option>Atelier</option><option>North</option><option>Vertex</option><option>Forma</option></select></label><label>Categoria<select id="l01-cat"><option>Todos</option><option>Moda</option><option>Acessórios</option><option>Eletrônicos</option><option>Casa</option></select></label><label>Ordenar<select id="l01-sort"><option value="default">Relevância</option><option value="az">Nome A–Z</option><option value="za">Nome Z–A</option></select></label></div></div><div class="meta"><span id="l01-count">4 produtos</span><span>Curadoria MR</span></div><div class="grid" id="l01-grid"><article class="card" data-name="Tênis Studio" data-brand="Atelier" data-cat="Moda"><div class="media"><span class="tag">Destaque</span><button class="heart">♡</button><img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80" alt="Tênis Studio"></div><div class="content"><div class="pmeta"><span>Atelier</span><span>Moda</span></div><h4>Tênis Studio</h4><button class="link">Ver detalhes →</button></div></article><article class="card" data-name="Relógio Arc" data-brand="North" data-cat="Acessórios"><div class="media"><button class="heart">♡</button><img src="https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=80" alt="Relógio Arc"></div><div class="content"><div class="pmeta"><span>North</span><span>Acessórios</span></div><h4>Relógio Arc</h4><button class="link">Ver detalhes →</button></div></article><article class="card" data-name="Headphone Pro" data-brand="Vertex" data-cat="Eletrônicos"><div class="media"><span class="tag">Novo</span><button class="heart">♡</button><img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=80" alt="Headphone Pro"></div><div class="content"><div class="pmeta"><span>Vertex</span><span>Eletrônicos</span></div><h4>Headphone Pro</h4><button class="link">Ver detalhes →</button></div></article><article class="card" data-name="Poltrona Mono" data-brand="Forma" data-cat="Casa"><div class="media"><button class="heart">♡</button><img src="https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=900&q=80" alt="Poltrona Mono"></div><div class="content"><div class="pmeta"><span>Forma</span><span>Casa</span></div><h4>Poltrona Mono</h4><button class="link">Ver detalhes →</button></div></article></div></section>
<script>(function(){const r=document.getElementById('l01'),panel=r.querySelector('#l01-panel'),btn=r.querySelector('#l01-filter'),q=r.querySelector('#l01-q'),brand=r.querySelector('#l01-brand'),cat=r.querySelector('#l01-cat'),sort=r.querySelector('#l01-sort'),grid=r.querySelector('#l01-grid'),count=r.querySelector('#l01-count');btn.onclick=()=>{const o=!panel.classList.contains('open');panel.classList.toggle('open',o);btn.setAttribute('aria-expanded',o)};function run(){let cards=[...grid.children];const term=q.value.toLowerCase();cards.forEach(c=>c.hidden=!(c.dataset.name.toLowerCase().includes(term)&&(brand.value==='Todas'||c.dataset.brand===brand.value)&&(cat.value==='Todos'||c.dataset.cat===cat.value)));const vis=cards.filter(c=>!c.hidden);vis.sort((a,b)=>sort.value==='az'?a.dataset.name.localeCompare(b.dataset.name):sort.value==='za'?b.dataset.name.localeCompare(a.dataset.name):0).forEach(c=>grid.appendChild(c));count.textContent=vis.length+' produtos'};q.oninput=run;brand.onchange=cat.onchange=sort.onchange=run})();</script>
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

# Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.
# Isso garante um <body> real para receber os slots locais do Catálogo S.
if ($ConteudoModelo -notmatch '(?i)<body(?:\s|>)') {
    $tituloSeguro = [System.Net.WebUtility]::HtmlEncode($ModeloNome)
    $ConteudoModelo = '<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>' + $tituloSeguro + '</title></head><body>' + $ConteudoModelo + '</body></html>'
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
