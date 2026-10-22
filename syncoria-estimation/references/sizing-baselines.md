# Sizing Baselines

The effort numbers estimation builds on, taken from Syncoria's methodology sizing model. These are baselines to reason from — always adjust for the specific project, version/edition, and engagement model. They are starting points, not guarantees.

## Per-gap classification effort (full-service doing hours)

From the classification hierarchy. This is the effort to *resolve one gap* at each level, when Syncoria does the work:

| Classification | Typical effort (hrs) | Notes |
|----------------|----------------------|-------|
| Config | ~1.5 | A setting/record change. No code. |
| Process adaptation | ~1 (discussion) | Customer changes how they work; no system effort beyond agreeing it. |
| Studio (no-code) | ~4 | A field, view tweak, or automation. Requires CVBS. Enterprise only. |
| Community module | ~8 | Evaluate, install, configure a vetted module. |
| Custom development | ~22 (avg) | New logic/models. Requires CVBS + TTD + dev. Range widely by complexity. |

**Custom is a wide band.** ~22 hrs is an average; a simple custom field-plus-logic may be 8–12 hrs, a complex multi-model workflow or a real integration 40–80+ hrs. Get the complexity read from the `syncoria-odoo` skill, then place it in the band — don't apply the average blindly.

**Integrations and report rebuilds are separate categories**, each estimated on its own (an integration is effectively a custom-development item, often at the high end; a report rebuild ranges from trivial to significant). Never fold them into the generic gap average.

## Project tier baselines (full-service, whole project)

| Tier | Modules | Custom gaps | Calendar | Syncoria hrs | Customer hrs |
|------|---------|-------------|----------|--------------|--------------|
| Small | 3–4 | 3–5 | 5–6 months | 90–120 | 40–55 |
| Medium | 5–6 | 7–15 | 6–8 months | 180–260 | 65–90 |
| Large | 7–8 | 16–30 | 9–12 months | 340–500 | 100–140 |

Use the tier as a **sanity check** on a bottom-up estimate: if your gap-by-gap build-up lands far outside the tier band for the module/gap count, re-examine — one side is probably wrong. The tier is the cross-check; the bottom-up build is the estimate.

## What the Syncoria hours include (full-service)

The tier hours cover the whole methodology delivery, not just customization:
- Discovery, exploration, and process mapping (Phases 1–2)
- Training and gap discovery (Phase 3)
- Specification — CVBS, TTD, PSS (Phase 4)
- Build planning and build oversight (Phases 5–6)
- UAT support and go-live/hypercare (Phases 7–8)
- Project management throughout

So customization hours are only *part* of the total. A common estimation error is summing gap hours and calling it the project — the methodology delivery (discovery, training, PM, testing, go-live) is often the larger share, especially on config-heavy, low-custom projects.

## Rough effort distribution (full-service, typical)

As a sanity guide for a full-service project's Syncoria hours:
- Discovery / exploration / mapping: ~15–20%
- Training & gap discovery: ~15–20%
- Specification (CVBS/TTD/PSS): ~15–20%
- Build & build oversight: ~20–30% (scales with custom-gap count)
- UAT, go-live, hypercare: ~10–15%
- PM / overhead: ~10–15%

A config-heavy project shifts weight toward training and discovery; a custom-heavy project shifts toward specification and build. Let the gap profile move these.

## Version & edition adjustment

- **Version** is central to estimation because capability and defaults shift across annual releases — a gap that needs custom work in an older version may be native later, and vice versa. Always estimate against a stated version; get the version-specific capability read from `syncoria-odoo`.
- **Edition** modifies classification: Studio, advanced accounting automation, several quality/maintenance/PLM features are Enterprise-only. In Community, a gap that would be a ~4-hr Studio change becomes custom development (~22-hr band). When edition is Community, re-run the gap classifications with that constraint — it can materially raise the estimate.
- **Migration/upgrade projects** (existing Odoo on an old version → new) carry their own effort not captured above — assess separately and defer the upgrade-risk read to `syncoria-odoo`.

## Customer-side hours matter too

The tier table includes customer hours because in guided and DIY models the customer's effort is central — and in full-service it still gates the timeline (they must do async forms, training, UAT, data prep). Always state customer-side effort in an estimate; underestimating it is how timelines slip regardless of Syncoria hours.

## Adjustment factors to apply

Widen or shift the estimate for:
- **Soft scope** (pre-discovery) → wider range, lower confidence.
- **New industry for Syncoria** → add discovery buffer.
- **Unusual/heavy integrations** → estimate each explicitly; high variance.
- **Large data migration / poor source data quality** → add migration and cleanup effort.
- **Large or distributed training population** → scale training hours.
- **Multi-company / multi-currency / multi-language** → adds configuration and testing complexity.
- **Regulatory/compliance requirements** → adds specification, testing, and documentation effort.
- **Community edition** → re-classify gaps upward as above.
