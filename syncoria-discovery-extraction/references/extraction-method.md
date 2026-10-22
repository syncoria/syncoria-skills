# The Extraction Method — Full Procedure

The detailed procedure for turning a discovery transcript into a verified record. The goal throughout: capture the **complete** information yield (not just decisions), classify each item honestly, and make every claim verifiable against the source.

## Why multiple passes

A single read compresses as it goes. By the time a system fact is revisited or a number is corrected 40 minutes later, the early version is already "written down" in working memory and the revision is lost. Separating *extraction* from *inventory* from *classification* from *verification* forces you to look at each item deliberately instead of letting the first-heard version win. This is the same logic the `meeting-decisions` skill uses for decisions — here it's applied to the whole information set.

## Step 0 — Extract the transcript to flat text

Work from a single flat text file for everything downstream, including quote verification. For a `.docx` auto-transcript:

```python
import docx
d = docx.Document(path)
paras = [p.text for p in d.paragraphs]
open('transcript.txt','w').write('\n'.join(paras))
```

For a `.pdf`, use the pdf reading approach (extract text per page). Then **detect the citation format** before extracting anything:
- Timestamps present (`@1:23:45`, `[01:12]`, `00:42:15`)? Cite timestamp + speaker + short quote. Preserve the transcript's own timestamp style.
- Speaker labels, no timestamps? Cite speaker + a short, distinctive exact quote.
- Plain prose? Cite by quoting the exact passage; the quote is the locator.

Note any embedded auto-generated annotations (e.g. "ACTION ITEM: …" lines some tools insert) — these are useful seeds for the Action Items section but must still be tied to the spoken context.

## Step 1 — Read fully, then inventory by category

Read the entire transcript before writing conclusions. As you read, build a flat index of every substantive item — just enough to find it again (a label + roughly where it appears). Capture items even if they recur; you'll consolidate later. Inventory completeness is the goal here, not resolution.

What to inventory:
- Every **choice weighed or made** (→ likely Decided).
- Everything **assigned to someone** (→ Action item).
- Everything **raised and left open** (→ Open question).
- Every **fact shown or stated** — a system behavior, a data volume, a frequency, an integration, a process step, a tool, a count (→ Observed/demonstrated). This is the bulk and is easy to under-capture.
- Every **number and proper noun**, with the system it attaches to.
- Every **scope/commercial signal** — effort drivers, "this is another session" expansions, key-person dependencies, non-estimates, bounding figures.

## Step 2 — Classify each item into exactly one of four buckets

- **Decided** — a choice was actually reached. Hand this to the `meeting-decisions` method: trace raised → debated → reversed → settled → confirmed; the recorded outcome is the **last** substantive statement, not the first or loudest. Mark status (Decided / Reversed→Decided / Open / Deferred / Ambiguous).
- **Action item** — a task with an owner. Owner, task, due (or "not specified"), citation. Don't infer tasks nobody was given.
- **Open question** — discussed, not resolved, or explicitly deferred. Cite where it was left hanging. This is where you put things a normal summary would wrongly record as settled.
- **Observed / demonstrated** — a fact the meeting surfaced. Goes in Key Discovery Findings (or Commercial Signals if it's a scope/effort signal). **Never promote an observed fact into a decision.** "They showed the discrepancy workaround" is observed; "they agreed to replace it" is decided — and only if the transcript actually shows the agreement.

The single most common error this skill prevents: recording demonstrated behavior as if it were an agreed decision. When in doubt, it's Observed.

## Step 3 — Pin every number and proper noun (traceability)

For each figure, record: the **exact quote**, the **locator**, and the **system/integration it describes**. Then check:
- Is this number stated as fact, as an estimate, or as an illustration? Record that framing. An illustrative "it's going to be 10,000 hours" is not an estimate — say so.
- Does it belong to a specific system? Keep it there. Never let a figure for System A drift onto System B, and never attach a subsystem's number to the parent system generally.
- Are two figures close or related? Keep them separate, quote each, and don't sum them into a clean total the speaker didn't actually state. If the speaker gave a rough combined figure ("roughly 22, 23"), record it as approximate, quoted, alongside — not merged.
- Was the figure stated with uncertainty ("seven billions, I guess it's millions")? Record the uncertainty and recommend verifying from source data rather than committing a number.

Carry attribution **across sessions**. If an earlier session pinned a number to a system, and a later session gives a different number for a different system, state both and keep them distinct. Mis-attributed numbers compound across a multi-session engagement.

## Step 4 — Surface commercial/scope signals

Pull the scope-relevant items into their own section so a reader sizing the work sees them immediately:
- **Effort drivers** — the things that will dominate the estimate (large customization counts, integration volume, data migration scope).
- **Scope-expansion risks** — "that's another discussion", promised deep-dives multiplying, a pivot in approach that implies more sessions.
- **Key-person dependencies** — one person holds the knowledge or access.
- **Non-estimates** — figures explicitly disowned as estimates; record them as *not* estimates so nobody later treats them as one.
- **Bounding figures** — counts that bound the work (number of stores, entities, integrations, reports, tables).
- **Cross-system attribution notes** — the carry-forward warnings about which number belongs to which system.

## Step 5 — Verify every quote verbatim

Run the script:

```bash
python scripts/verify_quotes.py <record.md> <transcript.txt>
```

It extracts every double-quoted span from the finished record and checks each appears verbatim in the source. It strips editorial inserts like `[Odoo]` before checking. Typical flags and fixes:
- **Punctuation pulled inside the quote** (`"…useful."` vs source `…useful` mid-sentence) → move the period/comma outside the closing quote.
- **Ellipsis bridging non-contiguous text** (`"A… B"` where A and B aren't adjacent in the source) → split into two separate quoted fragments, or paraphrase the join without quotes.
- **A coined label in quotes** (your own term, e.g. a section heading) → drop the quotes; only transcript text goes in citation quotes.
- **Casing/spacing mismatch** → match the source exactly.

Re-run until it reports zero missing.

## Step 6 — Self-verification pass

Hold the record beside the transcript one last time and check, for each item:
1. Does each **Decided** outcome match the *last* thing the transcript says on it? (Catch decisions recorded at an early, since-reversed state.)
2. Is anything in **Decided** actually only **Observed**? Demote it.
3. Is every **number** attributed to the correct system, with its framing (fact / estimate / illustration / uncertain) intact?
4. Is any **scope signal** sitting in findings prose where it should be flagged in Commercial Signals?
5. Is every **citation** exact and locatable (script-clean)?
6. Did any decision change **owner, scope, or value** between "reached" and "confirmed"? The confirmed version governs.

Only after this pass do you write the Narrative Summary — derived from the verified sections so it can't drift.

## Handling very long or multi-session transcripts

If a transcript is too long to hold reliably, work in sections but keep a **running index** across them, and carry forward open items and pinned numbers so a fact raised early and resolved late still connects. Do a final whole-transcript verification pass on the consolidated record. For a multi-session engagement, keep a cross-session attribution ledger of which figure belongs to which system, and restate the relevant carry-forward notes in each new record.

## What good looks like

Every decision has a clear final state and a citation trail. Every finding is a fact with a citation, organized by analysis dimension. Every number is pinned to the right system with its framing intact. Scope signals are flagged, not buried. The quote-verification script reports zero missing. A reader can spot-check any line in seconds and could scope an implementation from the record without re-watching the recording.
