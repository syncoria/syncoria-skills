# Syncoria AI-DLC Methodology — Reference

This is the authoritative summary of the Syncoria AI-driven Lifecycle Collaboration methodology. Treat this as the source of truth for process, gates, and terminology. The templates for every artifact named here are listed, with links, in `template-library.md`.

---

## The six principles

1. **Standard-first, customize last.** Every gap is evaluated against the classification hierarchy in this order: Config → Process adaptation → Studio (no-code) → Syncoria product / asset → Community module → Custom development. Custom is the last option, not the first.

2. **Train before you gather requirements.** Customers cannot specify a system they have never used. Show standard Odoo first with their real data, let them use it for 5–7 days, then collect gap feedback. Real usage reveals genuine requirements; pre-training requirements are speculative.

3. **Iterate by business area, not by project.** Phases 2–4 (Exploration, Training & Gaps, Specification) loop per business area — usually one Odoo module, sometimes a flow that spans several (purchasing and inventory run as one, for example). One area at a time. SMB customers cannot process their entire business in parallel.

4. **AI drafts, humans validate.** AI eliminates mechanical document work (prep forms, process maps, spec drafts, UAT scripts). The OPL reviews every AI output before it goes to the customer. Customer-facing output is never raw AI.

5. **No build without a signed spec.** No developer touches code without a Technical Translation Document (TTD). No TTD exists without a corresponding signed Customer-Validated Behavior Specification (CVBS). The PM tool enforces both fields as required — the tool polices the gate, not the OPL.

6. **Async-first, respect SMB bandwidth.** Most discovery work happens between sessions via async forms the customer completes at their own pace. Live sessions have specific agendas and defined durations. Customer time is treated as scarce.

---

## The two scope-control artifacts

Scope is controlled by two complementary documents — the Charter and the PSS — plus the CVBS library.

### Project Charter (Artifact 01) — initiation

Lightweight. Signed at kickoff. Establishes that the engagement is aligned to begin: who is involved, the business goal, the high-level module list, governance, and communication norms. The Charter answers *"are we aligned to start?"*

### Project Scope Statement (Artifact 02) — complete scope

The full scope document. Covers everything outside customizations: configuration decisions per module, data migration scope, integrations, master data ownership, training, environments, reporting, go-live model, the explicit out-of-scope list, and assumptions. Signed twice:
- **PSS v1.0** at end of Phase 1 (initial scope, many items "TBD")
- **PSS v2.0** at end of Phase 4 (final scope, all items confirmed, all CVBSes referenced)

The PSS answers *"exactly what are we delivering?"*

### Project Control Register (Artifact 00) — what is currently true

The living, cited record of what is currently true across all phases, outside the 14 phase artifacts. Signed artifacts outrank it. See `control-register-rules.md`.

### CVBS Library (Artifact 08) — customizations

One CVBS per customization. Each signed before any TTD is written. Plain-English behavior spec with testable acceptance criteria.

### Together = complete signed scope

**PSS v2.0 + CVBS library + TTD register = complete authorized scope.** Anything not described in one of these is not in scope and is handled through the Change Request process.

**Why both Charter and PSS?** The Charter is a fast initiation document — it gets the project moving with alignment on team, goal, and governance. The PSS is the detailed scope contract that grows through discovery and locks at Phase 4. Keeping them separate means the Charter stays short and signable on day one, while the PSS captures the depth that only emerges as exploration proceeds.

---

## The eight phases

