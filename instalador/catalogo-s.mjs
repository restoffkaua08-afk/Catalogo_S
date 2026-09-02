#!/usr/bin/env node

import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const CLI_VERSION = '0.1.0';
const __filename = fileURLToPath(import.meta.url);
const SOURCE_ROOT = path.resolve(path.dirname(__filename), '..');
const PROJECT_ROOT = process.cwd();
const STATE_DIR = path.join(PROJECT_ROOT, '.catalogo-s');
const STATE_FILE = path.join(STATE_DIR, 'projeto.json');
const BACKUP_DIR = path.join(STATE_DIR, 'backups');
const REGISTRY_FILE = path.join(SOURCE_ROOT, 'instalador', 'modelos.json');

const args = process.argv.slice(2);
const command = (args[0] || 'help').toLowerCase();
const value = args[1];
const flags = new Set(args.filter((arg) => arg.startsWith('--')));

function info(message) {
  console.log(`[Catálogo S] ${message}`);
}

function fail(message, code = 1) {
  console.error(`[Catálogo S] ERRO: ${message}`);
  process.exitCode = code;
}

async function exists(file) {
  try {
    await fs.access(file);
    return true;
  } catch {
    return false;
  }
}

async function readJson(file) {
  return JSON.parse(await fs.readFile(file, 'utf8'));
}

async function writeJson(file, data) {
  await fs.mkdir(path.dirname(file), { recursive: true });
  await fs.writeFile(file, `${JSON.stringify(data, null, 2)}\n`, 'utf8');
}

async function registry() {
  return readJson(REGISTRY_FILE);
}

async function project() {
  await fs.mkdir(BACKUP_DIR, { recursive: true });
  if (await exists(STATE_FILE)) return readJson(STATE_FILE);

  const now = new Date().toISOString();
  const data = {
    schema: 1,
    cli: CLI_VERSION,
    criadoEm: now,
    atualizadoEm: now,
    modelos: {},
    paginas: {},
  };
  await writeJson(STATE_FILE, data);
  return data;
}

async function saveProject(data) {
  data.cli = CLI_VERSION;
  data.atualizadoEm = new Date().toISOString();
  await writeJson(STATE_FILE, data);
}

function backupName(relative) {
  const stamp = new Date().toISOString().replace(/[:.]/g, '-');
  return `${stamp}__${relative.replace(/[\\/]/g, '__')}.bak`;
}

async function backup(relative) {
  const target = path.join(PROJECT_ROOT, relative);
  if (!(await exists(target))) return null;

  await fs.mkdir(BACKUP_DIR, { recursive: true });
  const destination = path.join(BACKUP_DIR, backupName(relative));
  await fs.copyFile(target, destination);
  return destination;
}

async function writeManaged(relative, content) {
  const target = path.join(PROJECT_ROOT, relative);
  await backup(relative);
  await fs.mkdir(path.dirname(target), { recursive: true });
  await fs.writeFile(target, content, 'utf8');
  info(`gravado: ${relative}`);
}

async function copyManaged(sourceRelative, targetRelative) {
  const source = path.join(SOURCE_ROOT, sourceRelative);
  const content = await fs.readFile(source, 'utf8');
  await writeManaged(targetRelative, content);
}

function transformLogin(template, modelId) {
  let html = template;

  html = html.replace(
    '<html lang="pt-BR">',
    `<html lang="pt-BR" data-catalogo-s-page="login" data-catalogo-s-model="${modelId}">`
  );

  if (!html.includes('assets/js/catalogo-s.config.js')) {
    html = html.replace(
      '<script>\n// ===== EDITE AQUI: TELA APÓS O LOGIN =====',
      '<script src="assets/js/catalogo-s.config.js"></script>\n<script>\n// ===== TELA APÓS O LOGIN ====='
    );
  }

  html = html.replace(
    /\/\/ ===== EDITE AQUI: ENDPOINTS DO SEU BACKEND =====\nconst ENDPOINT_LOGIN='[^']*';\nconst ENDPOINT_CADASTRO='[^']*';/,
    `// ===== INTEGRAÇÃO AUTOMÁTICA CATÁLOGO S =====\nconst ENDPOINT_LOGIN=window.CATALOGO_S_CONFIG?.auth?.loginEndpoint||'';\nconst ENDPOINT_CADASTRO=window.CATALOGO_S_CONFIG?.auth?.cadastroEndpoint||'';`
  );

  return html;
}

