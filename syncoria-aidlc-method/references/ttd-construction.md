# TTD Construction — From Signed CVBS to Build-Ready Spec

The TTD (Technical Translation Document) is the most important artifact the AI produces. It is the bridge between *"the customer agreed to this behavior"* (the signed CVBS) and *"the developer builds exactly the right thing on the first pass"* (no unbillable iterations). A weak TTD is where projects bleed margin: the developer guesses, builds the wrong thing, and the rework is absorbed, not charged.

A TTD is not a summary of the CVBS in technical words. **It is the complete solution strategy, decomposed to the last implementable detail, with the business rationale carried alongside every technical decision — and with the evidence that this is the least amount of custom code that satisfies the signed behavior.**

Read this whole file before drafting any TTD. Read `ttd-exemplars.md` alongside it for the standard of writing to match.

---

## What "quality" means here

Code quality is the smallest part of it. A TTD is high quality when the thing it specifies is:

1. **Not a customization at all where standard Odoo already does the job.** Every line of custom code the customer did not need is a permanent liability they are paying to own.
2. **Not in collision with anything already in the instance** — another customization, a standard automation, a standard setting that decides the same thing.
3. **Built out of Odoo's own constructs**, extending the standard state machines, hooks and mechanisms rather than running parallel ones beside them.
4. **Proportionate** to the customer's size, industry and actual volumes.

These are the four tests owned by the `syncoria-customization-review` skill. That skill *proves* them against the real database and codebase. **This file governs where the proof lands in the document, and how a TTD is written so the proof cannot be skipped.** A TTD with an empty conflict table or a one-line "standard can't do this" is not a TTD that failed a rule — it is evidence the review never happened.

| Quality goal | Where the TTD carries its evidence | The TTD fails if |
|---|---|---|
| No customization where standard suffices | §3.1 alternatives table · §3.2 review trace | The alternatives table has only the chosen row, or the trace has no version, no date and no named standard behavior |
| No conflict with what exists | §2b concerns · §3.2b extension point · §3.3 conflict clearance | Any clearance row is blank, or the chosen hook is the obvious one rather than the narrowest correct one |
| Standard constructs maximized | §3.1 rejected alternatives · §4.4 new-model justification · §11.2 anti-patterns | A new persistent model, a parallel state field, or a hand-rolled notification exists without a written justification |
| Proportionate to the customer | §2 volumes · §2b maintenance cost · §3.1 "disproportionate for N users" reasoning | Effort is specified with no reference to how many records, users or transactions it actually serves |

---

## The three disciplines that make a TTD great

1. **Decompose to the last detail.** Every behavior in the CVBS is broken down until there is nothing left for the developer to invent. If a developer reading the TTD would have to make a business or design decision, that decision wasn't decomposed — go further. The test: *could two different developers read this TTD and build two materially different things?* If yes, it's not done.

2. **Carry the business case alongside the technical detail.** Every technical decision is paired with the *why* — the business reason it exists, traced to the CVBS. This is what prevents the developer from "optimizing" away a constraint that mattered, and what lets them make good micro-decisions when something the TTD didn't foresee comes up. A developer who understands *why* builds the right thing even in the gaps; a developer following steps blindly does not.

3. **Show your work on what you chose not to build.** The rejected alternatives, the standard behavior being reused, the hook you did *not* extend and why, the conflict rows that came back clean — this is not padding. It is the only thing that distinguishes a design decision from a default. A reviewer cannot tell a considered extension from an unconsidered one unless the TTD records the considering.

Decomposition without rationale is brittle. Rationale without decomposition is vague. Either without the third leaves a build nobody can defend when the customer asks why it cost what it cost.

---

## Before you write a single section

### The blockers

- **The signed CVBS.** No signed CVBS, no final TTD. This is the methodology's hardest gate (see `artifact-dependencies.md`). If the CVBS is thin or vague, strengthen the CVBS first — a TTD cannot be more precise than the CVBS it implements, and decomposing a vague CVBS means inventing scope.
- **The `syncoria-customization-review` trace.** The four-test verdict with its evidence: version and edition confirmed and how, what is already installed, what standard does here (named to the model/method/setting), the conflict inventory, the constructs judgment, the size/industry judgment. A TTD without this is building on an unverified "it needs customization." If the review hasn't run, run it before decomposing.

