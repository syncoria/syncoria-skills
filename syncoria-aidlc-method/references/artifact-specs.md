# Artifact Specs — Exact Structure for the Generator

This is the authoritative structure for every AI-DLC artifact. It **mirrors the templates of record** in Syncoria's Drive (`template-library.md` lists each file and link): same sections, same order, same tables and columns. When producing a `.docx`, build a content spec matching the artifact here, then **run `scripts/generate_artifact.js`** to render it in house style. Never free-hand a docx — the script owns the brand; this file owns the structure; you supply the content. Workbook artifacts (11, 12, DMT, GLC) are produced as `.xlsx` with the sheets and columns given here.

## How to produce any artifact (the workflow)

1. Identify the artifact and confirm inputs (per `artifact-dependencies.md`).
2. Build a JSON spec following that artifact's structure below, filling real content into the blocks.
3. Run: `node scripts/generate_artifact.js <spec.json> <output.docx>`
4. The script applies the Syncoria brand (banner, Montserrat, section heads, instruction/fill/callout boxes, tables, sign-off). You never style anything by hand.

The spec shape and block types are documented at the top of `generate_artifact.js`. Common blocks: `section`, `subhead`, `para`, `instruction`, `fill`, `callout`, `bullets`, `numbers`, `table`, `space`, `pagebreak`. Set `"signoff": true` to append the signature block.

## Global rules

- **Header band of every artifact:** `artifactNumber`, `artifactName`, `subtitle` (the phase line, e.g. "Phase 2 · Business Exploration · Confirmed by Customer").
- **meta lines:** the document-information fields listed per artifact below, in that order.
- **Customer-facing artifacts** (Charter, PSS, Module Scope List, Process Map, Gap Decision Log, CVBS, Build Plan, UAT Log, CR, Hypercare Summary, Decision Confirmation Note) end with `"signoff": true`. The sign-off block is a Customer / Syncoria table with Name, Title, Signature and Date rows.
- **Internal or input-gathering artifacts** (Prep Form, Gap Feedback Form, TTD, TCR, Weekly Status Report) have no sign-off block.
- Use `instruction` blocks for "how to fill this in" guidance in **blank templates**. In a drafted artifact, replace instructions and `[fill]` placeholders with content; keep an instruction only where the customer still has to act (e.g. the Prep Form questions they answer).
- Use `fill` blocks for open answer areas, `callout` for emphasis, `table` for any structured content.
- Customer's plain language in customer-facing artifacts; precise Odoo terms in the TTD.
- **Business areas.** Per-area artifacts (04–07, CVBS, TTD) carry the template's meta label **Module**; write the business area there as the customer names it (e.g. "Purchasing & Inventory"), and where it spans more than one Odoo module, list the modules after it.

### The standard-first order (used by 01, 07, 08, 09 and the TCR)

Every gap is resolved in this order, stopping at the first level that works:

| Level | Resolution | Question | Who rules | Recorded in |
|---|---|---|---|---|
| 1 | Configuration | Can a setting change fix this? | OPL, audited | PSS §3 — no CVBS |
| 2 | Process adaptation | Can the customer change how they work to fit standard Odoo? Ask, and record the answer | OPL, audited | PSS §3 / process notes |
| 3 | Studio (no-code) | Can a Studio field, view or automation handle it? | OPL, audited | CVBS required |
| 4 | Syncoria product / asset | Do we already own something that covers this? | **Product Manager — binding** | PSS §2 / §5 |
| 5 | Community module | Is there a well-maintained module for it? | Consulting Lead | PSS §2 |
| 6 | Custom development | None of the above | Consulting Lead, then Dev Lead on approach | CVBS + TTD |

Level 4 is not advisory. The Product Manager decides what a Syncoria product covers — **covered**, **partial** or **not applicable** — and is the only voice on what it does:

- **Covered** → the gap lands at level 4. Levels 5 and 6 are closed unless the OPL escalates and the Consulting Lead rules in writing that the asset doesn't fit this customer.
- **Partial** → record which part the product covers; only the remainder continues down to levels 5 and 6.
- **Not applicable** → continue to level 5.
- **No verdict** → `[PENDING — Product Manager verdict]` in drafts; nothing goes to custom until it exists.

Until a written authority rule for Product Manager rulings is added to the register's authority ladder, the Consulting Lead's Classification Audit (A2) upholding a level-4 classification is what settles it.

---

