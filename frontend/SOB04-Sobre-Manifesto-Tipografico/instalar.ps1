# Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.
# SOBxx já fornece um documento HTML completo para a página canônica sobre.html.
$ModeloId='SOB04'
$ModeloNome='Sobre Manifesto Tipográfico'
$Payload='H4sIADCqmWoC/41WwW7jNhC95ytYBQGSQrIlx3a8km20e+plUaCL/QBKHNnckiJLUo5cw0CvvfcHih6KHnrqrVf/Sb+kQ9F2nAQpenHAIfX45s3jTOZfMFW5rQaydlIsr+b+DxG0WS0i7ZL330XL+RooW84lOEqqNTUW3CJqXZ3MomO0oRIW0YbDo1bGRaRSjYMGTz1y5tYLBhteQdIvYt5wx6lIbEUFLDKEcNwJWH5UpYH5MCyu5tZt/d8vd6XqEst/5M0qL5VhYBKM7D3LuFRsu5PUrHiTp4XkTbIGvlq7PEvTm6Kk1fcro9qG5dfwUNeTSVEpoUx+naVZlrKiRpZJTSUX2/xrg5zib0BswPGKxpY2NrFgeL2/GlhVpuPdc3y7WReMWy3oNq8FdIX/SRg3UDmumhyvamVTaMqYp14JKvXtaKS7eLx5jKep7u4KrSzvDxsQ1PENFGoDphbqMV9zxqA53Z34CuyeXfe5tY7X2+QodW41RYlLcI8ATUEFXzUJdyBtXuE2mJAtCgnIXndh+RjSeZemhQCHpxIP4/kOshnIwkHnEmdQi1oZmbdag6moheJcCeeUzDErYpXgjFxnWXbK+bSbjXV3TkRS3ux8Anl2lm9lODsyPmUTOO/DR2Sd7Txdz5MEIaeIGWf3qGT2zks5HDxMSV9D8l5g3eNQz6cqvswvGaSzCWZ4ds+bqUraBediIml6kUql9HYXaFsQdQ4Ne56S/0mwBBhxkARD2DyrDUErIeztaIZ48XTUm2FFdX7vK3NZO4951Nop/ZbQ/dYlNd4w6IJmM9Qsy3Q3zII+rws9/Y9Cnyqgd0/2CRXIHnwFBhMswSjz/AVv4Pw+BtPRWdozK2XK3dnytMREWgdF0PYI6q0ZZz1oUOUI+NZ20OalLkfFDGW8tfkEe4HpUWY3RS/V+AabRZeUAuVNpGKQy1Y4rsV2/0Q1LwG1gPgiQmtUbnfyaBQVr7PhDXbHfDS6+b/U9q/wA8R4fLO/+koC4/T2yYIP3oF3u0sHvumyF6/nsniTGeo4Gvnn4yW9uyCxU94YbpsP7idH2ZJsEoS7n9zs91fzYejN82GYC74L4xzAh+0fp7WLqAeLCKOOJhX+CLVSie2VFovo47fvcddPGvwczLOP+kaHIwHd2Sw/0IbXYJ3CG/06RPs5QYYkHZ/CwwCE+6H3Pkf0xPwMy5YfoFGWmPbwJ1ODeWnwAm6JxVpyHxjiEYQMGG+AecURjPHN83j/4KJlmpF/fvqF4BAkP7RAoOPYpKWy8yF+sZzr5SeLUeuA9FooPEUbpgglEhpLVyAJeo5Iz4tLP0speq3Horjj1MrQmtMB+SRxbfCB+vN4QlWtpnjG4SAhuCSamsOv/jSCl5R3CslogZPN7xmlD3+hc1WMK3n4wynkoNr+DoPIlTLGj3UGpLXU4CE8DANy+Jm0/bb0xj/8fvhNET/xHI0xAanwyg0I4lPUUGGzkb6Nk8PfjgvPCNOkvq3EngJrHVaD8RV3Pl3wsc/gYxR3DMawJPqyIq9UR7tGhGJXS8K4XETOtID16eVGo/ra4yo4dNj/g/Mvejz4M/AIAAA='
$ms=New-Object IO.MemoryStream(,[Convert]::FromBase64String($Payload))
$gz=New-Object IO.Compression.GzipStream($ms,[IO.Compression.CompressionMode]::Decompress)
$sr=New-Object IO.StreamReader($gz,[Text.Encoding]::UTF8)
$ConteudoModelo=$sr.ReadToEnd();$sr.Dispose();$gz.Dispose();$ms.Dispose()
$ErrorActionPreference='Stop'
$Root=(Get-Location).Path
$Utf8=New-Object System.Text.UTF8Encoding($false)
function Full([string]$r){[IO.Path]::GetFullPath((Join-Path $Root $r))}
function Backup([string]$r){$p=Full $r;if(!(Test-Path -LiteralPath $p)){return};$bd=Full '.catalogo-s/backups';New-Item -ItemType Directory -Force -Path $bd|Out-Null;$safe=$r-replace'[\\/:*?"<>|]','__';Copy-Item -LiteralPath $p -Destination (Join-Path $bd ((Get-Date -Format 'yyyyMMdd-HHmmssfff')+'__'+$safe+'.bak')) -Force}
function Put([string]$r,[string]$c){$p=Full $r;$d=Split-Path -Parent $p;if($d-and!(Test-Path -LiteralPath $d)){New-Item -ItemType Directory -Force -Path $d|Out-Null};if(Test-Path -LiteralPath $p){$old=[IO.File]::ReadAllText($p);if($old-eq$c){return};Backup $r};[IO.File]::WriteAllText($p,$c,$Utf8);Write-Host "[Catálogo S] gravado: $r"}
Put 'sobre.html' $ConteudoModelo
Write-Host ""
Write-Host "[Catálogo S] $ModeloId — $ModeloNome instalado em sobre.html."
Write-Host '[Catálogo S] SOBxx é página canônica: outro SOBxx substitui somente sobre.html.'
Write-Host '[Catálogo S] Nenhum arquivo foi baixado do GitHub.'
