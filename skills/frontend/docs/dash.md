# Dash (Python)

App factory, layout, tabs, theme, components, and callbacks for Dash dashboards. Use with the frontend skill when stack = Dash. Goal: clean, pragmatic, easy to evolve and maintain. Align with the project’s existing dashboard (e.g. `manager/src/dashboard/`). Follow **architect** (structure, simple names, one purpose per module) and **code-style** (formatting, naming, final pass).

## Structure

- **App entry:** Single `app.py` — create `Dash`, set layout, register callbacks, inject global CSS.
- **Layout:** Root `layout.py` composes shell (e.g. `dcc.Tabs`); tab content in `tabs/<name>/layout.py`.
- **Tabs:** One folder per section: `tabs/<name>/` with `layout.py` (UI tree) and `callbacks.py` (callbacks).
- **Shared UI:** `components/` for tables, charts, utils. Constants in one place.
- **Constants:** `constants.py` at dashboard root for colors, borders, style dicts (`TAB_STYLE`, `TAB_SELECTED_STYLE`).

```
src/dashboard/
├── app.py              # create_app(), layout, register callbacks, _get_dark_css()
├── layout.py           # create_layout(...) → dcc.Tabs + tab children
├── constants.py        # DARK_BG, DARK_CARD, DARK_TEXT, ACCENT_COLOR, TAB_* ...
├── components/
│   ├── tables.py       # DataTable helpers, _table_styles()
│   ├── charts.py      # Plotly figures, shared layout/colors
│   └── utils.py       # Formatters, validators, small helpers
├── tabs/
│   ├── accounts/
│   │   ├── layout.py   # create_*_layout(...) → html.Div tree
│   │   └── callbacks.py # register_*_callbacks(app, ...)
│   └── ...
└── services/           # Optional: business logic used by callbacks
```

## Naming

- Layout builders: `create_<name>_layout` (e.g. `create_accounts_layout`).
- Callback registration: `register_<name>_callbacks` (e.g. `register_metrics_callbacks`).
- Private helpers: `_leading_underscore` (e.g. `_table_styles`, `_get_dark_css`).
- One purpose per module; simple, descriptive names.

## App Factory

- `create_app() -> Dash`: instantiate `Dash(__name__, assets_folder=..., suppress_callback_exceptions=True)`; set `app.title`, `app.layout = create_layout(...)`; inject global CSS via `app.index_string` and `_get_dark_css()` from `constants.py`; call each `register_<name>_callbacks(app, ...)`; return app.
- Callback registration lives in tab modules; app factory only calls them with required deps (e.g. repository).

```python
def create_app() -> Dash:
    app = Dash(__name__, suppress_callback_exceptions=True)
    app.title = "Dashboard"
    app.layout = create_layout()
    # Inject global CSS via app.index_string and _get_dark_css() from constants
    register_accounts_callbacks(app, repository)
    return app
```

## Layout and Tabs

- Root layout: one `html.Div(className="dashboard-container")`; children: `dcc.Tabs(id="dashboard-tabs", value=default_tab, children=[...])`, then `dcc.Store`, `dcc.Interval`, or status UI. Use constants for padding and background.
- Each tab: `dcc.Tab(label=..., value=..., children=[create_<name>_layout(...)], style=TAB_STYLE, selected_style=TAB_SELECTED_STYLE)`.
- Tab content: `create_<name>_layout(...)` in `tabs/<name>/layout.py` returns one `html.Div` with sections (headers, cards, placeholders). Use constants for background, text, borders, card style.

## Styling and Theme

- **Constants:** `DARK_BG`, `DARK_CARD`, `DARK_TEXT`, `DARK_BORDER`, `ACCENT_COLOR`, `ACCENT_RGB`, `LABEL_COLOR`, `ERROR_COLOR`, etc. in `constants.py`. Use in layout `style={}` and in `_get_dark_css()`.
- **Global CSS:** In `app.index_string`, inject a `<style>` block for body, `.dash-dropdown`, `.Select-control`, inputs, radio/checklist, buttons, `.dash-loading`, `.dash-table-container`, grids. Use the same constants (e.g. f-strings).
- **Cards/sections:** Consistent card: `backgroundColor: DARK_CARD`, `borderRadius: "12px"`, padding, boxShadow, marginBottom. Headers: `color: DARK_TEXT`, `fontSize: "1.3rem"`, `fontWeight: "600"`.
- **Buttons (primary):** e.g. `backgroundColor: ACCENT_COLOR`, `color: "#15161E"`, `border: "none"`, `borderRadius: "8px"`, padding, cursor, transition.

## Components

- **Tables:** Centralize `dash_table.DataTable` in `components/tables.py`: `_table_styles()` with `style_cell`, `style_header`, `style_data_conditional` from constants. Build columns and data in callbacks; pass shared styles.
- **Charts:** In `components/charts.py`, use Plotly (`go.Figure`) with shared layout (font, background, grid, accent). Export `_empty_figure()` and chart builders; keep axis/legend consistent with constants.
- **Utils:** Formatting (e.g. BRL), validation (e.g. lookback seconds), and small helpers in `components/utils.py`. Import constants when needed.

## Callbacks

- **Registration:** Each tab: `register_<name>_callbacks(app, ...)` in `tabs/<name>/callbacks.py`. Pass app and shared deps (repository, services).
- **Patterns:** `Input`, `Output`, `State`. Use `ctx.triggered_id` / `ctx.triggered` for multiple triggers; `no_update` when no change; `prevent_initial_call=True` or `"initial_duplicate"` where needed; `dash.dependencies.ALL` for dynamic ids.
- **IDs:** Stable ids for top-level containers; pattern-matching or `ALL` for lists (e.g. `{"type": "market-table", "table": "offers", "index": ALL}`).
- **Errors:** Log in callbacks; return safe default or `no_update`. Optional: `html.Div(id="status-message")` and `dcc.Store` for status.

## Evolvability

- Start minimal: add tabs and callbacks only when needed; reuse components and constants.
- Colocate tab logic: layout and callbacks for a tab in the same `tabs/<name>/` folder.
- Shared styling: new cards, tables, charts use `constants.py` and `components/` helpers.

---

After implementing, run **code-style** with the project Python style doc.
