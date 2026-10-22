# Output Template — Discovery Record

The discovery record leads with decision-relevant content, puts the findings reference after, and derives the narrative last so prose can't drift from verified content. Deliver as an uploadable markdown file.

Use this structure. Adapt section depth to the meeting, but keep the order and keep every claim cited.

---

## Annotated skeleton

```markdown
# Discovery Session — [Subject] (Decision Record)

**Meeting:** "[verbatim meeting title]" · Recording length [N] min
**Engagement phase:** [e.g. Pre-sales discovery — phase, who's in scope; "no project signed" if pre-sales]
**Focus:** [what this session covered]

**Participants**
- [Name] — [org] ([role])
- ...

> **How to read this record.** Citations use [the transcript's locator style] plus a short verbatim
> quote so any line can be located. Genuine decisions are separated from discovery findings. [Any
> caveat — e.g. the auto-transcript merges speakers in places, so uncertain attributions are flagged.]

---

## 1. Decision Log
[Apply the meeting-decisions method. One entry per decision.]

### D1 — [decision stated plainly as finally settled]
**Status:** Decided | Reversed → Decided | Open | Deferred | Ambiguous
**Trail:**
- Reached: [locator] [speaker] — "exact quote"
- Changed/Reversed (if any): [locator] [speaker] — "exact quote" (what changed)
- Confirmed (if separate): [locator] — "exact quote"
**Note (optional):** [caveat, dependency, commercial implication]

---

## 2. Action Items

| # | Action | Owner | Due / when | Citation |
|---|--------|-------|-----------|----------|
| AI-1 | [task] | [owner] | [date or "not specified"] | [locator + short quote] |

---

## 3. Open Questions

- **Q1 — [topic].** [Why it's open: unresolved / deferred / unknown to the stakeholder.] [locator] [speaker] — "exact quote". [Dependency if any.]

---

## 4. Commercial Signals — surface, do not bury

[Pre-sales note if applicable: none of this is committed work.]

- **[Effort driver / scope risk / dependency / non-estimate / bounding figure]** — [1–2 sentences], [locator] — "exact quote".
- ...

**Attribution note (carry forward):** [Which figure belongs to which system; explicit warning against
conflation, e.g. "X touchpoints" belongs to integration A; "Y touchpoints" to integration B; neither is
a [parent-system]-wide figure.]

---

## 5. Key Discovery Findings — [subject] (reference, not decisions)

[Observed/demonstrated facts, by analysis dimension. Tight bullets, each cited. Pick the dimensions
that fit the meeting — examples below.]

**Business / operations**
- [fact] — [locator] "exact quote".

**Finance**
- ...

**Data & volumes**
- ...

**Integrations**
- ...

**Process workarounds**
- ...

**Tooling / operational notes**
- ...

---

## 6. Narrative summary

[Short prose, written last, derived from the sections above. Lead with what was decided and what's
open/at-risk; then the substantive findings. Don't introduce anything not already cited above.]

---

## 7. Register merge block  (only if the engagement has project-control-register.md)

> Proposed for syncoria-aidlc-method to merge. Not applied. Source: this record (the SRC ID is assigned by syncoria-aidlc-method at merge).

| Type | Proposed statement | Authority | Citation | Register check |
|---|---|---|---|---|
| DEC | [decision as settled] | A3 (reached + confirmed) / A4 (once) / A5 (second-hand: "X told me") / cites [document] | [locator] [speaker] — "quote" | new / confirms DEC-### / ⚠ touches settled DEC-### / ⚠ matches out-of-scope SCP-### |
| ASM / RSK / OQ / ACT / SCP | ... | | | |
```

---

## Section notes

- **Header.** Quote the meeting title exactly (the verification script will check it). State the engagement phase plainly — pre-sales vs. won project changes how every signal is read.
- **Decision Log.** This is the primary deliverable and the only section that asserts choices. Borrow the `meeting-decisions` discipline wholesale: trace the lifecycle, let the last word govern, separate "reached" from "confirmed". If the meeting genuinely decided little (common in walkthroughs), a short Decision Log is correct — don't pad it by promoting findings.
- **Action Items.** Include items actually assigned. Embedded auto-transcript "ACTION ITEM:" annotations are good seeds but tie each to its spoken context and a real owner.
- **Open Questions.** This is where to put things a plain summary would wrongly record as settled. "The stakeholder didn't know" is a valid open item — capture it.
- **Commercial Signals.** The section that earns the record its keep for scoping. Effort drivers, scope-expansion risks, key-person dependencies, explicitly-disowned estimates, and bounding counts — each flagged. Put the cross-system attribution warnings here so they're impossible to miss.
- **Key Discovery Findings.** The bulk. Organize by analysis dimension so it drops into the downstream `syncoria-aidlc-method` artifacts (a finding about a process → Process Prep Form / Current-State Map; a customization/integration → Gap log / CVBS scoping). Keep bullets tight (a sentence or two) and cited. Don't editorialize Odoo fit here beyond what was said — that's `syncoria-odoo`'s lane.
- **Narrative.** Orientation only. Derived last, from verified content. Brief.
- **Register merge block.** One row per item from sections 1–5 that belongs in the register (findings that are only observations stay out). Read the register before filling the "Register check" column, and use it to *flag*, never to resolve. Decision Log items that are Open, Deferred or Ambiguous go in as `OQ`, never `DEC`. A ⚠ row is a conflict or scope-creep candidate that `syncoria-aidlc-method` will put to the user. Engagement facts (version, edition, hosting, users) stated in the session always get a row, even when they only confirm what's settled: confirmations are what lift an entry's authority.

## Length and tone

- Lead with what was decided and what's open/at-risk; findings come after.
- Don't pad. A walkthrough with two real decisions gets two Decision Log entries and a rich Findings section, not invented decisions.
- Make ambiguity visible, not buried. Three genuinely unresolved things is an important finding, not a failure.
- Keep the whole record scannable — a consultant should be able to find any fact and its source in seconds.