function runtimeConfig(data) {
  const login = data.modelos.LG01;
  const db = data.modelos.DB01;
  const conectado = Boolean(login && db);

  return `// Gerado automaticamente pelo Catálogo S.\n// Não coloque senhas, tokens ou credenciais neste arquivo público.\nwindow.CATALOGO_S_CONFIG={\n  auth:{\n    loginEndpoint:${JSON.stringify(conectado ? '/api/auth/login' : '')},\n    cadastroEndpoint:${JSON.stringify(conectado ? '/api/auth/cadastro' : '')}\n  }\n};\n`;
}

async function reconcile(data) {
  if (data.modelos.LG01) {
    await writeManaged('assets/js/catalogo-s.config.js', runtimeConfig(data));
  }

  if (data.modelos.LG01 && data.modelos.DB01) {
    data.modelos.DB01.integradoCom = 'LG01';
    data.modelos.DB01.estadoIntegracao = 'conectado';
  } else if (data.modelos.DB01) {
    data.modelos.DB01.integradoCom = null;
    data.modelos.DB01.estadoIntegracao = 'aguardando-LG01';
  }

  await saveProject(data);
}

async function mergeEnvExample(lines) {
  const relative = '.env.example';
  const target = path.join(PROJECT_ROOT, relative);
  let current = '';
  if (await exists(target)) current = await fs.readFile(target, 'utf8');

  const missing = lines.filter((line) => {
    const key = line.split('=')[0];
    return !new RegExp(`^${key}=`, 'm').test(current);
  });

  if (!missing.length) return;
  const next = `${current.trimEnd()}${current.trim() ? '\n\n' : ''}# Catálogo S — DB01\n${missing.join('\n')}\n`;
  await writeManaged(relative, next);
}

async function ensureDependencies() {
  if (flags.has('--no-deps')) {
    info('dependências não instaladas por --no-deps');
    return;
  }

  const packageFile = path.join(PROJECT_ROOT, 'package.json');
  if (!(await exists(packageFile))) {
    await writeJson(packageFile, {
      private: true,
      type: 'module',
    });
    info('criado: package.json');
  } else {
    const pkg = await readJson(packageFile);
    if (!pkg.type) {
      await backup('package.json');
      pkg.type = 'module';
      await writeJson(packageFile, pkg);
      info('package.json atualizado para módulos ESM');
    } else if (pkg.type !== 'module') {
      throw new Error('DB01 usa módulos ESM e o projeto declara outro tipo. Migração CommonJS ainda não está habilitada.');
    }
  }

  let executable = 'npm';
  let installArgs = ['install', 'mysql2', 'bcryptjs', '--save'];

  if (await exists(path.join(PROJECT_ROOT, 'pnpm-lock.yaml'))) {
    executable = 'pnpm';
    installArgs = ['add', 'mysql2', 'bcryptjs'];
  } else if (await exists(path.join(PROJECT_ROOT, 'yarn.lock'))) {
    executable = 'yarn';
    installArgs = ['add', 'mysql2', 'bcryptjs'];
  }

  info(`instalando dependências com ${executable}...`);
  const result = spawnSync(executable, installArgs, {
    cwd: PROJECT_ROOT,
    stdio: 'inherit',
    shell: process.platform === 'win32',
  });

  if (result.error || result.status !== 0) {
    throw new Error(`não foi possível instalar mysql2 e bcryptjs automaticamente. Execute: ${executable} ${installArgs.join(' ')}`);
  }
}

async function addLogin(model, data) {
  const template = await fs.readFile(path.join(SOURCE_ROOT, model.template), 'utf8');
  const html = transformLogin(template, model.id);
  await writeManaged(model.target, html);

  data.modelos[model.id] = {
    id: model.id,
    nome: model.nome,
    tipo: model.tipo,
    papel: model.papel,
    arquivo: model.target,
    instaladoEm: new Date().toISOString(),
  };
  data.paginas.login = {
    arquivo: model.target,
    modelo: model.id,
    rotulo: 'Login',
  };

  await reconcile(data);
}

