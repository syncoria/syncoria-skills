# The Review Procedure — Full Steps

The complete technical review, run identically in both intake modes (full-project and ticket) — access is the same; only the business context differs. This procedure produces the evidence for all four quality tests and feeds the CVBS resolution and TTD section 3.

## Step 0 — Locate the real targets (do this first, always)

Do not run any step in your head against a remembered version. Confirm you have, or ask for in one grouped message:
- The **database/instance** and how to reach it (environment + access), confirming it's the environment this actually concerns.
- The **exact version and edition**, read from that instance.
- The **codebase**: custom-addons repo (branch/tag matching what's deployed) + matching base Odoo/Enterprise source for that version.

No access → you cannot run tests 1–3 technically; reason only from documented behavior and flag the whole review as unverified.

## Step 1 — Confirm exact version and edition (never assume)

Pull from the instance (Settings → General Settings; `ir.module.module` records) or the codebase (`odoo/release.py`; manifest `version` keys). A requirement's classification can flip between versions and between Community and Enterprise — this is the ground truth everything else rests on.

## Step 2 — Inventory what's already there

Before assuming anything is missing:
- Query `ir.module.module` for installed apps/modules.
- Check relevant `ir.config_parameter` values and Settings toggles for the feature area.
- Grep the custom-addons repo for anything already touching this model/flow.

Two purposes: the "gap" may already be solved (by config or an existing customization), **and** this inventory is the map you need for the conflict check (Step 5) — so do it thoroughly. In Mode 1, also read the Gap Decision Log and the Product Fit Check (Artifact 03); in Mode 2 there usually isn't one, so the repo and DB are your only record — check them *more* carefully, not less.

## Step 3 — Read the actual base-Odoo source for the target version

Trace the models, fields, methods, views, and automations already involved in this flow, in the real addon source for that exact version/edition — not from memory. Version-specific behavior you're unsure of gets verified here, not asserted (per `syncoria-odoo`'s honesty rule). Note what standard already does, precisely.

## Step 4 — Test 1: Standard-first (config → process adaptation)

- **Config:** Is there a setting, pricelist/route/fiscal-position rule, sequence, standard Automation Rule / server action, or existing wizard that already produces this with zero code?
- **Process adaptation:** Could the customer's process flex slightly to fit an existing standard flow, rather than bending Odoo to match their exact current process?

If either resolves it, **stop** — recommend the standard path with the concrete setting/flow. The verdict is **"standard covers it"**, and it ends the review with no build. (Never write this outcome as "passed" or "failed" — both readings occur in practice; see block H.)

## Step 5 — Test 2: Conflict detection

Run all eight checks in `conflict-detection.md` against the inventory from Step 2. In brief: is anything already inheriting the same model or overriding the same method, automating on the same trigger, or writing the same field; would this alter a standard workflow the customer relies on; does an existing customization already do this or most of it; **is there a standard setting or native feature that would decide the same outcome**; **what downstream consumers change behavior as a side effect**; is it upgrade-fragile. A customization that works alone but collides with, competes with, or duplicates something already there returns **"conflict found"** — surface it before proceeding. Record every check, including the clean ones: block E needs all eight answered.

## Step 6 — Test 3: Standard constructs maximized

If a build is genuinely needed, confirm the approach:
- Extends via `_inherit` and standard hooks (overriding `action_confirm`, `create`, `write`, etc. with `super()`), rather than parallel mechanisms.
- Reuses existing models and fields rather than new top-level models duplicating them.
- Uses Odoo constructs (routes, pricelists, automations, activities, mail threads) where they fit, rather than hand-rolled equivalents.

Reinventing what Odoo provides **fails this test** even when the code works — it raises maintenance cost and upgrade risk.

## Step 7 — Test 4: Size/industry fit

Defer the judgment to the relevant `syncoria-industry-*` skill, but require the check: is this workflow proportionate to the customer's size and appropriate to their industry?
- **Over-engineering for an SMB:** a heavy approval matrix, a bespoke engine, or a multi-step workflow where a simple setting would serve a small team.
- **Under-serving a regulated/complex vertical:** a lightweight fix where the industry genuinely needs traceability, compliance, or controls.

A technically valid customization that doesn't fit the customer's reality **fails this test**.

## Step 8 — Settle the build level (only after all four clear)

Once all four tests clear — test 1 as "standard does not cover it", test 2 as "cleared", tests 3 and 4 as "passed" — and a build is genuinely required, settle the level in this order, using `syncoria-odoo` for the mechanics of each:

1. **Studio** (Enterprise only).
2. **Syncoria product / asset** — the **Product Manager's verdict**, taken from the Product Fit Check (Artifact 03, per module) or a written Product Manager ruling on this gap, recorded in the register. Don't judge it yourself.
   - **Covered** → the gap lands at level 4. Don't continue to community or custom unless the OPL escalated and the Consulting Lead ruled in writing that the asset doesn't fit this customer; cite that ruling if it exists.
   - **Partial** → record which part the product covers; continue down the ladder only for the remainder.
   - **Not applicable** → continue.
   - **No verdict** → `NOT ESTABLISHED — no Product Manager verdict`. A custom build cannot be recommended until it exists; ask for it.
3. **Community module** (the Consulting Lead rules on suitability).
4. **Custom.** Landing here is where CVBS/TTD customization content begins — not before.

## Step 9 — Emit the handoff record

The review's output is not a narrative; it is a **structured handoff record** whose fields drop straight into the CVBS and the TTD without re-derivation. Do the verification once, write it in this shape, and both documents can be written honestly from it.

