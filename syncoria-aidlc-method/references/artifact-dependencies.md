# Artifact Dependency Map

The lookup table for the input check. For each artifact: phase, blockers (must have), recommended (strongly wanted), context (sharpens quality), what it produces, sign-off, and the template of record. Before building any artifact, find it here and check each input against what's available. Template files and links are in `template-library.md`; their structure is in `artifact-specs.md`.

**Tiers defined:**
- **Blocker** — the artifact cannot be accurate without this. Get it, or mark its absence loudly in the output.
- **Recommended** — the artifact is materially better with this; ask, but may proceed with flagged assumptions.
- **Context** — improves precision and tone; ask if not already known.

**New project vs. in-flight (the two paths):**
- **New / in-sequence project** — a missing blocker means the upstream step hasn't happened. ASK for it; don't invent it. Offer to build the upstream artifact first.
- **In-flight project** (joined mid-stream, artifacts never produced) — ASK first, but if the blocker genuinely doesn't exist, FALL BACK to the best available source rather than stalling. Fallback hierarchy for any missing input: signed artifact → unsigned/draft → adjacent material with the same info (discovery notes, demo records, configuration notes, stale SoW, go-live plan, emails) → what the user tells you directly → explicit `[MISSING — assumption: …]`. Always flag what you used and what was missing.

The per-artifact "blockers" below are what the artifact *needs*. On a new project, get them. On an in-flight project, get them or fall back and flag — never stall.

**Check the register before asking for anything below.** Every input listed here, and especially the engagement facts (Odoo version, edition, hosting, user count, industry), may already be settled in the engagement's Project Control Register. If it is settled at A3 or above, use it and cite the ID. Don't ask. See the ask-check in `control-register-rules.md`. The ask-check stops questions to people, never reads of the instance or source.

---

## 00 — Project Control Register
- **Phase:** All. Created at Phase 1 kickoff, or bootstrapped during triage on an in-flight project; merged into continuously; reconciled at every gate.
- **Blockers (to create):** Customer and project name; at least one source to seed it (the Charter, PSS v1.0, or on an in-flight project whatever exists).
- **Blockers (to merge):** The new source, identified and dated. It must not already be in the Sources ledger.
- **Recommended:** Structured meeting records rather than raw transcripts (from `syncoria-discovery-extraction` / `meeting-decisions`); signed artifacts; customer emails that confirm decisions.
- **Produces:** The cited, living register of engagement facts, scope (in, out, pending), decisions, assumptions, risks, open questions, action items and tasks. Every other artifact reads it first and merges into it afterwards.
- **Sign-off:** None, it's internal. The phase-gate **Decision Confirmation Note** (DCN, below) extracted from it goes to the customer, and their written reply lifts entries to A2.
- **Critical:** Settled entries change only through a user-ruled conflict. A meeting cannot change signed scope; that is a CR candidate. Full rules in `references/control-register-rules.md`.

## 01 — Project Charter
- **Phase:** 1 (Kick Off)
- **Blockers:** Customer name; the business goal/reason for the project; the high-level list of modules/business areas in scope.
- **Recommended:** Key stakeholders and their roles (sponsor, project lead, SMEs); rough timeline expectation; governance/communication norms; the sales → delivery handoff (proposal, estimate assumptions, what was promised and excluded).
- **Context:** Customer industry; company size; current systems being replaced.
- **Produces:** Lightweight initiation document. Answers "are we aligned to start?"
- **Sign-off:** Customer signs at kickoff.

