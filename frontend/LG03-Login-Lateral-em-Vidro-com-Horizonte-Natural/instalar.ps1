$ModeloId = 'LG03'
$ModeloNome = 'Login Lateral em Vidro com Horizonte Natural'
$Papel = 'login'
$ArquivoAlvo = 'login.html'
$ConteudoModelo = @'
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Login lateral em vidro</title>
<style>
:root{
  --ink:#11232b;--muted:#49616b;--accent:#0c6f81;--glass:rgba(239,246,246,.48);--line:rgba(21,65,76,.18);
  --photo:url('https://images.unsplash.com/photo-1579970521525-188aaf56351c?auto=format&fit=crop&w=2400&q=90');
  --move:1.7s;--ease:cubic-bezier(.62,0,.14,1)
}
*{box-sizing:border-box}html,body{margin:0;min-height:100%;overflow:hidden;background:#dfe5e7;color:var(--ink);font-family:Arial,Helvetica,sans-serif}button,input{font:inherit}body{min-height:100svh}
.lg03{position:relative;isolation:isolate;min-height:100svh;overflow:hidden;background:#dfe4e6}
.lg03-landscape{position:absolute;z-index:-3;inset:0;background-image:linear-gradient(180deg,#dfe4e6 0 24%,rgba(223,228,230,.9) 32%,rgba(223,228,230,.3) 47%,rgba(223,228,230,0) 61%),linear-gradient(180deg,transparent 52%,rgba(3,30,37,.16)),var(--photo);background-size:cover;background-position:center 56%;transform:scale(1.035);transition:transform var(--move) var(--ease)}
.lg03.register-side .lg03-landscape{transform:scale(1.07) translate3d(-1.5%,0,0)}
.lg03::before{content:"";position:absolute;z-index:-2;inset:0;background:linear-gradient(90deg,rgba(255,255,255,.14),transparent 42%,rgba(8,50,59,.07));pointer-events:none}
.lg03-glass{position:absolute;z-index:2;top:6vh;bottom:6vh;left:4vw;width:min(46vw,650px);border:1px solid rgba(255,255,255,.54);border-radius:34px;background:linear-gradient(145deg,rgba(247,251,250,.64),rgba(225,240,238,.28));box-shadow:0 35px 90px rgba(9,44,50,.22),inset 0 1px rgba(255,255,255,.78);backdrop-filter:blur(17px) saturate(118%);-webkit-backdrop-filter:blur(17px) saturate(118%);transition:transform var(--move) var(--ease),box-shadow var(--move) ease;overflow:hidden}
.lg03.register-side .lg03-glass{transform:translate3d(calc(92vw - min(46vw,650px)),0,0);box-shadow:-22px 35px 90px rgba(9,44,50,.2),inset 0 1px rgba(255,255,255,.78)}
.lg03-glass::before{content:"";position:absolute;width:65%;height:45%;left:-20%;top:-18%;border-radius:50%;background:rgba(255,255,255,.3);filter:blur(30px);pointer-events:none}
.lg03-content{position:relative;width:100%;height:100%;padding:clamp(34px,5vw,74px)}
.lg03-view{position:absolute;inset:clamp(34px,5vw,74px);display:flex;flex-direction:column;justify-content:center;opacity:0;filter:blur(8px);transform:translate3d(0,30px,0);visibility:hidden;pointer-events:none;transition:opacity .55s ease,filter .75s ease,transform .75s cubic-bezier(.16,1,.3,1),visibility .55s}
.lg03.show-login .lg03-login,.lg03.show-register .lg03-register{opacity:1;filter:none;transform:none;visibility:visible;pointer-events:auto;transition-delay:.16s}
.lg03-kicker{display:flex;align-items:center;gap:10px;margin-bottom:15px;color:#245864;font-size:10px;font-weight:900;letter-spacing:.17em;text-transform:uppercase}.lg03-kicker::before{content:"";width:34px;height:1px;background:#2a7b88}
.lg03 h1{margin:0;font:500 clamp(42px,5.2vw,70px)/.94 Georgia,serif;letter-spacing:-.045em;text-wrap:balance}.lg03-lead{margin:15px 0 30px;max-width:38ch;color:var(--muted);font-size:13px;line-height:1.65}
.lg03-form{display:grid;gap:13px}.lg03-field{display:grid;gap:7px}.lg03-field span{font-size:10px;font-weight:900;letter-spacing:.12em;text-transform:uppercase;color:#315a63}
.lg03-input{width:100%;height:52px;border:1px solid var(--line);border-radius:14px;background:rgba(252,255,254,.48);color:#102a32;padding:0 15px;outline:none;box-shadow:inset 0 1px rgba(255,255,255,.65);transition:border-color .2s ease,box-shadow .2s ease,background .2s ease}
.lg03-input:focus{border-color:rgba(12,111,129,.62);background:rgba(255,255,255,.73);box-shadow:0 0 0 4px rgba(12,111,129,.1)}
.lg03-actions{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:4px}.lg03-btn{min-height:52px;border:1px solid rgba(16,69,78,.22);border-radius:14px;cursor:pointer;font-size:12px;font-weight:900;transition:background .2s ease,color .2s ease,border-color .2s ease,transform .2s ease}.lg03-btn:active{transform:translateY(1px)}
.lg03-primary{border-color:#0e6576;background:#0e6576;color:#f8ffff;box-shadow:0 13px 30px rgba(14,101,118,.18)}.lg03-primary:hover{background:#084e5e}.lg03-secondary{background:rgba(255,255,255,.35);color:#174853}.lg03-secondary:hover{border-color:#0e6576;background:rgba(255,255,255,.6)}
.lg03-message{min-height:18px;margin-top:8px;color:#3f6168;font-size:12px}.lg03-message.error{color:#8f2430}
.lg03-note{position:absolute;z-index:3;right:28px;bottom:23px;color:rgba(255,255,255,.76);text-shadow:0 1px 14px rgba(0,0,0,.32);font-size:9px;font-weight:900;letter-spacing:.16em;text-transform:uppercase}
@media(max-height:760px) and (min-width:821px){.lg03-glass{top:3vh;bottom:3vh}.lg03-view{inset:26px 46px}.lg03 h1{font-size:45px}.lg03-lead{margin-bottom:17px}.lg03-form{gap:9px}.lg03-input,.lg03-btn{height:46px;min-height:46px}}
@media(max-width:820px){html,body{overflow:auto}.lg03{min-height:820px}.lg03-landscape{background-position:62% center}.lg03-glass,.lg03.register-side .lg03-glass{position:relative;top:auto;bottom:auto;left:auto;width:calc(100% - 28px);min-height:770px;margin:14px;transform:none;border-radius:28px}.lg03-view{inset:38px 24px}.lg03-actions{grid-template-columns:1fr}.lg03 h1{font-size:46px}.lg03-note{right:24px;bottom:24px}}
@media(prefers-reduced-motion:reduce){.lg03-landscape,.lg03-glass,.lg03-view{transition:none}}
</style>
<script src="assets/js/catalogo-s.config.js"></script>
</head>
<body>
<main class="lg03 show-login" id="lg03">
  <div class="lg03-landscape" aria-hidden="true"></div>
  <section class="lg03-glass" aria-label="Acesso à conta">
    <div class="lg03-content">
      <div class="lg03-view lg03-login">
        <div class="lg03-kicker">Seu espaço</div>
        <h1>Entre com calma.</h1>
        <p class="lg03-lead">Um horizonte aberto para voltar ao que importa.</p>
        <form class="lg03-form" id="lg03-login-form">
          <label class="lg03-field"><span>E-mail</span><input class="lg03-input" name="email" type="email" autocomplete="email" required></label>
          <label class="lg03-field"><span>Senha</span><input class="lg03-input" name="senha" type="password" autocomplete="current-password" required></label>
          <div class="lg03-actions"><button class="lg03-btn lg03-primary" type="submit">Entrar</button><button class="lg03-btn lg03-secondary" id="lg03-open-register" type="button">Criar conta</button></div>
          <div class="lg03-message" id="lg03-login-message" aria-live="polite"></div>
        </form>
      </div>
      <div class="lg03-view lg03-register">
        <div class="lg03-kicker">Novo começo</div>
        <h1>Crie seu acesso.</h1>
        <p class="lg03-lead">Cadastre seus dados para abrir seu espaço.</p>
        <form class="lg03-form" id="lg03-register-form">
          <label class="lg03-field"><span>Nome</span><input class="lg03-input" name="nome" type="text" autocomplete="name" required></label>
          <label class="lg03-field"><span>E-mail</span><input class="lg03-input" name="email" type="email" autocomplete="email" required></label>
          <label class="lg03-field"><span>Senha</span><input class="lg03-input" name="senha" type="password" autocomplete="new-password" minlength="8" required></label>
          <label class="lg03-field"><span>Confirmar senha</span><input class="lg03-input" name="confirmarSenha" type="password" autocomplete="new-password" minlength="8" required></label>
          <div class="lg03-actions"><button class="lg03-btn lg03-primary" type="submit">Criar conta</button><button class="lg03-btn lg03-secondary" id="lg03-back-login" type="button">Já tenho conta</button></div>
          <div class="lg03-message" id="lg03-register-message" aria-live="polite"></div>
        </form>
      </div>
    </div>
  </section>
  <div class="lg03-note">LG03 · Horizonte natural</div>
</main>
<script>
// O instalador configura o destino e a integração automaticamente.
const DESTINO_APOS_LOGIN=window.CATALOGO_S_CONFIG?.auth?.afterLogin||'index.html';
const ENDPOINT_LOGIN=window.CATALOGO_S_CONFIG?.auth?.loginEndpoint||'';
const ENDPOINT_CADASTRO=window.CATALOGO_S_CONFIG?.auth?.cadastroEndpoint||'';
const MODO_DEMONSTRACAO=window.self!==window.top;
const shell=document.getElementById('lg03');
const loginForm=document.getElementById('lg03-login-form');
const registerForm=document.getElementById('lg03-register-form');
const loginMessage=document.getElementById('lg03-login-message');
const registerMessage=document.getElementById('lg03-register-message');
const esperar=ms=>new Promise(resolve=>setTimeout(resolve,ms));
let trocando=false;
async function mudarModo(destino){
  const cadastro=destino==='register';if(trocando)return;
  trocando=true;loginMessage.textContent='';registerMessage.textContent='';
  shell.classList.remove('show-login','show-register');shell.classList.toggle('register-side',cadastro);
  await esperar(matchMedia('(prefers-reduced-motion:reduce)').matches?20:1750);
  shell.classList.add(cadastro?'show-register':'show-login');trocando=false;
  document.querySelector(cadastro?'#lg03-register-form input':'#lg03-login-form input')?.focus();
}
document.getElementById('lg03-open-register').addEventListener('click',()=>mudarModo('register'));
document.getElementById('lg03-back-login').addEventListener('click',()=>mudarModo('login'));
async function postJSON(url,payload){const r=await fetch(url,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(payload)});const data=await r.json().catch(()=>({}));if(!r.ok)throw new Error(data.message||'Não foi possível concluir.');return data}
loginForm.addEventListener('submit',async e=>{e.preventDefault();loginMessage.classList.remove('error');loginMessage.textContent='Entrando...';const payload=Object.fromEntries(new FormData(loginForm));try{if(ENDPOINT_LOGIN)await postJSON(ENDPOINT_LOGIN,payload);if(MODO_DEMONSTRACAO&&!ENDPOINT_LOGIN){loginMessage.textContent='Preview: o DB01 será conectado pelo instalador.';return}location.href=DESTINO_APOS_LOGIN}catch(err){loginMessage.classList.add('error');loginMessage.textContent=err.message}});
registerForm.addEventListener('submit',async e=>{e.preventDefault();registerMessage.classList.remove('error');const payload=Object.fromEntries(new FormData(registerForm));if(payload.senha!==payload.confirmarSenha){registerMessage.classList.add('error');registerMessage.textContent='As senhas não coincidem.';return}registerMessage.textContent='Criando conta...';try{if(ENDPOINT_CADASTRO)await postJSON(ENDPOINT_CADASTRO,payload);registerForm.reset();registerMessage.textContent='Conta criada.';await esperar(900);await mudarModo('login')}catch(err){registerMessage.classList.add('error');registerMessage.textContent=err.message}});
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
