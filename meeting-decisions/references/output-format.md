# Output Format

The decision log is the primary deliverable. The narrative summary is a byproduct, produced last, derived from the verified log so it can't drift. Default to inline output unless the user asks for a file.

## Default structure

### 1. Decision Log (primary)

One entry per decision. Order by topic or by when settled — whatever is clearer for this meeting.

For each decision:
- **Decision:** the outcome as finally settled, stated plainly.
- **Status:** one of —
  - `Decided` — reached and not reopened.
  - `Reversed → Decided` — an earlier decision was changed; the trail shows the change.
  - `Open` — discussed but not clearly resolved.
  - `Deferred` — explicitly postponed to a later time/meeting.
  - `Ambiguous` — conflicting final statements; needs human resolution.
- **Trail:** the citation trail, in order:
  - Reached: [locator] — "exact quote"
  - Changed/Reversed (if any): [locator] — "exact quote" (what changed)
  - Confirmed (if separate): [locator] — "exact quote"
- **Note (optional):** any caveat, dependency, or ambiguity worth flagging.

Example (timestamped transcript):
> **Decision:** Roll out the new system in one big-bang cutover on the 14th, not phased.
> **Status:** Reversed → Decided
> **Trail:**
> - Reached: [00:41:30] Maria — "let's go with the phased rollout"
> - Reversed: [01:08:12] David — "scrap the phasing, we need it all live for the audit"
> - Confirmed: [01:15:02] Maria — "fine, big-bang on the 14th then"
> **Note:** The reversal was driven by the audit deadline; if that date moves, revisit.

### 2. Action Items

Table or list. For each: owner, task, due date (if stated, else "not specified"), citation. Only include items actually assigned in the transcript — don't infer tasks.

### 3. Open Questions

Topics raised but not resolved. For each: the question, why it's open (no resolution reached / explicitly deferred), and a citation to where it was left. This section is where you put things a normal summary would have wrongly recorded as decided.

### 4. Narrative Summary (last, optional)

A short prose summary, written *after* and *from* the decision log. Because it's derived from the verified decisions, it can't contradict them. Keep it brief — the decision log is the record; this is orientation. If the user only wants the decisions, skip this.

## Verification / discrepancy mode

When the user provides an existing summary to check against the transcript, produce a **Discrepancy Report** instead of (or before) the decision log:

For each claim in the provided summary:
- **Confirmed** — matches the transcript. Citation.
- **Wrong** — the transcript says something different. State what it actually says, with citation.
- **Unsupported** — no citable basis in the transcript. Flag it.

Then list **Missing** — decisions the transcript clearly contains that the summary omitted, with citations. Lead with the Wrong and Missing items — those are the ones that matter.

## File output

If the user wants a file (e.g., to keep or circulate), markdown is the clean default — the decision log with its citations reads well and pastes anywhere. Only produce a heavier format (docx) if asked. Keep citations intact in any format.

## Tone and length

- Lead with what was decided and what's wrong/open — the high-value content first.
- Don't pad. A meeting with six real decisions gets six entries, not a wall of prose.
- Make ambiguity visible, not buried. If three things are genuinely unresolved, that's an important finding, not a failure — surface it clearly.
