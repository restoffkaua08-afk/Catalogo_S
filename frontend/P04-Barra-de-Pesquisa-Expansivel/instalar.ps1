$ModeloId = 'P04'
$ModeloNome = 'Barra de Pesquisa Expansível'
$ConteudoModelo = @'
<style>
#pesquisa-p04{width:56px;height:56px;display:flex;align-items:center;justify-content:flex-end;gap:0;overflow:hidden;border:1px solid rgba(255,255,255,.18);border-radius:999px;background:#111318;color:#fff;box-shadow:0 14px 40px rgba(0,0,0,.34);transition:width .48s cubic-bezier(.16,1,.3,1),background .25s ease,border-color .25s ease;font-family:Arial,Helvetica,sans-serif}
#pesquisa-p04.open{width:min(620px,88vw);background:#15181d;border-color:rgba(255,255,255,.28)}
#pesquisa-p04 .p04-toggle{width:56px;height:56px;flex:0 0 56px;border:0;background:transparent;color:#fff;display:grid;place-items:center;cursor:pointer}
#pesquisa-p04 .p04-toggle svg{width:22px;height:22px;stroke:currentColor;transition:transform .35s ease}
#pesquisa-p04.open .p04-toggle svg{transform:rotate(8deg)}
#pesquisa-p04 input{width:0;min-width:0;opacity:0;border:0;outline:0;background:transparent;color:#fff;padding:0;font:500 16px/1.2 Arial,sans-serif;transition:width .42s cubic-bezier(.16,1,.3,1),opacity .22s ease .08s,padding .42s ease}
#pesquisa-p04.open input{width:100%;opacity:1;padding:0 8px 0 18px}
#pesquisa-p04 input::placeholder{color:#737880}
#pesquisa-p04 .p04-close{width:0;opacity:0;overflow:hidden;flex:0 0 auto;border:0;background:transparent;color:#878b92;font-size:20px;cursor:pointer;transition:width .28s ease,opacity .2s ease}
#pesquisa-p04.open .p04-close{width:44px;opacity:1}
#pesquisa-p04 .p04-close:hover{color:#fff}
@media(prefers-reduced-motion:reduce){#pesquisa-p04,#pesquisa-p04 input,#pesquisa-p04 .p04-close{transition:none}}
</style>
<div id="pesquisa-p04">
  <input type="search" placeholder="Digite para pesquisar" aria-label="Pesquisar">
  <button class="p04-close" type="button" aria-label="Fechar pesquisa">×</button>
  <button class="p04-toggle" type="button" aria-label="Abrir pesquisa">
    <svg viewBox="0 0 24 24" fill="none" stroke-width="1.7" aria-hidden="true"><circle cx="11" cy="11" r="6.8"></circle><path d="m16 16 4.2 4.2"></path></svg>
  </button>
</div>
<script>
(()=>{const root=document.getElementById('pesquisa-p04'),input=root.querySelector('input'),toggle=root.querySelector('.p04-toggle'),close=root.querySelector('.p04-close');const open=()=>{root.classList.add('open');toggle.setAttribute('aria-label','Pesquisa aberta');setTimeout(()=>input.focus(),180)};const shut=()=>{root.classList.remove('open');toggle.setAttribute('aria-label','Abrir pesquisa');input.blur()};toggle.addEventListener('click',()=>root.classList.contains('open')?input.focus():open());close.addEventListener('click',shut);})();
</script>
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
