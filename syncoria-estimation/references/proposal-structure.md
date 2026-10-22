# Proposal Structure

How to build a customer-facing proposal from the estimate, rendered via the branded generator (`scripts/generate_artifact.js` in the syncoria-aidlc-method skill). Customer-facing tone throughout: the customer's language, the methodology *philosophy* (never the internal AI tooling), and honest ranges.

## Before building: what a proposal needs

A completed estimate (via `estimation-method.md`), the chosen engagement model(s), and the pricing basis. If the user wants to present options, build one proposal that compares models rather than three separate documents.

## Section structure

Build the generator spec with these sections (adapt to the deal):

1. **Executive summary** — the customer's goal in their words, what Syncoria proposes, the engagement model, and the headline investment range. Short.

2. **Understanding your needs** — restate the customer's situation, current systems, and objectives. Shows you listened; anchors scope.

3. **Scope of engagement** — modules/business areas covered, the Odoo version/edition, and explicitly what's **not** included. The exclusions list is as important as the inclusions — it's the scope boundary.

4. **Our approach** — the methodology philosophy: standard-first, train-before-requirements, iterate by module, no build without signed spec. Communicate the *discipline and why it protects the customer* — never mention internal AI tooling or the skills. This is the trust-builder.

5. **Engagement model** — which model (full-service / guided / DIY / hybrid), what Syncoria does, what the customer does, and why this model fits them. If comparing models, this is the comparison section: same scope, three columns, with the effort/cost vs. customer-responsibility trade-off made explicit.

6. **Investment** — the ranged price with its basis (T&M/fixed, per `pricing-models.md`), phased or by workstream where possible. Include the customer's own time commitment. Range, not false point.

7. **Assumptions & dependencies** — every assumption the estimate rests on (scope, version, edition, gap profile, data, integrations, customer capability) and what Syncoria needs from the customer. This section protects both sides and sets expectations.

8. **Timeline** — indicative phases and duration (ranged), tied to the sizing model's calendar bands. Flag that timeline depends on customer responsiveness.

9. **Why Syncoria / next steps** — brief credibility and a clear next action (usually: commit to discovery/specification, with the build priced once scope is signed).

## Rendering

Build a generator spec (per the artifact-specs approach in syncoria-aidlc-method) with:
- Cover banner: "PROPOSAL" eyebrow, the project/customer name, a one-line subtitle.
- Sections as above using `section`, `para`, `table` (for scope lists, model comparison, investment breakdown), `callout` (for the approach/philosophy and key assumptions), `bullets` (exclusions, dependencies).
- No sign-off block by default (a proposal isn't a signed artifact) — end with next steps, unless the user wants an acceptance/signature page.

Run it through `scripts/generate_artifact.js` so the proposal carries the Syncoria brand exactly, like every other document.

## Tone rules for proposals

- **Customer's language, not internal jargon.** No "CVBS", "TTD", "OPL", "gap classification" — translate to plain business terms. (Internally these structure the estimate; externally the customer hears "we specify each customization and you approve it before we build.")
- **Never mention AI tooling or the skills.** The methodology philosophy is the external story; the tooling is internal.
- **Honest ranges, visible assumptions.** A proposal that hides uncertainty behind a confident single number sets up the overrun the methodology exists to prevent. Ranged and caveated reads as *more* professional to a sophisticated buyer, not less.
- **Make the model trade-off explicit** when comparing — cheaper-for-Syncoria (DIY) means more-work-and-risk-for-customer. Let them choose informed.
- **Exclusions and assumptions are features, not fine print.** They define the boundary that protects the relationship. Give them real space.

## Comparing engagement models in one proposal

When the customer wants options, use a comparison table: rows = what's included, who does the work, Syncoria effort/cost range, customer effort, outcome-risk; columns = Full-Service, Guided, DIY. Then a short recommendation based on their team capability, urgency, and risk appetite — not just price. Recommending the honestly-right model (even if not the most expensive) builds the trust that wins the engagement.
