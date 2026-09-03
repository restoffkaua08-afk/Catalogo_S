$ModeloId='NL01'
$ModeloNome='Sidebar Overlay em Vidro'
$Parte='lateral'
$Payload='H4sIADCqmWoC/5VWzW7jNhC+5ykUB11JhaXIP00cyTIaLFK0wHZRYC8FFnugRMpmQ5MqSf+tYaBv0d576KlAz73mTfZJOqQk/+8mhQJHEjkz33zzzVBDTOcOxWkrRxoxMRYBZ1Gn5WB4DLbvVDAVmLC09fbNuUUs0YLI0cVQ6RUjo4uJnrJ2JvBqPUVyTHkcba4O/K8LwXVQoCllq/heUsTa3xM2J5rmqK0QV4EikhZJLpiQ8VXRN9eRD+frdSaWgaIfKR/HmZCYyADeHG9D68oL5RPwqRNNljrAJBcSaSp4zAUnm4sjozBD+SOWolyXQlG7r6BLgpOPAeWYLOO7QRQllCui4ygxm8dSzDiOr6IoGiSiRDnVK1gqBeUagJE54VrZYImWkGHlNOyqI7yhKAnfi9+46hy7QjMtTnFXpfg86m+iRIsSgEk6nhjsC4r1JJ5S7vV6UblsDwbzhZ9MiF3uRBGeT5ISYWxI7gzKpWN/urA1wVSVDK3igpFlYn4CTCXJbVzgfDbl+8zIcYa8br9d/YV3N35SF42RAkKBVyUYxc5Vr9dLmvyDgjJIOs7YTHqdfrk0VlD1CcJiEQedGzCLnJ75Z6jvV+QWQk5je8eQJj97naj7lb/P+3aXE3b7yiFInWigLkRN6M6t1Us4IQivDwj4ZaY0LVZBDtKGAsUKCkeCjOgFITxBjI55QDWZqjgnpo4Nx33gcxNm4B9XbQGKJrFJNbGPi2ob6G0T5kwosq5K1gO7xoe9r9g0cqxolQjTmYpvzdKuDDaREknA0LQXxjjZRe52wSCfSQVLteTqwPFEzIGKfbV3M3OdypCjedP7XVuirVjGkuJkjMq4b9KGfdCgBzyeYerL1G7V2TPq7G6ZaAgYNExWxN4cEXtjiLU4zuV3Z65mHRWAZt2gaH367d9Ww+Ht7e0+h5FJrhBC1ywEpulMxzZo7Qtb5BqsfT7ogcrBHj0ZE/njLt3Oi9LtmWrWdb41V+P2C9kWiDHz/rNj5PauGSCWTovd3FTK7Pd3yuzvUtxPDw/MdQb5Ppyi2J4A3W53qyA7Q+EOJHCgkiPNXnw7JZgir5SkIFIFkuBZTjCcZDaj6tFfnxwqe1PCRLqk01JIjbjebC6G1/UJN8xmWgvu5AwplbYawlqOXpUkbVWrLQfB0RYwlJmj8z6TVDpTwmet0ac//hleV5tGQ3MC136aqVdbTijGhKctLWekNRpew87RECmKSWNQTafDQG/RnIzR019PfwrHjD+J2Hl/e4HNOIM3aAvEjKOWMwHu0pYtemgO9eOj3yg6YJQ/jn5EMkfDazQ6YsYOji/R8h3JJ6jh5en3HS1VtqbxaldwayG+HNQP/OnvnAoLq7ErpcCwQT1j+lO97cBWiUySZwzfmT0HVmZeIC2esXtd7bKW15DqQXlMx+7lDqaUP+PvgYOQZeXOMnlthWM+0nJJSz3yPD8dmWGmtCNTLPIZ1ECHv86IXL0jDM5xIT33sD1cv41TebynPiNhMTu32oga1vMzy1YhsFZkZxabxnL9pEIKH2/p+zAMz+O9Z8xz3598u4K2YL6Ox4x8cP0PYfVJ4S3T0aUMbXXgQ85b+n5CC+8SIoSM8LGe+EUW2n4P69GTuub0cmso5vsgtSSCF1OnN1TpEKaz55olgIxD+D6811pSEDXx3L0mdNsu5GYST7apNDcPjNjnKraZ0gUTi9StLRODED5FHlA+MUksz0UhyxI6mGCIY7rd9f1NDdvyfYpbkilEeiH0yuXLkf9vzDU3ANoUG4xBHh8OHQDRD+ZL2KAnHOrp5oyCUtomA6jl+xzk+FIbS0olgAVMFrEAfKy4TNP6CU64V6/2pWGCeH5y6vCRrMAASCJAMLgjIbxJ09R9UDkqIScbyvM3cIEDOFGqdryo2vQ/sDxiZJANAAA='
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