## 02 — Project Scope Statement (PSS)
- **Phase:** 1 (v1.0 initial) and 4 (v2.0 final)
- **Blockers:** Project name; the module list (from Charter or Module Scope List); which version you're producing (v1.0 initial with TBDs, or v2.0 final).
- **Recommended (v1.0):** Project Charter (for goal, stakeholders, modules); customer industry (drives configuration and out-of-scope expectations); any known integrations; any known data-migration sources; the Product Fit Check verdict (Syncoria products in §2 and §5).
- **Recommended (v2.0):** Everything from v1.0 PLUS the signed CVBS library (referenced in §13); all confirmed process maps; the audited gap decision logs; configuration decisions surfaced during Phases 2–3; the Data Migration Tracker; the go-live plan.
- **Context:** Data volumes; user counts; existing reports/BI; environments/hosting; who owns master data post-go-live.
- **Produces:** The complete scope contract — everything except customizations. Answers "exactly what are we delivering?"
- **Sign-off:** Customer signs v1.0 (end Phase 1) and v2.0 (end Phase 4).
- **Note:** If asked for v2.0 and no v1.0 exists, say so — you can still produce v2.0 retroactively from current sources, but flag that the initial scope baseline was never signed, which weakens scope-change traceability.

## 03 — Module Scope List & Product Fit Check
- **Phase:** 1
- **Blockers:** The modules/business areas in scope; **the Product Manager's written Fit Check verdict per module** (covered / partial / not applicable). Without the verdict the list can be drafted but not signed, and Phase 2 can't open.
- **Recommended:** Dependency knowledge between modules (drives sequence — defer to `syncoria-odoo`); customer's priority order; a named customer owner per business area.
- **Context:** Which modules are phase-1 vs later; whether any business area spans several modules.
- **Produces:** Sequenced list of business areas to implement, with the Fit Check. Often embedded in Charter §3 and PSS §2.
- **Sign-off:** Customer.
- **Critical:** Never fill the verdict column yourself or describe what a Syncoria product does. That belongs to the Product Manager; mark it `[PENDING — Product Manager verdict]`.

