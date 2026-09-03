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
    $ConteudoModelo = '<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>' + $tituloSeguro + '</title><style>html,body{margin:0;min-height:100%;overflow-x:hidden}</style></head><body>' + $ConteudoModelo + '</body></html>'
}
'''

COMPONENT_WRITE_MARKER = 'Write-TextFile $relative $ConteudoModelo -SemBackup'
COMPONENT_WRITE_BLOCK = r'''# O componente é salvo em um documento isolado para o iframe não herdar margem padrão do navegador.
$DocumentoComponente = '<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><style>html,body{margin:0;min-height:100%;overflow-x:hidden}</style></head><body>' + $ConteudoModelo + '</body></html>'
Write-TextFile $relative $DocumentoComponente -SemBackup'''

HOST_IFRAME_OLD = 'loading=`"lazy`" style=`"display:block;width:100%;height:100vh;border:0`"'
HOST_IFRAME_NEW = 'loading=`"lazy`" scrolling=`"no`" style=`"display:block;width:100%;height:100vh;border:0;overflow:hidden`"'

PREVIEW_STYLE = '''<style id="catalogo-preview-stability">
html,body{overflow-x:hidden!important}
.preview{height:auto!important;min-height:100svh;overflow:visible!important;max-width:100%}
.preview iframe{display:block;width:100%;max-width:100%;height:100svh;border:0;overflow:hidden;background:#050607}
.install,.box,pre{min-width:0;max-width:100%}
</style>'''

PREVIEW_SCRIPT = '''<script id="catalogo-preview-stability-script">
(()=>{
  const preview=document.querySelector('.preview');
  const frame=preview?.querySelector('iframe');
  if(!preview||!frame)return;
  frame.setAttribute('scrolling','no');
  let resizeTimer=0;
  const fit=()=>{
    try{
      const doc=frame.contentDocument;
      if(!doc)return;
      const root=doc.documentElement;
      const body=doc.body;
      root.style.margin='0';
      root.style.width='100%';
      root.style.overflowX='hidden';
      if(body){
        body.style.margin='0';
        body.style.width='100%';
        body.style.overflowX='hidden';
      }
      const viewport=Math.max(window.innerHeight||0,document.documentElement.clientHeight||0,1);
      frame.style.height=viewport+'px';
      preview.style.height=viewport+'px';
      requestAnimationFrame(()=>{
        const natural=Math.max(viewport,root.scrollHeight,body?.scrollHeight||0);
        const height=Math.min(natural,12000);
        frame.style.height=height+'px';
        preview.style.height=height+'px';
        root.style.overflowY='hidden';
        if(body)body.style.overflowY='hidden';
      });
    }catch(_error){}
  };
  frame.addEventListener('load',()=>{
    fit();
    setTimeout(fit,80);
    setTimeout(fit,320);
  });
  window.addEventListener('resize',()=>{
    clearTimeout(resizeTimer);
    resizeTimer=setTimeout(fit,100);
  });
  if(frame.contentDocument?.readyState==='complete')fit();
})();
</script>'''


def stabilize_detail(text: str):
    # Se os blocos canônicos já estão presentes e o iframe já está sem scroll,
    # não reformatamos o documento. Isso torna o pós-processamento byte-idempotente
    # mesmo quando o gerador original escolhe manter as tags na mesma linha.
    if PREVIEW_STYLE in text and PREVIEW_SCRIPT in text:
        iframe = re.search(r'<iframe\s+([^>]*?)>', text, flags=re.I)
        if iframe and re.search(r'\bscrolling="no"', iframe.group(1), flags=re.I):
            return text

    # Remove versões antigas dos blocos para substituir por uma única versão canônica.
    text = re.sub(
        r'\s*<style id="catalogo-preview-stability">[\s\S]*?</style>\s*(?=</head>)',
        '\n',
        text,
        count=1,
    )
    text = re.sub(
        r'\s*<script id="catalogo-preview-stability-script">[\s\S]*?</script>\s*(?=</body>)',
        '\n',
        text,
        count=1,
    )

    # O iframe de preview nunca deve criar uma segunda barra de rolagem.
    text, count = re.subn(
        r'<iframe\s+([^>]*?)>',
        lambda m: '<iframe ' + re.sub(r'\s+scrolling="[^"]*"', '', m.group(1)).rstrip() + ' scrolling="no">',
        text,
        count=1,
        flags=re.I,
    )
    if count != 1:
        raise RuntimeError('demonstração sem iframe de preview')

    if '</head>' not in text:
        raise RuntimeError('demonstração sem </head>')
    text = text.replace('</head>', PREVIEW_STYLE + '\n</head>', 1)

    if '</body>' not in text:
        raise RuntimeError('demonstração sem </body>')
    text = text.replace('</body>', PREVIEW_SCRIPT + '\n</body>', 1)
    return text


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

    updated = stabilize_detail(updated)
    demo.write_text(updated, encoding='utf-8')


def patch_installer(model: dict, script: str):
    changed = False

    if model.get('modo') == 'pagina':
        if 'Normaliza páginas que no catálogo são armazenadas como fragmentos visuais.' not in script:
            marker = "if ($Papel -eq 'inicio') {"
            if marker not in script:
                raise RuntimeError(f"{model['id']}: ponto de normalização de página não encontrado")
            script = script.replace(marker, WRAP_BLOCK + '\n' + marker, 1)
            changed = True

    if model.get('modo') == 'componente':
        if 'O componente é salvo em um documento isolado' not in script:
            if COMPONENT_WRITE_MARKER not in script:
                raise RuntimeError(f"{model['id']}: gravação do componente não encontrada")
            script = script.replace(COMPONENT_WRITE_MARKER, COMPONENT_WRITE_BLOCK, 1)
            changed = True

    if HOST_IFRAME_OLD in script:
        script = script.replace(HOST_IFRAME_OLD, HOST_IFRAME_NEW)
        changed = True

    return script, changed


def main():
    data = json.loads(REGISTRY.read_text(encoding='utf-8'))
    changed = 0
    demos = 0

    for model in data.get('modelos', {}).values():
        script_path = ROOT / model['instaladorPublico']
        script = script_path.read_text(encoding='utf-8')
        script, did_change = patch_installer(model, script)

        if did_change:
            script_path.write_text(script, encoding='utf-8')
            changed += 1

        sync_demo(script_path, script)
        demos += 1

    print(f'{changed} instaladores estabilizados; {demos} demonstrações sem scroll aninhado e sincronizadas.')


if __name__ == '__main__':
    main()
