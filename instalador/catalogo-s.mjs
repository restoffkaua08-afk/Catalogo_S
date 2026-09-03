#!/usr/bin/env node

import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const CLI_VERSION='1.0.0';
const __filename=fileURLToPath(import.meta.url);
const SOURCE_ROOT=path.resolve(path.dirname(__filename),'..');
const PROJECT_ROOT=process.cwd();
const STATE_DIR=path.join(PROJECT_ROOT,'.catalogo-s');
const STATE_FILE=path.join(STATE_DIR,'projeto.json');
const BACKUP_DIR=path.join(STATE_DIR,'backups');
const REGISTRY_FILE=path.join(SOURCE_ROOT,'instalador','modelos.json');
const args=process.argv.slice(2);
const command=(args[0]||'help').toLowerCase();
const value=args[1];
const flags=new Set(args.filter(a=>a.startsWith('--')));

const ROLE_LABELS={inicio:'Início',produtos:'Produtos',sobre:'Sobre',contato:'Contato',login:'Login'};
const SLOT_NAMES=['MENU','COMPONENTES','RODAPE'];

function info(message){console.log(`[Catálogo S] ${message}`)}
function fail(message,code=1){console.error(`[Catálogo S] ERRO: ${message}`);process.exitCode=code}
async function exists(file){try{await fs.access(file);return true}catch{return false}}
async function readJson(file){return JSON.parse(await fs.readFile(file,'utf8'))}
async function writeJson(file,data){await fs.mkdir(path.dirname(file),{recursive:true});await fs.writeFile(file,`${JSON.stringify(data,null,2)}\n`,'utf8')}
async function registry(){return readJson(REGISTRY_FILE)}

async function project(){
  await fs.mkdir(BACKUP_DIR,{recursive:true});
  if(await exists(STATE_FILE)){
    const data=await readJson(STATE_FILE);
    data.schema=2;
    data.modelos ||= {};
    data.paginas ||= {};
    data.instancias ||= [];
    return data;
  }
  const now=new Date().toISOString();
  const data={schema:2,cli:CLI_VERSION,criadoEm:now,atualizadoEm:now,modelos:{},paginas:{},instancias:[]};
  await writeJson(STATE_FILE,data);
  return data;
}

async function saveProject(data){data.schema=2;data.cli=CLI_VERSION;data.atualizadoEm=new Date().toISOString();await writeJson(STATE_FILE,data)}
function backupName(relative){const stamp=new Date().toISOString().replace(/[:.]/g,'-');return `${stamp}__${relative.replace(/[\\/]/g,'__')}.bak`}
async function backup(relative){const target=path.join(PROJECT_ROOT,relative);if(!(await exists(target)))return null;await fs.mkdir(BACKUP_DIR,{recursive:true});const dest=path.join(BACKUP_DIR,backupName(relative));await fs.copyFile(target,dest);return dest}
async function writeManaged(relative,content){
  const target=path.join(PROJECT_ROOT,relative);
  if(await exists(target)){
    const current=await fs.readFile(target,'utf8');
    if(current===content)return false;
    await backup(relative);
  }
  await fs.mkdir(path.dirname(target),{recursive:true});
  await fs.writeFile(target,content,'utf8');
  info(`gravado: ${relative}`);
  return true;
}
async function copyManaged(sourceRelative,targetRelative){const content=await fs.readFile(path.join(SOURCE_ROOT,sourceRelative),'utf8');return writeManaged(targetRelative,content)}

function ensureHtmlIdentity(html,role,modelId){
  let out=html;
  if(!/<html\b/i.test(out)){
    out=`<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>${ROLE_LABELS[role]||'Página'}</title></head><body>${out}</body></html>`;
  }
  out=out.replace(/<html\b([^>]*)>/i,(m,attrs)=>{
    const clean=attrs.replace(/\sdata-catalogo-s-page="[^"]*"/gi,'').replace(/\sdata-catalogo-s-model="[^"]*"/gi,'');
    return `<html${clean} data-catalogo-s-page="${role}" data-catalogo-s-model="${modelId}">`;
  });
  if(!/<body\b/i.test(out))out=out.replace(/<\/head>/i,'</head><body>')+'</body>';
  return ensureSlots(out);
}

