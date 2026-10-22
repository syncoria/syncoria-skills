# The Extraction Method — Full Procedure

The detailed procedure for decision-centric extraction. The goal throughout: catch decisions that evolved over a long discussion, which single-pass summarization misses.

## Why multiple passes

A single read compresses as it goes, so by the time a topic is revisited 40 minutes later, the early version is already "written down" in your working memory and the revision gets lost or under-weighted. Separating *inventory* from *lifecycle tracing* from *verification* forces you to look at each decision's whole arc deliberately, instead of letting the first-heard version win.

## Pass 1 — Inventory the decision topics

Read the entire transcript before writing any conclusions. As you read, build a flat list of every topic that involved a decision, an action, or an unresolved question. For each, note just enough to find it again — a label and roughly where it appears. Do **not** resolve outcomes yet.

What counts as a topic to inventory:
- Anything where options were weighed or a choice was made.
- Anything assigned to someone (action item).
- Anything raised and left open.
- Anything where people disagreed, even if it seemed resolved — disagreements are where decisions most often evolve.

Capture topics even if they appear several times; you'll consolidate in Pass 2. The point of Pass 1 is completeness of the index, not resolution.

## Pass 2 — Trace each decision's lifecycle

For each inventoried topic, go back through the transcript and find every point it was touched. You are building a timeline for each decision:

- **Raised:** where the topic first comes up, and the initial position or framing.
- **Debated / shifted:** each point where a position changes, an objection lands, new information reframes it, or someone proposes an alternative. Note what changed and who drove it.
- **Reversed:** if an earlier apparent decision was undone, mark exactly where and why.
- **Settled:** where the decision reaches its final form.
- **Confirmed:** where it was restated, written down, or explicitly agreed ("okay, so we're going with X"). This may be separate from where it was settled.

Search deliberately for re-openings. A topic that seemed closed at 00:15 may be reopened at 01:10. Scan forward through the *whole* transcript for each topic before concluding — do not stop at the first apparent resolution.

## Pass 3 — Determine the true final state

For each decision, the recorded outcome is the **last substantive statement on the topic**, not the first and not the most emphatic. Apply these rules:

- If a topic was settled and never reopened → that's the outcome.
- If it was settled, then reopened and re-settled → the later settlement governs. The earlier one is part of the trail (cite it as "initially decided X, later changed to Y") but is not the outcome.
- If it was discussed but never clearly resolved → it is **Open**, not Decided. Do not infer a resolution from the general drift of conversation.
- If two final statements conflict and neither clearly supersedes the other → flag as **Ambiguous** and cite both. Let the human resolve it.

## Pass 4 — Cite every touch point

For each decision, attach citations to each stage of its trail (reached, each change, confirmed). Use the locator the transcript supports (see citation-formats.md). Every citation is a short, exact, quoted snippet plus its locator. The test: could the user open the transcript and land on this exact moment? If not, the citation isn't good enough.

## Pass 5 — Self-verification (the pass that catches the failure)

This is the most important pass and the one a normal summary skips. Re-read the transcript a final time, holding your decision list beside it, and for each decision ask:

1. **Does my recorded outcome match the last thing the transcript actually says on this topic?** If the transcript's final word differs from what you recorded, you caught the failure — fix it.
2. **Did I miss a re-opening?** Scan for the topic appearing later than where I marked it settled.
3. **Am I recording a decision that was only ever discussed, never decided?** Demote it to Open.
4. **Is every citation exact and locatable?** Fix any that paraphrase or point vaguely.
5. **Did a decision change owner, scope, or value between "reached" and "confirmed"?** People often agree to a rough version, then tighten it later — the confirmed version governs.

Only after this pass do you write the final output.

## Handling very long transcripts

If a transcript is long enough that holding it all at once is unreliable, work in sections but keep a **running decision index** across sections, and explicitly carry forward open topics so a decision settled in section 5 that was raised in section 1 still gets connected. The cross-section carry-forward is exactly where long-meeting decisions get dropped — be deliberate about it. Do a final whole-transcript verification pass on the consolidated decision list even when you traced in sections.

## What good looks like

Every decision has a clear final state, a status, and a citation trail a human can follow. Evolved decisions show their evolution ("initially X at [time], reversed at [time], finally Y at [time]"). Nothing is recorded as decided that the transcript doesn't actually settle. The user can spot-check any entry in seconds by following its citation.
