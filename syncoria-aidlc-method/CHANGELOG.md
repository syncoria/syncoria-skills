# Changelog — syncoria-aidlc-method

Semver per the Skill Operating Model §3.5: major = behaviour/lane change · minor = new content · patch = correction.

---

## 1.3.0 — 2026-09-30 · SCR-2026-003 · effective on install

**Theme:** the skill follows the templates. Every artifact now has a template of record in Syncoria's Drive library (`02 Artifact Templates`), and the skill mirrors it section for section. Decision by Fida, 2026-09-30: "Skill follows the templates", which brings in the six-level standard-first order, the Phase 1 Product Fit Check and the Phase 3 Classification Audit.

### Added
- **`references/template-library.md`** (new): the template of record for 00–14 and the five supporting artifacts, with Drive link, format, phase, Odoo project-template task IDs, owner and sign-off. Rules: copy, never edit the master; the spec mirrors the template; a customer's own template overrides; format follows the template; replace every placeholder; template changes go through an SCR. What to do when Drive can't be reached.
- **Six-level standard-first order:** Config → Process adaptation → Studio → **Syncoria product / asset** → Community module → Custom. Level 4 is ruled by the **Product Manager, binding**. Covered closes levels 5–6 unless the OPL escalates and the Consulting Lead rules in writing that the asset doesn't fit; partial lets only the uncovered remainder continue; not applicable continues.
- **Markers:** `[PENDING — Product Manager verdict]` in drafts (03, 07, CVBS); `NOT ESTABLISHED` in a review record or TTD, blocking. One verdict source everywhere: the Product Fit Check (Artifact 03) or a written Product Manager ruling on the gap, recorded in the register.
- **Interim authority rule:** until the register's authority ladder has a row for Product Manager rulings, the Consulting Lead's Classification Audit (A2) upholding a level-4 classification is what settles it.
- **Phase 1 Product Fit Check** (Artifact 03 is now "Module Scope List & Product Fit Check") and **Phase 3 Classification Audit** (written, binding, Consulting Lead; Gap Decision Log not final until recorded).
- **Supporting artifact specs:** TCR (the only door to Development Lead time before Phase 5), Decision Confirmation Note, Weekly Status Report, Data Migration Tracker (standard load order, G/I/L dropdowns), Go-Live Readiness Checklist (23 standing Area · Check · Why rows).
- SKILL.md: "When you build" bullets for templates of record, drafted ≠ blank template, supporting-artifact rules; two new "don't" lines (don't describe Syncoria products; don't treat a classification as final before the audit).