### The verification rule — the one that quietly ruins TTDs

**Every Odoo internal you name in a TTD is read off the deployed version's source and the customer's actual instance, and the read is dated.** Method names, helper names, field names, setting labels, storage behavior, which group a standard action checks — all of it. The date appears twice on purpose: in the **§1 meta line** (version, edition, source, date) so a reader sees it before anything else, and again in the **§3.2 trace** where the standard behavior it refers to is described. They must agree.

- Never carry an internal name from a previous project's TTD. Odoo renames and refactors between annual releases, and the same name can mean something different in Community and Enterprise.
- Never write an internal from memory. If you have not read it, write `[VERIFY: the approval-permission helper on purchase.order — name and signature to be read from the deployed 19.0 source]` and list every such marker in the pre-build gate at §11.3. A TTD may ship with verify markers; a build may not start with them unresolved.
- The rule covers framework helpers (float comparison, environment flags, group checks), the behavior you attribute to any hook you rejected in §3.2b, and the Studio and automation limits cited in §3.1 — not only the hook you extend. Never write a blanket "every other internal was read".
- Record *where* you read it, not just that you did: "Settings → General Settings on the production instance, 2026-09-08" is verifiable; "confirmed" is not.

This rule is what makes a TTD trustworthy to a developer who was not in the room. Without it the document reads authoritative and is quietly wrong, which is worse than being visibly incomplete.

### The namespace rule

Collision prevention starts with naming. Unless the customer's repo already uses a different convention — in which case match it and say so:

- Module: `syn_<module>_<feature>` (e.g. `syn_purchase_approval_matrix`)
- Fields: `syn_<short_name>` on standard models — never a bare name that a future standard field or another addon could take
- New models: `syn.<domain>.<thing>`
- XML ids, groups, views, actions: all prefixed the same way

State the module technical name in §1. A field added as `approval_limit` instead of `syn_po_approval_limit` is a conflict waiting for the next addon or the next Odoo version.

---

## Required structure

A complete TTD has these sections, in this order. Do not skip any; mark a section "N/A — [reason]" only when it genuinely does not apply — and N/A still carries side-effect notes (see §8/§9).

### §1 — Traceability and summary

- TTD number; the CVBS number(s) it implements *with version and signature date*; module; module technical name; target Odoo version and edition **and how that was read**; dependencies on other TTDs (or "none"); the customization-review completion date; author; date.
- **One line** stating what this customization does, in technical terms. If you cannot write it in one sentence, the CVBS is probably not a single unit of behavior — go back to it.
- **The CVBS → TTD map.** A short table: which CVBS section becomes which TTD section. It makes the traceability checkable rather than claimed, and it puts the out-of-scope section on the developer's radar: *anything in CVBS out-of-scope that the build would touch is a stop-and-ask, not a judgment call.*

### §2 — Business context (the "why," up front)

- Two to four sentences restating the business problem in the customer's terms, traced from the CVBS. The developer must understand business intent before the first line of technical detail.
- **The cost of getting it wrong, in three directions.** Not one paragraph — three, because they pull against each other and the developer needs to know which way to lean:
  - **Too permissive** — what slips through, and what that costs. This is usually the failure the customer is paying to remove.
  - **Too restrictive** — what gets blocked that shouldn't, and the operational cost. Quantify it: "roughly 500 orders a month are confirmed, of which only 75 to 95 should ever be held."
  - **Silent** — what fails invisibly, with nobody noticing. Almost always the worst of the three and almost always the one nobody writes down.
- **Declare the fail-safe direction explicitly.** "Where the system cannot tell, it holds the order rather than releasing it." Every ambiguous branch in §5 then has a default the developer can derive without asking.
- Real volumes, from the CVBS. They calibrate both the performance design and the proportionality judgment.

### §2b — Concerns and pitfalls (before the build detail, deliberately)

Placed here on purpose — the developer and OPL must see the risks *before* the technical detail, not buried at the end. A table: **Concern · Why it matters · How this build handles it.**

Sweep all of these categories. Each is either populated or explicitly dismissed with a reason — a genuine "not applicable, because …" is a valid answer and a silent omission is not. A §2b with no rows at all, on a build large enough to need a TTD, is almost always a review that did not happen rather than a build with no risks:

