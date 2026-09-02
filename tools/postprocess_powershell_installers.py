from pathlib import Path
import html
import json
import re

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / 'instalador/modelos.json'

WRAP_BLOCK = r'''# Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.
# Isso garante um <body> real para receber os slots locais do Catálogo S.
if ($ConteudoModelo -notmatch '(?i)<body(?:\s|>)') {
    $tituloSeguro = [System.Net.WebUtility]::HtmlEncode($ModeloNome)
    $ConteudoModelo = '<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>' + $tituloSeguro + '</title></head><body>' + $ConteudoModelo + '</body></html>'
}
'''


def sync_demo(script_path: Path, script: str):
    demo = script_path.parent / 'index.html'
    if not demo.exists():
        raise RuntimeError(f'{script_path}: demonstração ausente')

    text = demo.read_text(encoding='utf-8')
    replacement = '<pre id="command">' + html.escape(script) + '</pre>'
    updated, count = re.subn(
        r'<pre id="command">[\s\S]*?</pre>',
        lambda _m: replacement,
        text,
        count=1,
    )
    if count != 1:
        raise RuntimeError(f'{demo}: bloco de instalação não encontrado')
    demo.write_text(updated, encoding='utf-8')


def main():
    data = json.loads(REGISTRY.read_text(encoding='utf-8'))
    changed = 0

    for model in data.get('modelos', {}).values():
        if model.get('modo') != 'pagina':
            continue

        script_path = ROOT / model['instaladorPublico']
        script = script_path.read_text(encoding='utf-8')

        if 'Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.' not in script:
            marker = "if ($Papel -eq 'inicio') {"
            if marker not in script:
                raise RuntimeError(f'{script_path}: ponto de inserção não encontrado')
            script = script.replace(marker, WRAP_BLOCK + '\n' + marker, 1)
            script_path.write_text(script, encoding='utf-8')
            changed += 1

        sync_demo(script_path, script)

    print(f'{changed} instaladores de página normalizados; demos sincronizadas.')


if __name__ == '__main__':
    main()
