$ModeloId = 'I01'
$ModeloNome = 'Tela Inicial Lateral com Foto Emergindo no Degradê'
$Papel = 'inicio'
$ArquivoAlvo = 'index.html'
$ConteudoModelo = @'
<style>
#i01-hero{position:relative;isolation:isolate;height:100svh;min-height:100svh;max-height:100svh;display:grid;grid-template-columns:minmax(320px,.96fr) minmax(380px,1.04fr);background:#060708;color:#f7f2ea;overflow:hidden;font-family:Arial,Helvetica,sans-serif}#i01-hero *{box-sizing:border-box}#i01-hero .copy{display:flex;align-items:center;padding:clamp(24px,4vw,54px);position:relative;z-index:2}#i01-hero .copy-inner{max-width:620px}#i01-hero .eyebrow{display:inline-flex;gap:8px;align-items:center;padding:8px 13px;border:1px solid rgba(255,255,255,.14);border-radius:999px;background:rgba(255,255,255,.03);color:#d5c09b;font-size:11px;letter-spacing:.16em;text-transform:uppercase}#i01-hero h1{font:500 clamp(42px,5.8vw,78px) Georgia,serif;line-height:.92;margin:16px 0 14px;max-width:11ch}#i01-hero p{max-width:480px;color:#b6b0a6;font-size:17px;line-height:1.68;margin:0 0 24px}#i01-hero .actions{display:flex;gap:12px;flex-wrap:wrap}#i01-hero .btn{display:inline-flex;align-items:center;justify-content:center;min-width:160px;padding:14px 20px;border-radius:999px;text-decoration:none;font-weight:700;transition:.18s}#i01-hero .btn.primary{background:#d1ae74;color:#060708;box-shadow:0 18px 34px rgba(209,174,116,.16)}#i01-hero .btn.secondary{border:1px solid rgba(255,255,255,.15);background:rgba(255,255,255,.04);color:#f7f2ea}#i01-hero .visual{position:relative;min-height:0;height:100%;background-image:linear-gradient(90deg,#060708 0%,#060708 7%,rgba(6,7,8,.96) 18%,rgba(6,7,8,.82) 30%,rgba(6,7,8,.48) 45%,rgba(6,7,8,.10) 60%,rgba(6,7,8,0) 74%),url("https://images.unsplash.com/photo-1517832606299-7ae9b720a186?auto=format&fit=crop&w=1600&q=80");background-size:cover;background-position:center right}#i01-hero .glow{position:absolute;right:8%;top:12%;width:min(24vw,260px);aspect-ratio:1;border-radius:50%;background:radial-gradient(circle,rgba(209,174,116,.26),rgba(209,174,116,0) 70%);filter:blur(22px)}@media(max-width:960px){#i01-hero{grid-template-columns:1fr;height:auto;min-height:100svh;max-height:none}#i01-hero .visual{min-height:42vh;height:auto}#i01-hero{min-height:auto}}</style>
<section id="i01-hero"><div class="copy"><div class="copy-inner"><span class="eyebrow">Barbearia autoral</span><h1>Presença forte logo na primeira dobra.</h1><p>Modelo ideal para marcas que precisam de leitura clara à esquerda e imagem marcante surgindo do lado direito.</p><div class="actions"><a class="btn primary" href="#">Agendar horário</a><a class="btn secondary" href="#">Conhecer serviços</a></div></div></div><div class="visual"><div class="glow"></div></div></section>
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
