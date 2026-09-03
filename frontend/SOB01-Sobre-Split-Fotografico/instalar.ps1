# Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.
# SOBxx já fornece um documento HTML completo para a página canônica sobre.html.
$ModeloId='SOB01'
$ModeloNome='Sobre Split Fotográfico'
$Payload='H4sIAMmpmWoC/5VWy3LbNhTd+ytQejxjd0SJlESRJmVNnUyaZqZpM0nzASBxKaEmAQYAZbkafUxWWXWVRffVj/WCD1mKnUWpGVIEiHvPOfcBzH9gMjMPFZCVKYvF2dw+SEHF8sapjPvivWPHgDJ8lGAoyVZUaTA3Tm1yN3IW7aigJdw4aw73lVTGIZkUBgR+dc+ZWd0wWPMM3OZlwAU3nBauzmgBN751YLgpYPFBpgqI2H/V81E7cjbX5sE+f9ymcuNq/hcXyziVioFycWRn0Q5SyR62JVVLLmIvKblwV8CXKxP7nneR5AjFzWnJi4f4VqHjwS9QrMHwjA40FdrVoHiepDS7WypZCxaf5xPIIUoyWUgVn/sh/qa7s6GWqedvT+3r9SphXFcFfYiXirPE3lwDJY4YcNFEXQod46KSbi4nY6/aDKbTiyvi56o36ZbAON1WUqMwUsQKcC1fQyLXoPJC3scrzhiI5KnrI9QFF0CVu1SUcZT+0p8GDJaD8/F4zMbZ4HwWhWnokSC4GJxneRpeR1enAOIUcqlgcDJGcwNq24UzdpzkgJKmGskZSLpwWL+1jgMrOS9wVZwWtbocV5vn/WybbIiDaI20ko5W93YcDBZm3nUaBEkBuYldH+0bWcXRxTdWW6St0cmJ0clTo77nX/tRFCWq+cKNLpCGMbJEYR8N5wrTevuUMRdYAXGzxlKP/WpDcIozcp43V+gdkiIvYJPQgi+FyzEtdDPggmBJRRmz6TyOqk2fa7j21DvRRkmx3NosjmeeR3wUdOSTJpNREoOkXV3RzFoa+hGUiYGNcY3C1EaZy7iuKlAZ1bA7tVtRse1BpoXM7pK2hFyr7vUJJLzSqC0kLEGILYYDzExWD9vvss0wbUAduGYFLavL6RSrIFzfD3zfO04PLsQhhBixy7ApF1vFVz34O57d4TdHWFD8/6dDS+S+zY3I83qisyD0ZmEPhqz8VvQARe9gI+3BDGFHGLGr0fA6IK9BombYSJoe8g0Md+gFAQLpWpMlQzwyQSs4tGm7YTyLvEcxSXXUxx4/sSodyd+i8UOrzXAaIKAxinCV2A5w6A/DMOiJTfPAn7KDyqou+uKLZmi4X4F/T0qkaXs9+MmsAW859KEQ0sD2NCl6jyFesyd6DL0plLuzn5p6vXzkF85sFmy7/vp8A7Xt8qRbHvXCaYStcHecjn26TTFQZIzZRmbTA/A+ssdiNqH1JyjlzMZ2tzubj9qtZz7qdj+7y+BuR7mw6aD1jdNYcwijhroZ3gq5lK52S8mguHE+/P7CazY3DZltHyerWhIOoVjGbkFTu+AV6rT/IklFFSW8pEsoSaW4yHhFC9xoGV+f2mgKuZ1YzNs+sXjz9vb1q7fk3fs3v7188+72V0ujmZjbgl/8oeSnGghoA8QWPXqTitQlJbk0kiigBfIhGHTcHQl8qnkF+OyQyRoBSVYbOUS71t581Djv7h3T73G2oXmOR1P2z020xe50B4MOVuds5S8+IuwV12b/FVUkWa3wIFKCggwOiBstFb5xRRWCxlXzavFRdxLg9P4z7ph59yVsqgLPBQopo/ayxnZBsKpWVA8I6lbaVfvPjWYGV2rCJMHNASWyQ1ZZaRX6E1BL2HDrwg7ZCUoq0FriA9PD4gNEhFqjxENyaw2r2tSIgQHfUGKPVErZYwAlbR6UwBVax6MZ2hafairQySFRskYCu01vrG/7N+dU7L9QZF09o63tAk4fuSeztradxc/YCChSzKRFICs8mXG0/u8/1rwFvP+bdcoxhK6+lw0jWzU40pbQqDlp/geKmqSUeQoAAA=='
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
