# Odoo Module Mechanics & Standard-First Rules

Grounding for classifying gaps, writing configuration scope, drafting TTDs, and judging what is native Odoo behavior. This covers Odoo's core modules, their data models, and the decision rules for standard-first implementation.

When something here is uncertain or version-specific, say so and recommend verifying against current Odoo documentation (the product changes meaningfully each annual release). Do not present version-specific details as settled fact when they may have shifted.

## Table of contents
1. How Odoo is structured (apps, modules, models)
2. The standard-first classification hierarchy in practice
3. Core module reference (Sales, Purchase, Inventory, Manufacturing, Accounting, CRM, Project, HR, POS, eCommerce)
4. Cross-cutting mechanics (Studio, automations, reporting, integrations, multi-company)
5. Customization mechanics (what _inherit means, upgrade-safety, anti-patterns)
6. Common gap patterns and how they usually resolve

---

## 1. How Odoo is structured

**Apps vs modules vs models.** An "app" is a user-facing capability (Sales, Inventory). Under the hood it's one or more *modules* (technical packages), and each module defines *models* (database tables, e.g. `sale.order`). When scoping, customers think in apps; configuration happens at the module level; customization happens at the model level.

**Editions.** Community (open source, free) vs Enterprise (subscription, adds Studio, advanced accounting, many app features, mobile, support). Several capabilities customers assume are standard are Enterprise-only (notably Studio, full accounting automation, some quality/maintenance features, sign, marketing automation). Always confirm which edition is in scope — it changes what's "config" vs "custom."

**Editions matter for classification.** A gap that's a no-code Studio change in Enterprise may require custom development in Community. Never classify a gap without knowing the edition.

**The ORM.** Odoo models are Python classes mapped to Postgres tables. Fields, methods, and views are defined in the module. Customization works by *inheriting* these classes — extending behavior without editing core. This is why upgrade-safety is largely about how you inherit (see §5).

---

## 2. The standard-first hierarchy in practice

Apply in order; stop at the first that genuinely fits. The art is not stopping too early (forcing a bad process change) or too late (customizing what config handles).

| Level | What it means in Odoo | Tell-tale that this is the right level |
|-------|----------------------|----------------------------------------|
| 1 — Config | A setting, a configured record (pricelist, payment term, route, fiscal position), an activated feature flag in Settings. | The capability exists; you just turn it on or fill it in. No new fields, no code. |
| 2 — Process adaptation | The customer changes how they work to match Odoo's standard flow. | Odoo does this well, just differently from the customer's current habit. The difference is habit, not requirement. |
| 3 — Studio (no-code) | Add a field, modify a view, add an automation rule, build a simple report — all via Studio UI (Enterprise). | Small additive change to an existing model/view; logic is simple (set a value, send a notification, make required). |
| 4 — Community module | Install a vetted OCA or marketplace module that already does it. | A whole sub-capability is missing but is a common need others have solved (e.g., specific localization, a known connector). |
| 5 — Custom development | New Python logic, complex constraints, new models, real integrations. Requires CVBS + TTD. | The behavior is genuinely specific to this customer and none of the above reach it. |

**Integrations** (external systems) and **report rebuilds** are tracked separately from this hierarchy because they're their own effort categories, but they still get specified as customizations (CVBS + TTD) when they require code.

**The most common classification errors:**
- Calling something "custom" that's actually a pricelist/route/fiscal-position configuration.
- Calling something "config" that actually needs a Studio field plus an automation (small, but it's level 3, and in Community it's custom).
- Accepting a customer's "we need X built" at face value without checking whether standard Odoo already does X a different way (→ process adaptation).

---

## 3. Core module reference

For each: what it's for, key models, what's strong out-of-the-box, and where gaps commonly land.

### Sales (`sale`)
- **Key models:** `sale.order`, `sale.order.line`, `res.partner` (customers), `product.product`/`product.template`, `account.tax`.
- **Strong standard:** Quotation→order→delivery→invoice flow; pricelists (incl. rules by qty/date/category); multiple delivery and invoicing policies; quotation templates; eSignature (Enterprise); customer portal.
- **Config handles:** payment terms, pricelists, delivery methods, quotation templates, invoicing policy (ordered vs delivered qty), down payments, sales teams, approval thresholds (via Studio/automation in some cases).
- **Common gaps:** complex approval matrices (often Studio automation or custom); margin rules beyond pricelists; commission schemes (often need a module or custom); industry-specific quote documents (report customization).

