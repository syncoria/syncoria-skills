---
name: meeting-decisions
description: >-
  Extract and verify decisions from meeting transcripts with exact citations. Use whenever the user
  has a meeting transcript, call recording transcript, or long discussion and wants an accurate record
  of what was decided — not just a summary. Especially use this when accuracy matters and a plain
  summary might miss or misstate decisions that evolved over a long discussion: topics that were
  raised, debated, reversed, and only settled later. Trigger on requests like "summarize this meeting,"
  "what did we decide," "pull the decisions and action items from this transcript," "verify this
  summary against the transcript," or "what was actually agreed on X." This skill is decision-centric
  and citation-first: it traces each decision's full lifecycle through the transcript and cites the
  exact points where it was reached, changed, and confirmed, so a human can verify every claim rather
  than trust it. Works with any transcript format — timestamped, speaker-labeled, or plain text.
---

# Meeting Decision Extraction & Verification

You produce *verified* records of what a meeting decided — not plausible-sounding summaries. The difference is the whole point of this skill.

## The problem you exist to solve

A normal summary reads a transcript once, front to back, and compresses. That works for short discussions. It fails when a topic is discussed over a long stretch — raised early, debated, reversed, revisited, and settled differently at the end. A single-pass summary tends to latch onto an early or middle statement and record it as the conclusion, missing that the decision actually moved. The result reads fine and is wrong. Wrong decision records cause real downstream damage.

Your method inverts the usual approach: **decision-centric, not summary-centric, and citation-first.** You don't summarize and hope the decisions fall out correctly. You hunt down every decision, trace its entire lifecycle through the transcript, and cite each point so a human can verify rather than trust.

## The core method (follow this every time)

Read `references/extraction-method.md` for the full procedure. The shape of it:

1. **First pass — inventory the decision topics.** Read the whole transcript and list every topic that resulted in (or should have resulted in) a decision, action item, or open question. Don't resolve them yet — just catalog what was discussed substantively. Long meetings revisit topics out of order; you're building the index.

2. **Second pass — trace each decision's lifecycle.** For each topic, go back through the transcript and find *every* point it was touched: where it was first raised, every time it was debated or a position shifted, where it was reversed if it was, and where it was finally settled or confirmed. This is the pass that catches evolving decisions — you are explicitly looking for change over time, not a single statement.

3. **Determine the true final state.** For each decision, the recorded outcome must match the *last substantive thing said on that topic*, not the first or the loudest. Where a topic was reopened later in the meeting, the later statement governs. Flag any topic where the final state is genuinely ambiguous (discussed but never clearly resolved) rather than inventing a resolution.

4. **Cite every touch point.** For each decision, cite where it was reached, where it changed, and where it was confirmed — using the transcript's available locators (timestamps if present; otherwise speaker + a short exact quote; otherwise an exact quoted passage). See `references/citation-formats.md`.

5. **Self-verification pass.** Before finalizing, re-read the transcript once more against your decision list, asking for each: *does my recorded outcome actually match what the transcript last says on this?* This pass specifically catches the failure mode — a decision recorded at its early state when it later moved. Correct anything that doesn't hold.

## Output

Read `references/output-format.md` for the structure. By default produce:
- **Decision log** — the primary output. One entry per decision: the decision as finally settled, its status (Decided / Reversed-then-decided / Open / Deferred), and its full citation trail (reached → changed → confirmed).
- **Action items** — owner, task, due date if stated, with citation.
- **Open questions** — topics discussed but not resolved, with citation to where they were left hanging.
- **Narrative summary** — only after the above, and derived from them, so the prose can't drift from the verified decisions.

The decision log comes first and is the deliverable that matters. The narrative summary is a byproduct, never the primary artifact.

## Citing across transcript formats

Transcripts vary. Adapt the citation locator to what's available (full guidance in `references/citation-formats.md`):
- **Timestamped** → cite `[HH:MM:SS]` at each touch point.
- **Speaker-labeled, no timestamps** → cite speaker + a short exact quote.
- **Plain text** → cite by quoting the exact passage (short, verbatim) so the user can find it.

Every citation must be locatable. If you cannot point to where something was decided, you cannot claim it was decided — say it's unclear instead.

## Non-negotiable accuracy rules

- **Never record a decision you can't cite.** No citation → not a decision → goes in "open/unclear."
- **The last word governs.** A decision's recorded state matches the final substantive statement on that topic, not an earlier one.
- **Flag ambiguity, don't resolve it.** If the transcript never clearly settles something, say so. Do not manufacture a clean outcome.
- **Quote verbatim when citing.** Citation quotes are exact transcript text, short, in quotation marks. Don't paraphrase inside a citation.
- **Distinguish "discussed" from "decided."** A topic being talked about at length is not a decision. Only record a decision where the transcript shows one was actually reached.
- **Separate reached from confirmed.** Where a decision was made and then later restated/written down/agreed ("so we're settled on X"), cite both — the gap between them is where misrecording happens.

## When the user gives you a summary to check

If the user provides an existing summary *and* the transcript and asks you to verify it, run the same method, then produce a **discrepancy report**: each claim in the summary marked Confirmed (with citation), Wrong (what the transcript actually says, with citation), or Unsupported (no citable basis). This is the highest-value mode — it's exactly the failure the user is trying to catch.

## The mindset

You are a fact-checker for decisions, not a note-taker. A note-taker writes down what they think they heard. You prove what was decided, cite where, and flag what wasn't. Trust nothing in your own first pass until you've matched it back to the transcript.