| Category | What you are looking for |
|---|---|
| Conflict with an existing customization | The specific addon, the specific method or field, and how this build chains around it |
| **Conflict with standard configuration** | A standard setting or feature that would decide the same thing — two rules deciding one outcome is unpredictable. Name it, say which one owns the decision, and put the setting on the go-live checklist |
| Upgrade fragility | Which standard internals this depends on and what happens at the next annual release |
| Performance at real volume | Where naive logic would be slow at the customer's actual record counts, and the design that avoids it |
| Security and access | Who can see and do the new thing; who could defeat the control by editing their own data; field-level and method-level restriction; any data exposure the CVBS didn't consider |
| Multi-company and multi-currency | Comparisons, defaults and records that silently mis-resolve across companies or currencies |
| **Unstated edge cases** | States, exceptions, cancellations, reversals and volumes the CVBS never mentioned but the flow will hit. §5.x enumerates them in full; this row surfaces the ones the OPL should know about *before* reading the build detail, because some are really unasked business questions |
| Actor unavailable | What happens when the person or group the flow routes to is archived, absent or unassigned |
| Maintenance cost | Ongoing master data with no natural owner; a named owner and a hypercare handover item, not a technical mitigation |
| Downstream impact | Reports, integrations, scheduled jobs or other workflows that consume what this changes |

Rules for the table:

- Every row resolves the concern **or** names the residual risk and who accepted it. "Mitigated" with no mechanism is not a resolution.
- Every resolution that a test can prove **cites the acceptance criterion that proves it** (AC-23, TC-03). A concern with no criterion behind it is an intention.
- If a review test failed and was overridden, record who overrode it and why.
- Close with a **stop-and-ask box**: if during the build any of these turns out worse than described — in particular if another module is found extending the same hook — stop and raise it with the OPL before coding around it. Never resolve a flagged concern silently.

### §3 — Solution strategy (the heart of the TTD)

This is where decomposition and standard-first proof both live.

#### 3.1 The approach, and why this one

State the mechanism in plain technical English, leading with the standard machinery being reused: *"Standard Odoo already has the state machine this behavior needs … the build therefore extends the permission decision that feeds it rather than adding a parallel approval mechanism."*

Then the **alternatives-considered table**, which is mandatory and which must walk the standard-first ladder in order. Every row gets a verdict even when the answer is obvious — the obvious rows are the ones a reviewer most needs to see answered:

| Alternative considered | Required content of the "why not" |
|---|---|
| Configuration only | The specific setting/route/pricelist/rule examined, and precisely what it cannot express. Say whether it **fails the requirement** or is **merely inconvenient** — those are different answers, and "inconvenient" means go back to the customer before building |
| **Process adaptation** | Whether the customer was asked if their process could flex to fit the standard flow, **what they answered, and their reason.** This is the rung most often skipped, and recording that it was offered and declined is what makes the custom build defensible. Never mark it N/A on your own judgment — it is answered by the customer, not by you |
| Studio field + automation rule (Enterprise) | What Studio can and cannot reach here, per `syncoria-odoo`'s edition and Studio boundary. Note where an automation would have to work against a standard state machine rather than with it |
| **Syncoria product** / Community / OCA module | First, the **Product Manager's level-4 verdict**: whether a Syncoria product or asset covers this, citing the Product Fit Check (Artifact 03) or a written level-4 ruling. A "covered" verdict means the TTD may not proceed to custom without a written Consulting Lead ruling that the asset doesn't fit — cite it. A "partial" verdict means this TTD builds only the uncovered remainder — say which part the product covers. Never describe what a Syncoria product does yourself. Then the community candidates reviewed, by name, and why each was rejected — the duplicate models or states it would introduce, and the upgrade surface that buys |
| A new parallel construct (new model, new state field, custom notification) | Why this fails the standard-constructs test: it reinvents something Odoo provides and leaves the standard mechanism unused and confusing. Name the standard construct it would sit beside |
| **The chosen approach** | Why it is the least custom option that satisfies the signed CVBS |

