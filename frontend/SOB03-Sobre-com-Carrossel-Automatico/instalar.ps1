# Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.
# SOBxx já fornece um documento HTML completo para a página canônica sobre.html.
$ModeloId='SOB03'
$ModeloNome='Sobre com Carrossel Automático'
$Payload='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'
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
