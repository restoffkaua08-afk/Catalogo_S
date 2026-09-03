# Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.
# SOBxx já fornece um documento HTML completo para a página canônica sobre.html.
$ModeloId='SOB05'
$ModeloNome='Sobre em Camadas com Painel de História'
$Payload='H4sIAHmPmWoC/6VXzY7bNhC+71OwXgTYLSxbki3bkmyjCRCkPaQBmvYBKHFkEaFIlaS93hj7MEEPAQLklFuvfrEOJdm79u4GAWrAskSO5uebb4bj+U9M5fa2BlLaSiwv5u6HCCpXi15tvVd/9JbzEihbziuwlOQl1Qbsore2hTfrdauSVrDobTjc1ErbHsmVtCBR6oYzWy4YbHgOXvPQ55JbToVncipgEaAKy62A5XuVaZgP24eLubG37vfnXaa2nuEfuVwlmdIMtIcrd87LfqbY7a6iesVl4qcVl14JfFXaJPD9F2lG8w8rrdaSJZdBEIyDaZoroXRyWURFAHFaoJdeQSsubpOXGn3q/wpiA5bntG+oNJ4BzYu7i4FRmR/tTvWbTZnWymAsSiYaBLV8Aynjphb0NllpzlK8w6i5hcokOcIBOq0pYy6SXNCqvgrDetuPNjf96aTeXqdqA7oQ6iYpOWMgD4Y9p2x3tEUzo8TaQsolJuJpTSduuIuHTuCKBQ8hWFfSJMEgjApNBlO8nolodYP7uBm4LVonwbjepqqmObe3ySAOj56ZUtndYxTOA3kgnUhbennJBbsKrneNXTSXBMPRw3wJLoFqDJwyjsBdBeOIwap/OR5H4zHrXwazMAyATMIX/Us6nRUTdv2MkfB69z29o1Yvnc3i6QT1s1E+mpIoQr1hGI7D7Dm9ox/SG+RhPPL7l1E4yaYjEvmoN4somrs+wTChBbJj15VN0vvt7cs3r9/20sdJ1y3/XEIyZa2qkgBT31IZqwSSGJ8EWFTnGZcxJNsghOpI/eZDZ0fzOdXsiRR+9LhksE1GaVO1CZL/ajrxkWWz2ebmOm2rzhNQHCjo9oIQKRjMfMfBU6qP/I6gk4agj2szj9O2vJOg3hKMljPSeRu6LWwCJWVIFZ+EM5SIUSG59H0/bpQxrWqv4ALjTjKx1k1F3IMMt5Ahz3b3OAX+M0BZ2FrPaqz/QukqWdc16JwaaDG+aRtA7PsHRPMpZbOgowkpg8ZGEvk+aSMfu9KcHEpzOIgn5A0oRA+bjOsv5054Az9CN7q2FkwxTAw5qrcHE/V9y+tcYH4O+fQBCVrLwcSlZDBysAexg93x9NjDBtP7QnZdfPcDXUNDDdRejfrYGo4ksKpORi0jm/7snh8nMTowot3HHLa9ZXaMrPGCGKuVXB2dyYTKP6RHTF1ah8EZgvfcPtVUU3mm54HH05OyeZIOfvw9PnRW43Ecx6O7i18qYJxeVXTbHnRJUy7Xu+70OJRDEzgVfCW7kwEku3vY6Nu23uLzdOd+pmEPjv38BxouXVv1fGs7gCaVhLuHjeLIvDbE5pw9ROZKnITj03Tuno2BdN+nkv8gL44edxfzYTsPzIftLOJOfpw9KJeuyoxZ9BolPcKopeiqpUKtlGe8SjEQi977d69wF8cKxjcnbzSY9wjF499rT6tFz+o14FjySNThhOtD3Ph/u831Yk41jhoCTgUdzE8Z7zpYb/m7MoYSMGb/ReacdirLYPmuHbu2VpECRxhCrd5/MgPykpTc2P03DJFsoCI11ZQU2g0kA8QzWM7r5V8VjnaqcufA/vP+H9UKSVjtv+VcGfL3GkitIeeGVgS2tUAD2q1WxDhxgzc0o5IpieuoXun9ZzTHzZqKAflT778Ysv+kgRrCgFT7r1grTqpCfYrgdISbXBEgzjR2KUGakhP7f3POlIvMTVDo07pywSNNCgRurS0dkHeG1IC+SHQUTy10jSkNxjnEt6gPKVChK9p55mTQAQwBO0eLYJ+sJWeUgekj5O78dnfIxhqdVWuMkgrUrpFb6IlDwiEloHKSxA2/WrtDkyKa9ROZc8RuM7qct/xe+jNH6OZ27rrU0vmFS+72nkFH8XD84Uy+xvwr+p1X/NH5G5rLfP+15ueGumtHRqTl0JUVrrQ1Nmz+FvwHr+ONQyYMAAA='
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