### Purchase (`purchase`)
- **Key models:** `purchase.order`, `purchase.order.line`, `res.partner` (vendors), `product.supplierinfo` (vendor pricelists).
- **Strong standard:** RFQ→PO→receipt→bill flow; vendor pricelists; reordering rules; multi-step approvals (config + Studio); blanket orders; drop-shipping.
- **Config handles:** approval thresholds, vendor price lists, reordering rules, purchase agreements, 3-way match (PO/receipt/bill).
- **Common gaps:** complex multi-tier approval routing; supplier scorecards/governance (often module or custom); RFQ comparison logic beyond standard.

### Inventory (`stock`)
- **Key models:** `stock.picking`, `stock.move`, `stock.quant` (on-hand), `stock.location`, `stock.warehouse`, `stock.lot` (lots/serials), `stock.rule`/`stock.route`.
- **Strong standard:** multi-warehouse, multi-location; routes (push/pull rules) for complex flows (cross-dock, multi-step receiving/delivery); lot/serial tracking; FIFO/Average/Standard costing; putaway/removal strategies (incl. FEFO); barcode (Enterprise); reordering rules.
- **Config handles:** warehouse/location structure, routes, costing method, lot/serial per category, putaway rules, units of measure, reordering.
- **Common gaps:** very specific picking logic; complex landed costs; integrations with WMS/3PL; specialized labels (report customization); some serial-tracking workflows.
- **Routes are powerful and under-used** — many "we need custom flow" requests are actually configurable routes. Check before classifying custom.

