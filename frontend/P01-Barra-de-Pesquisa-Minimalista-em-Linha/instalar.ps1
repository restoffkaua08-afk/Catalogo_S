$ModeloId = 'P01'
$ModeloNome = 'Barra de Pesquisa Minimalista em Linha'
$ConteudoModelo = @'
<style>
#pesquisa-p01{width:min(760px,92vw);position:relative;color:#f5f5f5;font-family:Arial,Helvetica,sans-serif}
#pesquisa-p01 .p01-label{display:block;margin-bottom:12px;font-size:11px;letter-spacing:.14em;text-transform:uppercase;color:#7e8188}
#pesquisa-p01 .p01-field{position:relative;display:flex;align-items:center;gap:14px;padding:0 4px 15px;border-bottom:1px solid rgba(255,255,255,.24)}
#pesquisa-p01 .p01-field::after{content:"";position:absolute;left:0;right:100%;bottom:-1px;height:1px;background:#f3f3f3;transition:right .38s cubic-bezier(.16,1,.3,1)}
#pesquisa-p01 .p01-field:focus-within::after{right:0}
#pesquisa-p01 svg{width:23px;height:23px;flex:0 0 auto;stroke:#aeb1b6;transition:stroke .25s ease,transform .25s ease}
#pesquisa-p01 .p01-field:focus-within svg{stroke:#fff;transform:scale(1.04)}
#pesquisa-p01 input{width:100%;min-width:0;border:0;outline:0;background:transparent;color:#fff;font:400 clamp(20px,3vw,34px)/1.2 Georgia,"Times New Roman",serif}
#pesquisa-p01 input::placeholder{color:#62656b}
#pesquisa-p01 kbd{flex:0 0 auto;padding:5px 8px;border:1px solid rgba(255,255,255,.16);border-radius:6px;background:rgba(255,255,255,.04);color:#777b82;font:10px/1 Arial,sans-serif}
@media(max-width:560px){#pesquisa-p01 kbd{display:none}}
</style>
<label id="pesquisa-p01">
  <span class="p01-label">Pesquisa</span>
  <span class="p01-field">
    <svg viewBox="0 0 24 24" fill="none" stroke-width="1.6" aria-hidden="true"><circle cx="11" cy="11" r="6.8"></circle><path d="m16 16 4.2 4.2"></path></svg>
    <input type="search" placeholder="O que você procura?" aria-label="Pesquisar">
    <kbd>⌘ K</kbd>
  </span>
</label>
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