## 04 — Process Prep Form
- **Phase:** 2 (per business area)
- **Blockers:** The business area being explored; the customer contact who will complete it.
- **Recommended:** Customer industry; anything already known about how they work in this area (from the register, kickoff and sales).
- **Context:** Session date (the form goes out 3–5 business days before); who attends.
- **Produces:** 5–7 question async form the customer fills before the exploration session, plus volumes, pain points and systems tables.
- **Sign-off:** None (it's an input-gathering form).

## 05 — Current-State Process Map
- **Phase:** 2 (per business area)
- **Blockers:** Exploration session notes (or equivalent raw capture of how the customer works today); the business area.
- **Recommended:** The completed Process Prep Form; attendee roles; the Module Scope List (to confirm boundaries).
- **Context:** Volumes/frequencies; pain points mentioned; exceptions/edge cases.
- **Produces:** Plain-English map of how the customer works TODAY. Customer-confirmed before training.
- **Sign-off:** Customer confirms in writing.

## 06 — Gap Feedback Form
- **Phase:** 3 (per business area)
- **Blockers:** The confirmed Current-State Process Map for this area (the form anchors questions to its steps).
- **Recommended:** Notes on what was configured in staging; the training date and practice window.
- **Context:** Anything the customer was skeptical about during training (to probe).
- **Produces:** Structured form forcing specific gap feedback after the practice period.
- **Sign-off:** None.

## 07 — Gap Decision Log
- **Phase:** 3–4 (per business area; classified in Phase 3, audited before Phase 4 specification starts)
- **Blockers:** The completed Gap Feedback Form (or the raw gaps the customer raised).
- **Recommended:** The Current-State Process Map; knowledge of standard Odoo capability for this area (to classify — defer to `syncoria-odoo`); the Product Fit Check verdict (level 4); the Rulings Register (maintained by the Consulting Lead — prior rulings on similar gaps).
- **Context:** Customer's relative priority on each gap; the customer's answer to "can your process flex to the standard flow?" for each gap.
- **Produces:** Every gap classified via the six-level standard-first hierarchy (config / process adaptation / Studio / Syncoria product / community module / custom), agreed jointly, then **audited in writing by the Consulting Lead**.
- **Sign-off:** Joint (OPL + customer agreement). Not final until the audit verdict is recorded.

## 08 — CVBS (Customer-Validated Behavior Specification)
- **Phase:** 4 (per customization)
- **Blockers:** The specific gap being specified; the resolution decision from the audited Gap Decision Log (config / process adaptation / Studio / Syncoria product / community module / custom, and why custom if so); the relevant step from the Current-State Process Map; **the `syncoria-customization-review` handoff record** (four-test verdict + trace) — its verdict goes in the CVBS §1 callout and its concerns become §5.
- **Recommended:** Signed PSS v1.0 (for scope context); the CVBS number (sequential); related CVBSes (to cross-reference and avoid overlap); confirmed Odoo version and edition (from register DEC-001/002 when settled; ask only if not); **real volumes** for the §3.10 timing criteria; the Product Manager's level-4 verdict — required whenever the module's Fit Check verdict is covered or partial.
- **Context:** Customer industry; constraints; data specifics that affect acceptance criteria; whether the customer was offered a process-flex to the standard flow and what they answered. That answer is a register `DEC`: check it before asking, and record it after.
- **Produces:** Plain-English behavior spec with testable acceptance criteria across the full coverage set. The customer signs this BEFORE any TTD.
- **Sign-off:** Customer (mandatory, before TTD).
- **Critical:** If the process step is missing, the CVBS floats with no anchor — this is a blocker, not a nicety. If the resolution decision is missing, you may be specifying something that should have been config or process change — push back before writing.
- **Coverage, not just correctness.** Criteria must be written under every subhead of the §3 coverage set (happy path, boundaries, alternate paths, exception states, negative, failure & recovery, reversal & correction, pre-go-live records, permissions & visibility, volume & timing) or marked N/A with a reason. **CVBS coverage caps TTD quality:** the ACs become the developer ACs one to one, so a missing category here becomes an unspecified branch the developer has to invent.

## 09 — TTD (Technical Translation Document)
- **Phase:** 4 (per customization)
- **Blockers:** (1) The SIGNED CVBS this TTD implements. No signed CVBS = no TTD. This is the methodology's hardest gate. (2) **The `syncoria-customization-review` handoff record** — the four-test verdict with its trace. Without it the "standard can't do this" claim is unverified and §3.2 / §3.3 cannot be written honestly. (3) **Read access to the deployed version's source and the customer's instance**, because every Odoo internal named in a TTD must be read and dated, never recalled. The register settles *which* version and edition (DEC-001/002). The instance read is still required for internals, but don't re-ask the edition to get it.
- **Recommended:** The CVBS acceptance criteria (they become developer AC, one to one); the relevant process-map step; knowledge of the Odoo models involved (defer to syncoria-odoo skill); related TTDs (for dependencies); the custom-addons repo at the deployed branch (for the conflict clearance); the repo's existing naming convention; the Product Manager's level-4 verdict for §3.1 row 4; any TCR answers for this gap.
- **Context:** Performance constraints; **real data volumes** (records per period, largest record size, concurrent users — they drive §2, the performance concern and the TC-03 query-count criterion); existing customizations on the same models; standard settings in the same feature area.
- **Produces:** The complete solution strategy, decomposed to the last implementable detail, with the business rationale carried alongside every technical decision, **and the evidence that this is the least amount of custom code that satisfies the signed behavior**. Sections §1–§12 plus §2b: 1 traceability, 2 business context, 2b concerns & pitfalls, 3 solution strategy (alternatives / review trace / extension-point selection / conflict clearance / build units), 4 data model, 5 business logic + edge cases, 6 UI & views, 7 access & security, 8 reports, 9 integrations, 10 developer AC + standing technical criteria, 11 upgrade risk & assumptions, 12 AI scaffold prompt.
- **Sign-off:** None (internal dev document), but gated by the signed CVBS.
- **This is the most important artifact the AI produces.** Read `references/ttd-construction.md` in full before drafting any TTD, and `references/ttd-exemplars.md` for the standard of writing. Together they carry the three disciplines (decompose to the last detail; carry the business case alongside the technical detail; show your work on what you chose *not* to build) and the three completion tests — decomposition, standard-first, collision — that separate a build-ready TTD from a vague one. A weak TTD is where projects bleed unbillable rework.
- **A TTD may ship with `[VERIFY: …]` markers for internals not yet read off the deployed source; a build may not start with them unresolved.** List every marker in §11.3 as a blocking assumption.
- **Critical:** If asked for a TTD without a signed CVBS, refuse to produce it as final. Offer to draft the CVBS first, or produce a clearly-marked provisional TTD that cannot go to a developer until the CVBS is signed. If the CVBS is thin or vague, strengthen the CVBS first — a TTD cannot be more precise than the CVBS it implements, and decomposing a vague CVBS means inventing scope.

## 10 — Build Register + Plan
- **Phase:** 5
- **Blockers:** The set of TTDs to be built (the register); developer count and availability.
- **Recommended:** Signed PSS v2.0 and signed CVBS library (these authorize the build together with the plan); TTD dependencies; the Consulting Lead's architecture approval; developer-confirmed estimates from Dev Kickoff; the Data Migration Tracker's dates; target go-live window.
- **Context:** Customer blackout periods; customer-side dependencies (data prep, sign-offs).
- **Produces:** Dependency-ordered build sequence, estimates, assignments, plain-English customer timeline, customer-side dependencies with owners.
- **Sign-off:** Customer signs the Build Plan. PSS v2.0 + CVBS library + Build Plan together authorize development.

## 11 — UAT Acceptance Script
- **Phase:** 7 (per signed CVBS, plus one end-to-end script per business area)
- **Blockers:** The signed CVBS(es) to test; staging access details for the tester.
- **Recommended:** Confirmation that the OPL Gate passed (staging matches the CVBS); test data the customer needs; the confirmed process map (for the end-to-end script).
- **Context:** How staging differs from production; tester's role/permissions.
- **Produces:** Step-by-step Pass/Fail/New-Request testing workbook the customer runs; every CVBS criterion maps to at least one step.
- **Sign-off:** The tester signs the script; the customer signs the completed UAT log.
- **Note:** When a project skipped formal CVBS (common in triage/retrofit), the UAT script can be built to double as a Scope-of-Work-of-record. Source it from the most current artifacts (go-live plan, configuration notes, demonstrated workflows) and flag that it's serving as retroactive scope.

## 12 — UAT Log
- **Phase:** 7
- **Blockers:** The UAT Acceptance Script(s) being executed.
- **Produces:** Recorded Pass/Fail/New-Request results per step, triage decisions, CR numbers for new requests, and the bug-share summary.
- **Sign-off:** Customer.

## 13 — Change Request
- **Phase:** Any
- **Blockers:** The request itself; what existing signed scope it relates to (which PSS section or CVBS, or "net new").
- **Recommended:** The root-cause classification (customer scope addition / OPL spec gap / dev error / Odoo limitation — drives chargeability); impact estimate.
- **Context:** Timeline impact; risk to existing scope.
- **Produces:** Scoped, classified change request with chargeability decision.
- **Sign-off:** Customer.

## 14 — Hypercare Summary
- **Phase:** 8
- **Blockers:** The hypercare issue log (what came up during hypercare and how each was triaged).
- **Recommended:** The go-live date; the PSS go-live/hypercare terms (duration, SLA) to confirm against.
- **Produces:** Close-out document summarizing hypercare, marking formal project end.
- **Sign-off:** Customer.

---

## Supporting artifacts

## TCR — Technical Consult Request
- **Phase:** Any, before Phase 5 (Dev Kickoff is the Dev Lead's default entry point)
- **Blockers:** The confirmed process-map step it concerns; the gap in the customer's own words; the classification attempted and why each lower level was rejected; **the specific technical question**.
- **Recommended:** The proposed behaviour in plain English; whether a customer call is requested, with the pre-stated question for it; the customization-review record if one exists.
- **Produces:** A one-page written request the Development Lead answers in writing (feasibility, approach, effort range).
- **Sign-off:** None. The Development Lead may return it as incomplete — that is the rule working, not a failure.
- **Critical:** Don't draft a TCR that hands problem definition to the Dev Lead ("can you work out what they need?"). If the process step or the classification attempt is missing, build those first.

## DCN — Decision Confirmation Note
- **Phase:** Every gate (and whenever high-impact `Proposed` entries need lifting to A2)
- **Blockers:** The engagement's register, reconciled for this gate.
- **Produces:** Customer-language list of decisions, assumptions relied on, confirmed exclusions and open questions with needed-by dates. Usually sent as an email; the template is used when a signature is preferred.
- **Sign-off:** The customer's written reply. Record it as an A2 source and promote the listed entries.
- **Critical:** Only DEC, SCP and ASM statements (plus the OQs the customer must answer). Never risks, tasks, chargeability views, ladder verdicts or conflict analysis.

## WSR — Weekly Status Report
- **Phase:** Weekly, all phases
- **Blockers:** The signed plan to report against (Charter/PSS early on, Build Plan once signed); the register's action items.
- **Recommended:** Hours consumed vs budget; open CRs; gate status per business area.
- **Produces:** One-page status: headline, gate status, done / next, customer actions outstanding (anything over 3 business days goes to the AM), risks, budget, open CRs.
- **Sign-off:** None.
- **Critical:** Status is measured against the signed plan, never against what was said in a meeting. At 70% and 85% of budget the escalation goes to the AM and the Program Manager together.

## DMT — Data Migration Tracker
- **Phase:** Started in Phase 3 (import templates handed over), planned in 5, executed in 6–8
- **Blockers:** PSS §4 (datasets, sources, history depth, cleanup owners).
- **Recommended:** Volumes per dataset; the customer's data owners; dates for staging load, practice go-live and production cutover.
- **Produces:** One row per dataset in the standard load order, with owner, cleanup date, template status and spot-check results per environment.
- **Sign-off:** None; each spot-check is confirmed by the customer in writing.
- **Critical:** Read `data-migration.md` whenever this is in play. A row with no owner or cleanup date before Phase 6 is a risk to raise, not a blank to fill.

## GLC — Go-Live Readiness Checklist
- **Phase:** 7 → 8, before Go / No-Go and cutover
- **Blockers:** The UAT Log status; the practice go-live results.
- **Recommended:** The cutover plan; the Data Migration Tracker.
- **Produces:** Every standing readiness check marked OK / Not OK / N/A with who checked and when, ending with the sponsor's GO / NO-GO.
- **Sign-off:** The customer sponsor's written GO.
- **Critical:** A "Not OK" row without a decision is a NO-GO. Defer to `syncoria-odoo` for what each Odoo check means on the customer's version.

---

## Quick dependency chains (the common "what's missing" reasoning)

- **CVBS** ← audited Gap Decision Log ← Gap Feedback Form ← Current-State Process Map ← Exploration notes. If someone asks for a CVBS and there's no process map, walk back up this chain to find where the project actually is.
- **TTD** ← signed CVBS. Always. No exceptions.
- **Phase 2** ← signed Module Scope List with the Product Fit Check verdict.
- **PSS v2.0** ← PSS v1.0 + signed CVBS library + confirmed process maps + audited gap logs + config decisions.
- **Build Plan** ← all TTDs + signed PSS v2.0 + signed CVBS library + architecture approval.
- **UAT script** ← signed CVBS (or, in retrofit, the most-current scope source available).
- **Go / No-Go** ← UAT Log (every CVBS at Pass) + practice go-live + Go-Live Readiness Checklist.
- **Every gate** ← register reconciled → Decision Confirmation Note sent.
- **Every artifact** ← the register (read first) → the register (merge after).

## When multiple artifacts are missing (typical of in-flight projects)

Don't try to build the requested artifact and all its missing ancestors in one shot. Surface the chain, tell the user where the project actually sits versus where the requested artifact lives, and propose the shortest path: either build upstream artifacts first in order, or (if go-live is close) use the triage-playbook's retrofit approach to create a combined scope-of-record. Let the user choose.
