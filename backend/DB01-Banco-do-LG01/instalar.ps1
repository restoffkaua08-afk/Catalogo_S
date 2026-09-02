$ModeloId = 'DB01'
$ModeloNome = 'Banco do LG01'
$Arquivo1 = 'database/schema.sql'
$Conteudo1 = @'
-- DB01 — Banco do LG01
-- Compatível com MySQL 8+ e MariaDB 10.5+

-- ============================================================
-- LIGAÇÃO LG01 ↔ BACKEND ↔ DB01
-- ============================================================
-- NÃO conecte login.html diretamente a este arquivo .sql.
-- O fluxo correto é:
--
--   LG01 (login.html)
--        ↓ HTTP/JSON
--   BACKEND / API
--        ↓ conexão MySQL/MariaDB
--   DB01 (banco catalogo_login_lg01 / tabela usuarios)
--
-- Na integração gerada pelo Catálogo S, o LG01 usa:
--   ENDPOINT_LOGIN = '/api/auth/login'
--   ENDPOINT_CADASTRO = '/api/auth/cadastro'
--
-- O backend dessas rotas deve conectar neste banco:
--   BANCO:  catalogo_login_lg01
--   TABELA: usuarios
--
-- Contrato recebido do LG01:
--   POST /api/auth/cadastro
--   { nome, email, senha, confirmarSenha }
--
--   POST /api/auth/login
--   { email, senha }
--
-- IMPORTANTE:
-- - confirmarSenha serve apenas para validação e NÃO é armazenada.
-- - senha chega ao backend como texto de entrada, mas NÃO deve ser salva.
-- - o backend deve gerar um hash seguro e gravá-lo em senha_hash.
-- - use consultas parametrizadas/prepared statements no backend.
-- ============================================================

CREATE DATABASE IF NOT EXISTS catalogo_login_lg01
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE catalogo_login_lg01;

CREATE TABLE IF NOT EXISTS usuarios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT pk_usuarios PRIMARY KEY (id),
  CONSTRAINT uq_usuarios_email UNIQUE (email)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- EXEMPLOS PARA O BACKEND DO LG01
-- NÃO são executados por este arquivo; copie-os para consultas
-- parametrizadas/prepared statements no backend.
-- ============================================================

-- CADASTRO
-- LG01.nome  -> usuarios.nome
-- LG01.email -> usuarios.email
-- LG01.senha -> backend gera hash -> usuarios.senha_hash
-- INSERT INTO usuarios (nome, email, senha_hash)
-- VALUES (?, ?, ?);

-- LOGIN
-- LG01.email localiza o usuário.
-- Depois o backend compara LG01.senha com usuarios.senha_hash.
-- SELECT id, nome, email, senha_hash
-- FROM usuarios
-- WHERE email = ?
-- LIMIT 1;
'@
$Arquivo2 = 'lib/catalogo-s-db.js'
$Conteudo2 = @'
import mysql from 'mysql2/promise';

let pool;

function banco() {
  if (pool) return pool;

  const url = process.env.DATABASE_URL;
  if (!url) {
    throw new Error('DATABASE_URL não configurada. Use o formato indicado em .env.example.');
  }

  pool = mysql.createPool(url);
  return pool;
}

export async function localizarUsuarioPorEmail(email) {
  const [linhas] = await banco().execute(
    'SELECT id, nome, email, senha_hash FROM usuarios WHERE email = ? LIMIT 1',
    [email]
  );

  return linhas[0] || null;
}

export async function criarUsuario({ nome, email, senhaHash }) {
  const [resultado] = await banco().execute(
    'INSERT INTO usuarios (nome, email, senha_hash) VALUES (?, ?, ?)',
    [nome, email, senhaHash]
  );

  return {
    id: resultado.insertId,
    nome,
    email,
  };
}
'@
$Arquivo3 = 'api/auth/login.js'
$Conteudo3 = @'
import bcrypt from 'bcryptjs';
import { localizarUsuarioPorEmail } from '../../lib/catalogo-s-db.js';

function json(data, status = 200) {
  return Response.json(data, {
    status,
    headers: { 'Cache-Control': 'no-store' },
  });
}

export default {
  async fetch(request) {
    if (request.method !== 'POST') {
      return json({ ok: false, message: 'Método não permitido.' }, 405);
    }

    let body;
    try {
      body = await request.json();
    } catch {
      return json({ ok: false, message: 'JSON inválido.' }, 400);
    }

    const email = String(body?.email || '').trim().toLowerCase();
    const senha = String(body?.senha || '');

    if (!email || !senha) {
      return json({ ok: false, message: 'Informe e-mail e senha.' }, 400);
    }

    try {
      const usuario = await localizarUsuarioPorEmail(email);
      if (!usuario) {
        return json({ ok: false, message: 'Credenciais inválidas.' }, 401);
      }

      const valida = await bcrypt.compare(senha, usuario.senha_hash);
      if (!valida) {
        return json({ ok: false, message: 'Credenciais inválidas.' }, 401);
      }

      return json({
        ok: true,
        usuario: {
          id: usuario.id,
          nome: usuario.nome,
          email: usuario.email,
        },
      });
    } catch (error) {
      console.error('[DB01 login]', error);
      return json({ ok: false, message: 'Não foi possível entrar.' }, 500);
    }
  },
};
'@
$Arquivo4 = 'api/auth/cadastro.js'
$Conteudo4 = @'
import bcrypt from 'bcryptjs';
import { criarUsuario, localizarUsuarioPorEmail } from '../../lib/catalogo-s-db.js';

