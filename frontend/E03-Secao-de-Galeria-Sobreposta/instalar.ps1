$ModeloId = 'E03'
$ModeloNome = 'Seção de Galeria Sobreposta'
$ConteudoModelo = @'
<div id="catalogo-e03" data-componente="E03">
<section class="team-model" aria-label="Galeria visual de fotografias sobrepostas">
  <div class="team-intro">
    <h1>SEU TÍTULO<br>AQUI.</h1>
    <p>Texto descritivo opcional para acompanhar a composição visual.</p>
  </div>

  <div class="team-gallery" aria-label="Galeria demonstrativa">
    <figure class="photo-card card-01"><div class="photo-placeholder" aria-label="Imagem 1">IMAGEM 01</div></figure>
    <figure class="photo-card card-02"><div class="photo-placeholder" aria-label="Imagem 2">IMAGEM 02</div></figure>
    <figure class="photo-card card-03"><div class="photo-placeholder" aria-label="Imagem 3">IMAGEM 03</div></figure>
    <figure class="photo-card card-04"><div class="photo-placeholder" aria-label="Imagem 4">IMAGEM 04</div></figure>
  </div>
</section>
</div>
<style>
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@500;600;700&family=Manrope:wght@400;500;600&display=swap');
#catalogo-e03, #catalogo-e03 *{box-sizing:border-box}
#catalogo-e03{font-family:Manrope,Arial,sans-serif;color:#f1eee8}
#catalogo-e03 .team-model{--line:rgba(238,234,226,.12);--muted:#9e9a93;min-height:100vh;display:grid;grid-template-columns:38% 62%;background:linear-gradient(90deg,rgba(7,8,8,.99) 0 35%,rgba(7,8,8,.91) 50%,rgba(7,8,8,.97) 100%),radial-gradient(circle at 70% 40%,rgba(135,98,65,.12),transparent 34%),#070808;border-top:1px solid rgba(255,255,255,.04);border-bottom:1px solid rgba(255,255,255,.04);overflow:hidden}
#catalogo-e03 .team-intro{min-height:100vh;border-right:1px solid var(--line);display:flex;flex-direction:column;justify-content:center;padding:8vh 3vw 8vh 2.2vw;position:relative;z-index:20;background:linear-gradient(90deg,rgba(0,0,0,.30),rgba(0,0,0,0))}
#catalogo-e03 .team-intro h1{margin:0;max-width:96%;text-transform:uppercase;letter-spacing:-.025em;font-family:"Barlow Condensed","Arial Narrow",Arial,sans-serif;font-weight:600;font-size:clamp(68px,6.9vw,112px);line-height:.88}
#catalogo-e03 .team-intro p{color:var(--muted);max-width:390px;margin:30px 0 0;font-size:12px;line-height:1.75}
#catalogo-e03 .team-gallery{min-height:100vh;position:relative;overflow:hidden;isolation:isolate}
#catalogo-e03 .photo-card{position:absolute;width:27%;height:calc(100vh - 24px);min-height:560px;top:50%;border:0;border-radius:0;padding:0;margin:0;overflow:hidden;background:#0a0b0b;pointer-events:auto;cursor:default;box-shadow:0 22px 58px rgba(0,0,0,.36);transition:transform 1.25s cubic-bezier(.16,1,.3,1),box-shadow 1.25s cubic-bezier(.16,1,.3,1),z-index 0s}
#catalogo-e03 .photo-placeholder{width:100%;height:100%;display:grid;place-items:center;background:linear-gradient(145deg,#1b1e24,#0b0d11 56%,#302719);color:#d1ad73;font:700 11px Arial,sans-serif;letter-spacing:.16em;text-transform:uppercase;filter:grayscale(1) saturate(0) contrast(1.07) brightness(.88);transform:scale(1.002);transition:filter 1.05s cubic-bezier(.16,1,.3,1),transform 1.25s cubic-bezier(.16,1,.3,1);user-select:none;pointer-events:none}
#catalogo-e03 .card-01{left:15%;z-index:1;width:27%;transform:translateY(-46%)}
#catalogo-e03 .card-02{left:34%;z-index:5;width:21%;transform:translateY(-53%)}
#catalogo-e03 .card-03{left:52%;z-index:2;width:29%;transform:translateY(-44%)}
#catalogo-e03 .card-04{right:0;z-index:4;width:23%;transform:translateY(-50%)}
#catalogo-e03 .photo-card:hover{z-index:20;box-shadow:0 28px 64px rgba(0,0,0,.46)}
#catalogo-e03 .card-01:hover{transform:translateY(calc(-46% - 4px)) scale(1.002)}
#catalogo-e03 .card-02:hover{transform:translateY(calc(-53% - 4px)) scale(1.002)}
#catalogo-e03 .card-03:hover{transform:translateY(calc(-44% - 4px)) scale(1.002)}
#catalogo-e03 .card-04:hover{transform:translateY(calc(-50% - 4px)) scale(1.002)}
#catalogo-e03 .photo-card:hover .photo-placeholder{filter:grayscale(0) saturate(1.35) contrast(1.03) brightness(1.05);transform:scale(1.006)}
@media(max-width:900px){#catalogo-e03 .team-model{grid-template-columns:1fr}#catalogo-e03 .team-intro{min-height:auto;border-right:0;border-bottom:1px solid var(--line);padding:70px 24px 45px}#catalogo-e03 .team-intro h1{font-size:clamp(58px,15vw,90px)}#catalogo-e03 .team-gallery{min-height:620px;overflow-x:auto;overflow-y:hidden}#catalogo-e03 .photo-card{width:250px;height:570px;min-height:0}#catalogo-e03 .card-01{left:24px}#catalogo-e03 .card-02{left:205px;width:215px}#catalogo-e03 .card-03{left:375px}#catalogo-e03 .card-04{left:555px;right:auto;width:215px}#catalogo-e03 .team-gallery:after{content:"";position:absolute;left:794px;width:24px;height:1px}}
@media(prefers-reduced-motion:reduce){#catalogo-e03 .photo-card,#catalogo-e03 .photo-placeholder{transition:none}}
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
            $sections += "<section id=`"catalogo-s-$key`" data-catalogo-s-instance=`"$key`" data-catalogo-s-model=`"$id`" style=`"width:100%;min-height:100vh;overflow:hidden`"><iframe src=`"$relative`" title=`"$id`" loading=`"lazy`" scrolling=`"no`" style=`"display:block;width:100%;height:100vh;border:0;overflow:hidden`"></iframe></section>"
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

# O componente é salvo em um documento isolado para o iframe não herdar margem padrão do navegador.
$DocumentoComponente = '<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><style>html,body{margin:0;min-height:100%;overflow-x:hidden}</style></head><body>' + $ConteudoModelo + '</body></html>'
Write-TextFile $relative $DocumentoComponente -SemBackup
Rebuild-Components

Write-Host ""
Write-Host "[Catálogo S] $ModeloId — $ModeloNome instalado como componente."
Write-Host "[Catálogo S] Arquivo criado: $relative"
Write-Host "[Catálogo S] Nenhum arquivo foi baixado do GitHub."
