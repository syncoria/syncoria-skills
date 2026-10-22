# Changelog — syncoria-customization-review

Semver per the Skill Operating Model §3.5: major = behaviour/lane change · minor = new content · patch = correction.

---

## 1.2.0 — 2026-09-30 · SCR-2026-003 · effective on install

**Theme:** the review walks the six-level order. Paired release with `syncoria-aidlc-method` 1.3.0.

### Changed
- **Lane:** the classification hierarchy is Config → Process adaptation → Studio → Syncoria product / asset → Community module → Custom. Defer to the **Product Manager** for level 4: take the verdict from the Product Fit Check (Artifact 03) or a written Product Manager ruling on the gap, recorded in the register. Never judge or describe a Syncoria product. No verdict → `NOT ESTABLISHED — no Product Manager verdict`, blocking a custom build.
- **Step 8** settles the build level as Studio → Syncoria product → Community → Custom. Covered ends the climb at level 4 unless the OPL escalated and the Consulting Lead ruled in writing that the asset doesn't fit; partial lets only the uncovered remainder continue; not applicable continues.
- **Mode 1** reads the Product Fit Check alongside the Gap Decision Log in Step 2.
- **Block C** records the Syncoria-product half of row 4 (verdict and source, quoted not judged). **Block H** build level uses the six numbers: 1 configuration · 2 process adaptation · 3 Studio · 4 Syncoria product · 5 community module · 6 custom.
- New "don't": don't climb past a Syncoria product the Product Manager says covers the gap, and don't judge its fit or behaviour yourself.
- Description 1008 characters.

### Notes
- No change to `conflict-detection.md`, `pitfall-flagging.md`, `ticket-intake.md`.
- **Blast radius:** `syncoria-aidlc-method` 1.3.0 depends on block C and block H's six-level numbering. Release together.

---

## 1.1.0 — 2026-09-22 · SCR-2026-001 · effective immediately

**Theme:** make the review's output a structured handoff record the CVBS and TTD consume field by field, instead of a narrative that has to be re-derived.

Paired release with `syncoria-aidlc-method` 1.1.0. Lane unchanged — this skill still owns *proving* the four tests; the change is to the shape of what it emits.

### Changed

- **Step 9 rewritten** (`references/review-procedure.md`): "Document the trace" becomes **"Emit the handoff record"** — eight labelled blocks, each mapped to the CVBS or TTD section that consumes it:
  - **A Provenance** → TTD §1 meta, §3.2 (instance, version, edition, where read, date; installed module versions; repo branch/tag)
  - **B Standard behavior** → TTD §3.2, CVBS §1 (what standard does, named as read; where it stops; **what will be reused unchanged**; any `[VERIFY: …]` internals)
  - **C The ladder** → TTD §3.1, CVBS §1 (every rung answered, including **whether the customer was offered a process-flex to the standard flow and what they answered**; "fails the requirement" vs "merely inconvenient")
  - **D Extension point** → TTD §3.2b (candidates, narrowest correct hook chosen, what was *not* extended, the `super()` contract)
  - **E Conflict clearance** → TTD §3.3 (eight surfaces, every one answered)
  - **F Concerns** → TTD §2b and CVBS §5, each marked technical / business-facing / both
  - **G Proportionality** → CVBS §1, TTD §2 and §3.1, with the numbers behind the judgment
  - **H Four-test verdict and build level** → CVBS §1 review-verdict callout, with the fixed verdict wording, the date, the TTD cross-reference, and the Step 8 build level
- **Unestablished fields are written `NOT ESTABLISHED — [why]`, never omitted.** A missing field is what a skipped check looks like downstream.
- **Test 2 widened with two conflict surfaces** (`references/conflict-detection.md`, now eight checks and reflected in `SKILL.md`):
  - **Check 6 — a standard setting or native feature deciding the same outcome.** Previously the conflict check looked only at other customizations. Two rules deciding one outcome presents as an intermittent bug, not a design fault. Resolution requires naming which one owns the decision, the required setting state, a go-live checklist item, and where possible a load-time warning if the setting is found wrong.
  - **Check 7 — downstream consumers** (reports, integrations, scheduled actions, dashboards, other workflows) whose behavior changes as a side effect. Intended side effects must be named and attributed to whoever confirmed them.
  - Previous check 6 (upgrade fragility) renumbered to 8.
- **"Record every surface, including the clean ones."** "None found" is the answer the TTD's conflict-clearance table requires.
- `SKILL.md` description and Step 9 outline updated; two fields called out as carrying more weight than their size suggests — the **list of standard constructs reused unchanged** (the only real evidence for test 3, and the first thing usually dropped) and the **`super()` contract**.

### Fixed (post-review audit, same release)

- **Verdict polarity defined once.** "Test 1 failed" previously meant *standard covers it* in `pitfall-flagging.md` and *standard does not cover it* in the worked example — inverted, in a verdict that goes in front of the customer. Block H now fixes the wording per test: test 1 is **"standard covers it" / "standard does not cover it"** (never pass/fail), test 2 is **"cleared" / "conflict found"**, tests 3 and 4 are **"passed" / "failed"**. `SKILL.md` and `pitfall-flagging.md` updated to match.
- **Block H now carries the build level** from Step 8 (configuration · process adaptation · Studio · community module · custom). Step 8's output previously had no field in the record at all, while the CVBS lists that classification as a blocker.
- **Block A now carries the Step 2 inventory forward** — installed modules, settings state, and every existing customization touching the flow. Block E records only collisions, so a record of eight "None found" rows previously told a later reader nothing about what is actually installed.
- **Block E aligned to eight surfaces**, matching the TTD's §3.3 table row for row. These are `conflict-detection.md`'s checks re-cut for the document — its check 1 splits into rows 1 and 2, and its check 8 (upgrade fragility) reports in block F as a risk rather than here as a collision. Two checks — *altering a standard workflow the customer depends on* and *duplicating an existing customization* — existed in the reference but reached no document.
- **Block F's concern set is now the explicit ten** the TTD's §2b uses, rather than being derived from `pitfall-flagging.md` (which produced a set that double-counted two categories and omitted conflict-with-an-existing-customization).
- **Block C** already carried the process-adaptation rung; the TTD's alternatives table has been extended to match it.

### Notes

- `references/pitfall-flagging.md` and `references/ticket-intake.md` changed only in the post-audit fixes above (verdict wording; the ticket-pair cross-reference). Their substance is unchanged.
- **Blast radius:** `syncoria-aidlc-method` 1.1.0 depends on this record's field names. Release the two together.
