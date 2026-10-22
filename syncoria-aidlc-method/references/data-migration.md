# Data Migration Across AI-DLC

Data migration is not a single step — it is a **thread that runs across the whole methodology**, owned by the PSS and executed at go-live. Because it is spread across phases rather than being one named task, it is a classic place for things to fall through the cracks — especially source-data quality, which surfaces late but should shape effort early. Manage it as a continuous thread, not a Phase-6 event.

Consult this reference whenever migration is in play: scoping it, estimating it, drafting the PSS migration section, planning the build, or triaging where an in-flight project's migration actually stands.

## The one-line model

**Scope it in the PSS (drafted Phase 1, locked Phase 4) → plan it in Phase 5 → execute and spot-check in Phase 6 → test it in UAT (Phase 7) → cut over at Go-Live (Phase 8).** The PSS owns migration scope end to end; the phases progressively de-risk it.

## Where each part lives

### Phase 1 — Kick Off: first scoping (PSS v1.0)
Migration gets its first entry in **PSS Section 4 (Data Migration Scope)**, with TBDs: which datasets, rough volumes, how much history, which source systems, and an initial read on cutover approach. It is a placeholder at this stage — but it is on the record from day one, so it can never be "forgotten until go-live."
- **Prompt for:** source systems, the datasets that must come across (master data — customers, vendors, products, CoA, BoMs; and transactional/historical data), rough volumes, and how much history the customer believes they need.

### Phases 2–3 — Exploration & Training: the facts surface
This is where migration reality appears.
- **Phase 2 (Exploration):** you learn what data actually exists, where it lives, and its structure. Refine the PSS migration section.
- **Phase 3 (Training):** the customer uses **their real data** in staging. This is often where data-quality problems first become visible — duplicates, missing fields, inconsistent formats, junk records. Capture these; they drive cleanup responsibility and effort.
- **Source-data quality is the single biggest migration risk, and it is discovered here — mid-process — yet it should influence the effort estimated early.** When quality problems appear, flag them loudly and feed them back into scope and estimate; do not let them stay a Phase-3 footnote.

### Phase 4 — Specification: scope is locked (PSS v2.0)
Migration scope is finalized in **PSS Section 4** of v2.0 and signed. This is where it stops being a guess:
- Exact datasets and volumes; history depth (how many years/what cutoff).
- Cutover approach (big-bang vs. phased load).
- **Cleanup responsibility** — who cleans the data, customer or Syncoria, and by when.
- **Validation and reconciliation policy** — how migrated data will be checked and reconciled against the source.
- **Re-run policy** — whether/how imports can be re-run before go-live.
- Any **custom migration logic** (transformations, field mappings, deduplication rules) is specified here as its own work item — and if it needs code, it gets a CVBS + TTD like any customization.

### Phase 5 — Build Planning: migration is scheduled, not assumed
Migration work is sequenced into the **Build Plan** alongside customizations — estimated, assigned, and slotted into the timeline. Migration is real effort; planning it as an afterthought is how go-lives slip. Include dependencies (e.g., data cleanup must finish before final load).

### Phase 6 — Build: execution + the spot-check
Master data is imported into staging per PSS Section 4. The control here is the **customer spot-check: the customer verifies ~10% of each import** for accuracy. This is the hands-on migration step and the first real proof the data landed correctly.
- Run imports in dependency order (e.g., CoA and partners before transactions).
- Log what was imported, counts, and spot-check results. Discrepancies get resolved before UAT.

### Phase 7 — UAT: migrated data tested in context
The customer runs acceptance scripts against **real migrated records**, which surfaces data issues the spot-check missed — a customer who can't find their top account or whose opening balance is off will discover it here. Treat data defects found in UAT like any other UAT finding (fix vs. change request).

### Phase 8 — Go-Live: the final cutover
The production data load happens per the PSS go-live/cutover model:
- Final delta load (data changed since the staging load).
- **Final reconciliation against the source system** — the point where the books/records must tie out.
- The cutover is the point of no return; the PSS cutover plan governs timing, rollback criteria, and sign-off.

## The migration checklist by phase (what a well-run project always has)

| Phase | Migration checkpoint |
|-------|----------------------|
| 1 | PSS §4 drafted: datasets, volumes, history, sources (TBDs allowed) |
| 2–3 | Data facts refined; **source-data quality assessed with real data in training** |
| 4 | PSS §4 locked & signed: cleanup owner, validation/reconciliation policy, cutover approach, custom migration logic specified |
| 5 | Migration sequenced & estimated in the Build Plan; cleanup dependencies flagged |
| 6 | Imports run in dependency order; **customer spot-checks ~10% of each dataset** |
| 7 | Migrated data tested via UAT scripts; data defects triaged |
| 8 | Final delta load; **reconciliation against source**; cutover per PSS plan |

## How to use this when helping

- **Scoping / estimating:** pull migration into the estimate explicitly — datasets, volume, history depth, and especially the cleanup burden driven by source-data quality. Defer volume/complexity-to-effort judgment to the estimation skill; defer any Odoo import mechanics to the syncoria-odoo skill.
- **Drafting the PSS:** make Section 4 complete — never leave cleanup responsibility, validation policy, or history depth blank. Those blanks are where disputes and overruns start.
- **Triaging an in-flight project:** check where migration actually stands against this checklist. A project near go-live with no reconciliation policy or no spot-check done is carrying real risk — surface it.
- **The recurring failure to catch:** migration treated as a Phase-6 event instead of a Phase-1-to-8 thread. If the customer or team only starts thinking about data at build time, that's the signal to walk them back to the PSS and scope it properly.

## What this reference does not own

- **Odoo import mechanics** (import tools, field mapping specifics, model load order) → defer to the `syncoria-odoo` skill.
- **Converting migration scope into hours** → defer to the `syncoria-estimation` skill.
- **Industry-specific data patterns** (e.g., lot/batch history for manufacturing) → defer to the relevant `syncoria-industry-*` skill.

This reference owns the **methodology thread** — where migration is scoped, refined, locked, planned, executed, tested, and cut over across the eight phases.
