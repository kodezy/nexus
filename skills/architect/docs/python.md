---
description: Python architecture — simple layout, pragmatic naming, one purpose per module.
alwaysApply: false
---

# Architect Guide (Python)

## Objetivo

Manter a arquitetura Python simples, clara e direta, no mesmo estilo do projeto: nomes de arquivos e módulos simples e descritivos, sem nomes compostos longos.

## Estrutura de pastas (padrão do projeto)

- **Raiz do código:** `src/` (ou equivalente).
- **Domínios no primeiro nível:** uma pasta por domínio (ex.: `trading`, `game`, `vision`, `storage`, `dashboard`, `network`, `infra`).
- **Subdomínios por necessidade:** dentro do domínio, agrupar por função quando fizer sentido:
  - `trading/services/` — serviços de domínio (analyzer, arbitrage, metrics, notifier, selector, availability, factory).
  - `trading/workflows/` — fluxos (base, start, finish, preparing, trading, handler).
  - `trading/signals/` — sinais (create, cancel, utils).
  - `game/actions/` — ações agrupadas por contexto: `auth/`, `gameplay/`, `market/`.
  - `dashboard/tabs/` — uma pasta por aba (trading, market, arbitrage, metrics, workers, accounts, misc).
  - `vision/screens/components/` — componentes por contexto (auth, gameplay, market).
- **Evitar profundidade desnecessária:** dois níveis sob o domínio costumam bastar; três quando o domínio é grande e já segue esse padrão.

## Nomes de arquivos e módulos

- **Simples e diretos:** um ou poucos termos que descrevem o conteúdo.
- **Snake_case** para arquivos: `analyzer.py`, `arbitrage.py`, `create_offer.py`, `scan_balances.py`.
- **Preferir:** `notifier`, `metrics`, `selector`, `availability`, `factory`, `open_market`, `close_market`, `cancel_offer`, `create_offer`.
- **Evitar:** nomes compostos longos ou genéricos como `trading_metrics_service.py`, `market_offer_creation_handler.py`, `user_authentication_manager.py`. Em vez disso: `metrics`, `create_offer`, `login_account`.
- **Verbo + substantivo quando for ação:** `create_offer`, `cancel_offer`, `scan_balances`, `open_market`, `login_account`, `select_character`.
- **Substantivo quando for conceito/serviço:** `analyzer`, `arbitrage`, `notifier`, `strategy`, `session`, `context`.

## Um propósito por módulo

- Cada arquivo deve ter uma responsabilidade clara (ex.: um workflow, um tipo de ação, um serviço).
- Se um arquivo crescer demais, dividir por responsabilidade e manter nomes simples (ex.: vários workflows em `workflows/`, vários serviços em `services/`).
- Evitar módulos “guardião” que só reexportam dezenas de coisas sem agrupar por conceito; preferir reexportar só o que é usado fora do pacote.

## Onde colocar código novo

| Tipo de código | Onde colocar (exemplos) |
|----------------|--------------------------|
| Serviço de domínio (trading) | `trading/services/<nome>.py` (ex.: `metrics`, `analyzer`) |
| Workflow / fluxo | `trading/workflows/<nome>.py` (ex.: `start`, `finish`, `trading`) |
| Ação de jogo | `game/actions/<contexto>/<nome>.py` (ex.: `market/create_offer`, `auth/login_account`) |
| Aba do dashboard | `dashboard/tabs/<nome>/` com `layout.py`, `callbacks.py` conforme o projeto |
| Componente de tela (vision) | `vision/screens/components/<contexto>/<nome>.py` |
| Infra compartilhada | `infra/<nome>.py` (ex.: `cache`, `logger`, `database`) |
| Modelos / repositório | `storage/models.py`, `storage/repository.py` ou módulos novos em `storage/` com nome simples |

## Exemplos de nomes (seguir este estilo)

**Bom:**  
`analyzer`, `arbitrage`, `metrics`, `notifier`, `selector`, `availability`, `factory`, `create_offer`, `cancel_offer`, `open_market`, `close_market`, `scan_balances`, `scan_my_offers`, `login_account`, `select_character`, `base`, `start`, `finish`, `preparing`, `trading`, `handler`.

**Evitar:**  
`trading_metrics_service`, `market_offer_creator`, `user_authentication_service`, `gameplay_market_open_action`, `dashboard_trading_tab_layout`.

## Imports e API pública

- Importar do caminho mais direto que o projeto já usa (ex.: `from src.trading.services.analyzer import ...`).
- Em pacotes com `__init__.py`, manter `__all__` quando o projeto usar, listando apenas o que é API pública do pacote.
- Não criar novos “hubs” de reexportação sem seguir o padrão já usado no mesmo domínio.

## Resumo

- Estrutura alinhada ao projeto: domínio → subdomínio → módulos com nomes curtos.
- Nomes de arquivos/módulos: simples, pragmáticos, descritivos, em snake_case; evitar compostos longos.
- Um propósito claro por módulo; estrutura plana ou com poucos níveis.
- Colocar código novo no mesmo tipo de pasta e padrão de nome que o domínio já usa.
