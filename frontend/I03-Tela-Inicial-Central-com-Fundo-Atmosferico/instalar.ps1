$ModeloId = 'I03'
$ModeloNome = 'Tela Inicial Central com Fundo Atmosférico'
$Papel = 'inicio'
$ArquivoAlvo = 'index.html'
$ConteudoModelo = @'
<style>
#i03-hero{position:relative;height:100svh;min-height:100svh;max-height:100svh;overflow:hidden;background:#090b11;color:#f7f3e9;font-family:Arial,Helvetica,sans-serif;display:grid;place-items:center;padding:28px}#i03-hero *{box-sizing:border-box}#i03-hero .bg{position:absolute;inset:0;background:radial-gradient(circle at 18% 28%,rgba(72,120,255,.20),transparent 28%),radial-gradient(circle at 78% 22%,rgba(0,255,183,.14),transparent 24%),radial-gradient(circle at 64% 80%,rgba(255,119,187,.14),transparent 28%),linear-gradient(180deg,#0b0f18,#090b11)}#i03-hero .rings{position:absolute;inset:0;background:radial-gradient(circle at center,transparent 0 28%,rgba(255,255,255,.03) 28.5%,transparent 29.5%,transparent 40%,rgba(255,255,255,.028) 40.5%,transparent 41.5%)}#i03-hero .content{position:relative;z-index:1;max-width:960px;text-align:center}#i03-hero .eyebrow{display:inline-flex;padding:8px 12px;border:1px solid rgba(255,255,255,.14);border-radius:999px;background:rgba(255,255,255,.03);font-size:11px;letter-spacing:.16em;color:#d6cfbf;text-transform:uppercase}#i03-hero h1{max-width:12ch;margin:16px auto 14px;font:500 clamp(44px,6vw,82px) Georgia,serif;line-height:.92}#i03-hero p{max-width:560px;margin:0 auto;color:#b7b2a9;font-size:17px;line-height:1.68}#i03-hero .actions{display:flex;justify-content:center;gap:12px;flex-wrap:wrap;margin-top:24px}#i03-hero .btn{display:inline-flex;padding:14px 20px;border-radius:999px;text-decoration:none;font-weight:700;min-width:150px}#i03-hero .primary{background:#f7f3e9;color:#08090c}#i03-hero .secondary{background:rgba(255,255,255,.05);color:#f7f3e9;border:1px solid rgba(255,255,255,.13)}#i03-hero .showcase{position:relative;margin:26px auto 0;width:min(760px,88vw);padding:12px;border-radius:24px;background:linear-gradient(180deg,rgba(255,255,255,.08),rgba(255,255,255,.03));border:1px solid rgba(255,255,255,.10);box-shadow:0 24px 70px rgba(0,0,0,.42)}#i03-hero .showcase img{display:block;width:100%;height:min(32vw,260px);min-height:180px;object-fit:cover;border-radius:16px}@media(max-width:700px){#i03-hero{height:auto;min-height:100svh;max-height:none;padding:24px 18px}#i03-hero .showcase img{height:190px}}</style>
<section id="i03-hero"><div class="bg"></div><div class="rings"></div><div class="content"><span class="eyebrow">Loja de moda</span><h1>Uma hero central com presença e atmosfera.</h1><p>Boa para marcas que querem uma abertura moderna, bonita e com foco total no título.</p><div class="actions"><a class="btn primary" href="#">Ver coleção</a><a class="btn secondary" href="#">Conhecer a marca</a></div><div class="showcase"><img src="https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=1600&q=80" alt="Moda em destaque"></div></div></section>
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

    # CATALOGO-S:REBUILD-RODAPE
    $footerRelative = 'components/catalogo-s/rodape/ativo.html'
    $footerFull = Get-FullPath $footerRelative
    if (Test-Path -LiteralPath $footerFull) {
        $footerContent = [System.IO.File]::ReadAllText($footerFull)
        $index = Get-FullPath 'index.html'
        $html = [System.IO.File]::ReadAllText($index)
        $html = Ensure-Slots $html
        $updated = Set-Slot $html 'RODAPE' $footerContent
        Write-TextFile 'index.html' $updated
    }
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
