$ModeloId = 'F05'
$ModeloNome = 'Rodapé Utilitário de Aplicação'
$ConteudoModelo = @'
<footer id="catalogo-f05" data-catalogo-s-model="F05">
<style>
#catalogo-f05{--bg:#f4f6f8;--ink:#18202a;--muted:#667180;--line:#dce1e7;--blue:#2563eb;background:var(--bg);color:var(--ink);font-family:Arial,Helvetica,sans-serif;border-top:1px solid var(--line)}
#catalogo-f05 *{box-sizing:border-box}#catalogo-f05 a{color:inherit;text-decoration:none}
#catalogo-f05 .f05-wrap{width:min(1320px,calc(100% - 32px));margin:auto;padding:22px 0}
#catalogo-f05 .f05-row{display:grid;grid-template-columns:auto 1fr auto;align-items:center;gap:28px;min-height:72px}
#catalogo-f05 .f05-brand{display:flex;align-items:center;gap:11px;font-weight:900;font-size:13px}.f05-brand i{width:29px;height:29px;display:grid;place-items:center;border-radius:8px;background:#18202a;color:#fff;font-style:normal;font-size:10px}
#catalogo-f05 .f05-nav{display:flex;align-items:center;gap:20px;flex-wrap:wrap}#catalogo-f05 .f05-nav a{color:var(--muted);font-size:11px;font-weight:700}#catalogo-f05 .f05-nav a:hover{color:var(--blue)}
#catalogo-f05 .f05-tools{display:flex;align-items:center;gap:8px}
#catalogo-f05 .f05-control,#catalogo-f05 .f05-support{height:36px;display:flex;align-items:center;gap:8px;border:1px solid var(--line);border-radius:9px;background:#fff;padding:0 11px;color:#45505e;font-size:10px;font-weight:800}
#catalogo-f05 .f05-support{background:#18202a;color:#fff;border-color:#18202a}
#catalogo-f05 .f05-meta{display:flex;justify-content:space-between;gap:18px;padding-top:17px;border-top:1px solid var(--line);color:#7e8895;font-size:9px}
#catalogo-f05 .f05-status{display:flex;align-items:center;gap:7px}.f05-status i{width:7px;height:7px;border-radius:50%;background:#2fba6d;box-shadow:0 0 0 3px #2fba6d18}
#catalogo-f05 .f05-meta nav{display:flex;gap:15px;flex-wrap:wrap}
@media(max-width:800px){#catalogo-f05 .f05-row{grid-template-columns:1fr auto}#catalogo-f05 .f05-nav{grid-column:1/-1;grid-row:2;padding-bottom:8px}}
@media(max-width:520px){#catalogo-f05 .f05-wrap{width:calc(100% - 24px)}#catalogo-f05 .f05-row{grid-template-columns:1fr}#catalogo-f05 .f05-tools{justify-content:flex-start;flex-wrap:wrap}#catalogo-f05 .f05-nav{grid-column:auto;grid-row:auto;gap:13px}#catalogo-f05 .f05-meta{align-items:flex-start;flex-direction:column}}
</style>
<div class="f05-wrap"><div class="f05-row"><div class="f05-brand"><i>OS</i><span>Orbit Console</span></div><nav class="f05-nav"><a href="#">Documentação</a><a href="#">API</a><a href="#">Changelog</a><a href="#">Status</a><a href="#">Comunidade</a></nav><div class="f05-tools"><div class="f05-control">PT-BR ▾</div><div class="f05-control">Tema · Sistema</div><a class="f05-support" href="#">Suporte</a></div></div><div class="f05-meta"><div class="f05-status"><i></i><span>Serviços operacionais · v4.8.2</span></div><nav><a href="#">Privacidade</a><a href="#">Termos</a><a href="#">Segurança</a><span>© 2026 Orbit</span></nav></div></div>
</footer>
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

Ensure-HostPage
$footerRelative = 'components/catalogo-s/rodape/ativo.html'
Write-TextFile $footerRelative $ConteudoModelo
$index = Get-FullPath 'index.html'
$html = [System.IO.File]::ReadAllText($index)
$html = Ensure-Slots $html
$updated = Set-Slot $html 'RODAPE' $ConteudoModelo
Write-TextFile 'index.html' $updated
Write-Host ""
Write-Host "[Catálogo S] $ModeloId — $ModeloNome instalado como rodapé ativo."
Write-Host "[Catálogo S] Rodapés são singleton: instalar outro Fxx substitui apenas o rodapé."
Write-Host "[Catálogo S] Nenhum arquivo foi baixado do GitHub."
