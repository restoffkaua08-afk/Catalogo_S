from pathlib import Path
from urllib.parse import quote
import json
from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[1]
BASE = 'http://127.0.0.1:4173'
MODELS = json.loads((ROOT / 'instalador/modelos.json').read_text(encoding='utf-8'))['modelos']
CATEGORIES = json.loads((ROOT / 'dados/categorias.json').read_text(encoding='utf-8'))['categorias']
FORBIDDEN = ['npx ', 'github.com/', 'api.github.com', 'raw.githubusercontent.com', 'git clone', 'invoke-webrequest', 'invoke-restmethod']


def web_url(path):
    return BASE + '/' + '/'.join(quote(part) for part in Path(path).as_posix().split('/'))


def attach_monitor(page, label):
    errors = []
    page.on('pageerror', lambda exc: errors.append(f'{label}: pageerror: {exc}'))

    def on_console(msg):
        text = msg.text
        if msg.type == 'error' and 'Failed to load resource' not in text:
            errors.append(f'{label}: console.error: {text}')

    def on_response(response):
        if not response.url.startswith(BASE) or response.status < 400:
            return
        if response.request.resource_type in {'document', 'script', 'stylesheet', 'image'}:
            errors.append(f'{label}: HTTP {response.status}: {response.url}')

    page.on('console', on_console)
    page.on('response', on_response)
    return errors


def assert_clean(errors):
    if errors:
        raise AssertionError('\n'.join(errors))


def assert_no_horizontal_overflow(page, label, tolerance=3):
    metrics = page.evaluate(
        """() => ({
          html: document.documentElement.scrollWidth - document.documentElement.clientWidth,
          body: document.body ? document.body.scrollWidth - document.documentElement.clientWidth : 0
        })"""
    )
    overflow = max(metrics['html'], metrics['body'])
    assert overflow <= tolerance, f'{label}: overflow horizontal de {overflow}px'


def normalize_fragment_page(page):
    page.evaluate(
        """() => {
          document.documentElement.style.margin='0';
          document.documentElement.style.overflowX='hidden';
          if(document.body){
            document.body.style.margin='0';
            document.body.style.overflowX='hidden';
          }
        }"""
    )


def test_catalog_navigation(page):
    assert page.locator('.category-card').count() == len(CATEGORIES), 'quantidade de categorias renderizada diverge do JSON'
    for category in CATEGORIES:
        page.locator(f'.category-card[data-category="{category["slug"]}"]').click()
        page.wait_for_function(
            "slug => location.hash === '#categoria=' + encodeURIComponent(slug)",
            arg=category['slug'],
            timeout=3000,
        )
        page.wait_for_function(
            "title => document.querySelector('#context')?.textContent.trim() === title && document.querySelector('.category-head h1')?.textContent.trim() === title",
            arg=category['titulo'],
            timeout=3000,
        )
        assert (page.locator('#context').text_content() or '').strip() == category['titulo']
        assert (page.locator('.category-head h1').text_content() or '').strip() == category['titulo']
        cards = page.locator('.demo-card')
        assert cards.count() == len(category['itens']), f'{category["slug"]}: quantidade de demos incorreta'
        for item in category['itens']:
            card = page.locator('.demo-card').filter(has=page.locator('.demo-id', has_text=item['id']))
            assert card.count() == 1, f'{item["id"]}: card ausente na categoria'
            href = card.get_attribute('href') or ''
            assert href == item['caminho'], f'{item["id"]}: href divergente: {href}'
        page.locator('#homeBtn').click()
        page.wait_for_function("location.hash === ''", timeout=3000)
        page.locator('.category-grid').wait_for(timeout=3000)


