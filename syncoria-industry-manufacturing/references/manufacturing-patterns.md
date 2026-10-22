# Manufacturing Implementation Patterns

Syncoria's accumulated patterns for manufacturing Odoo implementations. Patterns to ask better questions and avoid blind spots — not facts about any specific customer. Confirm everything against the actual customer; defer Odoo mechanics to the syncoria-odoo skill.

## Manufacturing modes (establish this first)

A manufacturer's mode drives almost everything downstream. Identify it early:

- **Make-to-Stock (MTS)** — produce to forecast, sell from inventory. Emphasis on demand planning, reorder logic, finished-goods inventory.
- **Make-to-Order (MTO)** — produce against confirmed orders. Emphasis on order-driven production, lead times, configure-to-order sometimes.
- **Engineer-to-Order (ETO)** — design/engineer per order. (Often its own engagement type — see the ETO industry skill when it exists.) Emphasis on project-linked manufacturing, one-off BoMs.
- **Process manufacturing** — formulas/recipes, batches, co-products/by-products, often regulated (food, chemical, pharma). Emphasis on batch traceability, yield, quality.
- **Mixed-mode** — most real manufacturers are some blend. Ask which products run which way.

The mode determines BoM structure, costing approach, planning logic, and which gaps will appear.

## Questions that surface real requirements (Phase 2 discovery)

Manufacturers under-describe their own complexity. Ask:

- Walk me through one product from raw material to shipped finished good — every step, every person, every system.
- Which products are made to stock vs. to order? Any configured/custom products?
- How many levels deep are your bills of materials? Do BoMs change often? Who controls changes?
- Do you subcontract any operations or whole products? How does material flow to/from the subcontractor?
- How do you track lots/batches? Is it required (regulation, recall) or nice-to-have? Forward and backward traceability?
- What happens to scrap, rework, and yield loss? How is it recorded and costed?
- How do you schedule production? By hand, by spreadsheet, by system? What constrains capacity — machines, people, tooling, materials?
- How do you capture what actually happened on the shop floor — quantities, time, downtime, quality? Paper, terminal, scanner?
- How do you cost a manufactured product? Standard cost, actual, both? How often do standards get revised?
- What quality checks happen, and where in the flow? Who signs off? What records must you keep?
- How do you handle engineering changes? Versioning of BoMs/routings?
- What do you do when you're short a component mid-production?

## Recurring gaps and their usual resolution

Patterns only — confirm Odoo specifics with the syncoria-odoo skill and the customer's edition.

| Recurring manufacturing gap | Usual resolution path | Watch for |
|------------------------------|----------------------|-----------|
| Multi-level BoMs with phantom/kit assemblies | Standard Odoo BoM config | Phantom BoMs vs. sub-assemblies change the picking/costing — confirm intent. |
| Subcontracting (operation or full product) | Standard subcontracting config | Multi-step or multi-vendor subcontracting can strain native; verify. |
| Lot/batch traceability (forward + backward) | Config (lot tracking per category) + reporting | Full genealogy reports often need report work. |
| Shop-floor data capture (qty, time, downtime) | Work orders + tablet/barcode (Enterprise) or custom | Native work-order capture is decent; deep OEE/downtime analytics often custom or external. |
| Finite-capacity / constraint scheduling (APS) | Often custom or external tool | Native scheduling is limited — flag early, don't over-promise. |
| Demand planning / S&OP / forecasting | Often external or custom | Weak natively. Don't imply Odoo covers this cleanly. |
| Quality checks in production flow | Quality module (Enterprise) config | Complex sampling plans / SPC may exceed native. |
| Engineering change management / BoM versioning | PLM (Enterprise) or custom in Community | True PLM is Enterprise; Community needs a module or custom. |
| Scrap, rework, yield costing | Config + possibly custom costing logic | Yield/by-product costing is where native costing strains. |
| Co-products / by-products (process mfg) | Config (where supported) → custom | Native support varies; verify for the version. |
| Standard vs. actual cost variance reporting | Config + report work | The reports are usually the real ask, not the costing itself. |
| Machine/PLC/SCADA integration | Custom integration | Each is a CVBS + TTD; specify direction, frequency, data. |
| Maintenance of equipment tied to production | Maintenance module config | Tight production-maintenance coupling may need custom. |

## Reports manufacturers almost always want

Surface these in PSS reporting scope so they're decided explicitly (rebuild in Odoo / external BI / out of scope):

- Production schedule / order status (what's running, what's late).
- Material requirements / shortage report (what's short for planned production).
- Lot/batch genealogy (full forward+backward traceability for recall).
- Yield and scrap analysis by product/line/period.
- Work-center utilization / OEE.
- Standard vs. actual cost variance by product/order.
- WIP valuation.
- On-time-in-full (OTIF) / production attainment.
- Quality non-conformance / defect analysis.

Manufacturers migrating from a legacy ERP usually have a large library of these — point external BI at Odoo for the long tail, rebuild the operationally-critical few natively. (Confirm the platform decision in the PSS — it moves the estimate more than almost anything.)

## Integrations that recur in manufacturing

Each is a customization (CVBS + TTD) or a vetted connector — defer mechanics to syncoria-odoo:

- Shop-floor / MES / machine data (PLC, SCADA, OPC-UA).
- PLM / CAD systems (BoM and engineering-change sync).
- Barcode / label printing (often Zebra/ZPL).
- Quality / LIMS systems (regulated industries).
- EDI with customers and suppliers (common in automotive, aerospace, retail-supplying manufacturers).
- Freight / logistics / 3PL.
- Legacy costing or financial consolidation systems.

## Compliance & traceability considerations

Flag these early — they drive scope and are easy to under-estimate:

- **Food / beverage:** allergen control, lot traceability, recall readiness, FEFO, sometimes specific certifications (HACCP, SQF). Allergen and label-artwork management often exceed native and need a module or custom.
- **Pharma / medical / chemical:** batch records, electronic signatures, audit trails, validation (GxP) — heavy compliance, often Enterprise + custom + careful validation scope.
- **Automotive / aerospace:** EDI, PPAP, serial traceability, customer-specific quality standards.
- **General:** country-specific manufacturing/environmental reporting.

When compliance is in play, it belongs explicitly in the PSS scope and out-of-scope sections — never assume the customer's regulatory needs are covered by standard Odoo without confirming.

## Costing — the recurring complexity

Costing is where manufacturing implementations most often run into trouble. Establish early:
- Standard vs. actual vs. average costing — and whether they want variance analysis (almost always yes).
- How overhead/labor is applied to manufactured cost.
- How often standards are revised and by whom.
- Whether co-products/by-products/yield affect costing.

The costing *method* is usually configurable; the costing *reports and variance analysis* are usually where the real work (and the real scope) lives. Defer the exact Odoo costing mechanics to syncoria-odoo, but make sure costing is a deliberate scope conversation, not an afterthought.
