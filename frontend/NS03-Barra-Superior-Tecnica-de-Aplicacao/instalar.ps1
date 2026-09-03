$ModeloId='NS03'
$ModeloNome='Barra Superior Técnica de Aplicação'
$Parte='superior'
$Payload='H4sIAMmpmWoC/5VWzW7jNhC+5ylUG4XthWVLin8l2+h2u4eixW6BAC2KogdKHMlsZFJL0om9hi+9Fdhzu4deigIteus75E32STrUj+O/bNIEkCUO+fGbbzgznFB2YzE6rUVEk1QkwubKuaxZFD/t3ZiyF4JCOq29ukLj7GKi9DqF2cVcL9J2KOh6syAyYdx3tvUDoE0suLZjsmDp2v+Sa5Dt55KRtK0IV7YCyeIgEqmQfh1GQOPe0Xrr2SYUK1uxt4wnfigkBWnjyPE0silQGJ8jpg40rLRNIRKSaCa4zwWH7cXRok5I5CYTiuVTYrYCGry1Gaew8sdjxwlSiLXvBJIlc/OrRYbPOeSfg1G2CihTWUrWfiIZDczD1rDAEQ028lkuuPLJUgsrf7ixzF8CkrKE2wynKj8CI0qQkMx3PUTMCKXGVcdyzQYhia4TKZac+nXXdQcuDXYiaC0WvputLCVSRq16nP+5TpArNidU3BoYRLU8xLLqjuP0TkXQIklS2Nwyqud+z8FNSw/z92K3M9v0KiKSULZU/glb4jneuApuFNI+uEG0lAo/M8Fyr/PDgbEF3zi77YSScLqpRI1TWD2oleGWL78tyI76Jlwa7bbKSGQk7DiXsNh2jKuld97w3rv8/dCF4aELKeNApJ0YK+7cdC/7FJJ2vT+iXhy360M66MVx61Bux/KM4PV+REZx3Dujd4Ss8XRuFozbBS0neLLLpZyj8bhP+vv6uUa/EtoKy2yo0wj6EG87VOhSgsG9AoMTAfrOpwcx7A/p5Sg6dtAtHMxtp+6RyGSTelIU86AXCzYlqcvBYRJ4HzuD3mNncOhSr1+JFsbRmA6CJxI7Efc6pJuKmFGg/zFmo2Nl72M37I/ccW8PfozoJzLGJE2NKw/Wp9GoKEhDwzUvVLlW5UEfOXsyuv8rkQvJT+pO3Ds8B14PkQZOWVfGgTBZp9emTGIWq1jIhZ+/mWr4fdNGmq2gTHwbblBrlVflYnrhYsdT253nHZEB31Sw7h5svuwIyhTW+7XYD56cUjuV3LMFoYwagXAcDfcPhWcOxf2G/lzcgNzsC1cI7IwqDPzYXny2AMpIc0FWZfYPPWTR2jxQJtodhUUomttlmlRu5Q3tXD97Qhfa7pL0p6XSLF5jI05jHzjd7vhlEmKQypZAlxFQ7P95hIrPE7bPNntRNNQ+YYtMSE24RshJt7wuTOZAUF4rSolS0xrSrc0m4RIbGa/Gim5Us/Q6A5yR287cRoAv7WKqRfA+YackNNeT56Fk0uLkBhJy9/fdn6JWmGGVYWcBvOZgwBTUZh/e/zvpFuizCdkRMv2nZs3R92ktz7OOueEc7290tLE7XM8m2Gt21I0N/emasdmr11+87L6+mnTJbGKuWOWcMqq1w5VYnncLJ+HsOyGvTRMDpFhMnHUra/78Rgq6zP2rhru4x8FGZYRP9C3GrYNDdaT27POlioi0Dihi9UPV3r3/arfjiXoVWCEfqsH4I/K9QDVILlHBv1ucDzwoGMIKtkqx2kGkX93H2NJ3/0ScRaRmyDw9eB/e/Vz4OPuWKYOTgCTpzj9yj5YZvbVQjwH++lcJ+ILouz+M9RyaEqGEx6B++6WEujKzz8GYo0S0eAzo9x2nYv4+VBdlNpf5SLJMz5rN1nSGNweutCWnVERLTDPdebMEub6CFCItZLNxmPmNVjucyuM55Z0SjfEZYxXQBl6dOlh8X5oK/jVTGjigPUoZ2to5GRY3H+Lxw3FNoJLcgvyx0WpJ0EvJg8ITMY07+UkyO5TEmg3TW/L9FejnWkuGpxmHD4pFo32FBp40Rau1bQWnTK9hjb2QN9pQUIUOjkyn08ZLzJ8M3d/fWcICG0S18xb/m60Ag1Fof1FkwH8e/HQdjg0AAA=='
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