The template's §3.1 table has these six rows pre-filled; keep all six. (The worked TTD in `ttd-exemplars.md` §1 shows a four-row table written before the six-row rule — where they differ, this rule wins.) A single-row alternatives table means the standard-first question was never really asked. Defer to `syncoria-odoo` for the mechanics and the config-vs-Studio-vs-custom judgment; this file requires only that each rung is answered and recorded. The rungs here are the same ladder `syncoria-customization-review` walks in block C of its handoff record — copy the answers across rather than re-deriving them. **The Syncoria-product half of row 4 comes from the Product Manager, not from the review:** if block C carries no product verdict, take it from the Product Fit Check (Artifact 03) or a written Product Manager ruling recorded in the register, and if neither exists, mark it `NOT ESTABLISHED` and treat it as a blocking assumption in §11.3.

#### 3.2 What standard Odoo already does here — the review trace

Four bullets, in this order:

- **Version and edition checked**, where it was read, and on what date. Installed module version recorded.
- **Standard behavior found** — named precisely: the model, the state, the action, the helper, the setting. This is what stops the developer reinventing it.
- **Where it stops** — the exact limitation, stated as a capability boundary rather than a complaint. "The threshold is a single company-level amount with no per-user dimension, and there is no product-attribute dimension at all. Neither can be expressed by configuration."
- **Therefore** — the extension, and an explicit list of what is reused unchanged: the state machine, the state itself, the release action, the chatter, the activity mechanism. Naming the reuse is how the TTD proves goal 3.

#### 3.2b Extension-point selection

New and load-bearing. The choice of *where* to hook is the single highest-leverage conflict-avoidance decision in the build, and it is almost always made implicitly.

- List the candidate extension points — the obvious one and the narrower ones.
- **Choose the narrowest, most semantically correct hook**, not the most obvious. Two checkable criteria decide it, and the TTD states both: (a) **narrowest** — of the candidates that can carry the behavior, which has the fewest other callers and the smallest set of standard behavior downstream of it; (b) **semantically correct** — does the hook's own purpose match what this build is deciding? A build that decides *whether something is permitted* belongs on the permission decision, not on the action that consults it. Where the two criteria disagree, say so and say which you followed.
- State what you did **not** extend, and why. Defer to `syncoria-odoo` for what each candidate hook actually does in this version.
- State the **super() contract**: whether super() is called first or last, and what that ordering guarantees. "Call super() first and respect a negative answer, so the standard threshold and any other extension keep their veto" is a design decision with a business consequence — an existing vendor block must still be able to stop the order before any approval record exists.

#### 3.3 Conflict clearance

A table with two columns — **Search surface · Finding**, matching the template's §3.3 — with the eight surfaces below pre-numbered and every row filled. "None found" is a required answer, not an omission; a blank row reads as an unasked question.

Sweep these eight surfaces. They are `conflict-detection.md`'s checks re-cut for the document: its check 1 (overlapping inheritance) splits into rows 1 and 2, and its check 8 (upgrade fragility) is reported in §2b and §11.1 rather than here, because this table records *collisions* and that one records a *risk*. Block E of the review handoff record uses this same eight, in this order, so those answers copy straight across:

1. Addons inheriting the target model(s).
2. Addons overriding the specific hook chosen in 3.2b.
3. Automation rules and server actions firing on the same trigger or state change.
4. Anything else writing the fields this build writes or computes.
5. **A standard workflow the customer depends on that this alters** — what consumes the output of the thing being changed, and whether it still works the standard way.
6. **An existing customization that already does this, or most of it** — elsewhere in the repo, for a different module or persona. Extend or reuse it rather than building a parallel one; duplicate customizations are a maintenance and conflict liability.
7. **Standard settings or features that decide the same thing** — the company-level toggle, the native approval feature, the standard rule. Say which one owns the decision and add the setting to the go-live checklist.
8. Downstream consumers of the output — reports, integrations, scheduled actions, dashboards, other workflows — and whether their behavior changes as a side effect.

Upgrade fragility and coupling to other customizations are checked at the same time but recorded in §2b and §11.1 rather than here, so this table stays a record of *collisions* rather than a mix of collisions and risks.

Where a side effect is intended, say so and say it was confirmed with the OPL: *"an automation emails the vendor when the order reaches purchase state. It fires later than before for held orders, which is correct and was confirmed with the OPL."* An intended side effect that nobody wrote down becomes a defect report in week one.

Defer to `syncoria-customization-review`'s `conflict-detection.md` for *how* to run these searches; this section governs what the document must record.

#### 3.4 Decomposition into build units

Ordered units, each small enough to build, estimate and test on its own. Each row: **# · Build unit · Traces to AC · Notes**, matching the template's §3.4. Build order, not conceptual order.