function json(data, status = 200) {
  return Response.json(data, {
    status,
    headers: { 'Cache-Control': 'no-store' },
  });
}

export default {
  async fetch(request) {
    if (request.method !== 'POST') {
      return json({ ok: false, message: 'Método não permitido.' }, 405);
    }

    let body;
    try {
      body = await request.json();
    } catch {
      return json({ ok: false, message: 'JSON inválido.' }, 400);
    }

    const nome = String(body?.nome || '').trim();
    const email = String(body?.email || '').trim().toLowerCase();
    const senha = String(body?.senha || '');
    const confirmarSenha = String(body?.confirmarSenha || '');

    if (!nome || !email || !senha || !confirmarSenha) {
      return json({ ok: false, message: 'Preencha todos os campos.' }, 400);
    }

    if (senha !== confirmarSenha) {
      return json({ ok: false, message: 'As senhas não coincidem.' }, 400);
    }

    if (senha.length < 8) {
      return json({ ok: false, message: 'A senha precisa ter pelo menos 8 caracteres.' }, 400);
    }

    try {
      const existente = await localizarUsuarioPorEmail(email);
      if (existente) {
        return json({ ok: false, message: 'Já existe uma conta com este e-mail.' }, 409);
      }

      const senhaHash = await bcrypt.hash(senha, 12);
      const usuario = await criarUsuario({ nome, email, senhaHash });

      return json({
        ok: true,
        usuario: {
          id: usuario.id,
          nome: usuario.nome,
          email: usuario.email,
        },
      }, 201);
    } catch (error) {
      console.error('[DB01 cadastro]', error);
      return json({ ok: false, message: 'Não foi possível criar a conta.' }, 500);
    }
  },
};
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

Write-TextFile $Arquivo1 $Conteudo1
Write-TextFile $Arquivo2 $Conteudo2
Write-TextFile $Arquivo3 $Conteudo3
Write-TextFile $Arquivo4 $Conteudo4

$envExamplePath = Get-FullPath '.env.example'
$envCurrent = ''
if (Test-Path -LiteralPath $envExamplePath) {
    $envCurrent = [System.IO.File]::ReadAllText($envExamplePath)
}

if ($envCurrent -notmatch '(?m)^DATABASE_URL=') {
    $separator = ''
    if ($envCurrent.Trim().Length -gt 0) { $separator = "`r`n`r`n" }
    $envUpdated = $envCurrent.TrimEnd() + $separator + "# DB01 — banco`r`nDATABASE_URL=mysql://USUARIO:SENHA@HOST:3306/catalogo_login_lg01`r`n"
    Write-TextFile '.env.example' $envUpdated
}

$config = "// Gerado localmente pelo Catálogo S.`r`nwindow.CATALOGO_S_CONFIG={auth:{afterLogin:'index.html',loginEndpoint:'/api/auth/login',cadastroEndpoint:'/api/auth/cadastro'}};`r`n"
Write-TextFile 'assets/js/catalogo-s.config.js' $config

$packagePath = Get-FullPath 'package.json'
if (-not (Test-Path -LiteralPath $packagePath)) {
    $package = "{`r`n  `"private`": true,`r`n  `"type`": `"module`"`r`n}`r`n"
    Write-TextFile 'package.json' $package -SemBackup
} else {
    try {
        $packageObject = [System.IO.File]::ReadAllText($packagePath) | ConvertFrom-Json
        if ($null -eq $packageObject.type) {
            $packageObject | Add-Member -NotePropertyName type -NotePropertyValue 'module' -Force
            $packageJson = ($packageObject | ConvertTo-Json -Depth 30) + "`r`n"
            Write-TextFile 'package.json' $packageJson
        } elseif ($packageObject.type -ne 'module') {
            Write-Warning 'DB01 usa módulos ESM. O package.json atual possui type diferente de module; revise antes de publicar.'
        }
    } catch {
        Write-Warning 'Não foi possível analisar package.json. Os arquivos do DB01 foram instalados, mas revise o tipo de módulo manualmente.'
    }
}

if ($env:CATALOGO_S_SKIP_DEPS -eq '1') {
    Write-Host '[Catálogo S] instalação de dependências ignorada por CATALOGO_S_SKIP_DEPS=1.'
} elseif (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host '[Catálogo S] instalando mysql2 e bcryptjs pelo npm...'
    & npm install mysql2 bcryptjs --save
    if ($LASTEXITCODE -ne 0) {
        throw 'Falha ao instalar mysql2 e bcryptjs.'
    }
} else {
    Write-Warning 'npm não encontrado. Instale manualmente os pacotes mysql2 e bcryptjs antes de executar o backend.'
}

Write-Host ""
Write-Host '[Catálogo S] DB01 — Banco do LG01 instalado.'
Write-Host '[Catálogo S] Nenhum arquivo foi baixado do GitHub.'