Emit these fields, in this order. Anything you could not establish is written as `NOT ESTABLISHED — [why]`, never left out — a missing field is what a skipped check looks like downstream.

**A. Provenance and inventory** → TTD §1 meta and §3.2
- Instance and environment checked; **version and edition, where read, and the date**.
- Codebase: custom-addons repo and the branch/tag matching what is deployed; base Odoo/Enterprise source for that exact version.
- **The Step 2 inventory, carried forward in full** — installed modules relevant to this flow with their versions, the Settings and `ir.config_parameter` values in this feature area and their current state, and every existing customization touching this flow. Block E records only what *collided*; six or eight "None found" rows tell a later reader nothing about what is actually installed. This is the field most often dropped and the one the TTD's §2b and go-live checklist depend on.

**B. Standard behavior** → TTD §3.2, CVBS §1 "why standard does not cover this"
- What standard does here, named precisely (model, state, action, helper, setting) — as read, not recalled.
- **Where it stops** — the limitation as a capability boundary.
- **What will be reused unchanged** (state machine, states, actions, chatter, activities, wizards, groups). This list is the evidence for test 3; write it explicitly.
- Any internal you could not verify, as `[VERIFY: …]`, for the TTD's blocking-assumption list.

**C. The ladder** → TTD §3.1 alternatives table, CVBS §1
One line per rung, every rung answered even when obvious: configuration only · process adaptation (**including whether the customer was asked to flex to the standard flow, and their answer and reason**) · Studio + automation · **Syncoria product (the Product Manager's verdict and where it was recorded)** / community or OCA module (named candidates) · new parallel construct · chosen approach. The Syncoria-product half is recorded, not judged: quote the verdict and its source, or write `NOT ESTABLISHED — no Product Manager verdict`. Each rejection states whether standard **fails the requirement** or is **merely inconvenient** — the second is a reason to go back to the customer, not to build.

**D. Extension point** → TTD §3.2b
- Candidate hooks considered; the **narrowest semantically correct** one chosen; what was deliberately *not* extended and why.
- The **`super()` contract**: called first or last, and what that ordering guarantees for extensions already present.

**E. Conflict clearance** → TTD §3.3
One line per surface, in the order the TTD's §3.3 table uses them. These are `conflict-detection.md`'s checks re-cut for the document: its check 1 splits into rows 1 and 2 here, and its check 8 (upgrade fragility) is reported in block F instead, because this block records *collisions* and that one is a *risk*. Every line answered; **"None found" is a required answer, not an omission**:
1. Addons inheriting the target model(s).
2. Addons overriding the chosen hook.
3. Automation rules / server actions on the same trigger or state change.
4. Other writers of the fields this build writes or computes.
5. A standard workflow the customer depends on that this alters.
6. An existing customization that already does this, or most of it — extend or reuse rather than duplicate.
7. **Standard settings or features that decide the same outcome** — and which one owns the decision, plus any go-live checklist item that follows.
8. Downstream consumers (reports, integrations, scheduled actions, other workflows) and whether their behavior changes as a side effect — with **intended side effects named and confirmed with the OPL**.

So: eight rows here, and `conflict-detection.md` check 8 (upgrade fragility and coupling) reported in block F and the TTD's §11.1.

**F. Concerns** → TTD §2b (technical) and CVBS §5 (business-facing)
One row per concern: concern · why it matters · resolution **or** the residual risk and who accepted it. Mark each as technical, business-facing, or both.

Sweep exactly the ten categories the TTD's §2b table uses, so the two documents cannot disagree: conflict with an existing customization · conflict with standard configuration · upgrade fragility · performance at real volume · security and access · multi-company and multi-currency · unstated edge cases · actor unavailable · maintenance cost with a named owner · downstream impact. (`pitfall-flagging.md` explains how to raise each and how to force the iteration; this list is the set to sweep.)

**G. Proportionality** → CVBS §1 verdict, TTD §2 and §3.1
The size/industry judgment with the numbers behind it (users, records per period, largest record) — the same volumes the TTD needs for its performance concern and its timing criterion.

**H. Four-test verdict and build level** → CVBS §1 review-verdict callout, TTD §1

One line per test with the one-clause reason, plus the review date and the cross-reference to TTD §3. **This callout goes in front of the customer, so the verdict words are fixed — do not improvise them, and never write a bare "pass" or "fail," which reads in opposite directions depending on the test:**

| Test | Write exactly one of | Meaning |
|---|---|---|
| 1 · Standard-first | **"standard covers it"** / **"standard does not cover it"** | "Covers it" ends the review with no build. "Does not cover it" is what authorises a build — this is the test people wrongly call "failed" when the build proceeds |
| 2 · Conflict | **"cleared"** / **"conflict found"** | Cleared means checked and nothing collides. "Conflict found" names the collision and blocks until resolved |
| 3 · Standard constructs | **"passed"** / **"failed"** | Passed means the approach extends standard machinery. Failed means it reinvents a construct Odoo provides |
| 4 · Size / industry fit | **"passed"** / **"failed"** | Passed means proportionate to this customer. Failed means over-engineered or under-serving |

Then: **build level** — the landing point from Step 8, as the Gap Decision Log's classification number and name (1 configuration · 2 process adaptation · 3 Studio · 4 Syncoria product · 5 community module · 6 custom). This is the Gap Decision Log's resolution decision and a CVBS blocker in its own right, so it must appear here rather than being left implicit in the fact that a TTD is being written.

This record is the evidence that turns "this needs customization" from an assertion into a proven, defensible decision. It is also what the TTD's standard-first and collision completion tests are checked against, so an incomplete record blocks the TTD rather than degrading it quietly.
