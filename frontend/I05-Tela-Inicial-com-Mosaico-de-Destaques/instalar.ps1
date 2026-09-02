$ModeloId = 'I05'
$ModeloNome = 'Tela Inicial com Mosaico de Destaques'
$Papel = 'inicio'
$ArquivoAlvo = 'index.html'
$ConteudoModelo = @'
<style>
#i05-hero{position:relative;height:100svh;min-height:100svh;max-height:100svh;display:grid;grid-template-columns:minmax(320px,.92fr) minmax(420px,1.02fr);gap:18px;padding:clamp(20px,3vw,32px);background:#08090c;color:#f7f3e9;font-family:Arial,Helvetica,sans-serif}#i05-hero *{box-sizing:border-box}#i05-hero .copy{display:flex;align-items:center;padding:clamp(6px,1vw,12px)}#i05-hero .copy-inner{max-width:560px}#i05-hero .eyebrow{display:inline-flex;padding:8px 12px;border:1px solid rgba(255,255,255,.15);border-radius:999px;background:rgba(255,255,255,.03);font-size:11px;letter-spacing:.16em;color:#d7cfbf;text-transform:uppercase}#i05-hero h1{margin:16px 0 14px;font:500 clamp(42px,5.9vw,80px) Georgia,serif;line-height:.92;max-width:11ch}#i05-hero p{color:#b7b0a6;font-size:17px;line-height:1.68;margin:0 0 24px}#i05-hero .actions{display:flex;gap:12px;flex-wrap:wrap}#i05-hero .btn{display:inline-flex;padding:14px 20px;border-radius:999px;text-decoration:none;font-weight:700;min-width:150px}#i05-hero .primary{background:#f7f3e9;color:#08090c}#i05-hero .secondary{background:rgba(255,255,255,.05);color:#f7f3e9;border:1px solid rgba(255,255,255,.12)}#i05-hero .mosaic{display:grid;grid-template-columns:1.05fr .95fr;grid-template-rows:1fr .8fr .8fr;gap:12px;min-height:0;height:100%}#i05-hero .tile{position:relative;overflow:hidden;border-radius:22px;border:1px solid rgba(255,255,255,.10);background:#101216;box-shadow:0 24px 56px rgba(0,0,0,.30)}#i05-hero .tile img{width:100%;height:100%;object-fit:cover;display:block;transition:transform .7s ease}#i05-hero .tile:hover img{transform:scale(1.05)}#i05-hero .tile::after{content:"";position:absolute;inset:0;background:linear-gradient(180deg,rgba(8,9,12,.08),rgba(8,9,12,.36))}#i05-hero .big{grid-row:1 / span 2}#i05-hero .wide{grid-column:1 / span 2}@media(max-width:980px){#i05-hero{grid-template-columns:1fr;height:auto;min-height:100svh;max-height:none}#i05-hero .mosaic{grid-template-rows:220px 160px 160px;min-height:auto}}</style>
<section id="i05-hero"><div class="copy"><div class="copy-inner"><span class="eyebrow">Divulgação e vitrine</span><h1>Mostre variedade já na abertura do site.</h1><p>Perfeita para negócios que querem combinar título forte com um mosaico visual de produtos, serviços ou ambiente.</p><div class="actions"><a class="btn primary" href="#">Explorar</a><a class="btn secondary" href="#">Falar com a equipe</a></div></div></div><div class="mosaic"><article class="tile big"><img src="https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80" alt="Coleção em destaque"></article><article class="tile"><img src="https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80" alt="Moda e produtos"></article><article class="tile"><img src="https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80" alt="Atendimento e experiência"></article><article class="tile wide"><img src="https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1600&q=80" alt="Campanhas e vitrine"></article></div></section>
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
