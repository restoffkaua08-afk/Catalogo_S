$ModeloId='NS01'
$ModeloNome='Barra Superior Institucional Centralizada'
$Parte='superior'
$Payload='H4sIACSsmWoC/+VWzXLqNhTe5ylcsgDuYAfIH7GBaaaTO+1Mb6czeQLZOjZqZEmVBIHL8DRddNVVHyEv1iPZEBtym3TdYQBbOr/f+c6RppStAkZnnYxYwmUhQ2GGo05A8TU8rJmwlBT4rPPLI27Oz6bGbjjMzxa25INU0s22JLpgIh7uzluGtrkUNsxJyfgmvteM8MGPwFdgWUYGhggTGtAsTzLJpY7PR7fuc2Qj+LRN5To07CsTRZxKTUGHuHIsRraVFSYWaNMmFtY2pJBJTSyTIhZSwO7sSClKid4qaZgXydkaaPI1ZILCOr67Gw4TK1U8TDjkFv80KxbufwH+4Xas1gllRnGyiQvNaOJ+QgslrlgIMZ5lKUw8ynVAllYG+JAQzgoRMhQycQbCgk4UodTlNgwyTkrVGw/VenC1eh5c36h1P0lJ9lRouRQ01kVKeuPr68H+G93doMAeE2tlGY/UOjCSMxqcw8R9vAGqpQpzxtFfnPKl7o0w+P4beGgiaFW25yrLCaLg37ECEI8wJITDop3QKJK5uMNoOIZyF3Emnsx2D0jOYf1WtgVRcSPPS8zzcuLybDi5RCfNGG6Gw9o8lnkP1xhDCYZH2Y8P2VvMBCPU6PWgGy/kCvS2pRK2yXeCiC/69relsSzfIF95HoOgyUfSHGGCuyizrzG7lWB0henVMWhC2dLEE7fyWuc6mH1f5Hn+HSuV1JYI28RpfITTrcOplCnjcKiD433yzKhdxFdOviavf66CQEY3fDdwS7KlNhiAkszltDcd4LY42E+5zJ5qB66iewej6PrtpOpZgbu+K04Rr7yE6AR4O41vderk7s53qu/Io2ZtQT/2+B+jjfi+10S7VlSRVPCKgOv69n6DpY7LJyxtmgdoVvTqLea3TcecGBtmC8Zpm8k4fs++L4Ey0ivJOqxKcjvBlPvbt+bev0+rumkGnr/NKpwwzDNgVzeKN1rZise7ep40F0fVlNTyOR7tDgErDTloE2qgywwoHji+ztXrSfiftp6l7DDYX9sDTU4v6vNpugCC8Lixasysgzl3AoKnUMhJ6o8zsoKCvPz58ocMlGYiY4rwznxKDhou+k6wwOBmHc+1yJ15x+ejgyt0aM2/EJ2R6QWZTwVZ7a14HL3Zjxv6Sbz8lTHpTe31lJYUBcw7qr/WYi1dI1MN7yg+OpmWVoZMJFa+o/dDJeU1LzDv+dTdKurkPSuamCKdOv/J/GeCIwdFpckqH+kS2S729ioydgK7UYAV83vtMt+nmumgBLGs12GNrUQBrz054QYwOjfRMPjqr/VyUVnEB0wKfytKIbcaBW72Z9v1F3QalC9/r4D/Twiw10QRJt7RexDYxvqVN3ixzDRTdt7r9WdzvM8JYwM9ozJbYvVs9PsS9OYROGRW6l63PRS6/UE608cy9azCTfXNzapwXbxIRTi0H1bo6mdmLAhAmYyz7Kk7aAQkZyryhXdCkZVFwaHXdSeCN2HA3lurGfIGl1t86w4ecUMUPdnv7/rJqbMn2FD5LLoDQG8s70GEK7PZrPtgMqIwi23TtYYSrzMfdd31XO/2dzv03esnSPAK7LOK2v8AoudMeAsMAAA='
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
