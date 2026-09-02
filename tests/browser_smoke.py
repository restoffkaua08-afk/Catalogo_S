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
        if response.request.resource_type in {'document', 'script', 'stylesheet'}:
            errors.append(f'{label}: HTTP {response.status}: {response.url}')

    page.on('console', on_console)
    page.on('response', on_response)
    return errors


def assert_clean(errors):
    if errors:
        raise AssertionError('\n'.join(errors))


def test_catalog_navigation(page):
    assert page.locator('.category-card').count() == len(CATEGORIES), 'quantidade de categorias renderizada diverge do JSON'
    for category in CATEGORIES:
        page.locator(f'.category-card[data-category="{category["slug"]}"]').click()
        page.wait_for_function(
            "slug => location.hash === '#categoria=' + encodeURIComponent(slug)",
            category['slug'],
            timeout=3000,
        )
        assert page.locator('#context').inner_text().strip() == category['titulo']
        cards = page.locator('.demo-card')
        assert cards.count() == len(category['itens']), f'{category["slug"]}: quantidade de demos incorreta'
        for item in category['itens']:
            card = page.locator(f'.demo-card:has(.demo-id:text-is("{item["id"]}"))')
            assert card.count() == 1, f'{item["id"]}: card ausente na categoria'
            href = card.get_attribute('href') or ''
            assert href == item['caminho'], f'{item["id"]}: href divergente: {href}'
        page.locator('#homeBtn').click()
        page.wait_for_function("location.hash === ''", timeout=3000)
        page.locator('.category-grid').wait_for(timeout=3000)


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
        assert page.locator('#l01-count').inner_text().strip() == '1 produtos'
        page.locator('#l01-filter').click()
        page.locator('#l01-panel.open').wait_for(timeout=2000)
        return

    if mid == 'L02':
        page.locator('input[name="l02-cat"][value="Moda"]').check()
        assert page.locator('#l02-count').inner_text().strip() == '2 resultados'
        page.locator('#l02-clear').click()
        assert page.locator('#l02-count').inner_text().strip() == '6 resultados'
        return

    if mid == 'L03':
        page.locator('.chip[data-cat="Gaming"]').click()
        assert page.locator('#l03-rows .row:not([hidden])').count() == 1
        page.locator('#l03-sort').select_option('price-desc')
        return

    if mid == 'L04':
        page.locator('#l04-open').click()
        page.locator('#l04-drawer.open').wait_for(timeout=2000)
        page.locator('input[name="l04-brand"][value="Vertex"]').check()
        assert page.locator('#l04-grid .card:not([hidden])').count() == 2
        page.locator('#l04-close').click()
        page.wait_for_function("!document.querySelector('#l04-drawer').classList.contains('open')")
        return

    if mid == 'LG01':
        page.locator('#lg01-open-register').click()
        page.wait_for_function("document.querySelector('#lg01')?.classList.contains('show-register')", timeout=12000)
        form = page.locator('#lg01-register-form')
        form.locator('input[name="nome"]').fill('Pessoa Teste')
        form.locator('input[name="email"]').fill('teste@example.com')
        form.locator('input[name="senha"]').fill('SenhaTeste123')
        form.locator('input[name="confirmarSenha"]').fill('SenhaTeste456')
        form.locator('button[type="submit"]').click()
        assert page.locator('#lg01-register-message').inner_text().strip() == 'As senhas não coincidem.'
        page.locator('#lg01-back-login').click()
        page.wait_for_function("document.querySelector('#lg01')?.classList.contains('show-login')", timeout=12000)


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
            assert_clean(errors)
            detail.close()

            direct_path = model.get('template') if model['tipo'] == 'frontend' else 'backend/DB01-Banco-do-LG01/preview.html'
            direct = context.new_page()
            errors = attach_monitor(direct, f'{mid} preview')
            response = direct.goto(web_url(direct_path), wait_until='domcontentloaded', timeout=15000)
            assert response and response.status == 200, f'{mid}: preview direto indisponível'
            assert len(direct.locator('body').inner_html()) > 60, f'{mid}: demonstração sem conteúdo'
            test_interaction(direct, mid)
            direct.wait_for_timeout(150)
            assert_clean(errors)
            direct.close()
            checked += 1

        browser.close()

    assert checked == len(MODELS) == 21, f'esperados 21 modelos, validados {checked}'
    print(f'Chromium: {checked} modelos, navegação, previews, cópia e interações críticas validados.')


if __name__ == '__main__':
    main()