async function addDb(model, data) {
  await copyManaged(model.schemaTemplate, 'database/schema.sql');
  await copyManaged('instalador/templates/DB01/lib/catalogo-s-db.js', 'lib/catalogo-s-db.js');
  await copyManaged('instalador/templates/DB01/api/auth/login.js', 'api/auth/login.js');
  await copyManaged('instalador/templates/DB01/api/auth/cadastro.js', 'api/auth/cadastro.js');
  await mergeEnvExample([
    'DATABASE_URL=mysql://USUARIO:SENHA@HOST:3306/catalogo_login_lg01',
  ]);
  await ensureDependencies();

  data.modelos[model.id] = {
    id: model.id,
    nome: model.nome,
    tipo: model.tipo,
    papel: model.papel,
    pareadoCom: model.pareadoCom,
    instaladoEm: new Date().toISOString(),
  };

  await reconcile(data);
}

async function add(modelId) {
  if (!modelId) throw new Error('informe o ID do modelo. Exemplo: catalogo-s add LG01');
  const reg = await registry();
  const model = reg.modelos[String(modelId).toUpperCase()];
  if (!model) throw new Error(`modelo ${modelId} ainda não possui contrato no instalador.`);

  const data = await project();
  info(`instalando ${model.id} — ${model.nome}`);

  if (model.id.startsWith('LG')) await addLogin(model, data);
  else if (model.id.startsWith('DB')) await addDb(model, data);
  else throw new Error(`tipo de instalação ainda não implementado para ${model.id}.`);

  info(`${model.id} instalado.`);
}

async function list() {
  const data = await project();
  const installed = Object.values(data.modelos);
  if (!installed.length) {
    info('nenhum modelo instalado neste projeto.');
    return;
  }

  console.log('');
  for (const model of installed) {
    console.log(`- ${model.id} · ${model.nome || model.papel}`);
  }
  console.log('');
}

async function doctor() {
  const data = await project();
  const issues = [];

  if (data.modelos.LG01) {
    if (!(await exists(path.join(PROJECT_ROOT, 'login.html')))) issues.push('LG01 registrado, mas login.html não existe.');
    if (!(await exists(path.join(PROJECT_ROOT, 'assets/js/catalogo-s.config.js')))) issues.push('LG01 sem assets/js/catalogo-s.config.js.');
  }

  if (data.modelos.DB01) {
    for (const relative of ['database/schema.sql', 'lib/catalogo-s-db.js', 'api/auth/login.js', 'api/auth/cadastro.js']) {
      if (!(await exists(path.join(PROJECT_ROOT, relative)))) issues.push(`DB01 registrado, mas ${relative} não existe.`);
    }

    if (!data.modelos.LG01) issues.push('DB01 instalado sem LG01. A integração ficará pendente até uma tela LG01 ser instalada.');
  }

  if (!issues.length) {
    info('doctor: nenhuma inconsistência encontrada.');
    return;
  }

  info(`doctor: ${issues.length} ponto(s) encontrado(s):`);
  for (const issue of issues) console.log(`  - ${issue}`);
  process.exitCode = 2;
}

function help() {
  console.log(`\nCatálogo S CLI v${CLI_VERSION}\n\nComandos:\n  catalogo-s init\n  catalogo-s add <ID>\n  catalogo-s list\n  catalogo-s reconcile\n  catalogo-s doctor\n\nFlags:\n  --no-deps   não instala dependências do backend automaticamente\n`);
}

try {
  if (command === 'init') {
    await project();
    info('projeto inicializado.');
  } else if (command === 'add') {
    await add(value);
  } else if (command === 'list') {
    await list();
  } else if (command === 'doctor') {
    await doctor();
  } else if (command === 'reconcile') {
    const data = await project();
    await reconcile(data);
    info('reconciliação concluída.');
  } else {
    help();
  }
} catch (error) {
  fail(error?.message || String(error));
}
