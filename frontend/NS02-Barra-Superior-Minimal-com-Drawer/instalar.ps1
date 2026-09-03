$ModeloId='NS02'
$ModeloNome='Barra Superior Minimal com Drawer'
$Parte='superior'
$Payload='H4sIADCqmWoC/41WzW7jNhC+5ylU52CpkBTJSTaJZBtNFwu0QLsokFNR9ECJI5kNRaok5Z81/DQ99NSnyIt1SFmJ7U2QhRyI4nCG33zzcZgpZUuP0dmoJIZwWctI6GQy8ih+Rs9zOmokBT4bfX5A4/xsqs2Gw/xsYRoeFpJutg1RNRNZsjs/CrStpDBRRRrGN9m9YoSHPwFfgmElCTUROtKgWJWXkkuVnVfX9jmJ4X2/LeQ60uwLE3VWSEVBRThzuoxs+yhMLDCmyQ2sTUShlIoYJkUmpIDd2YlTXBC1baVmbknF1kDzLxETFNbZ3V2S5Ea2WZJzqAy+FKsX9r0AN/hw265zynTLySarOKxzwlktImag0VkJwoDK/+q0YdUmKpEJnMl0S0qICjArAJG3hFKbVuKVnDStn2LI8Gq5Cq8n7TrIC1I+1kp2gmaqLoif3oT9L767QuvAhTGyydJ27WnJGfXOJ8Q+zpsq2UYV4wglK3in/NQGfoUHRQTty4VMQ5ZeY27uc9Une5tYGgzGiWwKFnQUJxNodnEDotuuGDWL7AqjD/S4cY8ROduDVYSyTmc31vSSnMHdMapCgp61UKEsOqVx3ErmqByorhWjOY6Qx0OqeyDZQi5BbQ+Cn0+u7NObPRbu31kBlVSwHaIWXJaPeZ/GJHlJI42vj8H20PblHI1yB74XUDzRu5Pwzoqjpk+SEwO/+x9erUFFOLf7vCnI29tekDfovxfjXjZXKJtLlM2ljbxPomHCv0wwk7AkvPTTJFmuvMiboMSC4Fl5ty9FOlRQYZ+ToqXJCRHpjX1ydzwXhMoV6jhFBJ6F4Z0nSXKdSysWs0EFvMpE5ADvKxzBEjnV7qge0ZreIq8DPbFsQWyHuOlBXOd3Eot0Rr74Ypc4rvdAgz0WXnr5TMahUA9OBfJ8GOxtsZ390ABlxG8VVKB0pIB2JVBspC6j/jPYftXqDrK22XzHmlYqQ4TZ7c6mF/u+O10AQYy2Z2g9G2EPG3kEu2vESWHb9I9EKeLprsVGKNVoPiXPS+0xH3kLRDUbOVXFtomfNnxLWsSZeJz/SlRJphdkPi06bDNiCGRFPvLMpgUM6iyvXBq4JjKyrjkcwbsvFFOeIEuoydO/T/9Iz2pBEb7PAtYtogS8lZBpDYifzacX9q/fCQc9AcgERhkgDWU55uLzwTYU8NdIoZFlN+Oo+XYyfhZP/5VMOjoGv1ZJigv0O66/7Zcd+WpZKHjH8cGuOfKyrYcY+Y7fx36V87xAluytXSrWmrnvB7M5XpZIg6dmVJYdFsrEf3egNg/AoTRS+eNjZY6DsJip0zWu1aGpesU0VGOM91SMh+yTPY6/MI1dE9Becoa20EFhlf8Wij9ONUUVWYH6cxwECkynRN7nIWdV7GRgd4h7zflj2yjc/hrMvTGKoX5w+khk4/ABDaL2ZRDsgvxrpI+wwc4mxiH0UCHGmdlsNv6kS9LCONgebq1QX8tv3nrsBD4Odjvc2w9yPOF9jfCs439m8/8BDfYFV58JAAA='
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