function slotBlock(name){return `<!-- CATALOGO-S:SLOT:${name}:START -->\n<!-- CATALOGO-S:SLOT:${name}:END -->`}
function ensureSlots(html){
  let out=html;
  if(!out.includes('CATALOGO-S:SLOT:MENU:START'))out=out.replace(/<body([^>]*)>/i,`<body$1>\n${slotBlock('MENU')}`);
  if(!out.includes('CATALOGO-S:SLOT:COMPONENTES:START'))out=out.replace(/<\/body>/i,`${slotBlock('COMPONENTES')}\n</body>`);
  if(!out.includes('CATALOGO-S:SLOT:RODAPE:START'))out=out.replace(/<\/body>/i,`${slotBlock('RODAPE')}\n</body>`);
  return out;
}
function setSlot(html,name,content){
  const re=new RegExp(`<!-- CATALOGO-S:SLOT:${name}:START -->[\\s\\S]*?<!-- CATALOGO-S:SLOT:${name}:END -->`,'m');
  return html.replace(re,`<!-- CATALOGO-S:SLOT:${name}:START -->\n${content||''}\n<!-- CATALOGO-S:SLOT:${name}:END -->`);
}
function shellPage(){return ensureHtmlIdentity('<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Projeto</title><style>html,body{margin:0;background:#08090c;color:#fff;font-family:Arial,sans-serif}</style></head><body></body></html>','inicio','SHELL')}

function transformLogin(html,model){
  let out=ensureHtmlIdentity(html,'login',model.id);
  if(!out.includes('assets/js/catalogo-s.config.js'))out=out.replace(/<\/head>/i,'<script src="assets/js/catalogo-s.config.js"></script>\n</head>');
  out=out.replace(/const DESTINO_APOS_LOGIN\s*=\s*['"][^'"]*['"]\s*;/,`const DESTINO_APOS_LOGIN=window.CATALOGO_S_CONFIG?.auth?.afterLogin||'index.html';`);
  out=out.replace(/const ENDPOINT_LOGIN\s*=\s*['"][^'"]*['"]\s*;/,`const ENDPOINT_LOGIN=window.CATALOGO_S_CONFIG?.auth?.loginEndpoint||'';`);
  out=out.replace(/const ENDPOINT_CADASTRO\s*=\s*['"][^'"]*['"]\s*;/,`const ENDPOINT_CADASTRO=window.CATALOGO_S_CONFIG?.auth?.cadastroEndpoint||'';`);
  return out;
}

function activeByRole(data,role){return Object.values(data.modelos).find(m=>m.papel===role && m.ativo!==false && !m.instancias)}
function runtimeConfig(data){
  const login=activeByRole(data,'login');
  const db=activeByRole(data,'auth-db');
  const connected=Boolean(login&&db&&(!db.pareadoCom||db.pareadoCom===login.id));
  return `// Gerado automaticamente pelo Catálogo S.\n// Não coloque senhas, tokens ou credenciais neste arquivo público.\nwindow.CATALOGO_S_CONFIG={auth:{afterLogin:'index.html',loginEndpoint:${JSON.stringify(connected?'/api/auth/login':'')},cadastroEndpoint:${JSON.stringify(connected?'/api/auth/cadastro':'')}}};\n`;
}

async function ensureHostPage(data){
  if(data.paginas.inicio?.arquivo && await exists(path.join(PROJECT_ROOT,data.paginas.inicio.arquivo)))return data.paginas.inicio.arquivo;
  const relative='index.html';
  if(await exists(path.join(PROJECT_ROOT,relative))){
    const current=await fs.readFile(path.join(PROJECT_ROOT,relative),'utf8');
    await writeManaged(relative,ensureHtmlIdentity(current,'inicio','EXISTENTE'));
  }else await writeManaged(relative,shellPage());
  data.paginas.inicio={arquivo:relative,modelo:null,rotulo:'Início',gerado:true};
  return relative;
}

async function reconcilePages(data){
  for(const [role,page] of Object.entries(data.paginas)){
    if(!page?.arquivo)continue;
    const full=path.join(PROJECT_ROOT,page.arquivo);
    if(!(await exists(full)))continue;
    let html=await fs.readFile(full,'utf8');
    html=ensureHtmlIdentity(html,role,page.modelo||'EXISTENTE');
    if(role==='inicio'){
      const items=data.instancias.filter(i=>i.destino==='inicio').sort((a,b)=>a.ordem-b.ordem);
      const body=items.map(i=>`<section id="catalogo-s-${i.chave}" data-catalogo-s-instance="${i.chave}" data-catalogo-s-model="${i.id}" style="width:100%;min-height:${i.altura};overflow:hidden"><iframe src="${i.arquivo}" title="${i.id}" loading="lazy" style="display:block;width:100%;height:${i.altura};border:0"></iframe></section>`).join('\n');
      html=setSlot(html,'COMPONENTES',body);
    }
    await writeManaged(page.arquivo,html);
  }
}

