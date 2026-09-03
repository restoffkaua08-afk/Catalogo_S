$ModeloId = 'LG02'
$ModeloNome = 'Login Central em Vidro com Cidade Noturna'
$Papel = 'login'
$ArquivoAlvo = 'login.html'
$ConteudoModelo = @'
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Login central em vidro</title>
<style>
:root{
  --ink:#fffaf1;--muted:#d7cbbd;--accent:#ffc36b;--line:rgba(255,255,255,.28);
  --photo:url('https://images.unsplash.com/photo-1674759690830-4d6013da1449?auto=format&fit=crop&w=2400&q=88');
  --ease:cubic-bezier(.16,1,.3,1)
}
*{box-sizing:border-box}html,body{margin:0;min-height:100%;background:#07090d;color:var(--ink);font-family:Arial,Helvetica,sans-serif}button,input{font:inherit}body{min-height:100svh}
.lg02{position:relative;isolation:isolate;min-height:100svh;display:grid;place-items:center;overflow:hidden;padding:32px}
.lg02-bg{position:absolute;z-index:-3;inset:-24px;background-image:linear-gradient(180deg,rgba(4,7,13,.16),rgba(4,7,13,.5)),var(--photo);background-position:center;background-size:cover;filter:saturate(.92) contrast(1.03);transform:scale(1.03);animation:lg02-drift 18s ease-in-out infinite alternate}
.lg02::before{content:"";position:absolute;z-index:-2;inset:0;background:radial-gradient(circle at 22% 78%,rgba(255,169,75,.22),transparent 27%),radial-gradient(circle at 78% 24%,rgba(255,205,132,.12),transparent 24%),linear-gradient(90deg,rgba(3,5,9,.28),transparent 45%,rgba(3,5,9,.24))}
.lg02::after{content:"";position:absolute;z-index:-1;inset:0;box-shadow:inset 0 0 150px rgba(0,0,0,.48);pointer-events:none}
@keyframes lg02-drift{to{transform:scale(1.07) translate3d(-.7%,.5%,0)}}
.lg02-card{position:relative;width:min(460px,100%);min-height:760px;padding:clamp(30px,4vw,48px);overflow:hidden;border:1px solid rgba(255,255,255,.24);border-radius:30px;background:linear-gradient(145deg,rgba(21,24,30,.58),rgba(11,13,18,.36));box-shadow:0 36px 90px rgba(0,0,0,.45),inset 0 1px rgba(255,255,255,.22);backdrop-filter:blur(20px) saturate(125%);-webkit-backdrop-filter:blur(20px) saturate(125%)}
.lg02-card::before{content:"";position:absolute;inset:0;background:linear-gradient(135deg,rgba(255,255,255,.13),transparent 34%,transparent 68%,rgba(255,190,102,.06));pointer-events:none}
.lg02-brand{position:relative;display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:24px;color:#fff0dc;font-size:11px;font-weight:800;letter-spacing:.18em;text-transform:uppercase}
.lg02-brand::before{content:"";width:28px;height:1px;background:var(--accent);box-shadow:0 0 14px rgba(255,195,107,.8)}
.lg02-stage{position:relative;min-height:630px}
.lg02-view{position:absolute;inset:0;display:flex;flex-direction:column;justify-content:center;opacity:0;visibility:hidden;pointer-events:none;transform:translate3d(34px,0,0);transition:opacity .5s ease,transform .65s var(--ease),visibility .5s}
.lg02.show-login .lg02-login,.lg02.show-register .lg02-register{opacity:1;visibility:visible;pointer-events:auto;transform:none}
.lg02.show-register .lg02-login{transform:translate3d(-34px,0,0)}
.lg02 h1{margin:0;text-align:center;font:500 clamp(37px,5vw,54px)/.98 Georgia,serif;letter-spacing:-.035em;text-wrap:balance}
.lg02-lead{margin:13px auto 28px;max-width:34ch;text-align:center;color:var(--muted);font-size:13px;line-height:1.6}
.lg02-form{display:grid;gap:14px}.lg02-field{display:grid;gap:7px}.lg02-field span{font-size:10px;font-weight:800;letter-spacing:.13em;text-transform:uppercase;color:#efe3d4}
.lg02-input{width:100%;height:52px;border:1px solid var(--line);border-radius:13px;background:rgba(4,7,11,.42);color:#fff;padding:0 15px;outline:none;transition:border-color .2s ease,background .2s ease,box-shadow .2s ease}
.lg02-input:focus{border-color:rgba(255,195,107,.86);background:rgba(4,7,11,.62);box-shadow:0 0 0 4px rgba(255,195,107,.1)}
.lg02-actions{display:grid;gap:10px;margin-top:4px}.lg02-btn{min-height:52px;border:1px solid var(--line);border-radius:13px;cursor:pointer;font-size:13px;font-weight:800;transition:background .2s ease,border-color .2s ease,color .2s ease,transform .2s ease}
.lg02-btn:active{transform:translateY(1px)}.lg02-primary{border-color:transparent;background:#fff3df;color:#17110a}.lg02-primary:hover{background:#fff}.lg02-secondary{background:rgba(255,255,255,.04);color:#fff}.lg02-secondary:hover{border-color:rgba(255,195,107,.72);color:#ffdba5}
.lg02-message{min-height:18px;margin-top:7px;color:#f1dfc9;font-size:12px;text-align:center}.lg02-message.error{color:#ffd0d0}
.lg02-note{position:absolute;right:20px;bottom:17px;color:rgba(255,255,255,.5);font-size:9px;font-weight:800;letter-spacing:.15em;text-transform:uppercase}
@media(max-height:820px) and (min-width:701px){.lg02{padding:12px}.lg02-card{transform:scale(.88)}}
@media(max-width:700px){.lg02{min-height:800px;padding:18px;overflow:visible}.lg02-card{min-height:760px;padding:28px 22px;border-radius:24px}.lg02-stage{min-height:640px}.lg02 h1{font-size:39px}}
@media(prefers-reduced-motion:reduce){.lg02-bg{animation:none}.lg02-view{transition:none}}
</style>
<script src="assets/js/catalogo-s.config.js"></script>
</head>
<body>
<main class="lg02 show-login" id="lg02">
  <div class="lg02-bg" aria-hidden="true"></div>
  <section class="lg02-card" aria-label="Acesso à conta">
    <div class="lg02-brand">Acesso seguro</div>
    <div class="lg02-stage">
      <div class="lg02-view lg02-login">
        <h1>Bem-vindo.</h1>
        <p class="lg02-lead">Entre para continuar de onde parou.</p>
        <form class="lg02-form" id="lg02-login-form">
          <label class="lg02-field"><span>E-mail</span><input class="lg02-input" name="email" type="email" autocomplete="email" required></label>
          <label class="lg02-field"><span>Senha</span><input class="lg02-input" name="senha" type="password" autocomplete="current-password" required></label>
          <div class="lg02-actions"><button class="lg02-btn lg02-primary" type="submit">Entrar</button><button class="lg02-btn lg02-secondary" id="lg02-open-register" type="button">Criar conta</button></div>
          <div class="lg02-message" id="lg02-login-message" aria-live="polite"></div>
        </form>
      </div>
      <div class="lg02-view lg02-register">
        <h1>Crie sua conta.</h1>
        <p class="lg02-lead">Quatro campos e seu acesso estará pronto.</p>
        <form class="lg02-form" id="lg02-register-form">
          <label class="lg02-field"><span>Nome</span><input class="lg02-input" name="nome" type="text" autocomplete="name" required></label>
          <label class="lg02-field"><span>E-mail</span><input class="lg02-input" name="email" type="email" autocomplete="email" required></label>
          <label class="lg02-field"><span>Senha</span><input class="lg02-input" name="senha" type="password" autocomplete="new-password" minlength="8" required></label>
          <label class="lg02-field"><span>Confirmar senha</span><input class="lg02-input" name="confirmarSenha" type="password" autocomplete="new-password" minlength="8" required></label>
          <div class="lg02-actions"><button class="lg02-btn lg02-primary" type="submit">Criar conta</button><button class="lg02-btn lg02-secondary" id="lg02-back-login" type="button">Já tenho conta</button></div>
          <div class="lg02-message" id="lg02-register-message" aria-live="polite"></div>
        </form>
      </div>
    </div>
    <div class="lg02-note">LG02 · Cidade noturna</div>
  </section>
</main>
<script>
// O instalador configura o destino e a integração automaticamente.
const DESTINO_APOS_LOGIN=window.CATALOGO_S_CONFIG?.auth?.afterLogin||'index.html';
const ENDPOINT_LOGIN=window.CATALOGO_S_CONFIG?.auth?.loginEndpoint||'';
const ENDPOINT_CADASTRO=window.CATALOGO_S_CONFIG?.auth?.cadastroEndpoint||'';
const MODO_DEMONSTRACAO=window.self!==window.top;
const shell=document.getElementById('lg02');
const loginForm=document.getElementById('lg02-login-form');
const registerForm=document.getElementById('lg02-register-form');
const loginMessage=document.getElementById('lg02-login-message');
const registerMessage=document.getElementById('lg02-register-message');
const esperar=ms=>new Promise(resolve=>setTimeout(resolve,ms));
function mudarModo(destino){
  const cadastro=destino==='register';
  loginMessage.textContent='';registerMessage.textContent='';
  shell.classList.toggle('show-register',cadastro);shell.classList.toggle('show-login',!cadastro);
  setTimeout(()=>document.querySelector(cadastro?'#lg02-register-form input':'#lg02-login-form input')?.focus(),220);
}
document.getElementById('lg02-open-register').addEventListener('click',()=>mudarModo('register'));
document.getElementById('lg02-back-login').addEventListener('click',()=>mudarModo('login'));
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
