$ModeloId='NS03'
$ModeloNome='Barra Superior Técnica de Aplicação'
$Parte='superior'
$Payload='H4sIAB+qmWoC/61WwW7jNhC95ytUB4WtheVItmM7km00LRbooV0UCFCgKHqgxJHNjUyqJJXYa/gPei3Qew9Fb/2H/ZN+SYei5JXsBEnRXmSL5LyZN29mqDllDw6ji05CNMnESnhc+aOOQ/HVO64pbyMoZIvOuzvcXF7Mld5lsLxY603WjwXd7TdErhgP/cNlC2ifCq69lGxYtgtvJSNZ/2vIHkCzhPQV4cpTIFkaJSITMrwc+sNgOD7BcN7sY7H1FPvA+CqMhaQgPVw5PUb2FoXxNWLqSMNWexQSIYlmgodccDhcnBgNYiL3uVCsPJKyLdDog8c4hW14c+P7kRZ56EcZpBp/JFutze8ayj+Tcb6NKFN5RnbhSjIamYenYYMrGjyMp9hwFZJCC6d8bBjfkG0vmPj5tj+e4dN1glSWmxHJ2Ip7DM1VmADXIKMVycNgiF5yQqmh7zvBDF9jktyvpCg4DS/TNI2OWdFabMIg3zpKZIw6lzCGCczOaWuxWmWwf2RUr8ORgaw4lf8tXBOHpjCE69qPJJQVKpw+EUml5Gg8mo1olBRS4WsuWEmnrAYUEsIAbQ9VFOFaPIDct5Cu00k6PQxiSTi1RfRo45uhJg0Yo8DjGnPmqZwkgCI/SpKf81VAZLLeN0nWwqUZbJ/L/ayd+uA/5GaaztKbOj0TOh1PkyaRocmHjdJhPC90pU3g+5/XPv1IFDpjHPBfA1tjkpC9xLBLxGMHtLtqQBJT5Gr/vlCapTtsvSwNgdPXZqJGaGWxkZ3h/1k5L8XUTl3ULJGJ79ehPl9aZxWSkiwz556dBrOZnQZT468cCKVnK9Pw2m8k41/00M2T3Yzjbk2oeDRpnSDCyDwufd8fRgLrnOkdlkCpeyrkxlaAGTk/9Dw86UZVw3nwgNlS5eizxy2zQTBThyPjgciB72vcoIFb2p1gmVH1yRanbq1UnInk/pgC0yvNkqj5Yni10uPxOL4eNpUcmSL7BP2UeqN0nF7XCEEQHC6+2ABlpIdz1bNaTM10dffPjIA63PI6eOo2eGmG1/P6cDjzbCf6mWdbixhAIjglcteO4cggl5CCVJ4EWiRA8c4txbKvZ6hv9g1BDdBnbJMLqQnXCDm/qq7o+RoIpt9JMqLUooMEOw7Bi9jLSGxu9C+JlMRRRY4TQ0iHgkPyDG/nj398/F10lvO4wCuF1+Z2YHccvcsBwcq9Jz4WgBeePdrydRtLJh1OHmBV4dtt2OY45gG/QlB7BZ3l37/9Nb+y6Ms5OcZuLoOOs8Y0LTplUw7MB8ipf6ONh1PyfvktCk7mV2Q5LwOocWwhIDccmtxGsGaUAkd+sjDuf/kV84eby3k5iiu6lZ2D0iWwFhmmFfNXqOQsp3ZtOb8qF6yjZQ1pvriqSKqJ3GmQtEvOsVZqvviqiRYvML59X1DL+ASwhsHzjL8A8pZjZckS5QqDxaetISwm1K7Grdu0Tf3dJ3Ed/fHPhGMplfRer9r3TBnrFUiSVVSscS4FxVPqBfvvqmMtWyViCS8Y3pkzLavXJf0re8omDDNkvo8TyXK97PXcxRI/S7nSjlxQkRTYGnrwcwFydwcZJFrIXrfd2F23Hy/k6ZnqUwk30yc2ay26bhQPcAC/NaP6G6Y0cMD9BBv6vtsvg2Fp77k4fjztYyrJI8ifuq4rQReSR5aJWKSDsgiMhyqwXtdcIqV/BfpWa8mwf3G51eDd/h1u8FVPuO7Bjc4jvYcd3nq82wcbKgxwZbFYdN9iR+VIf990LWGDF8RrXXfL4dJ1Dwf03XMj7Eer0oUt838AKYViVAsNAAA='
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
