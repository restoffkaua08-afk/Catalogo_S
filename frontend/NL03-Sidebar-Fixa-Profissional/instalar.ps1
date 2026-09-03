$ModeloId='NL03'
$ModeloNome='Sidebar Fixa Profissional'
$Parte='lateral'
$Payload='H4sIACSsmWoC/5VWS4vjRhC+z69QNCy2F0sjezx+SLbJsgwksLsE9pJrS12yOyN1K62Wx15hCDkEQnJOcsgtkEAgkGvO+0/2l6S6JXtkzcwmg8H0o+qrqq8e6jllG4vRhR0RRRKxEg5PvEvborh1jme5kwoKycJ+8wovl2fzXO0SWJ6tVZr0Q0F3ZUrkinHf25+fAJWx4MqJScqSnf9CMpL0P4NkA4pFpJ8Tnjs5SBYHkUiE9M8vvcvRJWlhWM/LUGydnL1jfOWHQlKQDp60xUhZoTC+RkwVKNgqh0IkJFFMcJ8LDvuzlpKbMwohkWUmcmbEYrYFGrxzGKew9WdTzwsSiJXvBUpk+B8KpUSKi1tG1dofjkbZNsgIpdq7AW6sgYcnlOVZQnZ+nMA20H8OZRIiYwL9LFIehCS6WUlRcOqfx5N4Gs+COjrJVmvlDxArFwmj1jkMYASTQEmkrHLTWLfc4TDvm9NYyNRs926Ie1quwYBc3XOGJGzFHaYgzf0IuAJ5dN+rfDdJu630dfxmj/yDP7jKtns3ISEk5THmSR2zhYtDJmejGSGDhuashTtBXJOho/d+kWUgI5IDEq7QLSfPSKQtuN4U0r3LyaY8RLKSjAYrkvlD7RDeYPr/K0otbuJLGXdqekbDRvbq8A9JIJQVud8I6mo2HoxJk47LVlRjz6u98ddiA7JfbVyCid9A2cw4zCCCY+UPJgMyoJWuyyJR1tWl/TE0mXgOkdRK06tpNLvcI3qEmKpuQkfXKSmUOASi9/drqQ66uvU0i4iakCyHu14gIeoUCoKqIB0Tr1aYatpqF8e4rNk068pq0yKdUEKhxeuV9+y0A+IjGePxOIgKmeM6E0xH3O5b9DXF4lB3/Vs5M55m7blwJ2r6wsKi4v3HRExlP3prcmkAcJiors5T71h1Zrx8VLP8qsgVi3dOhBWDibzXfXs3FSFLwBEZ8BPg4LHxNJnV40lPHpMas6jYMMXdLPT/mZqpFn04NcPhcH/2aQqUkW5Ktk5laDLGAuqVj83WuxY3q4Qo+LLrDLzRs15zin7C0kxIRbhq86j5eAjOcP4gaWY+4CqCkxnQKPKTvO3rkDIJMcjckUCLCCh+9gzp1fZegM/LxkDWOI0I9mfzi/orOQ8L/GRwK0pIni/shru2pXYZLOxKwLYIfiEdU4ML+0UombTqmO3lh1/+nl9Ucss50ccHvIPIifYbsoEVef/H+9+EhSVD7GXLiwMPH3UhQco4kVaCg6WQCPLhm38aXhywTGPZ1hrJW9imMF39Mmi/IvRMchLGb5Zz3UPL1wSnPbKk1/MLspzrt0gNaTywl6+BF/MLPF/OdQvVl7i0G+ar4fpk+wd17GIM7MdvD56Y/8/5+78iJprekdpAJgVFpPzpNn76/cTGFzXQQ0ZyEUp4uoWffzix8FajPASvJxBR4ukGfv3+xMDLCqdp4gKz086WVX+h7DsP0BTjT7f/3Z8n9q85dqC8b/7CdIh+qEaSZWrZ7fYWS3wf8lxZckFFVKQ4D9yvC5C7t5Dgu0zIbue0vTu9frSQbZnjAMHr9IHrRnd3ekHk4my/3qCtVyzHmQ8oEiUsuun0tUfSNcHpO1eJ1SoBvK6+GZ1eL0ifrl3Z7QX3FW9gR8Ut7/QBmWBxF1w8WSwWnes8IhmG04STkOLz5QC3x1+3FyDNFZtnVUv+CzpOPBo8DAAA'
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
