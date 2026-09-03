$ModeloId='NL03'
$ModeloNome='Sidebar Fixa Profissional'
$Parte='lateral'
$Payload='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'
$ms=New-Object IO.MemoryStream(,[Convert]::FromBase64String($Payload))
$gz=New-Object IO.Compression.GzipStream($ms,[IO.Compression.CompressionMode]::Decompress)
$sr=New-Object IO.StreamReader($gz,[Text.Encoding]::UTF8)
$ConteudoModelo=$sr.ReadToEnd();$sr.Dispose();$gz.Dispose();$ms.Dispose()
$ErrorActionPreference='Stop'
$Root=(Get-Location).Path
$Utf8=New-Object System.Text.UTF8Encoding($false)
function Full([string]$r){[IO.Path]::GetFullPath((Join-Path $Root $r))}
function Backup([string]$r){$p=Full $r;if(!(Test-Path -LiteralPath $p)){return};$bd=Full '.catalogo-s/backups';New-Item -ItemType Directory -Force -Path $bd|Out-Null;$safe=$r-replace'[\\/:*?"<>|]','__';Copy-Item -LiteralPath $p -Destination (Join-Path $bd ((Get-Date -Format 'yyyyMMdd-HHmmssfff')+'__'+$safe+'.bak')) -Force}
function Put([string]$r,[string]$c,[switch]$NoBackup){$p=Full $r;$d=Split-Path -Parent $p;if($d-and!(Test-Path -LiteralPath $d)){New-Item -ItemType Directory -Force -Path $d|Out-Null};if(Test-Path -LiteralPath $p){$old=[IO.File]::ReadAllText($p);if($old-eq$c){return};if(!$NoBackup){Backup $r}};[IO.File]::WriteAllText($p,$c,$Utf8)}
function Slots([string]$h){$menu="<!-- CATALOGO-S:SLOT:MENU:START -->`r`n<!-- CATALOGO-S:SLOT:MENU:END -->";$components="<!-- CATALOGO-S:SLOT:COMPONENTES:START -->`r`n<!-- CATALOGO-S:SLOT:COMPONENTES:END -->";$footer="<!-- CATALOGO-S:SLOT:RODAPE:START -->`r`n<!-- CATALOGO-S:SLOT:RODAPE:END -->";if($h-notmatch'CATALOGO-S:SLOT:MENU:START'){$h=$h-replace'(?i)<body([^>]*)>',('<body$1>'+"`r`n"+$menu)};if($h-notmatch'CATALOGO-S:SLOT:COMPONENTES:START'){$h=$h-replace'(?i)</body>',($components+"`r`n</body>")};if($h-notmatch'CATALOGO-S:SLOT:RODAPE:START'){$h=$h-replace'(?i)</body>',($footer+"`r`n</body>")};return $h}
function SetSlot([string]$h,[string]$n,[string]$c){$e=[Text.RegularExpressions.Regex]::Escape($n);$p='(?s)<!-- CATALOGO-S:SLOT:'+$e+':START -->.*?<!-- CATALOGO-S:SLOT:'+$e+':END -->';$r="<!-- CATALOGO-S:SLOT:$n`:START -->`r`n$c`r`n<!-- CATALOGO-S:SLOT:$n`:END -->";return [Text.RegularExpressions.Regex]::Replace($h,$p,$r)}
function EnsureHost{$p=Full 'index.html';if(!(Test-Path -LiteralPath $p)){$shell='<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Projeto</title><style>html,body{margin:0;min-height:100%}</style></head><body><main style="min-height:100vh"></main></body></html>';Put 'index.html' (Slots $shell) -NoBackup}else{$h=[IO.File]::ReadAllText($p);$s=Slots $h;if($s-ne$h){Put 'index.html' $s}}}
function RebuildMenu{EnsureHost;$h=[IO.File]::ReadAllText((Full 'index.html'));$h=Slots $h;$dir=Full 'components/catalogo-s/menu';$parts=@();foreach($f in @('superior.html','lateral.html')){$p=Join-Path $dir $f;if(Test-Path -LiteralPath $p){$parts+=[IO.File]::ReadAllText($p)}};$shared=@'
<style id="catalogo-s-menu-host">[data-catalogo-auto-link][hidden]{display:none!important}</style>
<script>
(()=>{const links=[...document.querySelectorAll('[data-catalogo-auto-link]')];
if(!/^https?:$/.test(location.protocol))return;
links.forEach(async a=>{try{const r=await fetch(a.getAttribute('href'),{method:'HEAD',cache:'no-store'});if(!r.ok)a.hidden=true}catch(_){}})})();
</script>
'@;$content=$shared+"`r`n"+($parts-join"`r`n");Put 'index.html' (SetSlot $h 'MENU' $content)}
$dest='components/catalogo-s/menu/'+$Parte+'.html'
Put $dest $ConteudoModelo
RebuildMenu
Write-Host "[Catálogo S] $ModeloId — $ModeloNome instalado como navegação $Parte."
Write-Host '[Catálogo S] NSxx/NLxx recompõem juntos somente o slot MENU.'
Write-Host '[Catálogo S] Nenhum arquivo foi baixado do GitHub.'
