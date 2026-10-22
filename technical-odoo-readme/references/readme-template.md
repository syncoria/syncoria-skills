# README template

Write `<module>/README.md` (see SKILL.md Step 5). Drop sections that genuinely do not apply; never
drop **Features** or **Main flows**. Keep PR IDs inline, oldest → newest.

---

```markdown
# <Module display name from manifest>

<One paragraph: the business problem this module exists to solve, in the words a
consultant would use with the client. No Odoo jargon in this paragraph.>

| | |
|---|---|
| Technical name | `<module_dir_name>` |
| Odoo serie | 19.0 (from manifest `version`: `19.0.1.0.0`) |
| Depends | `base`, `stock`, `sale_stock` (from the manifest) |
| License | `<manifest license>` |
| Author | `<manifest author>` |

## What it customises in Odoo base

| Base object | What base does | What this module changes |
|---|---|---|
| `stock.picking.move_ids` | returns every move, scrap included | redefined with a `domain` so the Operations tab, the reports and Barcode agree (#101, a1b2c3d4) |
| `stock.picking` form view | standard Operations tab | adds the Add Cases button and the payment columns (#118) |

Only rows that change base behaviour or extend base objects. New standalone
objects belong under Features.

## Features

Each main feature: what a user can now do, the code behind it, and every request
that built it, in order. Supporting plumbing needs no id.

### <Feature group, e.g. Delivery Slip report>

- **<Feature>** — <what it does, and the visible effect>.
  `<model>.<method>` in [models/stock_picking.py](models/stock_picking.py),
  view [views/stock_picking_views.xml](views/stock_picking_views.xml).
  (#101, #118, #240, a1b2c3d4)
- **<Feature>** — … (#118, ticket H4356)
- **<Feature>** — … (#240, task P20911)

### <Next group>

- …

## Main flows

### <Flow name, e.g. Add cases to a picking>

1. User opens a picking in state `assigned`; `show_add_case_button` computes
   true when any move line has `quantity > 0`.
2. Button `action_add_cases` groups `move_line_ids` by
   `product_id.case_product_id` and sums quantities.
3. For each case product it reuses an existing move on the picking or creates
   one, then …
4. Result: the case moves appear in the Operations tab and print on the
   delivery slip.

Trigger → steps → result. Real model and method names throughout.

## Models

| Model | Kind | Purpose |
|---|---|---|
| `product.fit` | new (`_name`) | catalogue attribute used by the website filter |
| `stock.picking` | extension (`_inherit`) | case handling, report fields |

## Views, reports and menus

- `report/stock_report_deliveryslip.xml` — Delivery Slip QWeb, adds payment
  terms and method (#240)
- `views/stock_menu.xml` — menu entries under Inventory
- …

## Data, security and assets

- `security/ir.model.access.csv` — ACLs for the new models
- `data/ir_cron_data.xml` — cron `<name>`, every `<interval>`, runs `<method>`
- `static/src/**/*.js` in `web.assets_backend` — <component / patch and effect>

## Requirements and configuration

<External pip packages, ir.config_parameter keys, settings page location,
manual steps after install. Omit if none.>

## Notes and known debt

<Reverted work, TODOs and FIXMEs found in the code, overrides of base methods
that no longer exist in this serie, anything left half-done by a migration.>

## History

Full commit list: `git log --oneline -- <module>`.
Requests that shaped this module, in order: #101, #118, #240, plus direct
pushes a1b2c3d4, b2c3d4e5.
```

---

## Style rules

- Name the file `README.md`, always, in every module.
- Relative markdown links from the module directory, so they resolve on GitHub.
- One feature per bullet. No bullet that says "various improvements".
- Request ids bare with `#` — GitHub, GitLab and Bitbucket all auto-link them
  inside the repo. Short SHAs plain.
- Tracker ids never bare: `H<n>` is written **ticket H4356**, `P<n>` is written
  **task P20911**, letter and digits unchanged. Never `#4356` — that is a
  request number, a different system.
- Do not invent a "Roadmap"; do not add badges; do not credit the AI.
- Tables only where there are at least two rows worth of content.
