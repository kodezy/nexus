---
description: Rust architecture — simple layout, pragmatic naming, one purpose per module.
alwaysApply: false
---

# Architect Guide (Rust)

## Objetivo

Manter a arquitetura Rust simples, clara e direta, no mesmo estilo do projeto: nomes de arquivos e módulos simples e descritivos, sem nomes compostos longos.

## Estrutura de pastas (padrão do projeto)

- **Raiz do código:** `src/` (crate root com `lib.rs` e/ou `main.rs`).
- **Binários:** `src/main.rs` para o binário principal; binários adicionais em `src/bin/<nome>.rs` (ex.: `src/bin/cli.rs`, `src/bin/worker.rs`).
- **Domínios no primeiro nível:** um módulo por domínio (ex.: `trading`, `game`, `vision`, `storage`, `dashboard`, `network`, `infra`), cada um como pasta `src/<domínio>/` com `mod.rs` ou como `src/<domínio>.rs`.
- **Subdomínios por necessidade:** dentro do domínio, agrupar por função quando fizer sentido:
  - `trading/services/` — serviços de domínio (analyzer, arbitrage, metrics, notifier, selector, availability, factory).
  - `trading/workflows/` — fluxos (base, start, finish, preparing, trading, handler).
  - `trading/signals/` — sinais (create, cancel, utils).
  - `game/actions/` — ações agrupadas por contexto: `auth/`, `gameplay/`, `market/`.
  - `dashboard/tabs/` — um módulo por aba (trading, market, arbitrage, metrics, workers, accounts, misc).
  - `vision/screens/components/` — componentes por contexto (auth, gameplay, market).
- **Evitar profundidade desnecessária:** dois níveis sob o domínio costumam bastar; três quando o domínio é grande e já segue esse padrão.

## Nomes de arquivos e módulos

- **Simples e diretos:** um ou poucos termos que descrevem o conteúdo.
- **Snake_case** para arquivos e módulos: `analyzer.rs`, `arbitrage.rs`, `create_offer.rs`, `scan_balances.rs`.
- **Preferir:** `notifier`, `metrics`, `selector`, `availability`, `factory`, `open_market`, `close_market`, `cancel_offer`, `create_offer`.
- **Evitar:** nomes compostos longos ou genéricos como `trading_metrics_service.rs`, `market_offer_creation_handler.rs`, `user_authentication_manager.rs`. Em vez disso: `metrics`, `create_offer`, `login_account`.
- **Verbo + substantivo quando for ação:** `create_offer`, `cancel_offer`, `scan_balances`, `open_market`, `login_account`, `select_character`.
- **Substantivo quando for conceito/serviço:** `analyzer`, `arbitrage`, `notifier`, `strategy`, `session`, `context`.
- **Módulo como pasta:** `trading/services/` → `trading/services/mod.rs` reexportando ou `trading/services.rs`; submódulos como `trading/services/analyzer.rs` (declarados em `mod.rs` ou no pai).

## Um propósito por módulo

- Cada arquivo deve ter uma responsabilidade clara (ex.: um workflow, um tipo de ação, um serviço).
- Se um arquivo crescer demais, dividir por responsabilidade e manter nomes simples (ex.: vários workflows em `workflows/`, vários serviços em `services/`).
- Evitar módulos “guardião” que só reexportam dezenas de coisas sem agrupar por conceito; preferir reexportar só o que é API pública do crate ou do módulo.

## Onde colocar código novo

| Tipo de código | Onde colocar (exemplos) |
|----------------|--------------------------|
| Serviço de domínio (trading) | `src/trading/services/<nome>.rs` (ex.: `metrics`, `analyzer`) |
| Workflow / fluxo | `src/trading/workflows/<nome>.rs` (ex.: `start`, `finish`, `trading`) |
| Ação de jogo | `src/game/actions/<contexto>/<nome>.rs` (ex.: `market/create_offer`, `auth/login_account`) |
| Aba do dashboard | `src/dashboard/tabs/<nome>/` com `mod.rs` e submódulos conforme o projeto |
| Componente de tela (vision) | `src/vision/screens/components/<contexto>/<nome>.rs` |
| Infra compartilhada | `src/infra/<nome>.rs` (ex.: `cache`, `logger`, `database`) |
| Modelos / repositório | `src/storage/models.rs`, `src/storage/repository.rs` ou módulos novos em `src/storage/` com nome simples |
| Binário extra | `src/bin/<nome>.rs` (ex.: `cli`, `worker`, `migrate`) |

## Exemplos de nomes (seguir este estilo)

**Bom:**  
`analyzer`, `arbitrage`, `metrics`, `notifier`, `selector`, `availability`, `factory`, `create_offer`, `cancel_offer`, `open_market`, `close_market`, `scan_balances`, `scan_my_offers`, `login_account`, `select_character`, `base`, `start`, `finish`, `preparing`, `trading`, `handler`.

**Evitar:**  
`trading_metrics_service`, `market_offer_creator`, `user_authentication_service`, `gameplay_market_open_action`, `dashboard_trading_tab_layout`.

## Imports e API pública

- Usar `mod` e `use` do caminho mais direto que o projeto já usa (ex.: `use crate::trading::services::analyzer::...`).
- Expor apenas o necessário no `lib.rs` ou no `mod.rs` do domínio; usar `pub use` para reexportar tipos e funções que são API pública do crate.
- Não criar novos “hubs” de reexportação sem seguir o padrão já usado no mesmo domínio.
- Preferir `pub(crate)` para itens usados só dentro do crate e `pub` apenas para o que for API externa.

## Resumo

- Estrutura alinhada ao projeto: domínio → subdomínio → módulos com nomes curtos.
- Nomes de arquivos/módulos: simples, pragmáticos, descritivos, em snake_case; evitar compostos longos.
- Um propósito claro por módulo; estrutura plana ou com poucos níveis.
- Colocar código novo no mesmo tipo de pasta e padrão de nome que o domínio já usa.
- Binários extras em `src/bin/<nome>.rs`; API pública via `pub`/`pub use` consciente.