def assert_detail_preview_stable(detail, mid):
    iframe = detail.locator('.preview iframe')
    iframe.wait_for(timeout=7000)
    assert iframe.get_attribute('scrolling') == 'no', f'{mid}: iframe de preview voltou a permitir scroll próprio'
    detail.wait_for_timeout(700)

    child_frames = [frame for frame in detail.frames if frame != detail.main_frame]
    assert len(child_frames) == 1, f'{mid}: esperado exatamente um iframe de preview'
    preview = child_frames[0]
    metrics = preview.evaluate(
        """() => {
          const root=document.documentElement;
          const body=document.body;
          const style=body?getComputedStyle(body):null;
          return {
            marginTop: style?.marginTop || '0px',
            marginRight: style?.marginRight || '0px',
            marginBottom: style?.marginBottom || '0px',
            marginLeft: style?.marginLeft || '0px',
            clientHeight: root.clientHeight,
            scrollHeight: Math.max(root.scrollHeight,body?.scrollHeight||0),
            clientWidth: root.clientWidth,
            scrollWidth: Math.max(root.scrollWidth,body?.scrollWidth||0),
            overflowY: getComputedStyle(root).overflowY
          };
        }"""
    )
    margins = {metrics['marginTop'], metrics['marginRight'], metrics['marginBottom'], metrics['marginLeft']}
    assert margins == {'0px'}, f'{mid}: preview ainda possui margem padrão do navegador: {margins}'
    assert metrics['scrollWidth'] <= metrics['clientWidth'] + 3, f'{mid}: preview possui overflow horizontal interno'
    assert metrics['overflowY'] == 'hidden', f'{mid}: preview interno ainda pode criar barra vertical'
    assert metrics['scrollHeight'] <= metrics['clientHeight'] + 6, (
        f'{mid}: conteúdo interno excede iframe ({metrics["scrollHeight"]}>{metrics["clientHeight"]})'
    )
    assert_no_horizontal_overflow(detail, f'{mid} detail')


def test_interaction(page, mid):
    if mid == 'P04':
        page.locator('.p04-toggle').click()
        page.locator('#pesquisa-p04.open').wait_for(timeout=3000)
        page.locator('#pesquisa-p04 input').fill('teste')
        assert page.locator('#pesquisa-p04 input').input_value() == 'teste'
        page.locator('.p04-close').click()
        page.wait_for_function("!document.querySelector('#pesquisa-p04').classList.contains('open')")
        return

    if mid in {'P01', 'P02', 'P03'}:
        field = page.locator('input[type="search"]').first
        field.fill('teste funcional')
        assert field.input_value() == 'teste funcional'
        return

    if mid == 'L01':
        page.locator('#l01-q').fill('Headphone')
        page.wait_for_function("document.querySelectorAll('#l01-grid .card:not([hidden])').length === 1")
        assert page.locator('#l01-grid .card:not([hidden])').count() == 1
        assert (page.locator('#l01-count').text_content() or '').strip() == '1 produtos'
        page.locator('#l01-filter').click()
        page.locator('#l01-panel.open').wait_for(timeout=2000)
        return

    if mid == 'L02':
        page.locator('input[name="l02-cat"][value="Moda"]').check()
        page.wait_for_function("document.querySelectorAll('#l02 .product:not([hidden])').length === 2")
        assert (page.locator('#l02-count').text_content() or '').strip() == '2 resultados'
        page.locator('#l02-clear').click()
        page.wait_for_function("document.querySelectorAll('#l02 .product:not([hidden])').length === 6")
        assert (page.locator('#l02-count').text_content() or '').strip() == '6 resultados'
        return

    if mid == 'L03':
        page.locator('.chip[data-cat="Gaming"]').click()
        page.wait_for_function("document.querySelectorAll('#l03-rows .row:not([hidden])').length === 1")
        assert page.locator('#l03-rows .row:not([hidden])').count() == 1
        page.locator('#l03-sort').select_option('price-desc')
        return

    if mid == 'L04':
        page.locator('#l04-open').click()
        page.locator('#l04-drawer.open').wait_for(timeout=2000)
        page.locator('input[name="l04-brand"][value="Vertex"]').check()
        page.wait_for_function("document.querySelectorAll('#l04-grid .card:not([hidden])').length === 2")
        assert page.locator('#l04-grid .card:not([hidden])').count() == 2
        page.locator('#l04-close').click()
        page.wait_for_function("!document.querySelector('#l04-drawer').classList.contains('open')")
        return

    if mid.startswith('LG'):
        prefix = mid.lower()
        page.locator(f'#{prefix}-open-register').click()
        page.wait_for_function(
            "selector => document.querySelector(selector)?.classList.contains('show-register')",
            arg=f'#{prefix}',
            timeout=12000,
        )
        form = page.locator(f'#{prefix}-register-form')
        form.locator('input[name="nome"]').fill('Pessoa Teste')
        form.locator('input[name="email"]').fill('teste@example.com')
        form.locator('input[name="senha"]').fill('SenhaTeste123')
        form.locator('input[name="confirmarSenha"]').fill('SenhaTeste456')
        form.locator('button[type="submit"]').click()
        assert (page.locator(f'#{prefix}-register-message').text_content() or '').strip() == 'As senhas não coincidem.'
        page.locator(f'#{prefix}-back-login').click()
        page.wait_for_function(
            "selector => document.querySelector(selector)?.classList.contains('show-login')",
            arg=f'#{prefix}',
            timeout=12000,
        )


