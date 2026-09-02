$ModeloId = 'P02'
$ModeloNome = 'Barra de Pesquisa em Bloco'
$ConteudoModelo = @'
<style>
#pesquisa-p02{width:min(820px,92vw);display:flex;align-items:center;gap:14px;padding:14px 14px 14px 18px;border-radius:18px;background:#f3f4f6;color:#16181c;box-shadow:0 18px 50px rgba(0,0,0,.18);font-family:Arial,Helvetica,sans-serif}
#pesquisa-p02 svg{width:23px;height:23px;stroke:#6b7078;flex:0 0 auto}
#pesquisa-p02 input{width:100%;min-width:0;border:0;outline:0;background:transparent;color:#16181c;font:500 16px/1.2 Arial,sans-serif}
#pesquisa-p02 input::placeholder{color:#8b9098}
#pesquisa-p02 button{flex:0 0 auto;border:0;border-radius:12px;background:#101216;color:#fff;padding:13px 20px;font:700 12px/1 Arial,sans-serif;cursor:pointer;transition:transform .2s ease,background .2s ease}
#pesquisa-p02 button:hover{transform:translateY(-1px);background:#242830}
#pesquisa-p02:focus-within{box-shadow:0 22px 70px rgba(0,0,0,.25),0 0 0 1px rgba(255,255,255,.16)}
@media(max-width:560px){#pesquisa-p02{padding:12px 12px 12px 15px}#pesquisa-p02 button{padding:12px 14px}}
</style>
<form id="pesquisa-p02" role="search" onsubmit="return false">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="1.7" aria-hidden="true"><circle cx="11" cy="11" r="6.8"></circle><path d="m16 16 4.2 4.2"></path></svg>
  <input type="search" placeholder="Buscar produtos, páginas ou conteúdos" aria-label="Pesquisar">
  <button type="submit">BUSCAR</button>
</form>
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
