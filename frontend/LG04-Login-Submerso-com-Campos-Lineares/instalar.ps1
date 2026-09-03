$ModeloId = 'LG04'
$ModeloNome = 'Login Submerso com Campos Lineares'
$Papel = 'login'
$ArquivoAlvo = 'login.html'
$ConteudoModelo = @'
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Login submerso</title>
<style>
:root{
  --ink:#f5ffff;--muted:#c6e4e7;--aqua:#a9f5ec;--line:rgba(228,255,255,.82);
  --photo:url('https://images.unsplash.com/photo-1575975632779-cbff9d3b56b0?auto=format&fit=crop&w=2400&q=90');
  --ease:cubic-bezier(.16,1,.3,1)
}
*{box-sizing:border-box}html,body{margin:0;min-height:100%;background:#032732;color:var(--ink);font-family:Arial,Helvetica,sans-serif}button,input{font:inherit}body{min-height:100svh}
.lg04{position:relative;isolation:isolate;min-height:100svh;display:grid;place-items:center;overflow:hidden;padding:34px 22px;background-image:linear-gradient(180deg,rgba(0,45,59,.08),rgba(0,31,43,.33)),var(--photo);background-size:cover;background-position:center}
.lg04::before{content:"";position:absolute;z-index:-1;inset:0;background:linear-gradient(120deg,rgba(220,255,255,.09),rgba(3,38,50,.16) 42%,rgba(190,245,242,.08) 72%,rgba(1,25,37,.2));backdrop-filter:blur(5px) saturate(112%);-webkit-backdrop-filter:blur(5px) saturate(112%);box-shadow:inset 0 0 150px rgba(0,20,31,.34),inset 0 1px rgba(255,255,255,.18)}
.lg04-glass{position:absolute;z-index:-1;inset:-18%;pointer-events:none;background:radial-gradient(ellipse at 18% 8%,rgba(207,255,250,.22),transparent 26%),radial-gradient(ellipse at 80% 44%,rgba(109,232,220,.13),transparent 21%),repeating-linear-gradient(108deg,transparent 0 12%,rgba(255,255,255,.035) 14%,transparent 18%);filter:blur(5px);animation:lg04-caustics 12s ease-in-out infinite alternate}
@keyframes lg04-caustics{to{transform:translate3d(3%,-2%,0) rotate(.6deg)}}
.lg04-access{position:relative;width:min(440px,100%);height:720px;text-align:center}
.lg04-avatar{position:absolute;z-index:4;left:50%;top:5px;width:112px;height:112px;display:grid;place-items:center;transform:translateX(-50%);border:1px solid rgba(237,255,255,.54);border-radius:50%;background:linear-gradient(145deg,rgba(229,255,254,.22),rgba(14,76,85,.22));box-shadow:0 22px 60px rgba(0,23,34,.35),inset 0 1px rgba(255,255,255,.55),inset 0 -16px 30px rgba(7,55,66,.18);backdrop-filter:blur(13px);-webkit-backdrop-filter:blur(13px)}
.lg04-avatar svg{width:58px;height:58px;fill:none;stroke:#edffff;stroke-width:1.35;filter:drop-shadow(0 4px 12px rgba(0,26,35,.3))}
.lg04-avatar::after{content:"";position:absolute;inset:8px;border:1px solid rgba(255,255,255,.18);border-radius:50%}
.lg04-view{position:absolute;inset:142px 0 0;display:flex;flex-direction:column;justify-content:flex-start;opacity:0;visibility:hidden;pointer-events:none;filter:blur(10px);transform:translate3d(0,25px,0) scale(.98);transition:opacity .5s ease,filter .7s ease,transform .7s var(--ease),visibility .5s}
.lg04.show-login .lg04-login,.lg04.show-register .lg04-register{opacity:1;visibility:visible;pointer-events:auto;filter:none;transform:none}
.lg04 h1{margin:0;font:500 clamp(39px,5vw,56px)/1 Georgia,serif;letter-spacing:-.035em;text-shadow:0 4px 26px rgba(0,31,42,.45)}
.lg04-lead{margin:10px auto 27px;color:var(--muted);font-size:12px;line-height:1.6;letter-spacing:.025em}
.lg04-form{display:grid;gap:18px;text-align:left}.lg04-field{position:relative;display:grid;gap:6px;padding:0 14px 11px}.lg04-field::after{content:"";position:absolute;left:0;right:0;bottom:0;height:1px;background:linear-gradient(90deg,transparent,var(--line) 12%,var(--line) 88%,transparent);box-shadow:0 1px 8px rgba(183,255,248,.28);transition:filter .2s ease,opacity .2s ease}.lg04-field:focus-within::after{height:2px;filter:drop-shadow(0 0 7px var(--aqua))}
.lg04-field span{font-size:10px;font-weight:900;letter-spacing:.16em;text-transform:uppercase;color:#e5ffff;text-shadow:0 2px 12px rgba(0,25,34,.55)}
.lg04-input{width:100%;height:28px;border:0;background:transparent;color:#fff;outline:none;padding:0;font-size:15px;text-shadow:0 2px 10px rgba(0,19,31,.45)}.lg04-input::placeholder{color:rgba(229,255,255,.52)}
.lg04-actions{display:grid;gap:10px;margin-top:7px}.lg04-btn{min-height:50px;border:1px solid rgba(232,255,255,.42);border-radius:999px;cursor:pointer;font-size:12px;font-weight:900;letter-spacing:.04em;transition:background .2s ease,border-color .2s ease,color .2s ease,transform .2s ease,box-shadow .2s ease}.lg04-btn:active{transform:translateY(1px)}
.lg04-primary{background:rgba(236,255,253,.88);color:#063c48;box-shadow:0 14px 35px rgba(0,26,37,.28)}.lg04-primary:hover{background:#fff;box-shadow:0 17px 40px rgba(0,26,37,.38)}.lg04-secondary{background:rgba(2,42,54,.16);color:#efffff;backdrop-filter:blur(8px)}.lg04-secondary:hover{border-color:var(--aqua);background:rgba(2,42,54,.3)}
.lg04-message{min-height:18px;margin-top:4px;color:#e7ffff;font-size:12px;text-align:center;text-shadow:0 2px 12px rgba(0,19,29,.65)}.lg04-message.error{color:#ffd4d4}
.lg04-note{position:absolute;right:22px;bottom:18px;color:rgba(231,255,255,.62);font-size:9px;font-weight:900;letter-spacing:.16em;text-transform:uppercase;text-shadow:0 2px 10px rgba(0,20,30,.75)}
@media(max-height:790px) and (min-width:701px){.lg04-access{transform:scale(.87)}}
@media(max-width:700px){.lg04{align-items:start;min-height:790px;padding-top:28px;background-position:58% center}.lg04-access{height:730px}.lg04-avatar{width:96px;height:96px}.lg04-avatar svg{width:50px;height:50px}.lg04-view{inset:120px 0 0}.lg04 h1{font-size:42px}.lg04-note{display:none}}
@media(prefers-reduced-motion:reduce){.lg04-glass{animation:none}.lg04-view{transition:none}}
</style>
<script src="assets/js/catalogo-s.config.js"></script>
</head>
<body>
<main class="lg04 show-login" id="lg04">
  <div class="lg04-glass" aria-hidden="true"></div>
  <section class="lg04-access" aria-label="Acesso à conta">
    <div class="lg04-avatar" aria-hidden="true"><svg viewBox="0 0 64 64"><circle cx="32" cy="23" r="12"></circle><path d="M12 56c2.2-12.2 9.8-19 20-19s17.8 6.8 20 19"></path></svg></div>
    <div class="lg04-view lg04-login">
      <h1>Mergulhe de volta.</h1>
      <p class="lg04-lead">Seu acesso, claro e direto.</p>
      <form class="lg04-form" id="lg04-login-form">
        <label class="lg04-field"><span>E-mail</span><input class="lg04-input" name="email" type="email" autocomplete="email" required></label>
        <label class="lg04-field"><span>Senha</span><input class="lg04-input" name="senha" type="password" autocomplete="current-password" required></label>
        <div class="lg04-actions"><button class="lg04-btn lg04-primary" type="submit">Entrar</button><button class="lg04-btn lg04-secondary" id="lg04-open-register" type="button">Criar conta</button></div>
        <div class="lg04-message" id="lg04-login-message" aria-live="polite"></div>
      </form>
    </div>
    <div class="lg04-view lg04-register">
      <h1>Um novo mergulho.</h1>
      <p class="lg04-lead">Crie seu acesso em poucos instantes.</p>
      <form class="lg04-form" id="lg04-register-form">
        <label class="lg04-field"><span>Nome</span><input class="lg04-input" name="nome" type="text" autocomplete="name" required></label>
        <label class="lg04-field"><span>E-mail</span><input class="lg04-input" name="email" type="email" autocomplete="email" required></label>
        <label class="lg04-field"><span>Senha</span><input class="lg04-input" name="senha" type="password" autocomplete="new-password" minlength="8" required></label>
        <label class="lg04-field"><span>Confirmar senha</span><input class="lg04-input" name="confirmarSenha" type="password" autocomplete="new-password" minlength="8" required></label>
        <div class="lg04-actions"><button class="lg04-btn lg04-primary" type="submit">Criar conta</button><button class="lg04-btn lg04-secondary" id="lg04-back-login" type="button">Já tenho conta</button></div>
        <div class="lg04-message" id="lg04-register-message" aria-live="polite"></div>
      </form>
    </div>
  </section>
  <div class="lg04-note">LG04 · Vidro submerso</div>
</main>
<script>
// O instalador configura o destino e a integração automaticamente.
const DESTINO_APOS_LOGIN=window.CATALOGO_S_CONFIG?.auth?.afterLogin||'index.html';
const ENDPOINT_LOGIN=window.CATALOGO_S_CONFIG?.auth?.loginEndpoint||'';
const ENDPOINT_CADASTRO=window.CATALOGO_S_CONFIG?.auth?.cadastroEndpoint||'';
const MODO_DEMONSTRACAO=window.self!==window.top;
const shell=document.getElementById('lg04');
const loginForm=document.getElementById('lg04-login-form');
const registerForm=document.getElementById('lg04-register-form');
const loginMessage=document.getElementById('lg04-login-message');
const registerMessage=document.getElementById('lg04-register-message');
const esperar=ms=>new Promise(resolve=>setTimeout(resolve,ms));
function mudarModo(destino){const cadastro=destino==='register';loginMessage.textContent='';registerMessage.textContent='';shell.classList.toggle('show-register',cadastro);shell.classList.toggle('show-login',!cadastro);setTimeout(()=>document.querySelector(cadastro?'#lg04-register-form input':'#lg04-login-form input')?.focus(),220)}
document.getElementById('lg04-open-register').addEventListener('click',()=>mudarModo('register'));
document.getElementById('lg04-back-login').addEventListener('click',()=>mudarModo('login'));
async function postJSON(url,payload){const r=await fetch(url,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(payload)});const data=await r.json().catch(()=>({}));if(!r.ok)throw new Error(data.message||'Não foi possível concluir.');return data}
loginForm.addEventListener('submit',async e=>{e.preventDefault();loginMessage.classList.remove('error');loginMessage.textContent='Entrando...';const payload=Object.fromEntries(new FormData(loginForm));try{if(ENDPOINT_LOGIN)await postJSON(ENDPOINT_LOGIN,payload);if(MODO_DEMONSTRACAO&&!ENDPOINT_LOGIN){loginMessage.textContent='Preview: o DB01 será conectado pelo instalador.';return}location.href=DESTINO_APOS_LOGIN}catch(err){loginMessage.classList.add('error');loginMessage.textContent=err.message}});
registerForm.addEventListener('submit',async e=>{e.preventDefault();registerMessage.classList.remove('error');const payload=Object.fromEntries(new FormData(registerForm));if(payload.senha!==payload.confirmarSenha){registerMessage.classList.add('error');registerMessage.textContent='As senhas não coincidem.';return}registerMessage.textContent='Criando conta...';try{if(ENDPOINT_CADASTRO)await postJSON(ENDPOINT_CADASTRO,payload);registerForm.reset();registerMessage.textContent='Conta criada.';await esperar(900);mudarModo('login')}catch(err){registerMessage.classList.add('error');registerMessage.textContent=err.message}});
</script>
</body>
</html>
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