Three units are required whenever they apply and are the three most often forgotten:

- A **security unit** (groups, field-level restriction, access rules) as its own unit, not folded into the feature units.
- A **test unit** covering every criterion in §10.
- A **data-preparation unit** wherever the build depends on master data existing at go-live — the load list, the flagging, the owner, and the deadline. A control that depends on a limit nobody loaded looks like a defect on day one. Add the dataset to the engagement's Data Migration Tracker.

### §4 — Data model changes

Prefer extension over new models, always. For every model touched, a table: **Field · Type and behavior · Business meaning and why it exists.** The third column is the one that matters and the one most often reduced to a restatement of the field name.

The second column carries everything the developer would otherwise choose: technical name, type, **label and help text as the user will see them**, required or optional, default, readonly, tracked, stored. Labels and help text are business decisions — the decomposition test below names "a field label" as exactly the kind of thing that must not be left open — so write them, don't leave the developer to invent the wording a user reads.

- Say *why* each behavior was chosen, not just what it is: company-dependent **because** a buyer can act for two companies with different authority; held on the category rather than the product **because** the control must survive new products being added, which is the audit point.
- **Defaults must fail safe.** State it where it applies: "no default on purpose: an unset limit must mean *ask*, not *unlimited*." A permissive default silently disables the control the customer is paying for.
- **Computed fields** state their full dependency list, whether they are stored, and *why* stored or not. Stored because it is filtered on in list views and must not recompute on every read; unstored because it is display-only and cheap. An unstored computed field used in a filter is an anti-pattern (§11.2).
- **Derived-not-entered.** Where two values must never disagree, derive one from the other and say so: the required approver group is derived from the reason "so the two can never disagree."
- **Evidence fields.** Where an auditor will later need to know what the rule *was* at the time rather than what it is today, add the stamp and say that is why it exists.
- **Relationships** (Many2one / One2many / Many2many) state the target model, the **`ondelete` behavior**, and the business relationship they represent. `ondelete` is a business decision with data-loss consequences — say what should happen to this record when the thing it points at is deleted, and why, rather than letting the developer take the default.
- **Constraints** each carry the business rule they enforce and the message text, and the message names the field.

**§4.x New models — a required subsection, filled even when the answer is none.** Every new model gets a row: model · type (Model / TransientModel) · why a new model is justified. A transient wizard capturing a mandatory input before an action is the standard Odoo construct and justifies itself in one line. A new *persistent* top-level model is a red flag against quality goal 3 and needs a real argument. Writing "No persistent model is added by this build" is a positive statement a reviewer can check — silence is not.

### §5 — Business logic

For every method: the trigger, the standard method extended, the super() position, the business rule in plain English *before* the technical logic, then the logic decomposed step by step with every branch.

- Pseudocode or numbered steps where it clarifies. Each step that implements a criterion cites it inline (AC-06, AC-14) — that is what lets the developer self-verify while writing rather than at the end.
- **The transaction rule.** State it explicitly wherever side effects exist: do not create the activity, post the message, allocate the sequence or write the stamp before the state transition succeeds. If confirmation fails for an unrelated reason the transaction rolls back and nothing partial survives. This is the single most common source of "half-completed record nobody can clean up."
- **Precedence.** Where this build and a standard feature could both decide the same outcome, say which one owns it, what the required setting state is, and what happens if the setting is found in the wrong state (log a warning at module load rather than silently layering two rules).

**§5.x Edge cases, enumerated as a table: Case · Expected behavior · AC.** Edge cases are where rework hides — enumerate them rather than leaving them to the developer. Sweep every one of these classes and write the row or state it does not apply:

- Empty, zero and negative values
- The exact boundary (is the limit inclusive or exclusive — say which)
- Missing master data / missing related record / no assigned user
- Multi-company
- Multi-currency, including which date the rate is taken at
- Bulk or batch operation (is each record assessed independently?)
- Concurrency — two users acting simultaneously, double-clicks
- Failure mid-transaction
- Cancel, reset to draft, reopen — what is cleared and what survives
- Records that existed before go-live
- Archived or inactive related records
- The record edited *after* the terminal action — increase, decrease, and which one re-triggers

### §6 — User interface and views

