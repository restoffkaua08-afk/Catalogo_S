$ModeloId = 'L03'
$ModeloNome = 'Listagem Horizontal Comparativa'
$Papel = 'produtos'
$ArquivoAlvo = 'produtos.html'
$ConteudoModelo = @'
<style>
#l03{--bg:#090a0d;--surface:#111318;--ink:#f4f0e7;--muted:#9d998f;--line:#ffffff18;--accent:#d0aa70;max-width:1320px;margin:auto;color:var(--ink);font-family:Arial,Helvetica,sans-serif}#l03 *{box-sizing:border-box}#l03 .toolbar{position:sticky;top:0;z-index:4;display:flex;justify-content:space-between;gap:18px;align-items:center;padding:14px 0;background:#090a0ded;backdrop-filter:blur(14px);border-bottom:1px solid var(--line)}#l03 .chips{display:flex;gap:8px;flex-wrap:wrap}#l03 .chip{padding:9px 14px;border:1px solid var(--line);border-radius:999px;background:var(--surface);color:var(--muted);cursor:pointer}#l03 .chip.active{background:var(--accent);border-color:var(--accent);color:#111}#l03 select{height:40px;padding:0 12px;border:1px solid var(--line);background:var(--surface);color:var(--ink);border-radius:8px}#l03 .head{display:grid;grid-template-columns:170px minmax(250px,1.1fr) minmax(300px,.95fr) 170px;gap:20px;padding:16px 0 10px;color:#716e68;font-size:9px;font-weight:800;letter-spacing:.12em;text-transform:uppercase}#l03 .row{display:grid;grid-template-columns:170px minmax(250px,1.1fr) minmax(300px,.95fr) 170px;gap:20px;align-items:center;padding:20px 0;border-top:1px solid var(--line);transition:background .2s,padding .2s}#l03 .row:hover{background:#ffffff04;padding-left:12px;padding-right:12px}#l03 .row[hidden]{display:none}#l03 img{width:170px;height:132px;object-fit:cover;border-radius:10px;background:#d9d9d9}#l03 .eyebrow{color:var(--accent);font-size:10px;font-weight:800;letter-spacing:.12em;text-transform:uppercase}#l03 h3{margin:7px 0 6px;font:500 23px Georgia,serif}#l03 .desc{color:var(--muted);font-size:13px;line-height:1.55;max-width:430px}#l03 .specs{display:grid;grid-template-columns:repeat(2,1fr);gap:9px}#l03 .spec{padding:10px 11px;border:1px solid var(--line);border-radius:8px;background:#ffffff02}#l03 .spec small{display:block;color:#77746e;font-size:9px;text-transform:uppercase;letter-spacing:.08em}#l03 .spec b{display:block;margin-top:4px;font-size:12px}#l03 .buy{text-align:right}#l03 .price{display:block;font-size:21px;font-weight:800;margin-bottom:11px}#l03 .buy button{width:100%;padding:12px;border:1px solid var(--accent);background:transparent;color:var(--ink);border-radius:8px;font-weight:800;cursor:pointer;transition:.2s}#l03 .buy button:hover{background:var(--accent);color:#111}@media(max-width:980px){#l03 .head{display:none}#l03 .row{grid-template-columns:130px 1fr 170px}#l03 img{width:130px;height:112px}#l03 .specs{display:none}}@media(max-width:660px){#l03 .toolbar{align-items:flex-start;flex-direction:column}#l03 .row{grid-template-columns:90px 1fr}#l03 img{width:90px;height:96px}#l03 .buy{grid-column:2;text-align:left}#l03 .buy button{width:auto}}
</style>
<section id="l03"><div class="toolbar"><div class="chips"><button class="chip active" data-cat="Todos">Todos</button><button class="chip" data-cat="Trabalho">Trabalho</button><button class="chip" data-cat="Gaming">Gaming</button><button class="chip" data-cat="Criativo">Criativo</button></div><select id="l03-sort"><option value="default">Ordenar: destaque</option><option value="price-asc">Menor preço</option><option value="price-desc">Maior preço</option></select></div><div class="head"><span>Produto</span><span>Resumo</span><span>Comparação rápida</span><span style="text-align:right">Compra</span></div><div id="l03-rows"><article class="row" data-cat="Trabalho" data-price="1899"><img src="https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=900&q=80" alt="Monitor Work 27"><div><span class="eyebrow">North · Trabalho</span><h3>Work 27</h3><div class="desc">Monitor sóbrio para produtividade, texto e multitarefa em escritório.</div></div><div class="specs"><div class="spec"><small>Painel</small><b>IPS</b></div><div class="spec"><small>Resolução</small><b>QHD</b></div><div class="spec"><small>Taxa</small><b>75 Hz</b></div><div class="spec"><small>Conexão</small><b>USB-C</b></div></div><div class="buy"><span class="price">R$ 1.899</span><button>Ver produto</button></div></article><article class="row" data-cat="Gaming" data-price="2499"><img src="https://images.unsplash.com/photo-1585792180666-f7347c490ee2?auto=format&fit=crop&w=900&q=80" alt="Monitor Pulse 27"><div><span class="eyebrow">Vertex · Gaming</span><h3>Pulse 27</h3><div class="desc">Foco em fluidez, baixa latência e contraste para jogos competitivos.</div></div><div class="specs"><div class="spec"><small>Painel</small><b>Fast IPS</b></div><div class="spec"><small>Resolução</small><b>QHD</b></div><div class="spec"><small>Taxa</small><b>180 Hz</b></div><div class="spec"><small>Resposta</small><b>1 ms</b></div></div><div class="buy"><span class="price">R$ 2.499</span><button>Ver produto</button></div></article><article class="row" data-cat="Criativo" data-price="3299"><img src="https://images.unsplash.com/photo-1547082299-de196ea013d6?auto=format&fit=crop&w=900&q=80" alt="Monitor Studio 32"><div><span class="eyebrow">Atelier · Criativo</span><h3>Studio 32</h3><div class="desc">Tela ampla com prioridade para definição, cor e edição de imagem.</div></div><div class="specs"><div class="spec"><small>Painel</small><b>IPS Black</b></div><div class="spec"><small>Resolução</small><b>4K UHD</b></div><div class="spec"><small>Cor</small><b>98% DCI-P3</b></div><div class="spec"><small>Precisão</small><b>ΔE &lt; 2</b></div></div><div class="buy"><span class="price">R$ 3.299</span><button>Ver produto</button></div></article><article class="row" data-cat="Trabalho" data-price="1499"><img src="https://images.unsplash.com/photo-1593640408182-31c70c8268f5?auto=format&fit=crop&w=900&q=80" alt="Monitor Office 24"><div><span class="eyebrow">Forma · Trabalho</span><h3>Office 24</h3><div class="desc">Opção compacta para home office, navegação e tarefas do dia a dia.</div></div><div class="specs"><div class="spec"><small>Painel</small><b>IPS</b></div><div class="spec"><small>Resolução</small><b>Full HD</b></div><div class="spec"><small>Taxa</small><b>100 Hz</b></div><div class="spec"><small>Ajuste</small><b>Altura + giro</b></div></div><div class="buy"><span class="price">R$ 1.499</span><button>Ver produto</button></div></article></div></section><script>(function(){const r=document.getElementById('l03'),rows=r.querySelector('#l03-rows'),chips=[...r.querySelectorAll('.chip')],sort=r.querySelector('#l03-sort');let cat='Todos';function run(){const a=[...rows.children];a.forEach(x=>x.hidden=!(cat==='Todos'||x.dataset.cat===cat));const vis=a.filter(x=>!x.hidden);vis.sort((x,y)=>sort.value==='price-asc'?+x.dataset.price-+y.dataset.price:sort.value==='price-desc'?+y.dataset.price-+x.dataset.price:0).forEach(x=>rows.appendChild(x))}chips.forEach(c=>c.onclick=()=>{cat=c.dataset.cat;chips.forEach(x=>x.classList.toggle('active',x===c));run()});sort.onchange=run})();</script>
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
            $sections += "<section id=`"catalogo-s-$key`" data-catalogo-s-instance=`"$key`" data-catalogo-s-model=`"$id`" style=`"width:100%;min-height:100vh;overflow:hidden`"><iframe src=`"$relative`" title=`"$id`" loading=`"lazy`" scrolling=`"no`" style=`"display:block;width:100%;height:100vh;border:0;overflow:hidden`"></iframe></section>"
        }
    }

    $updated = Set-Slot $html 'COMPONENTES' ($sections -join "`r`n")
    Write-TextFile 'index.html' $updated
}

# Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.
# Isso garante um <body> real para receber os slots locais do Catálogo S.
if ($ConteudoModelo -notmatch '(?i)<body(?:\s|>)') {
    $tituloSeguro = [System.Net.WebUtility]::HtmlEncode($ModeloNome)
    $ConteudoModelo = '<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>' + $tituloSeguro + '</title><style>html,body{margin:0;min-height:100%;overflow-x:hidden}</style></head><body>' + $ConteudoModelo + '</body></html>'
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