### Changed
- **`artifact-specs.md` rewritten** to mirror the templates: headers, meta labels (per-area artifacts use the template's **Module** label with the business area written there), sections, tables and columns, sign-off texts. CVBS §3.5 is "What must NOT happen"; the level-4 verdict is required in CVBS §1 whenever the module's Fit Check is covered or partial. TTD §3.3 is Search surface · Finding with the eight surfaces named; §3.4 is # · Build unit · Traces to AC · Notes. The DCN never carries authority-ladder verdicts.
- **`ttd-construction.md`:** §3.1 row 4 is "Syncoria product / Community / OCA module", Product Manager verdict first; §11.3 gains a Blocking? column; §3.3/§3.4 columns match the template; note that the four-row table in `ttd-exemplars.md` §1 predates the six-row rule, and the rule wins.
- **`methodology.md`:** six-level hierarchy with who rules each level; Fit Check, Classification Audit, TCR, DMT, GLC placed in their phases; "Running every phase" section; per-business-area rule.
- **`artifact-dependencies.md`:** 03 requires the Fit Check verdict; 07 is Phase 3–4 and audited; 08 resolution list includes process adaptation and Syncoria product; Rulings Register maintained by the Consulting Lead; entries for TCR, DCN, WSR, DMT, GLC.
- **`document-generation.md`:** format follows the template (docx vs xlsx); supporting-artifact header values (DCN → "DCN"); drafted vs blank template.
- **Description** rewritten to name the supporting artifacts and the template library (1004 → 1015 characters).

### Fixed (pre-release audit, same release)
Independent audit (subagent, no authoring context) found 3 blocking defects, all fixed: the UAT Log template's bug-share formula (now `=IFERROR(B5/(B5+B6),0)`); TTD template §3.3 rows not matching the eight surfaces; `syncoria-customization-review` still on five levels (paired release 1.2.0). Should-fix and nits fixed: marker and source unification, covered/partial semantics, CVBS template instruction carrying the Product Manager verdict, CVBS §5 segregation-of-duty row, DCN header code, meta labels, PSS prefilled rows, Hypercare sign-off text, GLC wording ("inventory tracking NOT set").

### Fixed (eval round, same release)
Separate answerer and grader on the new cases: 2/9 pass. Most answers met their own checklists but invented detail. Fixed in the text:
- **Customer-template differences are always reported** for the learning log (`template-library.md` rule 3, `document-generation.md`, `artifact-specs.md`); the answerer had decided a difference was "nothing to log".
- **Proposed criteria are marked** `proposed — derived from [source]` in the CVBS self-check, and a citation is used only for what its source says. SKILL.md's never-invent rule now names the allowed markers and forbids marking an unconfirmed register write as done.
- **Provisional TTD** when only the level-4 verdict is `NOT ESTABLISHED`: drafted *not for build*, blocking in §11.3, out of the Build Register. The text previously both required and forbade the draft.
- **The read rule covers** framework helpers, the behaviour attributed to rejected hooks, and the Studio and automation limits; no blanket "every other internal was read".
- evals.md gains a standing Must-not for invented detail. **Not re-run after these fixes.**

### Notes
- **Templates corrected in the same release** (re-upload as new versions so links don't change): 08 CVBS, 09 TTD, 12 UAT Log, Decision Confirmation Note.
- **Known difference (open):** `scripts/brand.js` uses Teal/Amber; the templates follow Brand Guide V1.0_2026 (Relay `#C97B63`). Cosmetic; structure is what must match. Not changed here because `scripts/` wasn't available to this session.
- No change to `scripts/`, `ttd-exemplars.md`, `triage-playbook.md`, `control-register-rules.md`, `data-migration.md`.

---

## 1.2.0 — 2026-09-29 · SCR-2026-002 · effective immediately

**Theme:** stop settled things from coming back. Adds the **Project Control Register (Artifact 00)**, a cited, living register per engagement kept in the engagement's Claude Project knowledge, plus the behaviours that make it bite.

Driven by two observed failures (see SCR-2026-002): out-of-scope items repeatedly resurfaced as scope creep, and the Odoo Community edition decision was settled several times while Claude kept asking the question again. The second has a structural cause. The CVBS/TTD input checks and the sibling skills are written to *ask* for version and edition, and nothing told them the answer was already settled.

### Added
- **`references/control-register-rules.md`** (new; named so it can't be confused with an engagement's `project-control-register.md`): the rules, the register's §0–§9 structure, entry schema and status vocabulary, the A1–A5 authority ladder, citation format, the merge procedure, conflict handling, the phase-gate reconciliation and decision-confirmation note, bootstrapping on in-flight projects, write-back, and the template.
- **Register first:** step 0 of the input check. Read before any artifact, any answer about scope, decisions or commitments, and any merge.
- **Settled means settled:** settled entries are never re-derived from Claude's reasoning, template defaults, stale documents or earlier turns.
- **Ask-check:** nothing is asked that the register settles. It is stated with its ID instead. Settled facts are passed to `syncoria-customization-review` / `syncoria-odoo` on handoff.
- **Scope-creep check:** matches against out-of-scope, descoped or rejected-CR entries are flagged and routed to a CR or Work Order, never added to an artifact.
- **Engagement facts block:** reserved DEC-001…006 (version, edition, hosting, localization, users, go-live).
- **Conflicts go to the user every time:** no auto-change of settled entries; the current value governs until ruled; the ruling gets a source. A meeting cannot change signed scope (that is a CR candidate).
- **Register footer on every engagement reply:** version read (or a request to add or attach the register); changes and write-back status (or the full file plus a replace reminder); every pending conflict, re-asked until ruled; overdue items and unmerged material.
- Artifact 00 entries in `artifact-dependencies.md`, `methodology.md` (table, scope-control section, non-negotiable), `artifact-specs.md`, `triage-playbook.md` (Step 2b), `document-generation.md` (not generated).

### Changed
- **Description rewritten** to add the register triggers ("what was decided, assumed, promised or scoped") while staying under the ceiling (1014 → 1004 characters). Trimmed: the four-item quality-bar list (still in the body).
- CVBS and TTD dependency entries: version and edition come from DEC-001/002 when settled; ask only when not.
- Input check is now 0–7 (added 0 read the register and 7 merge back). The self-check lists the register IDs relied on and any pending conflicts.

### Fixed (pre-release audit and eval rounds, same release)
An independent adversarial audit (a subagent without authoring context) found 6 blocking and 17 should-fix defects. All blocking ones are fixed, along with the should-fix ones that change behaviour:
- **A settled item could never settle from chat.** The user's confirmation was A5, so the edition would have been re-asked forever: the SCR's own failure in a new form. Now a confirmation in chat stops the asking, and a ruling is not a ladder source.
- **"Settled" was defined two ways.** It is now one definition: a terminal status at A1–A3. A4/A5 entries are `Proposed` whatever their type.
- **The ask-check could suppress the review's instance read.** It now stops questions to people, never reads of the system. Expected values are never written into a review trace as if they had been read.
- **Pending conflicts had nowhere to live**, so they couldn't persist across chats. Added register §0c.
- **Staleness wasn't on the ladder** (a signed pre-sales SoW would have beaten a validated A2 assumption). Added a currency rule and a `Current?` ledger column.
- **Higher-authority contradictions had two answers.** An explicit CR or signed amendment is merged; anything else is a conflict, with the higher authority governing while it's pending.
- Also: the reference was renamed `control-register-rules.md`, so a knowledge search can't mistake it for an engagement's register. Rejected CRs are recorded as `SCP` exclusions. PSS §2 and CVBS §6 exclusions are seeded. The customer note is limited to DEC/SCP/ASM. The footer delivers the file on a schedule rather than every turn, and handles the no-register and declined cases. Merges assign concrete IDs, never invent part of a field (roles, titles), and give merge-raised OQs to the OPL. Description triggers restored ("generate", "Project Scope Statement", "where are we", "what next"): 1004 characters.

### Notes
- **Size:** SKILL.md 19.7 KB → 24.0 KB. The reference (`control-register-rules.md`, ~32 KB) is read only when creating or merging into a register, or when handling a conflict.
- **Blast radius:** every engagement conversation (footer); every artifact (register IDs in self-check); `syncoria-discovery-extraction` 1.1.0 (paired: emits the merge block); CASE-TTD-003 amended so asking for version and edition only applies when the register doesn't settle them.
- No change to `scripts/`, `ttd-construction.md`, `ttd-exemplars.md`, `data-migration.md`.

---

## 1.1.0 — 2026-09-22 · SCR-2026-001 · effective immediately

**Theme:** raise the TTD/CVBS quality bar from "well structured" to "provably the least custom code that satisfies the signed behavior."

Driven by the CVBS-014 / TTD-014 worked pair (Northwind Fabrication, purchase approval by buyer limit and category), which demonstrated enforceable behaviours the skill described only in outline. Lane unchanged: `syncoria-customization-review` still *proves* the four tests; this skill now governs how the proof lands in the document so it cannot be skipped.

### Added

- **`references/ttd-exemplars.md`** (new). Thirteen condensed gold-standard passages from the worked pair with weak-versus-strong comparisons, plus three CVBS passages that cap TTD quality. Explicitly framed as calibration, never content — every internal, volume and date in it is marked as belonging to the worked example.
- **The verification rule** (`ttd-construction.md`). Every Odoo internal named in a TTD is read off the deployed version's source and the customer's instance, and the read is dated in the §1 meta line and again in the §3.2 trace. Never recalled, never carried over from a previous project. Unverified internals ship as `[VERIFY: …]` markers and are listed as blocking assumptions: a TTD may carry them, a build may not start with them.
- **The namespace rule.** `syn_<module>_<feature>` modules, `syn_`-prefixed fields, `syn.`-prefixed models and xmlids, unless the customer's repo already uses another convention. Collision prevention starts at naming.
- **§3.1 alternatives-considered table, mandatory.** Walks the full standard-first ladder — configuration only, process adaptation (with the customer's answer and reason), Studio + automation, community/OCA module, new parallel construct, chosen approach — with every rung answered by name, and each rejection stated as a capability limit. "Fails the requirement" and "merely inconvenient" are explicitly different verdicts; the second sends you back to the customer rather than to the build.
- **§3.2b extension-point selection** (new subsection). Candidate hooks, the narrowest semantically correct one chosen, what was deliberately *not* extended, and the `super()` contract with the ordering guarantee it gives extensions already present.
- **§3.3 conflict clearance as an eight-surface table**, every row answered, "None found" required rather than optional. The eight are `conflict-detection.md`'s checks re-cut for the document (its check 1 splits in two; its check 8, upgrade fragility, is reported in §2b and §11.1 as a risk rather than a collision), and block E of the review handoff record uses the same eight in the same order, so answers copy across. Two are new to that skill as well — **a standard setting or native feature that decides the same outcome**, and **downstream consumers whose behavior changes as a side effect** (with intended side effects named and attributed to whoever confirmed them) — and two existed in the review but previously reached no document: *altering a standard workflow the customer depends on* and *duplicating an existing customization*.
- **§10.x standing technical criteria TC-01…TC-08** — the generic set (no-regression including existing automations, `super()` ordering, query-count assertion, no hardcoded ids, clean install/upgrade/uninstall on a production copy, recompute verification, pre-existing records unaffected, server-side security enforcement) carried into every TTD instead of reinvented per build.
- **The three completion tests**, replacing the single decomposition test: decomposition, **standard-first** (could a sceptical senior consultant still propose a cheaper path this document hasn't rejected by name?), and **collision** (if another addon extended the same hook tomorrow, would this still behave correctly?).
- **"The TTD quality bar"** section in `SKILL.md` — the four quality goals and the four structural requirements that carry them, visible without opening a reference.
- Required build units that were previously implicit: a **security unit**, a **test unit**, and a **data-preparation unit** wherever the build depends on master data existing at go-live.
- **The reuse sweep** — ten construct-family questions to put to `syncoria-odoo` and record before declaring anything net-new. Written as questions, not answers: the obligation is to have asked and written down the reply. `syncoria-odoo` owns what each construct is and whether it fits.

### Changed

- **`references/ttd-construction.md` rewritten in full.** Two disciplines became three (added: show your work on what you chose *not* to build). Adds a quality-goal → evidence-location → failure-condition map, the section structure (§1–§12 plus §2b) with a "fails if" per section, the mandatory edge-case classes, the transaction rule, the precedence rule, and a `§4.x new models` subsection that must be filled even to state that none are added.
- **§2 business context** now requires the cost of getting it wrong in **three** directions (too permissive / too restrictive / silent) and an explicitly declared fail-safe direction, so every ambiguous branch has a derivable default.
- **§2b concerns** now sweeps ten named categories — the same ten block F of the review's handoff record sweeps — with an AC citation per resolution, and closes with a stop-and-ask box.
- **§11.3 assumptions** now carry an "if wrong" consequence column and a **blocking / non-blocking** classification, closing with a gate box naming the blockers that must be confirmed in writing before build.
- **§10 developer AC** gains a "Verified by" column (automated test / migration test on a DB copy / timed test / manual check).
- **§8 and §9 N/A** must still record side effects rather than ending the section.
- **`references/artifact-specs.md` §09 renumbered** to match `ttd-construction.md` and the worked example. The previous ordering listed 2b before 2 and ran business context → solution strategy as 1 → 2, which conflicted with both. Now: 1 traceability · 2 business context · 2b concerns · 3 solution strategy · 4 data model · 5 business logic · 6 views · 7 security · 8 reports · 9 integrations · 10 developer AC · 11 upgrade risk · 12 scaffold prompt.
- **`references/artifact-specs.md` §08 (CVBS) expanded** with the ten-subhead acceptance-criteria coverage set (write under each or mark N/A with a reason), the singularity test and the note on criteria count, the review-verdict callout, the role-impact table, the process-flex question and its answer, and "out of scope is exhaustive, not illustrative."
- **`references/artifact-dependencies.md`** — TTD blockers now include the customization-review handoff record and read access to the deployed source; CVBS gains the coverage-set obligation and the note that CVBS coverage caps TTD quality.
- **`SKILL.md`** description extended to name the quality bar and the deferral to `syncoria-customization-review`; three new entries under "What you don't do."

### Fixed (post-review audit, same release)

An adversarial consistency audit was run against the rewrite before release. Corrections folded into this version:

- **§3.1 gains the process-adaptation rung.** The review's handoff record routes it to the alternatives table and `syncoria-odoo`'s canonical hierarchy includes it, but the table had five rungs and no home for it — the rung the exemplar itself calls "most often skipped."
- **§3.3 widened from six surfaces to eight**, aligned row for row with the review's block E. *Altering a standard workflow the customer depends on* and *duplicating an existing customization* existed as checks in `conflict-detection.md` but previously reached no document.
- **§2b widened from nine categories to ten** — "unstated edge cases" was dropped in the rewrite even though §2b's whole purpose is surfacing risk before the build detail, and §5.x sits after it. Security widened back from "security of the control" to general access and data exposure.
- **§4 restores relationships and `ondelete`** (a data-loss decision that was left to the developer) and **field labels and help text** (which the decomposition test simultaneously named as a business decision that must not be left open).
- **§11.1's "every internal is covered by an automated test"** re-expressed as a pairing checkable at sign-off: every internal listed in §11.1 has a matching named criterion in §10.
- **§12's "derivable only from §4–§7"** corrected — it self-contradicted the two requirements beside it, which pull constraints from §11.2 and the test instruction from §10.
- **"Narrowest, most semantically correct hook" given two checkable criteria** (fewest other callers; the hook's purpose matches what the build decides) so completion test 3 can actually be answered.
- **The reuse sweep rewritten as questions to put to `syncoria-odoo`**, dropping the "instead of Y" clauses that asserted which construct substitutes for which — those were product mechanics in a process skill's lane.
- **Verdict polarity fixed in the exemplar** (paired with `syncoria-customization-review` 1.1.0): "Test 1 standard-first: failed" reads both ways and appears on a customer-facing document. Now the fixed wording from that skill's block H.
- **Ticket-guidance circular reference resolved.** `syncoria-aidlc-method`, `syncoria-customization-review` and `ticket-intake.md` each deferred to another for what a "proportionate" ticket pair contains, and none defined it. Defined here, in the skill that owns document structure: what can never be dropped, what scales down, and the two-to-three-page rule of thumb.
- **Section count corrected** from "twelve" to "§1–§12 plus §2b" in three places; the read-date's home settled as both the §1 meta line and the §3.2 trace; handoff-record block→section mapping corrected to list all consuming sections.

### Notes

- No change to `scripts/generate_artifact.js`, `scripts/brand.js`, `references/methodology.md`, `references/triage-playbook.md`, `references/document-generation.md` or `references/data-migration.md`.
- **Blast radius:** every future CVBS and TTD; `syncoria-customization-review` (paired release 1.1.0, whose Step 9 now emits the fields these sections consume); `syncoria-estimation` indirectly, since alternatives and build units are now itemised enough to size. No lane boundary moved.
- **Known consequence:** TTDs get longer. That is intended — the added length is evidence that was previously either absent or held only in the consultant's head.