async function reconcile(data){
  const login=activeByRole(data,'login');
  const db=activeByRole(data,'auth-db');
  if(login)await writeManaged('assets/js/catalogo-s.config.js',runtimeConfig(data));
  if(db){
    if(login&&(!db.pareadoCom||db.pareadoCom===login.id)){db.integradoCom=login.id;db.estadoIntegracao='conectado'}
    else{db.integradoCom=null;db.estadoIntegracao=`aguardando-${db.pareadoCom||'login'}`}
  }
  await reconcilePages(data);
  await saveProject(data);
}

function removeSingletonSameRole(data,model){
  for(const [id,item] of Object.entries(data.modelos)){
    if(id!==model.id && item.papel===model.papel && !item.instancias){item.ativo=false}
  }
}

async function addPage(model,data){
  const template=await fs.readFile(path.join(SOURCE_ROOT,model.template),'utf8');
  let html=model.papel==='login'?transformLogin(template,model):ensureHtmlIdentity(template,model.papel,model.id);
  removeSingletonSameRole(data,model);
  await writeManaged(model.target,html);
  data.modelos[model.id]={id:model.id,nome:model.nome,tipo:model.tipo,papel:model.papel,arquivo:model.target,ativo:true,instaladoEm:new Date().toISOString()};
  data.paginas[model.papel]={arquivo:model.target,modelo:model.id,rotulo:model.rotulo||ROLE_LABELS[model.papel]||model.nome};
  await reconcile(data);
}

async function addComponent(model,data){
  await ensureHostPage(data);
  const template=await fs.readFile(path.join(SOURCE_ROOT,model.template),'utf8');
  const same=data.instancias.filter(i=>i.id===model.id).length+1;
  const key=`${model.id.toLowerCase()}-${same}`;
  const target=`components/catalogo-s/${key}.html`;
  await writeManaged(target,template);
  const ordem=(data.instancias.reduce((m,i)=>Math.max(m,i.ordem||0),0))+1;
  const instance={id:model.id,nome:model.nome,chave:key,arquivo:target,destino:model.destino||'inicio',altura:model.altura||'100vh',ordem,instaladoEm:new Date().toISOString()};
  data.instancias.push(instance);
  const current=data.modelos[model.id]||{id:model.id,nome:model.nome,tipo:model.tipo,papel:model.papel,instancias:[]};
  current.instancias ||= [];
  current.instancias.push(key);
  current.ativo=true;
  data.modelos[model.id]=current;
  await reconcile(data);
}

async function mergeEnvExample(lines,label='Catálogo S'){
  const relative='.env.example';const target=path.join(PROJECT_ROOT,relative);let current='';if(await exists(target))current=await fs.readFile(target,'utf8');
  const missing=lines.filter(line=>{const key=line.split('=')[0];return !new RegExp(`^${key}=`,`m`).test(current)});
  if(!missing.length)return;
  await writeManaged(relative,`${current.trimEnd()}${current.trim()?'\n\n':''}# ${label}\n${missing.join('\n')}\n`);
}
async function ensureDependencies(){
  if(flags.has('--no-deps')){info('dependências não instaladas por --no-deps');return}
  const packageFile=path.join(PROJECT_ROOT,'package.json');
  let pkg={private:true,type:'module'};
  if(await exists(packageFile)){pkg=await readJson(packageFile);if(pkg.type&&pkg.type!=='module')throw new Error('o backend DB01 exige módulos ESM; ajuste package.json para type="module".');pkg.type='module'}
  await writeJson(packageFile,pkg);
  let executable='npm',installArgs=['install','mysql2','bcryptjs','--save'];
  if(await exists(path.join(PROJECT_ROOT,'pnpm-lock.yaml'))){executable='pnpm';installArgs=['add','mysql2','bcryptjs']}
  else if(await exists(path.join(PROJECT_ROOT,'yarn.lock'))){executable='yarn';installArgs=['add','mysql2','bcryptjs']}
  info(`instalando dependências com ${executable}...`);
  const result=spawnSync(executable,installArgs,{cwd:PROJECT_ROOT,stdio:'inherit',shell:process.platform==='win32'});
  if(result.error||result.status!==0)throw new Error(`falha ao instalar dependências. Execute manualmente: ${executable} ${installArgs.join(' ')}`);
}

