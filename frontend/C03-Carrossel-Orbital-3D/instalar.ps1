$ModeloId = 'C03'
$ModeloNome = 'Carrossel Orbital 3D'
$ConteudoModelo = @'
<div id="catalogo-c03" data-componente="C03">
<section class="carousel-experiment"><div class="test-carousel"><div class="test-carousel-scene"><div class="test-carousel-ring"><article class="test-carousel-panel" style="--test-panel-index:0"><div class="placeholder">IMAGEM 01</div><span><small>TIPO 01</small>ITEM 01</span></article>
<article class="test-carousel-panel" style="--test-panel-index:1"><div class="placeholder">IMAGEM 02</div><span><small>TIPO 02</small>ITEM 02</span></article>
<article class="test-carousel-panel" style="--test-panel-index:2"><div class="placeholder">IMAGEM 03</div><span><small>TIPO 03</small>ITEM 03</span></article>
<article class="test-carousel-panel" style="--test-panel-index:3"><div class="placeholder">IMAGEM 04</div><span><small>TIPO 04</small>ITEM 04</span></article>
<article class="test-carousel-panel" style="--test-panel-index:4"><div class="placeholder">IMAGEM 05</div><span><small>TIPO 05</small>ITEM 05</span></article>
<article class="test-carousel-panel" style="--test-panel-index:5"><div class="placeholder">IMAGEM 06</div><span><small>TIPO 06</small>ITEM 06</span></article>
<article class="test-carousel-panel" style="--test-panel-index:6"><div class="placeholder">IMAGEM 07</div><span><small>TIPO 07</small>ITEM 07</span></article>
<article class="test-carousel-panel" style="--test-panel-index:7"><div class="placeholder">IMAGEM 08</div><span><small>TIPO 08</small>ITEM 08</span></article>
<article class="test-carousel-panel" style="--test-panel-index:8"><div class="placeholder">IMAGEM 09</div><span><small>TIPO 09</small>ITEM 09</span></article>
<article class="test-carousel-panel" style="--test-panel-index:9"><div class="placeholder">IMAGEM 10</div><span><small>TIPO 10</small>ITEM 10</span></article>
<article class="test-carousel-panel" style="--test-panel-index:10"><div class="placeholder">IMAGEM 11</div><span><small>TIPO 11</small>ITEM 11</span></article>
<article class="test-carousel-panel" style="--test-panel-index:11"><div class="placeholder">IMAGEM 12</div><span><small>TIPO 12</small>ITEM 12</span></article>
<article class="test-carousel-panel" style="--test-panel-index:12"><div class="placeholder">IMAGEM 13</div><span><small>TIPO 13</small>ITEM 13</span></article>
<article class="test-carousel-panel" style="--test-panel-index:13"><div class="placeholder">IMAGEM 14</div><span><small>TIPO 14</small>ITEM 14</span></article>
<article class="test-carousel-panel" style="--test-panel-index:14"><div class="placeholder">IMAGEM 15</div><span><small>TIPO 15</small>ITEM 15</span></article>
<article class="test-carousel-panel" style="--test-panel-index:15"><div class="placeholder">IMAGEM 16</div><span><small>TIPO 16</small>ITEM 16</span></article>
<article class="test-carousel-panel" style="--test-panel-index:16"><div class="placeholder">IMAGEM 17</div><span><small>TIPO 17</small>ITEM 17</span></article>
<article class="test-carousel-panel" style="--test-panel-index:17"><div class="placeholder">IMAGEM 18</div><span><small>TIPO 18</small>ITEM 18</span></article>
<article class="test-carousel-panel" style="--test-panel-index:18"><div class="placeholder">IMAGEM 19</div><span><small>TIPO 19</small>ITEM 19</span></article>
<article class="test-carousel-panel" style="--test-panel-index:19"><div class="placeholder">IMAGEM 20</div><span><small>TIPO 20</small>ITEM 20</span></article></div></div></div></section>
</div>
<style>
#catalogo-c03 .placeholder{width:100%;height:100%;display:grid;place-items:center;background:linear-gradient(145deg,#1c2028,#0e1015 55%,#2a241b);color:#d1ad73;font:700 11px Arial;letter-spacing:.16em;text-transform:uppercase}

#catalogo-c03 .carousel-experiment{color:#f7f3e9;background:#08090c;border-top:1px solid #ffffff12;place-items:center;min-height:100vh;display:grid;overflow:hidden}#catalogo-c03 .test-carousel{isolation:isolate;width:100vw;height:360px;position:relative;overflow:hidden}#catalogo-c03 .test-carousel:after{content:"";z-index:-1;filter:blur(26px);background:radial-gradient(#c59b5d1c,#0000 68%);border-radius:50%;width:720px;height:250px;position:absolute;bottom:-130px;left:50%;transform:translate(-50%)}#catalogo-c03 .test-carousel-scene{perspective:980px;perspective-origin:50%;place-items:center;display:grid;position:absolute;inset:0}#catalogo-c03 .test-carousel-ring{aspect-ratio:16/9;width:clamp(180px,17vw,250px);transform-style:preserve-3d;will-change:transform;animation:24s linear infinite both test-carousel-turn;position:relative}#catalogo-c03 .test-carousel-panel{--test-panel-angle:calc(var(--test-panel-index) * 18deg);transform:rotateY(var(--test-panel-angle)) translateZ(clamp(560px,62vw,860px)) rotateY(180deg);backface-visibility:hidden;background:#111318;border:1px solid #e6d3b338;border-radius:0;position:absolute;inset:0;overflow:hidden;box-shadow:0 18px 38px #0000006b,inset 0 1px #ffffff2e}#catalogo-c03 .test-carousel-panel:after{content:"";background:linear-gradient(#ffffff0d,#0000 45%,#060709e6);position:absolute;inset:0}#catalogo-c03 .test-carousel-panel span{z-index:1;color:#f5efe3;flex-direction:column;gap:4px;font-family:"Bodoni 72",Didot,Georgia,serif;font-size:22px;display:flex;position:absolute;bottom:17px;left:18px;right:18px}#catalogo-c03 .test-carousel-panel small{color:#d1ad73;letter-spacing:.16em;text-transform:uppercase;font-family:Arial,sans-serif;font-size:8px;font-weight:700}@keyframes test-carousel-turn{0%{transform:rotateY(0)}to{transform:rotateY(360deg)}}

</style>
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