### Phase 1 — Kick Off & Orientation
- **When:** Week 1, one-time at project start
- **Goal:** Shared understanding of the methodology, agreed module scope, staging ready, **Charter signed + Module Scope List and Product Fit Check signed + PSS v1.0 signed**
- **Key activities:** Sales → delivery handoff and register bootstrap, kick-off meeting, sign Project Charter, sequence the Module Scope List, **Product Fit Check** (the Product Manager's written verdict per module: covered / partial / not applicable by a Syncoria product), draft and sign PSS v1.0 (with TBDs flagged), staging database created with all modules installed
- **Gate:** Signed Charter, signed Module Scope List with the Fit Check verdict, and signed PSS v1.0 before Phase 2 begins
- **Owner:** Management + OPL (Product Manager for the Fit Check)

### Phase 2 — Business Exploration (per business area)
- **When:** 1.5–2 weeks per area
- **Goal:** Capture how the customer works today in plain English. No Odoo shown yet. Confirmed current-state process map before training. PSS sections refined.
- **Key activities:** Async prep form 3–5 days before session, 60-minute exploration session (no system shown), AI drafts current-state process map, OPL reviews, customer confirms in writing.
- **Gate:** Written customer confirmation of process map before Phase 3
- **Owner:** OPL
- **AI assist:** Prompt 01 (prep form), Prompt 02 (process map), Prompt 08 (PSS sections)

### Phase 3 — Odoo Training & Gap Discovery (per business area)
- **When:** 2–3 weeks per area
- **Goal:** Customer understands standard Odoo for this area, has used it with real data, submitted structured feedback identifying genuine gaps. PSS reporting/training sections updated.
- **Key activities:** Configure standard staging with real data, 90-minute training session, 5–7 day practice period, async Gap Feedback Form, 45-minute Gap Review session, **Classification Audit** of the Gap Decision Log by the Consulting Lead (written, binding, target 2 business days), import templates handed to the customer's data owner.
- **Gate:** Joint Gap Decision Log with every gap classified **and audited**
- **Owner:** OPL + Customer (Consulting Lead for the audit)
- **AI assist:** Prompt 03 (gap form)

### Phase 4 — Gap Classification, Specification & Scope Confirmation
- **When:** 1–2 weeks per area, plus 1 week project consolidation
- **Goal:** Every gap requiring system change has a signed CVBS. PSS v2.0 finalized with all scope confirmed and CVBS library referenced. Customer signs PSS v2.0.
- **Key activities:** Re-run each gap through classification hierarchy, customization review, AI drafts CVBS, customer signs each CVBS, OPL writes TTD (filing a **Technical Consult Request** for any feasibility, effort or build-approach question). **At end of Phase 4, OPL produces PSS v2.0 from PSS v1.0 with all confirmed scope and CVBS references; customer signs PSS v2.0.**
- **Gate:** Customer signature on every CVBS AND on PSS v2.0 before Build Planning
- **Owner:** OPL
- **AI assist:** Prompt 04 (CVBS), Prompt 05 (TTD), Prompt 08 (PSS sections)

### Phase 5 — Build Planning
- **When:** 1 week, one-time after Phase 4 completes
- **Goal:** Signed Build Plan — every task sequenced, estimated, assigned — before any code
- **Key activities:** Consolidate TTDs into Build Register, AI proposes sequence, OPL validates, Consulting Lead architecture review, assign to developers, Dev Kickoff, developers confirm estimates, Data Migration Tracker planned (load order, owners, dates), customer reviews timeline, customer signs Build Plan.
- **Gate:** Signed Build Plan before development. PSS v2.0 + CVBS library + Build Plan together authorize development.
- **Owner:** OPL + Dev Lead
- **AI assist:** Prompt 06 (build sequence)

### Phase 6 — Build (Staging)
- **When:** 2–10 weeks depending on scope
- **Goal:** All customizations built to TTD, validated against CVBS, master data imported per PSS. Staging is a working replica before UAT.
- **Key activities:** AI scaffolds code from TTD prompt seed, developer reviews/completes/tests, Dev Gate self-certification, code review, OPL functional validation against CVBS, OPL Gate; master data imported per PSS data migration section and the Data Migration Tracker, customer spot-checks 10% of each import.
- **Gate:** OPL Gate per feature
- **Owner:** Dev + OPL

### Phase 7 — User Acceptance Testing
- **When:** 2–4 weeks
- **Goal:** Customer tests every signed CVBS using AI-generated UAT scripts. Clear pass/fail/new-request triage.
- **Key activities:** AI generates UAT scripts, UAT kickoff, customer runs scripts async, OPL triages every entry into Pass/Fail/New Request, finance walkthrough, key-user training, Practice Go-Live dress rehearsal, Go-Live Readiness Checklist, Go / No-Go.
- **Gate:** All CVBSes Pass status before Go-Live. New Requests have CRs. Go-Live Readiness Checklist green.
- **Owner:** Customer + OPL
- **AI assist:** Prompt 07 (UAT scripts)

### Phase 8 — Go-Live & Hypercare
- **When:** 3–4 weeks (per PSS go-live model)
- **Goal:** Clean go-live per the model defined in PSS, hypercare per its duration, formal handoff per its conditions
- **Key activities:** Pre-go-live prep, Go-Live day per PSS cutover plan, Hypercare per PSS schedule, formal handoff.
- **Gate:** Customer-signed Hypercare Summary marks formal project close
- **Owner:** OPL + Customer

### Running every phase
Throughout all eight: the register is kept current, a **Weekly Status Report** goes out every Friday against the signed plan, budget burn is escalated at 70% and 85% to the AM and Program Manager together, every new request becomes a Change Request, and every gate closes with a **Decision Confirmation Note** to the customer and a logged learning.

---

## The classification hierarchy

When evaluating any gap, apply in this order. Stop at the first answer that fits.

| Level | Resolution | Question to ask | Who rules | Typical effort |
|-------|------------|-----------------|-----------|----------------|
| 1 | **Config** | Can a setting change fix this? Note in PSS Section 3. | OPL, audited | ~1.5 hrs |
| 2 | **Process adaptation** | Can the customer change how they work to fit standard Odoo? | OPL, audited | ~1 hr discussion |
| 3 | **Studio (no-code)** | Can a Studio field, view tweak, or automation handle it? Requires CVBS. | OPL, audited | ~4 hrs |
| 4 | **Syncoria product / asset** | Do we already own something that covers this? Note in PSS §2 / §5. | **Product Manager — binding** | per product |
| 5 | **Community module** | Is there a well-maintained module that addresses it? Note in PSS §2. | Consulting Lead | ~8 hrs |
| 6 | **Custom development** | None of the above apply — requires CVBS + TTD + dev | Consulting Lead, then Dev Lead on approach | ~22 hrs avg |

**Level 4 is not advisory.** The Product Manager decides what a Syncoria product covers:

- **Covered** → the gap lands at level 4. Levels 5 and 6 are closed unless the OPL escalates and the Consulting Lead rules in writing that the asset doesn't fit this customer.
- **Partial** → record which part the product covers; only the remainder continues down to levels 5 and 6.
- **Not applicable** → continue to level 5.

The Consulting Lead rules on fit only when the OPL escalates; they don't second-guess what the product does. Only the Product Manager describes, demos, sizes or commits a Syncoria product's behaviour. **No classification is final until the Consulting Lead's Classification Audit** has upheld it in writing. Until the register's authority ladder carries a written rule for Product Manager rulings, the Classification Audit (A2) upholding a level-4 classification is what settles it.

**Custom integrations** and **custom reports rebuild** are tracked as separate effort categories and listed explicitly in the PSS (Sections 5 and 9 respectively).

---

## The 14 artifact templates

| # | Artifact | Phase | Owner | Sign-off |
|---|----------|-------|-------|----------|
| 00 | **Project Control Register** (living, cited: engagement facts, scope, decisions, assumptions, risks, questions, actions, tasks) | All | OPL | — (the phase-gate decision-confirmation note goes to the customer) |
| 01 | Project Charter | 1 | OPL | Customer |
| 02 | **Project Scope Statement (PSS)** | 1 + 4 | OPL | Customer (v1.0 + v2.0) |
| 03 | Module Scope List + Product Fit Check | 1 | OPL (Fit Check: Product Manager) | Customer |
| 04 | Process Prep Form | 2 | AI + OPL | — |
| 05 | Current-State Process Map | 2 | AI + OPL | Customer |
| 06 | Gap Feedback Form | 3 | AI + OPL | — |
| 07 | Gap Decision Log | 3 | OPL (audited by Consulting Lead) | Joint agreement |
| 08 | CVBS (Customer-Validated Behavior Specification) | 4 | AI + OPL | Customer |
| 09 | TTD (Technical Translation Document) | 4 | OPL | — |
| 10 | Build Register + Plan | 5 | OPL | Customer |
| 11 | UAT Acceptance Script | 7 | AI + OPL | — |
| 12 | UAT Log | 7 | Customer + OPL | Customer |
| 13 | Change Request | Any | OPL | Customer |
| 14 | Hypercare Summary | 8 | OPL | Customer |

## Supporting artifacts

| Key | Artifact | When | Owner | Sign-off |
|-----|----------|------|-------|----------|
| TCR | Technical Consult Request — the only door to Development Lead time before Phase 5 | Any, before 5 | OPL → Dev Lead | — (written answer) |
| DCN | Decision Confirmation Note — what was decided, assumed and excluded this phase | Every gate | OPL | Customer's written reply (lifts entries to A2) |
| WSR | Weekly Status Report — progress against the signed plan | Weekly | OPL | — |
| DMT | Data Migration Tracker — PSS §4 in working form, one row per dataset | 3 → 8 | Functional Consultant | — (customer confirms each spot-check) |
| GLC | Go-Live Readiness Checklist | 7 → 8 | OPL + Functional Consultant | Customer sponsor's written GO |

---

## Change Request root causes

When a CR is raised, classification determines whether it is chargeable:

| Root cause | Charge |
|------------|--------|
| Customer scope addition (not in signed PSS or any signed CVBS) | **Chargeable** |
| OPL specification gap (PSS or CVBS didn't capture known requirement) | **Absorbed — Syncoria** |
| Developer interpretation error (TTD was clear, build was wrong) | **Absorbed — Syncoria** |
| Odoo platform limitation (native behavior differed from reasonable expectation) | Case by case, escalate |

**The CR chargeability rate is the single most important methodology metric.** Rising chargeability rate = improving specification discipline. The PSS makes this clearer than CVBS alone could: scope additions to configuration, data migration, training, integrations, reporting, and go-live are now explicit CR scenarios.

---

## Project sizing model

| Tier | Modules | Custom gaps | Calendar | Syncoria hrs | Customer hrs |
|------|---------|-------------|----------|--------------|--------------|
| Small | 3–4 | 3–5 | 5–6 months | 90–120 | 40–55 |
| Medium | 5–6 | 7–15 | 6–8 months | 180–260 | 65–90 |
| Large | 7–8 | 16–30 | 9–12 months | 340–500 | 100–140 |

---

## Six success metrics (tracked quarterly)

1. **Rework hours per project** — should decline quarter-on-quarter
2. **CR chargeability rate** — target >60% chargeable at 6 months (most important)
3. **Kickoff → Build Plan duration** — should stabilize ±20% of estimate
4. **UAT bugs vs new requests ratio** — target <20% classified as bugs
5. **OPL hours per module** — actual within 15% of estimate
6. **Customer async response time** — target <3 business days median

---

## The non-negotiables

- **The register is read before anything is built or asked, and a settled entry changes only through a user-ruled conflict.** Out-of-scope items stay out unless a CR says otherwise.

- **No build without PSS v2.0 signed AND every relevant CVBS signed.** The Build Plan is authorized by these together.
- No TTD without a signed CVBS.
- No work on a new request without a Change Request.
- Custom development is the last classification option, not the first — and never past a Syncoria product the Product Manager says covers the gap (or past the covered part of a partial verdict), without a written Consulting Lead ruling.
- No Dev Lead or developer time before Phase 5 without an accepted Technical Consult Request.
- AI output is reviewed by the OPL before the customer sees it.
- Phases 2–4 run per business area, not in parallel.