async function addDb(model,data){
  await copyManaged(model.schemaTemplate,'database/schema.sql');
  for(const file of model.arquivos||[]){await copyManaged(file.origem,file.destino)}
  await mergeEnvExample(['DATABASE_URL=mysql://USUARIO:SENHA@HOST:3306/catalogo_login_lg01'],`${model.id} — banco`);
  await ensureDependencies();
  removeSingletonSameRole(data,model);
  data.modelos[model.id]={id:model.id,nome:model.nome,tipo:model.tipo,papel:model.papel,pareadoCom:model.pareadoCom,ativo:true,instaladoEm:new Date().toISOString()};
  await reconcile(data);
}

async function add(modelId){
  if(!modelId)throw new Error('informe o ID. Exemplo: catalogo-s add I01');
  const reg=await registry();
  const id=String(modelId).toUpperCase();
  const model=reg.modelos[id];
  if(!model)throw new Error(`modelo ${id} não encontrado no catálogo instalável.`);
  const data=await project();
  info(`instalando ${model.id} — ${model.nome}`);
  if(model.modo==='pagina')await addPage(model,data);
  else if(model.modo==='componente')await addComponent(model,data);
  else if(model.modo==='banco')await addDb(model,data);
  else throw new Error(`modo de instalação inválido para ${id}: ${model.modo}`);
  info(`${id} instalado e reconciliado.`);
}

async function list(){
  const data=await project();
  const installed=Object.values(data.modelos).filter(m=>m.ativo!==false);
  if(!installed.length){info('nenhum modelo instalado.');return}
  console.log('');
  for(const model of installed)console.log(`- ${model.id} · ${model.nome}${model.instancias?` · ${model.instancias.length} instância(s)`:''}`);
  console.log('');
}

async function doctor(){
  const data=await project();const issues=[];
  for(const [role,page] of Object.entries(data.paginas))if(page?.arquivo && !(await exists(path.join(PROJECT_ROOT,page.arquivo))))issues.push(`página ${role} registrada, mas ${page.arquivo} não existe.`);
  for(const i of data.instancias)if(!(await exists(path.join(PROJECT_ROOT,i.arquivo))))issues.push(`${i.chave} registrado, mas ${i.arquivo} não existe.`);
  const login=activeByRole(data,'login');if(login&&!(await exists(path.join(PROJECT_ROOT,'assets/js/catalogo-s.config.js'))))issues.push('login instalado sem assets/js/catalogo-s.config.js.');
  const db=activeByRole(data,'auth-db');
  if(db){for(const relative of ['database/schema.sql','lib/catalogo-s-db.js','api/auth/login.js','api/auth/cadastro.js'])if(!(await exists(path.join(PROJECT_ROOT,relative))))issues.push(`${db.id}: falta ${relative}.`);if(!login)issues.push(`${db.id} instalado sem ${db.pareadoCom||'tela de login'}; integração pendente.`)}
  if(!issues.length){info('doctor: nenhuma inconsistência encontrada.');return}
  info(`doctor: ${issues.length} ponto(s):`);for(const issue of issues)console.log(`  - ${issue}`);process.exitCode=2;
}

function help(){console.log(`\nCatálogo S CLI v${CLI_VERSION}\n\nComandos internos:\n  catalogo-s init\n  catalogo-s add <ID>\n  catalogo-s list\n  catalogo-s reconcile\n  catalogo-s doctor\n\nUso público:\n  copie o bloco PowerShell autocontido exibido na demonstração do modelo.\n\nFlags:\n  --no-deps   não instala dependências de backend\n`)}

try{
  if(command==='init'){await project();info('projeto inicializado.')}
  else if(command==='add')await add(value);
  else if(command==='list')await list();
  else if(command==='doctor')await doctor();
  else if(command==='reconcile'){const data=await project();await reconcile(data);info('reconciliação concluída.')}
  else help();
}catch(error){fail(error?.message||String(error))}
