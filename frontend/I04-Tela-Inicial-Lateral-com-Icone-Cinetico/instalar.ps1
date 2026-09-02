$ModeloId = 'I04'
$ModeloNome = 'Tela Inicial Lateral com Ícone Cinético'
$Papel = 'inicio'
$ArquivoAlvo = 'index.html'
$ConteudoModelo = @'
<style>
#i04-hero{position:relative;height:100svh;min-height:100svh;max-height:100svh;display:grid;grid-template-columns:minmax(320px,1fr) minmax(320px,.88fr);background:#08090c;color:#f7f3e9;overflow:hidden;font-family:Arial,Helvetica,sans-serif}#i04-hero .left{display:flex;align-items:center;padding:clamp(24px,4vw,54px);position:relative;z-index:1}#i04-hero .copy{max-width:620px}#i04-hero .eyebrow{display:inline-flex;padding:8px 12px;border:1px solid rgba(255,255,255,.14);border-radius:999px;background:rgba(255,255,255,.03);font-size:11px;letter-spacing:.16em;color:#d6cebf;text-transform:uppercase}#i04-hero h1{margin:16px 0 14px;font:500 clamp(42px,5.7vw,78px) Georgia,serif;line-height:.92;max-width:11ch}#i04-hero p{max-width:480px;color:#b7b0a6;font-size:17px;line-height:1.68;margin:0 0 24px}#i04-hero .actions{display:flex;gap:12px;flex-wrap:wrap}#i04-hero .btn{display:inline-flex;padding:14px 20px;border-radius:999px;text-decoration:none;font-weight:700;min-width:160px}#i04-hero .primary{background:#d0ad72;color:#08090c}#i04-hero .secondary{background:rgba(255,255,255,.04);color:#f7f3e9;border:1px solid rgba(255,255,255,.12)}#i04-hero .right{position:relative;display:grid;place-items:center;padding:20px;min-height:0;height:100%}#i04-hero .orb{position:absolute;width:min(40vw,360px);aspect-ratio:1;border-radius:50%;background:radial-gradient(circle,rgba(208,173,114,.18),rgba(208,173,114,0) 66%);filter:blur(18px)}#i04-hero .shell{position:relative;width:min(28vw,280px);min-width:220px;aspect-ratio:1;border-radius:30%;background:linear-gradient(180deg,rgba(255,255,255,.08),rgba(255,255,255,.025));border:1px solid rgba(255,255,255,.10);box-shadow:0 28px 70px rgba(0,0,0,.44);display:grid;place-items:center;overflow:hidden;transform:rotate(-8deg)}#i04-hero .shell::before{content:"";position:absolute;inset:-35% -30%;background:conic-gradient(from 90deg,rgba(208,173,114,0),rgba(208,173,114,.05),rgba(208,173,114,.45),rgba(255,255,255,.10),rgba(208,173,114,0));animation:i04spin 9s linear infinite}#i04-hero .shell::after{content:"";position:absolute;inset:16px;border-radius:26%;border:1px solid rgba(255,255,255,.08)}#i04-hero .pulse{position:absolute;inset:0;background:radial-gradient(circle at center,rgba(255,255,255,.12),transparent 42%);mix-blend-mode:screen;animation:i04pulse 4.4s ease-in-out infinite}#i04-hero svg{position:relative;z-index:1;width:54%;height:54%;stroke:#f7f3e9;stroke-width:1.6;fill:none;stroke-linecap:round;stroke-linejoin:round;filter:drop-shadow(0 0 18px rgba(208,173,114,.32))}@keyframes i04spin{to{transform:rotate(360deg)}}@keyframes i04pulse{0%,100%{opacity:.42;transform:scale(.92)}50%{opacity:.88;transform:scale(1.08)}}@media(max-width:960px){#i04-hero{grid-template-columns:1fr;height:auto;min-height:100svh;max-height:none}#i04-hero .shell{width:min(62vw,280px)}#i04-hero{min-height:auto}}</style>
<section id="i04-hero"><div class="left"><div class="copy"><span class="eyebrow">Prestação de serviços</span><h1>Uma abertura moderna sem depender de foto.</h1><p>Ideal para negócios de serviço que querem um visual elegante e um elemento gráfico forte no lado direito.</p><div class="actions"><a class="btn primary" href="#">Solicitar orçamento</a><a class="btn secondary" href="#">Conhecer serviços</a></div></div></div><div class="right"><div class="orb"></div><div class="shell"><div class="pulse"></div><svg viewBox="0 0 64 64" aria-hidden="true"><path d="M14 43 32 16l18 27"></path><path d="M19 38h26"></path><path d="M24 47h16"></path></svg></div></div></section>
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