## 00 — Project Control Register
Not rendered by the generator. It's a markdown file in project knowledge. See `control-register-rules.md`: structure in Part 2, entry schema in Part 3, template in Part 9. The Drive template is the same Part 9 template with a "how to use" comment block at the top; delete the comment block in the customer copy.

## 01 — Project Charter
Subtitle: `Phase 1 · Kick Off · Standard-first implementation`
meta: Customer, Project name, Version / status, Prepared by (OPL), Date.
aboutBox: the Charter answers "are we aligned to start?"; the detailed scope lives in the PSS.
Sections:
1. **Project Information** — two-column table (Item · Detail), first column shaded: Project name, Customer sponsor (name, title), Customer project lead, Syncoria OPL, Account Manager, Odoo version / edition / hosting, Start date, Target go-live. Version, edition and hosting come from register DEC-001…003 when settled.
2. **Business Goal** — instruction + two fills: *Why this project* (in the customer's words) and *What success looks like* six months after go-live (measurable where possible).
3. **Module Scope List** — table: #, Module / business area, In this phase?, Sequence rationale, Customer owner. Then subhead **Not in scope** + fill. Attach the Product Manager's Fit Check verdict (Artifact 03).
4. **Stakeholders & Roles** — table: Name, Organization, Role on project, Decides on, Time commitment.
5. **Governance & Communication** — two-column table (Item · Agreement): Status report (weekly, Fridays, from the OPL) · Project check-in (day/time, length) · Commercial review (monthly, first week, AM + OPL with sponsor) · Main channel (customer project lead ↔ OPL; no direct requests to consultants or developers unless the OPL arranges it) · Customer response time (3 business days for forms, questions and sign-offs) · Decision-makers · Escalation path.
6. **How the project runs** — para (eight phases; 2–4 repeat per business area; every phase ends with a signed artifact; nothing is built without a signed specification) + table: Phase, What happens, Signed at the end — one row per phase 1–8.
7. **Standard-First Commitment** — callout listing the six levels in order (configuration → process adaptation → Studio → Syncoria product → community module → custom development), plus a scope callout: anything not in the signed PSS v2.0, a signed CVBS or an approved CR is out of scope and goes through a Change Request.
Signoff: yes.

## 02 — Project Scope Statement (PSS)
Subtitle: `The complete agreed scope of the Odoo implementation — everything except customizations`
meta: Customer, Version (1.0 initial / 2.0 final), Status, Date, Prepared by (OPL). aboutBox explaining PSS + relationship to Charter and CVBS (PSS v2.0 + CVBS library = complete authorized scope).
Sections (14), each with an `instruction` box where the template has one, then the table or fill below. Keep the template's prefilled rows (the §4 policy rows, the §8 Staging and Production rows, the §10 handoff condition):
1. **Executive summary** — fill: goal, modules/business areas, go-live model and target date.
2. **Modules in scope** — table: #, Module, Edition / source (standard, Syncoria product, community), Sequence, Notes. Subhead **Not in scope** + fill.
3. **Configuration scope per module** — table: Module, Setting / area, Decision, Reason / gap #, Status (TBD / confirmed). v2.0 is complete and becomes the build and production-move checklist.
4. **Data migration scope** — callout "never leave this blank" + table: Dataset, Source system, Volume, History depth / cutoff, Cleanup owner & deadline, Import method + policy table (Policy · Agreement): Cutover approach · Validation & reconciliation (customer spot-checks ≥10% of each import and confirms in writing; totals reconciled to legacy) · Re-run policy · Open transactions at cutover (method for open POs, SOs, MOs, AR/AP, opening inventory, trial balance) · Custom migration logic. See `data-migration.md`; never leave cleanup responsibility, validation/reconciliation or history depth blank.
5. **Integrations scope** — table: Integration, Direction & data, Frequency, Error handling, Third-party account owner, Lead time. Syncoria connectors are described by the Product Manager only.
6. **Master data ownership** — table: Data, Owner before go-live, Owner after go-live.
7. **Training scope** — table: Audience, Format, Number of sessions, Materials.
8. **Environments & infrastructure** — table: Environment, URL, Purpose, Notes (Staging, Production rows at minimum).
9. **Reporting scope** — instruction (a changed PDF also touches email templates, automations and portal views) + table: Report / document, Standard / modified / new, Owner, CVBS # (if modified).
10. **Go-live model & hypercare** — two-column table: Go-live model, Target date, Hypercare duration, Hypercare support hours / SLA, Handoff to support conditions.
11. **Explicit out-of-scope** — exhaustive fill. Anything here requires a Change Request.
12. **Assumptions & dependencies** — table: #, Assumption / dependency, If wrong, Owner.
13. **Referenced CVBS library** — table: CVBS #, Title, Module, Signed date (empty in v1.0).
14. **Customer sign-off** — para on what signing v1.0 and v2.0 means.
Signoff: yes.

## 03 — Module Scope List & Product Fit Check
Subtitle: `Phase 1 · Kick Off · Sequenced list of modules to implement`
meta: Customer, Prepared by (OPL), Product Fit Check by (Product Manager), Date.
aboutBox: Phases 2–4 run one business area at a time in this order; the Product Manager reviews the list for Syncoria products before Phase 2 opens and that verdict is binding at level 4.
Sections:
1. **Module Scope List** — table: #, Module / business area, In this phase?, Sequence rationale, Customer owner. Subhead **Not in scope** + fill.
2. **Product Fit Check (Product Manager)** — table: Module, Syncoria product considered, Verdict (covered / partial / not applicable), Notes / conditions. Callout: no OPL, AM or Sales Executive describes, demos, sizes or commits a Syncoria product's behaviour without the Product Manager.
Also embedded as Charter §3 and PSS §2. Signoff: customer.

## 04 — Process Preparation Form
Subtitle: `Phase 2 · Business Exploration · Complete before your session`
meta: Module (the business area), Project, Completed by, Session date, Return by (3–5 business days before the session).
aboutBox: answer in your own words, no Odoo knowledge needed; attach real examples.
Sections: 1 **How you work today** — 5–7 questions specific to this business area, each a fill (drafted from the register and presales notes, reviewed by the OPL) · 2 **Volumes & frequencies** — table: What, How many, Per (day / week / month), Peak periods · 3 **Pain points** — fill · 4 **Systems used today** — table: System / spreadsheet, Used for, Who uses it, Keep, replace or connect?
Signoff: no.

## 05 — Current-State Process Map
Subtitle: `Phase 2 · Business Exploration · Confirmed by Customer`
meta: Module (the business area), Project, Prepared by, Source (session date, prep form), Confirmed by / date.
aboutBox: how you work TODAY, in plain language; written confirmation required before training starts.
Sections: 1 **Process overview** (2–4 sentences) · 2 **Step-by-step flow** — table: Step #, Who, Action, System / tool, Notes (documents, decisions, timing) · 3 **Exceptions & edge cases** (returns, partial shipments, rush orders, credit holds, cancellations, corrections) · 4 **Volumes** — table: What, Volume, Per, Peak · 5 **Confirmation** — para: reply "Confirmed" or sign.
Plain customer language only — no Odoo terms. Signoff: customer confirms (sign-off text: "the customer confirms this map accurately describes how the process works today").

## 06 — Gap Feedback Form
Subtitle: `Phase 3 · Odoo Standard Training · Complete after your practice period`
meta: Module (the business area), Project, Completed by, Practice window (dates), Return by.
aboutBox: per step of your confirmed process, did standard Odoo work; be specific; "how do I…" questions are not gaps.
Sections: 1 **Feedback by process step** — instruction (OPL pre-fills the step column from Artifact 05) + table: Process step (from map), Did standard Odoo work? (Yes / Partly / No), If not, what's missing or different?, How often does this happen?, Priority (H / M / L) · 2 **Anything else** — fill.
Signoff: no.

## 07 — Gap Decision Log
Subtitle: `Phase 3–4 · Gap Classification · Agreed by both parties`
meta: Module (the business area), Project, OPL, Gap review session date, Classification Audit by / date (Consulting Lead).
aboutBox: every gap from the Gap Feedback Form classified standard-first, agreed in the 45-minute gap review, then audited in writing by the Consulting Lead; only Studio and Custom gaps need a CVBS.
Sections:
1. **Standard-first order** — the six-level table (Level, Resolution, Question, Where it's recorded) + callout: stop at the first level that works; "merely inconvenient" is a reason to ask whether the process can flex, not to go up a level.
2. **Gap log** — table: Gap #, Gap (customer's words) + process step, Classification (1–6), Rationale (why lower levels don't fit), Rough effort, Priority, Audit verdict (upheld / reclassified / returned).
3. **Audit notes (Consulting Lead)** — fill.
Each classification is a register `DEC` linked to its row; each process-flex answer is a `DEC` too. Signoff: joint (sign-off text: both parties agree the classification of every gap; Studio and Custom gaps proceed to a CVBS, all others are recorded in the PSS).

## 08 — CVBS (Customer-Validated Behavior Specification)
Subtitle: `[CVBS-NNN] · [Title] · [Module]`
meta: Customer, CVBS # / title, Module, **Odoo version/edition (confirmed on the customer's instance)**, **Implements gap (Gap Decision Log row + classification date)**, **Process map anchor (map + step number)**, **Related CVBS (and why there is no overlap)**, Version / status, Prepared by / date.
aboutBox: plain-English; every AC markable pass/fail by a non-technical user during testing; nothing outside this document is being built; signature authorises the TTD and the build.

Sections:
1. **The business problem** — instruction + para. Anchored to a numbered process-map step. Who, what happens today, how often, at what volume, what it costs, and the do-nothing consequence. Then three required blocks: **why standard Odoo does not cover this** (the setting/feature examined, on the customer's instance, on a date, and **whether the customer was asked if the process could flex to the standard flow** — record the answer and their reason; and the Product Manager's level-4 verdict and where it is recorded — **required whenever the module's Fit Check verdict is covered or partial**, otherwise `[PENDING — Product Manager verdict]`); a **review-verdict callout** giving a one-line verdict per test with the review date and a cross-reference to TTD §3; and **why this is a single unit of behavior** (one trigger, one decision, one outcome — argued, not asserted). Never put the solution here.
2. **What the system will do** — bullets, plain English, present tense, user's point of view. No Odoo object names, no field names, no mention of code, Studio or modules. If the customer cannot read a bullet aloud and say whether it is true of their business, rewrite it.
3. **Acceptance criteria** — Given / When / Then, each testable by a non-technical user in front of the system, each testing one thing. **The subheads below are the coverage set. Write criteria under every subhead, or write "N/A" with the reason** — a CVBS with only happy-path criteria is not finished:

   3.1 Happy path · 3.2 Boundaries · 3.3 Alternate valid paths · 3.4 Exception states · 3.5 What must NOT happen · 3.6 Failure and recovery · 3.7 Reversal and correction · 3.8 Records that exist before go-live · 3.9 Permissions and visibility · 3.10 Volume and timing.

   3.6, 3.7 and 3.8 are the most-skipped and the most-argued-about at UAT. 3.6 must say what the user sees, what state the record is left in, whether a failed attempt leaves a partial record, and who clears it. Table per subhead: #, Given/When/Then, Pass?.

   **Proposed criteria are marked.** A criterion, threshold or mechanism that the customer, the process map or the register didn't state is a proposal: list each in the self-check as `proposed — derived from [source]` so the customer confirms it before signing. Cite a customer answer or register ID only for what it actually says ("a few hours" is not "three hours").

   Add a **note on criteria count** wherever the list is long: coverage is not aggregation. The singularity test counts triggers, decisions and outcomes — criteria covering boundaries, failures, permissions and pre-existing records do not count toward it.
4. **How it fits the existing process** — name the process-map step, what changes there, what stays the same before and after it, then a **role-impact table** (Role · What changes · What stays the same). That last table is the training and change-management cost the customer is agreeing to.
5. **Concerns & things to accept** — the business-facing output of the `syncoria-customization-review`. A callout stating that signing means accepting them as described, then a table (Concern · Resolved or accepted? · Detail) naming each concern: new master data and who owns it, a new approval point or restriction users don't have today, re-test effort at each annual Odoo upgrade, a deliberate segregation-of-duty control, anything recorded but not reported. **Do not soften these — the customer is signing them.** An empty concerns section means the review was not really run.
6. **Out of scope for this customization** — **exhaustive, not illustrative.** Write down the adjacent things the customer might reasonably assume come along: other documents, other trigger dimensions, escalation, delegation, extra approval levels, dashboards and reporting, mobile, downstream document changes, reassessment of pre-go-live records, bulk maintenance tooling. Callout: anything listed here requires a Change Request. Every item left out is one you will argue about later.

Close with a **"before you sign" callout**: read every AC in §3, read §5 and §6, once signed this is the scope.
Signoff: yes (customer + Syncoria OPL).

**Only draft a CVBS resolution after the customization has passed the `syncoria-customization-review` four tests.** The resolution records the review's verdict; the customer accepts the business-facing concerns knowingly. **CVBS quality caps TTD quality** — the ACs become the developer ACs one to one, so a coverage-set gap here becomes an unspecified branch in the build.

## 09 — TTD (Technical Translation Document)
Subtitle: `[TTD-NNN] · implements [CVBS-NNN] · [Module]`
meta: Project, TTD ref, **Implements CVBS (number, version and signature date)**, Module / **module technical name**, **Odoo version/edition and how it was read (source + date)**, **Depends on** (other TTDs and base modules), **Customization review** (completion date + "trace in §3"), Author / date.
aboutBox: internal developer document, gated by the signed CVBS, not shared with the customer; complete enough that a competent Odoo developer builds the right thing end to end without asking a single business question; every technical decision carries the business reason it exists.

Sections — **this numbering, matching `ttd-construction.md` and the worked example:**
1. **Traceability and summary** — one-line technical statement + the CVBS→TTD section map (out-of-scope items the build would touch are a stop-and-ask).
2. **Business context** — intent in customer terms, plus cost of getting it wrong in three directions (too permissive / too restrictive / silent), the declared fail-safe direction, and real volumes.
2b. **Concerns and pitfalls** — table (Concern · Why it matters · How this build handles it), before the build detail, deliberately. Sweep the same ten categories block F of the review handoff record sweeps: conflict with an existing customization; **conflict with standard configuration**; upgrade fragility; performance at real volume; security and access; multi-company/currency; **unstated edge cases** (the ones the OPL should see before the build detail); actor unavailable; maintenance cost with a named owner; downstream impact. Each row resolves or names accepted residual risk, and cites the AC that proves it. Close with a **stop-and-ask callout**.
3. **Solution strategy** — 3.1 the approach + the **alternatives-considered table** (Option · Would it satisfy the CVBS? · Why not), six rows: configuration only / process adaptation with the customer's answer / Studio+automation / **Syncoria product or community module** (the Product Manager's level-4 verdict first, then the community candidates by name) / new parallel construct / chosen, each with a capability-level "why not"; 3.2 **what standard Odoo already does** (version+edition+read source+date, standard behavior named, where it stops, what is reused unchanged); 3.2b **extension-point selection** (candidates, the narrowest correct hook, what was *not* extended, the super() contract); 3.3 **conflict clearance** table (Search surface · Finding) with all eight surfaces answered — (1) addons inheriting the target model, (2) addons overriding the chosen hook, (3) automation rules / server actions on the same trigger, (4) other writers of the same fields, (5) a standard workflow the customer depends on, (6) an existing customization that already does this, (7) standard settings or features deciding the same outcome, (8) downstream consumers — "None found" is a required answer; 3.4 **decomposition into build units** — table (# · Build unit · Traces to AC · Notes), ordered, including a security unit, a test unit and a data-preparation unit.
4. **Data model changes** — table per model (Model · Field · Type and behavior · Business meaning and why it exists). Extension over new models. Computed fields state dependencies, stored-or-not, and why. Defaults fail safe. **A "new models" subsection filled even when the answer is none.** Constraints carry their business rule.
5. **Business logic** — per method: trigger, standard method extended, super() position, business rule in plain English, then numbered steps with every branch and inline AC citations. State the transaction rule and the precedence rule. Close with the **edge-case table** (Case · Expected behavior · AC) sweeping every class listed in `ttd-construction.md`.
6. **User interface and views** — `xpath` inheritance only, placement, visibility conditions with business reasons, plus a **"do not" callout** (no wholesale replacement, no hiding or relabelling standard elements).
7. **Access and security** — table (Item · Rule · Business reason). Field-level restriction on any field that *is* the control; enforcement in the method not only the view; **record rules stated even when none are added.**
8. **Reports and outputs** — or N/A with the reason and where the evidence lives instead.
9. **Integration touchpoints** — or N/A **with the side effects recorded** (existing automations/exports whose timing or content changes, and that the OPL confirmed them).
10. **Developer acceptance criteria** — table (Dev check · CVBS ref · Verified by: automated test / migration test on a DB copy / timed test / manual check), mapped one to one. Then **10.x technical criteria the CVBS did not cover** — carry the standing TC-01…TC-08 set from `ttd-construction.md` and add build-specific ones.
11. **Upgrade risk and assumptions** — 11.1 dependency surface (published behavior vs internals; every internal named as read and covered by a test); 11.2 **anti-patterns explicitly avoided** checklist; 11.3 assumptions table (# · Assumption · **If wrong** · Blocking?), each classified blocking or non-blocking, with a **gate callout** naming the blockers and any unresolved `[VERIFY: …]` markers.
12. **AI scaffold prompt** — derivable only from §4–§7, ending with the negative constraints and the test-generation instruction, in an instruction box stating it produces a starting point reviewed against §4–§7.

**Read `ttd-construction.md` in full before building, read `ttd-exemplars.md` for the standard of writing, and run `syncoria-customization-review` first.** Apply the three completion tests — decomposition, standard-first, collision — before calling a TTD done. Signoff: no (gated by signed CVBS).

## 10 — Build Register & Build Plan
Subtitle: `Phase 5 · Build Planning · Signed before development begins`
meta: Project, OPL, Date prepared, Dev Kickoff date, Architecture review approved (date).
aboutBox: PSS v2.0 + the signed CVBS library + this signed Build Plan together authorize development.
Sections: 1 **Build Register** — table: TTD #, CVBS #, Module, Effort (h), Developer, Depends on, Sequence · 2 **Build sequence rationale** — fill · 3 **Customer timeline** — table: Milestone, Target date, What it means for you; rows at minimum: Build starts, Master data loaded in staging, Staging ready for UAT, UAT window, Practice go-live, Go-live, Hypercare ends · 4 **Customer-side dependencies** — instruction + table: Dependency, Owner, Due (data cleanup, import templates, UAT testers' availability, sign-offs, third-party credentials).
Signoff: customer.

## 11 — UAT Acceptance Script (workbook)
One workbook per signed CVBS, plus one end-to-end script per module (business area) built from its process map. Sheet `Script`:
- Title band: `11 · UAT Acceptance Script` / `Phase 7 · User Acceptance Testing · Follow this script to confirm each workflow`.
- Meta rows (label · input): Workflow / feature, Linked CVBS #, Tester, Date, Staging URL.
- Instruction row: do each step in STAGING; Pass = expected result happened; Fail = it didn't (describe and screenshot); New Request = works as specified but you'd like it different — that becomes a Change Request, not a fix.
- Table: Step #, Action to perform, Expected result, Result (dropdown Pass / Fail / New Request), Notes / screenshot ref, CVBS AC ref. Each CVBS acceptance criterion becomes at least one step, cited in the last column.
- Closing row: tester sign-off (name / date).
Signoff: the tester signs the script; the customer signs the UAT Log.

## 12 — UAT Log (workbook)
Sheet `UAT Log`: title band `12 · UAT Log` / `Phase 7 · Consolidated results across all scripts · customer signs at the end`; meta rows: Project, OPL, UAT window, Customer tester(s), Last updated; instruction row (OPL triages daily; Fail → fix and retest; New Request → CR; go-live requires every CVBS at Pass and every New Request to have a CR); table: Script / CVBS #, Step #, Result (Pass / Fail / New Request), Triage decision (Accept / Fix & retest / Raise CR / Training), CR # (if New Request), Fixed / retested on, Status (Open / Closed), Notes.
Sheet `Summary`: entries logged, Pass, Fail, New Request, Open items, and **bug share = Fail ÷ (Fail + New Request), target < 20%** (all as formulas over the log), then customer sign-off (name / title / date).
Signoff: customer.

## 13 — Change Request
Subtitle: `[CR-NNN] · [short title]`
meta: Project, CR number, Date raised, Raised by, Raised during (phase).
aboutBox: any request not in the signed PSS v2.0, a signed CVBS or an approved CR; no work starts until signed; root cause classified by the OPL before any commercial conversation.
Sections: 1 **The request** — fill (requester's words, then restated) · 2 **What signed scope it relates to** — table (Reference · Detail): PSS section, CVBS #, Net-new? · 3 **Root-cause classification** — table (Root cause · Applies? · Chargeable?): Customer scope addition → Chargeable · OPL specification gap → Absorbed by Syncoria · Developer interpretation error → Absorbed by Syncoria · Odoo platform limitation → Case by case, escalated · 4 **Impact** — table (Item · Estimate): Effort (hours), Cost (AM), Timeline impact, Risk to existing scope, Artifacts to update (PSS / CVBS / Build Plan) · 5 **Decision** — table: Decision (Approved / Rejected / Deferred), Date, Notes + callout: rejected CRs stay recorded as out of scope.
Signoff: yes (customer).

## 14 — Hypercare Summary
Subtitle: `Phase 8 · Go-Live & Hypercare · Project close-out document`
meta: Project, Go-live date, Hypercare period, OPL, Review date.
aboutBox: summarizes go-live and hypercare and marks formal project close; the signature ends hypercare (warranty) and moves the customer to support under PSS §10.
Sections: 1 **Go-live summary** — fill · 2 **Hypercare issue log** — table: #, Issue, Severity, Type (defect / training / new request), Resolution, Status · 3 **Outstanding items & handoff** — fill · 4 **Support transition** — table (Item · Detail): Support pack, Helpdesk portal access, Customer Success Manager, Where signed artifacts live.
Signoff: customer (sign-off text: "By signing, the customer confirms go-live and hypercare are complete and the project is formally closed.").

---

## Supporting artifacts

In the header band, `artifactNumber` is the short code — `TCR`, `DCN`, `WSR`; the workbooks (DMT, GLC) carry the name in the title band.

### TCR — Technical Consult Request
Subtitle: `The only door to Development Lead time before Phase 5`
meta: Project / module, OPL, Date filed, Customer call requested? (Y/N).
aboutBox: do the business analysis first; the Development Lead answers in writing (target 2 business days) and may return an incomplete TCR; no developer joins a customer call without an accepted TCR.
Sections: 1 **Process step** — fill (confirmed map + step #) · 2 **The gap in the customer's words** — fill · 3 **Classification attempted** — table (Level · Considered? · Why it doesn't fit) for levels 1–5 · 4 **Proposed behaviour (plain English)** — fill · 5 **The specific technical question** — fill · 6 **Customer call (only if needed)** — fill with the pre-stated question · 7 **Development Lead response** — table (Item · Response): Accepted / returned incomplete, Feasibility, Recommended approach, Effort range, Date.
An incomplete TCR (no process step, no classification attempt, no specific question) is returned, not answered. Signoff: no.

### DCN — Decision Confirmation Note
Subtitle: `Sent at every phase gate · Your written reply confirms these decisions`
meta: Project, Phase / gate, Sent by (OPL) / date, Register version.
aboutBox: what was decided, assumed and excluded this phase, from the Project Control Register; reply "Confirmed" or correct within 3 business days; usually sent as an email with the same content.
Sections: 1 **Decisions** — table: ID, Decision, Date · 2 **Assumptions we are relying on** — table: ID, Assumption, If wrong · 3 **Confirmed out of scope** — table: ID, Exclusion, Date · 4 **Open questions — answers needed** — table: ID, Question, Needed by.
Carries only DEC, SCP and ASM statements (and the OQs the customer must answer) in the customer's language — never RSK, TSK, chargeability views, authority-ladder verdicts or conflict analysis (`control-register-rules.md` Part 6). The written reply lifts the listed entries to A2. Signoff: yes, when a signature is preferred to an email reply.

### WSR — Weekly Status Report
Subtitle: `Every Friday · OPL to customer project lead and AM`
meta: Project, Week ending, Current phase / module, Overall status (On track / At risk / Off track).
Sections: 1 **Headline** — fill (1–2 sentences) · 2 **Gate status** — table: Phase / module, Gate, Status, Expected · 3 **Done this week** — fill · 4 **Next week** — fill · 5 **Customer actions outstanding** — table: Action, Owner, Due, Days overdue (from register ACT entries; anything over 3 business days goes to the AM) · 6 **Risks & issues** — table: Risk / issue, Impact, Mitigation, Owner · 7 **Budget** — table: Hours budget, Hours used, % used, Forecast to complete + callout (at 70% and 85% the OPL escalates in writing to the AM and the Program Manager at the same time) · 8 **Open Change Requests** — table: CR #, Title, Status, Chargeable?
Status is measured against the signed plan, never against what was said in a meeting. Signoff: no.

### DMT — Data Migration Tracker (workbook)
PSS §4 in working form. Sheet `Tracker`: title band `Data Migration Tracker` / `PSS §4 in working form · one row per dataset · load in the order shown`; instruction row (standard load order; contacts loaded twice; customer spot-checks ≥10% of every import in writing; data problems go back to the data owner); table: #, Dataset, Source system, Records (approx.), Customer owner, Cleanup due, Template in shared folder?, Staging load date, Staging spot-check OK?, Practice go-live load, Production load date, Production spot-check OK?, Notes. Columns G, I and L (template, staging spot-check, production spot-check) are Yes / No / N/A dropdowns.
**Standard load order (rows, delete what doesn't apply):** Chart of Accounts · Account groups · Journals (incl. bank / EFT setup) · Industries · Delivery methods · Payment terms · Currencies · Users · Sales teams · Contacts pass 1 (without sales pricelist) · Customer & vendor bank accounts · Units of measure · Product categories (max. 2 levels) · Warehouses · Attributes / variants · Products · Bills of Materials · Vendor pricelists · Reordering rules · Sales pricelists · Contacts pass 2 (with sales pricelist) · Departments · Job positions · Employees · Opening inventory (+ lots/serials) · Open purchase orders (open lines only) · Open sales orders (open lines only, with down payments) · Open manufacturing orders · Open customer invoices (AR) · Open vendor bills (AP) · Trial balance (opening journal entry) · connector-specific data.
Every row has a customer owner and a cleanup date before Phase 6. See `data-migration.md` for the cross-phase thread. Signoff: no (each spot-check confirmed in writing).

### GLC — Go-Live Readiness Checklist (workbook)
Sheet `Checklist`: title band `Go-Live Readiness Checklist` / `Phase 7–8 · Run before Go / No-Go · every row must be OK or N/A with a reason`; table: Area, Check, Why it matters, Status (OK / Not OK / N/A), Checked by / date, Notes.
Standing rows (Area · Check · Why it matters), in the template's order — keep them all; mark N/A with a reason rather than deleting:

| Area | Check | Why it matters |
|---|---|---|
| Gates | Every CVBS at Pass in the UAT Log; every New Request has a CR | Go-live rule |
| Gates | UAT Log signed; practice go-live completed and reconciled | Go-live rule |
| Accounting | Chart of accounts matches the signed design; no unused Odoo default accounts in use | Wrong postings |
| Accounting | Taxes and fiscal positions tested with real customer/vendor addresses | Tax errors on day one |
| Accounting | Bank synchronization connected (or statement import agreed) and reconciliation models set | Payments can't be matched |
| Accounting | Currency exchange-rate method confirmed (automatic provider / manual) | FX differences |
| Contacts | Group contacts by Country and State: no "None" groups (flag to customer) | Fiscal positions and taxes depend on country/state |
| Contacts | Receivable/payable accounts correct on contacts (no Odoo defaults if custom CoA) | AR/AP posts to the wrong account |
| Products | Every product category has income and expense accounts | A wrong category choice still posts correctly |
| Products | Manufacturing: filter products with a BoM set and inventory tracking NOT set — fix any such manufactured item | No finished-good valuation or COGS entry otherwise |
| Purchasing | Vendor pricelist currency matches the vendor contact's currency | Wrong purchase prices |
| Purchasing | Vendor pricelist unit-of-measure category matches the product's | Conversion errors |
| Purchasing | Vendor on each reordering rule exists on the product's vendor pricelist | Replenishment fails |
| Inventory | Reordering rules: minimum never greater than maximum | Invalid replenishment |
| Inventory / MRP | UoM rounding precision in line with BoM consumption; BoM UoM category matches product and BoM lines | Consumption rounding errors |
| Inventory / MRP | No product with multiple BoMs where one is a Kit | Unpredictable explosion |
| Users | Production users created with correct access groups; each role tested | Security / access |
| Email | Incoming and outgoing mail servers live; test send and reply-to-chatter | Customer emails lost or spam-flagged |
| Integrations | Every integration switched to production credentials and tested live | Silent failures |
| Data | All datasets in the Data Migration Tracker loaded and spot-checked | Bad data at go-live |
| Backups | Production backup taken immediately before cutover | Rollback point |
| Calendar | Go-live date is not next to a holiday (or risk accepted in writing) | Staff unavailable |
| Support | Hypercare rota, customer contacts and escalation path agreed | Day-one response |

Status (column D) is an OK / Not OK / N/A dropdown. Add project-specific rows below the standing ones.
Closing row: customer sponsor GO / NO-GO (name / date). Odoo-specific checks are a checklist, not product guidance — defer to `syncoria-odoo` for what each setting does on the customer's version.

---

## When a project-knowledge template exists
If the customer Project contains its own `.docx` or `.xlsx` template for an artifact, match its structure exactly over the structure here. This file (mirroring the Drive library) is the default; a customer's own template is the override. Either way, **render via the script** so the brand stays consistent, and flag visual differences from the house brand rather than silently picking one. Report every structural difference from this file and suggest logging it in the Skill Improvement project's learning log (`template-library.md` rule 3).
