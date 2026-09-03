$ModeloId='NS01'
$ModeloNome='Barra Superior Institucional Centralizada'
$Parte='superior'
$Payload='H4sIAMmpmWoC/+VW3Y7iNhS+n6dIGVXAimQSyi6QAOpotdpW6lZVR30AJz4Bdxw7tQ0Di7jos/SiV73qI8yL9dhJ2AAznel1hQjEP+fn+75z7BllG4/ReScjhnC5lL7QYdTxKL76xzHtF5ICn3d+vMPJxdVMmx2HxdXKFHyQSrrbF0QtmYjDw/WJob3vM3EfX0dv7Sfx/ZKUoGK1TElvOJoOhqMxfqNBMB31k1wK4+ekYHwX3ypG+OA74BswLCMDTYT2NSiWJ5nkUsUbonrOeP9wderTe7NP5dbX7DMTyziVioLyceQsNI/sK0tMrNCuSQxsjU8hk4oYJkUspIAL20FK1L6UmrklOdsCTT5jGBS28XQahgmH3MRhothyZX+NLPG5Avc6npTbhDJdcrKLl4rRxD58AwWOGPAxnnUhdBzlyiNrIz38kxDOlsJnuEjHGQgDKikJpTa30Ms4KcrecFhuB6PNw+DdqNz2k5Rk90sl14LWKDnQcbyBwhhZxFG59bTkjHo1O9HE7aRKln7OODqKU75WvWjijFpIV4TKB3QboUPvm3f4uI7e2U+YPoGUIoLuLanxOMQ9Y1z+ESTqBOl0THIw6MXXJclsOkE4guIQcCRV7xuYcg7bpzBYkjKusw8x+2EwwfxHQxuq0xHSD7GNs3p9qBlwDD3h9SJ6FwVq5Mi1AuSIbeCI/nCKCZ0L/rgxJjl6QYlhtIhAp5McLZEUcV8bONVKFIZfJzU3ltBGNMhTm9GmlAyi20Rm13nBcKifDWYlN0hnFVItzcuU3cT+17U2LN9hsfE8BkGT1zBhgT4EmUG8anQiZMWL3trgnewu9dboURHK1hqrZ9qQVXEXnXE3CcNDUMiUcTiqw9Zo4yBsw+TgKYnCEJMHRs0qHrUwdf+ztdJY/qVkNo3GtIe7xNF+ymV2XxuwOnuBlLoLYtaufi8hrnxgQQrgp0k811Mm06lrIq53nDWXoxJHZ+Hk03ycRy8X/OEkoECW8CX1qj8ht2NLbXud12LZNoLRkeTnXQ3Py/Bw9W0BlJFeQbZ+BfB4ggj390913H/vk3XPGDgBtlG90Ivj81Ar3RmtbMXDQ92v2oNR1Z8V9rzocAy4VJCD0r4Cus6A4tFY9wf7ehH+m32rUm1MX7GilMoQYdDk7KY+SWcrIAigbehazzuYc8cjeAb6nKTu4CUbWJLHPx//kF6pmMhYSXhnMSPHHTb6jrfC4OYdp53Ans7nJ7mFy7doLe5+ub35dPvz+9vZDVnMBNk0lhyWzvTrjX0vHv/KmHSmmn2lkhQX6Be2/lQvO9mrZargpQTsmpNdttkSI1/Y975a5XbeYN6Lmb0D1ck7ZbRxRUk1qKIdJl4w/vi7AuJRiduZbY/OS7rGqhCNxUqSHc/sSkDe3Nwp2bepYsorQKzrcdhi4VHAa1pOuAaMz3YpDL/6OXm5qSziH0wLn5WwUGEtitvVfOr6Ezr1ise/N8D/JxIg/4HdDwKLWX1RDl6EM8VKs+j1+vOFPey18dScymyN7JngtzWo3R1wyIxUve5pa+j2B+lcna+pOxZOls9OVsR18VIWYB/+sEFXPzCN9wzANSi87L47aAUk52XgiLeLAiOXSw69rm32zoQGc2uMYqgbHD7RW3dwhxNi2ZP9/qGfXDq7hx3eCEV3AOiN5T0IcGQ+n3c/6Awvnd3+vu1aQYH3kNe67jqtd/uHA/ru9RMUeAX2VSXtfwCem0l2uwwAAA=='
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
