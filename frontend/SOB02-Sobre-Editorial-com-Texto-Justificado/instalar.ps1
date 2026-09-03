# Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.
# SOBxx já fornece um documento HTML completo para a página canônica sobre.html.
$ModeloId='SOB02'
$ModeloNome='Sobre Editorial com Texto Justificado'
$Payload='H4sIAB+qmWoC/5VW247jRBB9n69oMkLaQbFjW5MLdhLBLgieWInlB9p22e6l7W6627lslK/hYSWkfeKBd/JjVNlOJhlGi1Akx+muy6lTp7qz/CJXmdtrYJWr5fpuSV9M8qZcjbTzXv88Wi8r4Pl6WYPjLKu4seBWo9YV3mI0rDa8htVoI2CrlXEjlqnGQYNWW5G7apXDRmTgdT/GohFOcOnZjEtYhRjCCSdh/U6lBpaT/sfd0ro9fX91SNXOs+KDaMo4VSYH4+HKkVCOU5XvDzU3pWjiIKlF41UgysrFYRB8maQ8+7U0qm3y+L7gxaKIkkxJZeL7cEafpECUXsFrIffxtwYxjX8EuQEnMj62vLGeBSOK451vVRpEh9v4dlMlmuc54cokr/WraKF348fNdjx71LuHJBdWS76PSyPyhB6egxpXHHhGbW3MW6dYWBhGL+cknlP6cPYsJOyS9611oth7A6Wx1RypTMFtAZqES1E2nsDINs5wG0xyIck5Vceh3jGrpMjZfZjS5wz6YjDTu54JJBniEB0SCQ4jeZSKyvPDKdSJg53znEFeCmXquNUaTMYt9M7bnphFEFxKqbloDjcs4Btiv0F7S+EjUbhACsMoQA7ZUzDRNGAOnYJibMSrsLMYU6Mfjr0Nq8IDYYmnQcD6eNOI4vnTLiIW+jDxF4/sB1AoGewxtfd5sZ4fzKjcs6xYwAhVX35H9wD9Ao1KO3ym2yi6tm5s7M+n2O3Qj/ArKbm+ls2cEIZU801LrePGnTuK0rhuZ/Z1Nk2f2km7FOoCS/IUZE/IHAmhxk5Cf8o6pf+7xbPPtXiYm0U4T+dPPSHzPsHjhfGQqgl9qieiMcCU8+gZ40O0KIvSaHFN7KD1pNrrCpp+RC7Zer0eXibjmba7XUyf/I9Roo6Qps7w5tN5OFv812gEC6iPd9/UkAv+qua7/pCL551+D8PJcRY5MXK8Vs3LQgkHfVCM4zXXV1RJKNzxlhmq0cuFgcwJhSrtol3NxnPv491y0p+yy0l/wtN5iic6zi1109rVqHMesZw77mX4kKpUnvVqlYNcjd69fY27dGegO5gbJ+oBnu1IVLP+SVnLWSWsO/2J6sO0tNrvfQc2BxYF0ey8POmj0R3Ql3Ibl+Bh4Fxsbte7E4Iuq7C/SnwMFL5gR5y/5N/Ny2j9fc20alH1THPJN4bb5QRtX3AgPtHeOmCAyE8fFSuUYBqVy3OF7oaztuaMawMW9YYWp98Vow7hlYlOEkqOSvTZGxIkQxpUg48NCMU4EzngxLDfWi6ZNiqVgLE2Kjv9gZaZyEXLMK7CC8tgsMFMNNnpk0Z/ZQSlZIrhPKdcVopV6j3messIN8LDFuIrXj8IGKslpGCdUQXEmN0JrUrDC4KgKJEWRmEeRCZFU+F932CQfqLwvsR6cyqOU1WsL/j0kVNNOBlO0ZnDLNQMdqIUBolyQ3jLVEtOXUCL+4jX+gPnN89BDaiLQin3XG79EJwV90ZyAx+QeyTWdih2GVir/Bvt/dIxYdsUq3Dt6dMGJPv7r46G1rXYPqpbNVZsLpqd9LkRxISEiAv90Ey6f0//AGk+Ej5NCQAA'
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
