$ModeloId='NS02'
$ModeloNome='Barra Superior Minimal com Drawer'
$Parte='superior'
$Payload='H4sIAHimmWoC/41W227jNhB9z1eoCgpLheVIzs2RbKPBNmgDbLdFvSiwKPpAiSObjURqSfq2hr+mD33qV+THOqTkrC07ReI4oXg5c3jmcKghZQuH0ZGbEU0KMRUBV2HfdSg+Bi99KigFhWLkfpjg4PhsqPS6gPHZTJdFNxV0vSmJnDIeh9vzA6BNLrgOclKyYh3fS0aK7k9QLECzjHQV4SpQIFmeZKIQMj7Pb/Fz3cJwvtukYhUo9oXxaZwKSUEG2NOeRjY1CuMzxNSJhpUOKGRCEs0Ej7ngsD1rLeqlRG4qoZidkrMV0ORLwDiFVXx3F4aJFlUcDapVUkCu46wgZeVFN9Wqe7lYdq/61cpPJJvOXhmagR27uUIAylRVkHWcF7BKSMGmPGAaShVnwDXI5K+50ixfBxlKhj2xqkgGQQp6CcCTilBq9h86UVStnNDpY4CkViM2PUoUjDrnuf2JsmYokISyuaq3kJLsaSrFnNP4PLwLSZiRge2kUlRBzgqkEafFXHr9ENk7iug5igdedB1+6yc2CzNCxdKwQEDn+hr/nIdhOOiGjvkYIg2F8MZhXIE+IbkknNbOWNb6GKHtMyYZ4qhv5dbIJjAimG33ogGU254m08Zqgc1HZIRtzDPI7vp32T5OeAInNDhHlErg882SUT2LrwxkkzfbflVj0tb4sqVxI8Tgxd45On0uFbYrwWzSd6aYSkYTbGHG902xtcwc1m3+xynkQsJmtywtRPaU1MRtihvi0TGTZOcr1000ZqCxfK/fV9sWuh3GVhnbVoEW+OShsf1j4XJSFCbQq2doMKjP0J2R8n9OSr2HknHv8gbz1s1IkXlRGC6WTuBcmin+yxmozfzmtBxZPw1pFCHJ09a3dA683kfuzm3YeJ0kwphJr+MwOalUMDAITYYDWKDoylafY9138vVEBXyzw432cO26FhaZa/F1LRa+g9LytjpiTo7zVUcsqFqL8oScBycTF+0FViW2mqp7fntzSweD7dn3JVBGvEpCDlIFEug8A4oXiN12/ehvjkr8njRmy9+wshJSE66327PhRXPfDGdAkKyDDlJq5GLtdsdDvMHGQ/LSZ4qL68ww/Mi1HuyZW6p9oxkJg4Lxp/HvD+8+/vLb8IKMh6gU3+FgpXHHPzz++Pjx/r0z+TT5+PDzBHngjPHwwoZM56jYy3xzglxHrytADnbkxCWKcwItptMCHIKXYVCQ1Nyq96lk0uFkAVPy/M/z38IxRpIEWdtpsMKwFPCWRukV4J4ZkjDfOhI2amFQIUTZUdrlyT0I9mEvDAX8LQVXqL7tcY2Sb9fOKjZ+5M//Zkzs1LGuGIcRPtuWlXaHWklBcbl6E/CvzeQWcv8kshKphDfBTszMFublSUxzhIgWb0J9V89t4V4d4F5gdszbUyZZpcee54/GeHxQfkeOqMjmaBDd+zwHuZ5AAZkW0uscnpSO301Hsj3H1m8cyk8M7VzQwaLWw8P/YGrIe6awNgCOZwXDsa6lwnLvNRZ/tL1MJVmC/LPj+xLwLYEn9T7EKO9Z+5kIvdrrXsdUNxsf3wfutZYMfYvdB+budCc4wKee8P2tnxwzfYI1lmPe6UJNFXrYMxqNOg8qIxV0/P3IEm29eIm8xY/nJ5iLWvmz+gj/B8qDJnX9CgAA'
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
