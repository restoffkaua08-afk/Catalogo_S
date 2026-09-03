$ModeloId='NL02'
$ModeloNome='Sidebar Técnica Compacta'
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