### Manufacturing (`mrp`)
- **Key models:** `mrp.production` (manufacturing order), `mrp.bom` (bills of materials), `mrp.workorder`, `mrp.workcenter`, `mrp.routing` (operations).
- **Strong standard:** multi-level BoMs; BoM variants; work orders and work centers; backflushing; subcontracting; basic MPS (Enterprise); PLM (Enterprise, version/ECO management); quality checks (Enterprise).
- **Config handles:** BoM structure, routings, work centers, manufacturing readiness rules, subcontracting.
- **Common gaps:** finite-capacity scheduling / APS (Odoo's is limited — often a module or external tool); complex shop-floor data capture; advanced costing roll-ups; true PLM if Community edition.
- **Caution:** S&OP and demand-planning are weak natively — frequently external or custom. Don't over-promise here.

### Accounting (`account`)
- **Key models:** `account.move` (journal entries AND invoices/bills — same model), `account.move.line`, `account.journal`, `account.account` (chart of accounts), `account.payment`, `account.tax`, `account.analytic.line`.
- **Strong standard:** double-entry; multi-currency; tax engines + fiscal positions; bank sync and reconciliation (Enterprise has more automation); analytic accounting; asset management (Enterprise); deferred revenue/expense; localizations (country-specific CoA, tax, e-invoicing).
- **Config handles:** chart of accounts, fiscal periods, taxes, fiscal positions, payment terms, journals, bank feeds, analytic plans.
- **Common gaps:** specialized statutory reports (localization module or custom report); complex revenue recognition; industry-specific costing; certain e-invoicing/compliance regimes (check localization coverage).
- **Note:** `account.move` unifying invoices, bills, and journal entries surprises people — relevant when scoping reports and customizations.

### CRM (`crm`)
- **Key models:** `crm.lead` (leads AND opportunities), `crm.stage`, `crm.team`.
- **Strong standard:** pipeline stages, lead scoring (Enterprise), activities, email integration, lead assignment rules.
- **Config handles:** stages, teams, assignment rules, lost reasons, automated activities.
- **Common gaps:** complex territory/assignment logic; integration with external marketing tools; bespoke scoring.

### Project (`project`)
- **Key models:** `project.project`, `project.task`, `project.task.type` (stages).
- **Strong standard:** tasks, stages (kanban), timesheets, milestones, task dependencies (Enterprise), profitability (with timesheets + sale).
- **Config handles:** stages, task types, timesheet setup, billing from timesheets.
- **Note:** Project + Task are flexible enough that Syncoria's own AI-DLC tracking can extend them rather than building new models.

### HR suite (`hr`, `hr_holidays`, `hr_payroll`, `hr_recruitment`)
- **Key models:** `hr.employee`, `hr.contract`, `hr.leave`, `hr.payslip`.
- **Strong standard:** employee directory, org chart, leave management, recruitment, appraisals (Enterprise), expenses.
- **Payroll caution:** localized payroll is Enterprise and country-specific — coverage varies enormously by country. Confirm the localization exists before scoping payroll as "config."

### Point of Sale (`point_of_sale`)
- **Key models:** `pos.order`, `pos.session`, `pos.config`, `pos.payment`.
- **Strong standard:** offline-capable POS, multiple payment methods, sessions, cash control, restaurant features (Enterprise), loyalty.
- **Common gaps:** specific fiscal/receipt compliance by country; hardware integrations; complex promotions.

### eCommerce / Website (`website_sale`, `website`)
- **Strong standard:** product catalog from Odoo products, cart/checkout, payment providers, basic CMS.
- **Common gaps:** complex B2B portals; deep marketplace integrations (Amazon/Shopify) — usually connectors/custom; advanced merchandising.

---

## 4. Cross-cutting mechanics

**Studio (Enterprise).** No-code customization: add fields, edit form/list/kanban views, build automated actions (on create/write/time-based), create simple reports, build approval rules. The boundary of Studio: simple logic and additive fields. When logic gets conditional/multi-step or touches accounting/stock valuation, it's custom.

**Automated actions / server actions.** Trigger Python or no-code actions on record events or schedules. No-code automations are Studio/level-3; Python server actions are level-5 custom.

**Reporting.** Three native paths: (1) list/pivot/graph views + filters (config), (2) Studio reports or QWeb PDF reports (Studio→custom depending on complexity), (3) Spreadsheet dashboards (Enterprise). External BI (Power BI/Metabase) against the Odoo DB is common for heavy reporting — when a customer has 50+ legacy reports, pointing BI at Odoo is often saner than rebuilding each. Flag this in PSS reporting scope.

**Integrations.** Odoo exposes XML-RPC and JSON-RPC APIs; Enterprise adds more. Real integrations (Shopify, EDI, banks, SPS Commerce, etc.) are level-5 custom or vetted connectors. Each integration = its own CVBS + TTD (or module evaluation). Specify direction, frequency, field mapping, error handling, and which side owns what.

**Multi-company.** Native, but adds real complexity: inter-company rules, shared vs separate master data, consolidated reporting. Scope it explicitly; don't treat multi-company as a free toggle.

**Localizations.** Country packages bring CoA, taxes, e-invoicing, sometimes payroll. Coverage varies. Confirm the specific country's localization covers the customer's compliance needs before classifying compliance work as "config."

---

## 5. Customization mechanics (for TTDs)

**Inheritance is the whole game.** Customization extends core via:
- `_inherit = 'sale.order'` — extend an existing model (add fields, override methods). The default and safest.
- Never `_name`-override a core model or edit core files. That breaks upgrades.
- View inheritance via `xpath` — modify views without replacing them.

**Upgrade-safety rules for TTDs:**
- Prefer `_inherit` and standard hooks (e.g., overriding `action_confirm`, `create`, `write`) over patching internals.
- No hardcoded database IDs — use XML `ref()` / external IDs.
- No raw SQL where the ORM works.
- Don't duplicate standard fields; extend.
- Document which standard methods/hooks you depend on, because those are the upgrade risk surface.

**Anti-patterns to flag in any TTD review:**
- Overriding core methods without calling `super()`.
- New top-level models where extending an existing one would do.
- Studio fields that should be proper module fields (Studio customizations can be fragile across migrations and harder to version-control).
- Storing computed values without dependencies, or computing heavy logic on read.

---

## 6. Common gap patterns → usual resolution

A starting-point lookup. Always verify against the specific customer and edition.

| Gap pattern | Usual level | Notes |
|-------------|-------------|-------|
| "We need an approval step before X" | Config or Studio automation | Native approval features cover many cases; complex routing → custom. |
| "We need a custom field on the order/product" | Studio (Ent) / custom (Comm) | Trivial in Studio; a small module in Community. |
| "We need a specific document layout" | Studio report → custom QWeb | Simple → Studio; pixel-specific/conditional → QWeb custom. |
| "We need this number to flow to that report" | Config (pivot/filter) or report custom | Often a saved pivot/list view, not a build. |
| "We need finite-capacity production scheduling" | Module or custom/external | Odoo's native scheduling is limited — don't over-promise. |
| "We need demand planning / S&OP" | Custom or external | Weak natively. |
| "We need to sync with [external system]" | Connector or custom integration | Each is a CVBS + TTD; specify direction/frequency/ownership. |
| "We need a complex pricing rule" | Pricelist config → custom | Pricelists are powerful; check before custom. |
| "We need multi-step warehouse flow" | Routes (config) | Often configurable routes, not custom. |
| "We need 200 legacy reports rebuilt" | External BI + selective rebuild | Point BI at Odoo for the long tail; rebuild only the operationally-critical few natively. |
| "We need landed costs / complex costing" | Config + possibly custom | Landed costs are native (Ent); complex roll-ups may be custom. |
| "We need country compliance / e-invoicing" | Localization module → custom | Confirm localization coverage first. |

When a request doesn't fit any pattern here, reason from §2 (the hierarchy) and §3 (the module's standard capability), and if still unsure, say the classification needs validation against current Odoo docs or a quick staging test rather than asserting it.
