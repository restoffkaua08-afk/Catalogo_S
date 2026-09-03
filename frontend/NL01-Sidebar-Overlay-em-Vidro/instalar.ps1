$ModeloId='NL01'
$ModeloNome='Sidebar Overlay em Vidro'
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