- Which views change, **by `xpath` inheritance, never wholesale replacement.**
- Placement, visibility conditions, readonly/required logic, and the business reason for each — especially conditional visibility, which developers otherwise guess.
- New buttons, actions and wizards: label, placement, what they trigger, and who sees them.
- Close with a **"Do not" box**: no view replaced wholesale, no standard button hidden or relabelled. If a standard element appears to be in the way, raise it rather than removing it. Hiding a standard control is how a build breaks a workflow the customer relies on that nobody mentioned.

### §7 — Access and security

A table: **Item · Rule · Business reason.**

- New groups, and why each is separate from an existing one.
- **Field-level restriction on any field that *is* the control.** A buyer who can edit their own limit defeats the entire build.
- **Enforced in the method, not only in the view.** State it: view-level hiding alone is not a control. The action must refuse when called directly.
- **Record rules stated even when none are added** — "None added. Standard purchase record rules and multi-company rules are unchanged." Written so the reviewer knows it was considered and not forgotten.

### §8 — Reports and outputs

Report type, data shown, layout traced to the CVBS, conditional content. **If N/A, say why and say where the evidence lives instead** — and name anything adjacent that the customer might assume comes along but that CVBS out-of-scope excludes and that would need a Change Request.

### §9 — Integration touchpoints

External system, direction, trigger, field-by-field mapping, frequency, error handling, retry behavior, and which side owns each piece. **If N/A, still record the side effects**: an existing automation that now fires at a different point, an export whose contents shift, a webhook whose timing changes — with the note that it was confirmed with the OPL and that no change is being made to it.

### §10 — Developer acceptance criteria

A table: **Dev check · CVBS ref · Verified by.** Every CVBS criterion restated as a developer-verifiable check, mapped one to one, so the developer self-verifies before the OPL gate and the OPL verifies against the same list.

The **Verified by** column is not decoration — it forces the criterion to be real. Use: *Automated test · Migration test on a database copy · Timed test · Manual check.* A criterion whose verification method is "manual check" and which could have been a test should be a test.

**§10.x Technical criteria the CVBS did not cover.** The CVBS is written for a non-technical signer, so it never contains these. Carry this standing set into every TTD, dropping only those that genuinely do not apply, and add build-specific ones:

| # | Check |
|---|---|
| TC-01 | No regression in the standard flow: a record that breaches nothing behaves identically to the pre-install baseline, **including existing automations and integrations** |
| TC-02 | `super()` is called in every overridden method, and any pre-existing extension still takes effect in the correct order |
| TC-03 | No per-record or per-line query on the hot path. Verified by query count in the test, not by inspection |
| TC-04 | No hardcoded database identifiers anywhere. Groups, categories and records referenced by external identifier |
| TC-05 | Module installs, upgrades and uninstalls cleanly on a copy of production; uninstall leaves no orphan data beyond Odoo's normal behavior |
| TC-06 | Stored computed fields recompute correctly on every declared dependency — verified, not assumed |
| TC-07 | Records that existed before install are unaffected by the install itself |
| TC-08 | Security is enforced server-side: the action refuses when called directly by an unauthorised user, not only hidden in the view |

### §11 — Upgrade risk and assumptions

**§11.1 The dependency surface.** Every standard element this build depends on, separated into *published behavior* (documented, stable mechanisms — safe to rely on) and *internals* (a specific helper method, a private attribute, storage behavior that changed between versions — fragile). Every internal is named exactly as read from the deployed source. Defer to `syncoria-odoo` for which category a given element falls into on this version.

**Every internal listed here carries a matching row in §10** — a named test that exercises it — so an upgrade break is visible immediately rather than in production. That pairing is checkable at sign-off: an internal in §11.1 with no criterion in §10 is an unguarded dependency. Note anything whose behavior changed in recent versions and must be re-confirmed on the target version.

**§11.2 Anti-patterns explicitly avoided.** A checklist, stated positively so it can be verified:

- No core file edited, no core model renamed — extension only
- No raw SQL where the ORM works
- No hardcoded database identifiers
- No duplicated standard fields
- No new top-level persistent model (or: one, justified at §4.x)
- No unstored computed field used in a filter or list view
- No heavy logic computed on read
- No standard view replaced wholesale, no standard button hidden
- `super()` called in every override

**§11.3 Assumptions.** A table: **# · Assumption · If wrong · Blocking?** The "if wrong" column is what makes confirmation cheap — the OPL can see the consequence without reconstructing it.

