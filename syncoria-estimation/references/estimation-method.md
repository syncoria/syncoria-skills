# The Estimation Method — Procedure

Step-by-step for producing a defensible, ranged estimate. The goal: a number you can show your work for, that reflects the real scope, version/edition, and engagement model — never a false single point.

## Step 1 — Gather inputs (ask for what's missing)

Establish, and note which are firm vs. assumed:
- **Engagement model** — full-service, guided, DIY, or hybrid. This determines which effort profile you build. If unknown, ask, or estimate the models side by side.
- **Modules in scope** — the Odoo apps. Rough is fine early.
- **Odoo version** — central. Estimate against a specific version. If unknown, assume the current stable release and flag the sensitivity.
- **Edition** — Community or Enterprise. Modifies classification (see below). If unknown, ask or state the assumption.
- **Gap profile** — how many customizations, and rough complexity. Pre-discovery this is a guess; range accordingly.
- **Data migration** — sources, volume, history depth, source data quality.
- **Integrations** — external systems, direction, how many.
- **Training population** — how many users, how many roles, distributed or not.
- **Customer team capability** — critical for guided/DIY; assess honestly.
- **Special factors** — multi-company/currency/language, compliance, unusual industry.

The softer the inputs, the wider the range and the lower the confidence. Say so.

## Step 2 — Classify the work (defer to syncoria-odoo)

For each known or anticipated gap, get its classification from the `syncoria-odoo` skill: config / process adaptation / Studio / community module / custom / integration / report. Do not classify Odoo capability yourself — a wrong config-vs-custom call is the single biggest estimation error.

Apply version and edition here:
- **Version** changes what's native — the same requirement may be config in one version, custom in another. Classify against the stated version.
- **Edition** changes the ceiling — in Community, Studio-level gaps become custom development. If edition is Community, re-run classifications with that constraint.

Pre-discovery, you won't know every gap. Estimate a gap *profile* (e.g., "expect ~10 gaps: ~5 config, ~2 Studio, ~3 custom") from the modules and industry, and range on the count.

## Step 3 — Build up the effort (bottom-up)

Convert classified work to hours using `sizing-baselines.md`:
- Sum gap effort by classification (config × 1.5, Studio × 4, community × 8, custom × complexity-adjusted band).
- Estimate integrations and report rebuilds individually — never via the gap average.
- Add the methodology delivery effort — discovery, mapping, training, specification, testing, go-live, PM. On config-heavy projects this dominates the total; don't under-weight it.
- Add data migration effort scaled to volume and source quality.
- Add training effort scaled to population.

## Step 4 — Apply the engagement-model profile

Adjust the bottom-up build for the model (`engagement-models.md`):
- **Full-service** → the build-up as-is.
- **Guided** → strip most doing hours, keep and increase enablement/advisory/review, add escalation bank and risk buffer. Build from components, not from a discount.
- **DIY** → reduce to onboarding + checkpoints + support allowance; largely decouple from gap count; apply the floor.
- **Hybrid** → estimate each portion in its model and sum; add coordination PM.

## Step 5 — Cross-check against the tier

Compare your bottom-up total to the tier band in `sizing-baselines.md` for the module/gap count (full-service) or the appropriate fraction (guided/DIY). If you're far outside the band, something's off — re-examine before presenting. The tier is the sanity check on the build-up.

## Step 6 — Range and risk-adjust

Produce a **low–high range**, not a point:
- Base the low on things going smoothly, the high on the identified risks landing.
- Widen for: soft scope, new industry, heavy/unusual integrations, poor data quality, weak customer team (guided/DIY), Community edition, compliance.
- Attach a **confidence level** (High/Medium/Low) with the reason.
- Earlier phase = wider range. A pre-discovery estimate might be a 2× spread; a post-Phase-4 (signed CVBS) estimate can tighten considerably.

## Step 7 — State assumptions explicitly

List every assumption the estimate rests on: scope boundaries, version, edition, gap count/complexity, data volume and quality, integration specifics, customer capability, what's excluded. The assumptions are part of the estimate — they define the conditions under which the number holds, and they're what protects Syncoria when reality differs.

## Step 8 — Frame the pricing

Map the effort to the pricing approach for the model and phase (`pricing-models.md`): T&M vs. fixed-fee, and where in the phase sequence a fixed number becomes defensible (not before signed scope). Present the investment as a range with the pricing basis stated.

## Output of the method

A defensible estimate shows:
- The engagement model and what it includes/excludes.
- The build-up (gaps × classification × hours, plus delivery, data, training, PM) — the work shown, not just a total.
- A low–high range with confidence level.
- The version/edition assumed and its sensitivity.
- The full assumptions list.
- Customer-side effort, not just Syncoria's.
- The pricing basis.

Never hand over a bare number. The build-up and assumptions are what make it defensible and what prevent the dispute-and-overrun cycle.