def direct_path_for(model):
    return model.get('template') if model['tipo'] == 'frontend' else 'backend/DB01-Banco-do-LG01/preview.html'


def test_mobile_layout(browser):
    context = browser.new_context(viewport={'width': 390, 'height': 844}, is_mobile=True)

    root = context.new_page()
    errors = attach_monitor(root, 'CATALOGO mobile')
    response = root.goto(BASE + '/', wait_until='domcontentloaded', timeout=15000)
    assert response and response.status == 200
    root.locator('.category-grid').wait_for(timeout=5000)
    assert root.locator('.category-card').count() == len(CATEGORIES)
    assert_no_horizontal_overflow(root, 'CATALOGO mobile', tolerance=4)
    assert_clean(errors)
    root.close()

    for mid, model in MODELS.items():
        page = context.new_page()
        errors = attach_monitor(page, f'{mid} mobile')
        response = page.goto(web_url(direct_path_for(model)), wait_until='domcontentloaded', timeout=15000)
        assert response and response.status == 200, f'{mid}: preview mobile indisponível'
        normalize_fragment_page(page)
        page.wait_for_timeout(180)
        assert_no_horizontal_overflow(page, f'{mid} mobile', tolerance=5)
        assert len(page.locator('body').inner_html()) > 60
        assert_clean(errors)
        page.close()

    context.close()


def main():
    checked = 0
    with sync_playwright() as p:
        browser = p.chromium.launch()
        context = browser.new_context(viewport={'width': 1440, 'height': 900})
        context.grant_permissions(['clipboard-read', 'clipboard-write'], origin=BASE)

        root = context.new_page()
        root_errors = attach_monitor(root, 'CATALOGO')
        response = root.goto(BASE + '/', wait_until='domcontentloaded', timeout=15000)
        assert response and response.status == 200
        assert 'Catálogo S' in (root.title() + root.locator('body').inner_text())
        assert len(root.locator('body').inner_text()) > 100
        assert_no_horizontal_overflow(root, 'CATALOGO')
        test_catalog_navigation(root)
        assert_clean(root_errors)
        root.close()

        for mid, model in MODELS.items():
            detail_path = Path(model['instaladorPublico']).parent / 'index.html'
            detail = context.new_page()
            errors = attach_monitor(detail, f'{mid} detail')
            response = detail.goto(web_url(detail_path), wait_until='domcontentloaded', timeout=15000)
            assert response and response.status == 200, f'{mid}: detail indisponível'
            detail.locator('#copy').wait_for(timeout=5000)
            command = detail.locator('#command').inner_text()
            assert len(command) > 100, f'{mid}: bloco PowerShell vazio'
            low = command.lower()
            for token in FORBIDDEN:
                assert token not in low, f'{mid}: dependência proibida no bloco: {token}'
            detail.locator('#copy').click()
            detail.wait_for_function("document.querySelector('#copy')?.textContent.trim()==='Copiado'", timeout=3000)
            clipboard = detail.evaluate('navigator.clipboard.readText()')
            assert clipboard == command, f'{mid}: botão copiar não copiou o bloco completo'
            frame = detail.frame_locator('iframe')
            frame.locator('body').wait_for(state='attached', timeout=7000)
            assert len(frame.locator('body').inner_html()) > 60, f'{mid}: preview vazio'
            assert_detail_preview_stable(detail, mid)
            assert_clean(errors)
            detail.close()

            direct = context.new_page()
            errors = attach_monitor(direct, f'{mid} preview')
            response = direct.goto(web_url(direct_path_for(model)), wait_until='domcontentloaded', timeout=15000)
            assert response and response.status == 200, f'{mid}: preview direto indisponível'
            normalize_fragment_page(direct)
            assert len(direct.locator('body').inner_html()) > 60, f'{mid}: demonstração sem conteúdo'
            assert_no_horizontal_overflow(direct, f'{mid} preview', tolerance=4)
            test_interaction(direct, mid)
            direct.wait_for_timeout(150)
            assert_clean(errors)
            direct.close()
            checked += 1

        context.close()
        test_mobile_layout(browser)
        browser.close()

    assert checked == len(MODELS) == 35, f'esperados 35 modelos, validados {checked}'
    print(f'Chromium: {checked} modelos, navegação, scroll único, responsividade, cópia e interações críticas validados.')


if __name__ == '__main__':
    main()