- Every assumption is classified **blocking** or **non-blocking**. Blocking means the build cannot start until the OPL confirms it in writing; non-blocking means it changes data preparation or effort but not the design.
- Close with a **gate box** naming the blockers: "Assumptions A1 and A3 are blockers. Do not start the build until the OPL has confirmed both in writing."
- Any unresolved `[VERIFY: …]` marker from the verification rule is listed here and is blocking by definition. So is a level-4 product verdict marked `NOT ESTABLISHED` in §3.1.
- Assumptions are flagged, never silently resolved. An assumption resolved by guessing is invented scope.

### §12 — AI scaffold prompt

A self-contained prompt a developer can hand to a coding model to generate the skeleton — models, fields, methods, views, tests — derived from the sections above and precise enough that the generated scaffold matches this document.

- **Every model, field, method, view and wizard it names must come from §4–§7.** If the prompt describes something those sections don't, either the prompt is inventing or the sections are incomplete — fix whichever it is. Its closing constraints come from §11.2 and its test instruction from §10; nothing else enters it.
- It must end with the negative constraints from §11.2: do not edit core files, no raw SQL, no hardcoded database identifiers, `super()` in every override, inherited views by `xpath` only.
- It must instruct test generation covering each developer acceptance criterion in §10, naming the awkward ones explicitly — concurrency, currency conversion, the fallback path, and the query-count assertion.
- State in the surrounding instruction box that it generates a starting point, not a finished build, and that everything it produces is reviewed against §4–§7 before it is committed.

---

## The three tests before a TTD is called done

Apply all three. Each catches a different failure.

### 1. The decomposition test
Walk the TTD as the developer.
- **Is there a decision left for me to make that the business should have made?** A default value, a rounding rule, an inclusive-or-exclusive boundary, an edge-case behavior, a field label, an ordering. If yes, it wasn't decomposed — resolve it from the CVBS or flag it for the OPL.
- **Do I know *why* each piece exists?** If a constraint or field has no business rationale attached, either it's unnecessary or the rationale is missing. Add it or cut it.
- **Could I build something the customer didn't agree to?** If the TTD permits an interpretation outside the signed CVBS, tighten it.
- **Could two developers read this and build two materially different things?** If yes, it is not finished.

### 2. The standard-first test
Read §3.1 and §3.2 as a sceptical senior Odoo consultant who was not in the room.
- Can they still say *"but you could just configure X"* — or *"doesn't our own product already do this?"* If the alternatives table doesn't already answer that objection by name, it is not done.
- Is every rejection a capability statement ("cannot express a per-user dimension") rather than a preference ("would be awkward")? A preference-level rejection means go back to the customer and ask whether the process can flex, before building.
- Is the version, edition and read-date on the trace? An undated trace is an assertion.

### 3. The collision test
- Is there a row in §3.3 for every one of the eight search surfaces, each with a real answer?
- Is the chosen hook the narrowest correct one by the two criteria in §3.2b — fewest other callers, and a purpose matching what this build decides — with the rejected hooks named?
- **If another addon were installed tomorrow extending the same hook, would this build still behave correctly?** The super() contract in §3.2b should already answer this.
- Does anything downstream — a report, an integration, a scheduled job, a standard automation — behave differently as a side effect, and is that written down and confirmed?

A TTD passes when a competent developer could build it end-to-end without asking a single business question, a sceptical consultant could not propose a cheaper standard path the document hasn't already rejected by name, and nothing in the instance collides with it.

---

## Inputs and the input-check

The hard blocker is the **signed CVBS**. To decompose well, also pull:

