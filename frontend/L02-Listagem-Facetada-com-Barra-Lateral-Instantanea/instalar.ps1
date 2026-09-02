$ModeloId = 'L02'
$ModeloNome = 'Listagem Facetada com Barra Lateral Instantânea'
$Papel = 'produtos'
$ArquivoAlvo = 'produtos.html'
$ConteudoModelo = @'
<style>
#l02{--panel:#121419;--card:#15171c;--ink:#f4f1e8;--muted:#98958d;--line:#ffffff18;--accent:#d0aa70;max-width:1360px;margin:auto;display:grid;grid-template-columns:250px minmax(0,1fr);gap:30px;color:var(--ink);font-family:Arial,sans-serif}#l02 *{box-sizing:border-box}#l02 aside{position:sticky;top:18px;align-self:start;padding:22px;border:1px solid var(--line);background:var(--panel);border-radius:14px}#l02 aside h3{margin:0 0 20px;font:500 27px Georgia,serif}#l02 .facet{padding:17px 0;border-top:1px solid var(--line)}#l02 .facet b{display:block;margin-bottom:12px;font-size:11px;letter-spacing:.12em;text-transform:uppercase;color:#cbc4b8}#l02 label{display:flex;gap:10px;align-items:center;margin:10px 0;color:var(--muted);font-size:13px;cursor:pointer}#l02 input{accent-color:var(--accent)}#l02 .clear{width:100%;margin-top:10px;padding:11px;border:1px solid var(--line);background:transparent;color:var(--ink);border-radius:8px;cursor:pointer}#l02 .bar{display:flex;align-items:center;justify-content:space-between;gap:15px;margin-bottom:18px}#l02 .bar h2{margin:0;font:500 34px Georgia,serif}#l02 .count{color:var(--muted);font-size:12px}#l02 .grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:18px}#l02 .product{border:1px solid var(--line);background:var(--card);border-radius:12px;overflow:hidden;transition:transform .22s,border-color .22s}#l02 .product:hover{transform:translateY(-4px);border-color:#d0aa7066}#l02 .product img{width:100%;aspect-ratio:1/1.08;object-fit:cover;display:block}#l02 .body{padding:16px}#l02 .brand{color:var(--accent);font-size:10px;font-weight:800;letter-spacing:.12em;text-transform:uppercase}#l02 h4{margin:8px 0 12px;font:500 18px Georgia,serif}#l02 .price{font-weight:800}#l02 .product[hidden]{display:none}#l02 .empty{display:none;padding:60px;text-align:center;color:var(--muted);border:1px dashed var(--line);border-radius:14px}@media(max-width:960px){#l02{grid-template-columns:1fr}#l02 aside{position:static}#l02 .grid{grid-template-columns:repeat(2,1fr)}}@media(max-width:580px){#l02 .grid{grid-template-columns:1fr}}
</style>
<section id="l02"><aside><h3>Filtros</h3><div class="facet"><b>Categoria</b><label><input type="checkbox" name="l02-cat" value="Moda"> Moda</label><label><input type="checkbox" name="l02-cat" value="Eletrônicos"> Eletrônicos</label><label><input type="checkbox" name="l02-cat" value="Casa"> Casa</label></div><div class="facet"><b>Marca</b><label><input type="checkbox" name="l02-brand" value="Atelier"> Atelier</label><label><input type="checkbox" name="l02-brand" value="Vertex"> Vertex</label><label><input type="checkbox" name="l02-brand" value="Forma"> Forma</label></div><button class="clear" id="l02-clear">Limpar filtros</button></aside><div><div class="bar"><h2>Produtos</h2><span class="count" id="l02-count">6 resultados</span></div><div class="grid"><article class="product" data-cat="Moda" data-brand="Atelier"><img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80" alt="Tênis"><div class="body"><span class="brand">Atelier · Moda</span><h4>Tênis Studio</h4><span class="price">R$ 429</span></div></article><article class="product" data-cat="Eletrônicos" data-brand="Vertex"><img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80" alt="Headphone"><div class="body"><span class="brand">Vertex · Eletrônicos</span><h4>Headphone Pro</h4><span class="price">R$ 649</span></div></article><article class="product" data-cat="Casa" data-brand="Forma"><img src="https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=800&q=80" alt="Poltrona"><div class="body"><span class="brand">Forma · Casa</span><h4>Poltrona Mono</h4><span class="price">R$ 1.890</span></div></article><article class="product" data-cat="Moda" data-brand="Atelier"><img src="https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=800&q=80" alt="Bolsa"><div class="body"><span class="brand">Atelier · Moda</span><h4>Bolsa Frame</h4><span class="price">R$ 559</span></div></article><article class="product" data-cat="Eletrônicos" data-brand="Vertex"><img src="https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=800&q=80" alt="Câmera"><div class="body"><span class="brand">Vertex · Eletrônicos</span><h4>Câmera Compact X</h4><span class="price">R$ 2.390</span></div></article><article class="product" data-cat="Casa" data-brand="Forma"><img src="https://images.unsplash.com/photo-1549497538-303791108f95?auto=format&fit=crop&w=800&q=80" alt="Luminária"><div class="body"><span class="brand">Forma · Casa</span><h4>Luminária Arc</h4><span class="price">R$ 389</span></div></article></div><div class="empty" id="l02-empty">Nenhum produto corresponde aos filtros.</div></div></section>
<script>(function(){const r=document.getElementById('l02'),cards=[...r.querySelectorAll('.product')],count=r.querySelector('#l02-count'),empty=r.querySelector('#l02-empty');function vals(n){return [...r.querySelectorAll('input[name='+n+']:checked')].map(x=>x.value)}function run(){const cats=vals('l02-cat'),brands=vals('l02-brand');let n=0;cards.forEach(c=>{const ok=(!cats.length||cats.includes(c.dataset.cat))&&(!brands.length||brands.includes(c.dataset.brand));c.hidden=!ok;if(ok)n++});count.textContent=n+' resultados';empty.style.display=n?'none':'block'}r.querySelectorAll('input').forEach(i=>i.onchange=run);r.querySelector('#l02-clear').onclick=()=>{r.querySelectorAll('input').forEach(i=>i.checked=false);run()}})();</script>
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