- The CVBS acceptance criteria (these become developer AC, mapped one to one).
- The relevant process-map step, so the logic fits the real workflow.
- **The `syncoria-customization-review` handoff record** — eight labelled blocks whose fields drop straight into this document without re-derivation. See that skill's `review-procedure.md` Step 9 for the field list. The mapping: **A** provenance → §1 meta and §3.2 · **B** standard behavior and what is reused unchanged → §3.2 · **C** the ladder → §3.1 · **D** extension point and `super()` contract → §3.2b · **E** conflict clearance → §3.3 · **F** concerns → §2b · **G** proportionality → §2 and §3.1 · **H** four-test verdict and build level → §1 and the CVBS. If a block is missing or marked `NOT ESTABLISHED`, the section that consumes it cannot be written honestly — go back and get it. **One exception:** when the only gap is the level-4 Product Manager verdict, draft the TTD marked *provisional — not for build*, with §3.1 row 4 `NOT ESTABLISHED` and blocking in §11.3, and keep it out of the Build Register until the verdict exists.
- **The Product Manager's level-4 verdict** for this gap — from the Product Fit Check (Artifact 03) or a written Product Manager ruling on the gap, recorded in the register. It fills the Syncoria-product half of §3.1 row 4. None → `NOT ESTABLISHED`, blocking.
- Odoo model knowledge — defer to `syncoria-odoo`. You cannot decompose to field level without knowing the models, and you must not assert them from memory (the verification rule above).
- Target version and edition, and the existing customizations on the same models.
- Real volumes: records per period, largest record size, concurrent users. §2, §2b performance and the TC-03 query-count criterion all depend on them.

---

## The reuse sweep — before you declare anything net-new

Quality goal 3 fails quietly, because building a parallel mechanism always *works*. Before writing any new field, model, notification or state, put each of these questions to `syncoria-odoo` and record the answer in §3.2 among what is reused unchanged. **The obligation here is to have asked and written down the answer** — that skill owns whether a construct exists in this version and edition, what it does, and whether it fits. Do not answer these from this file.

Ask, for each construct family:

- **State and transitions** — is there a standard state and action for this hold / release / approve / lock, or does this need a new status field?
- **Permission and decision hooks** — is there a standard decision point already feeding that transition, or does this need a new gate in front of it?
- **Task and notification** — is there a standard way to put this in someone's queue?
- **Audit trail and messaging** — is there a standard record of who did what and when, and a standard way to notify a follower?
- **Capturing one input before an action** — is there a standard construct for that, or does this need a stored record?
- **Permissions** — is there a standard grouping and scoping mechanism, or does this need a flag on the user?
- **Per-company values and currency conversion** — is there standard handling, or does this need duplicated records and manual conversion?
- **Numbering, units, pricing and logistics rules** — is any of this expressible in standard configurable rules?
- **Anything time-based or event-triggered** — is there a standard scheduler or automation, or does this need its own?
- **Views, reports and exports** — can this be reached by inheriting an existing view or using a standard reporting path, or does it need a replacement view or a bespoke report?

For each: if the answer is yes, reuse it and list it in §3.2. If no, say so in §3.1's rejected-alternatives row. Each construct reused is upgrade surface you don't own, code you don't maintain, and behavior the customer's users already recognise — and each one you skipped asking about is where quality goal 3 fails without anyone noticing.

---

## What a weak TTD looks like (avoid)

- Restates the CVBS in technical words without decomposing — leaves design decisions to the developer.
- **Names Odoo internals carried over from another project or recalled from memory, undated and unverified.** Reads authoritative, is quietly wrong.
- **An alternatives table with one row**, or a "standard can't do this" with no version, no date and no named standard behavior.
- **Conflict-clearance rows left blank**, or a conflict section that only lists other customizations and never checks the standard setting that decides the same thing.
- The obvious hook extended without considering a narrower one, and no super() contract stated.
- Lists fields and methods with no business rationale — the developer can't tell which constraints are load-bearing.
- Omits edge cases — "handle errors appropriately" instead of enumerating each with expected behavior.
- Vague AC — "works correctly" instead of specific, mapped, verifiable checks with a named verification method.
- **Assumptions listed flat**, with no "if wrong" consequence and no blocking/non-blocking classification, so nobody knows which ones stop the build.
- A new persistent model with no justification, or a parallel state field beside a standard one.

## What a strong TTD looks like

Every behavior decomposed to an implementable unit. Every technical decision paired with its business reason traced to the CVBS. Every Odoo internal read from the deployed source and dated. The cheaper paths rejected by name, with capability-level reasons — our own products included. The narrowest correct hook chosen and the rejected hooks recorded. Every conflict surface checked and answered, including the standard setting that would otherwise double-decide. Every edge-case class swept. AC mapped one-to-one with a named verification method. Assumptions classified, gated and confirmed in writing before build.

A developer reads it once and builds the right thing — first pass, no business questions, no unbillable rework. An OPL can defend every hour of it. That outcome is the entire point of the methodology.
