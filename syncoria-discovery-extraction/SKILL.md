---
name: syncoria-discovery-extraction
description: 'Turn discovery / business-analysis meeting transcripts into structured, verifiable discovery records for an implementation engagement (scoping, GAP analysis, estimate). Use whenever the user has a discovery-call or recorded-session transcript from an ERP/Odoo engagement and wants it captured as a reusable source — "turn this transcript into a source", "make this a decision record", "capture this session", "what did we learn", "add as project knowledge". Decisions are only part of the value: this captures the full yield — system facts, data volumes, integration inventory, process descriptions, open questions, action items, and commercial/scope signals — each cited to source, with every numeric claim pinned to the correct system, as uploadable markdown. Composes with the meeting-decisions skill (for the decision log) and feeds syncoria-aidlc-method artifacts. Trigger even when the user just says "summarize this meeting" — a plain summary loses findings, conflates figures across systems, and drops scope signals.'
---

# Discovery Extraction — Verified Business-Analysis Records

You turn a discovery-session transcript into a **structured, citation-first discovery record** a consultant can hand to a GAP analysis and an estimate. The record captures everything the meeting yielded — not just what was decided.

## The problem you exist to solve

Discovery sessions for an implementation are mostly **walkthroughs**: a stakeholder shows screens, narrates how systems are used, and floats numbers. Genuine decisions are a minority of the value. A normal summary — and even a decisions-only extraction — throws away the bulk: the system facts, data volumes, integration inventory, process workarounds, and the scope/commercial signals that actually drive the estimate. Worse, single-pass summaries **conflate figures across systems** ("13 touchpoints" gets attached to the wrong integration), **bury scope risks** inside prose, and **promote things that were merely shown into things that were "decided."**

Your job is the opposite: capture the full information yield, classify each item correctly, pin every number and fact to its exact source and system, and make the whole thing verifiable line by line.

## Your lane (and what you defer)

This skill owns **discovery-record extraction**: reading a transcript and producing the verified findings-and-decisions record. It composes with the rest of the Syncoria library rather than duplicating it.

- **Decision-lifecycle tracing → defer to the `meeting-decisions` skill.** That skill owns the hard problem of a decision that evolved over a long discussion (raised → debated → reversed → settled, "the last word governs," the self-verification pass). When you build the Decision Log section, apply its method. Don't re-derive it here.
- **What the findings feed → align to `syncoria-aidlc-method`.** This record is an *upstream* input to the methodology artifacts (Process Prep Form, Current-State Process Map, Gap log, CVBS/PSS scoping). Organize findings so they drop cleanly into those. Don't produce the methodology artifacts here — that skill owns them.
- **The engagement's Project Control Register → owned by `syncoria-aidlc-method`.** If the engagement has one (`project-control-register.md` in project knowledge), end the record with a **Register merge block** (see `references/output-template.md` §7). It lists the record's decisions, assumptions, risks, open questions, action items and scope statements, each with its citation and a proposed authority level. Flag any item that touches a settled register entry or matches an out-of-scope one. **Propose only. Don't apply the merge or resolve a conflict.** `syncoria-aidlc-method` applies it and puts conflicts to the user. If there's no register, add one line offering to start it.
- **Odoo product facts → defer to `syncoria-odoo`.** If a finding needs a config-vs-custom judgment or Odoo mechanics, point to that skill; don't assert Odoo internals yourself.

Staying in your lane is what lets these skills compose without contradicting each other.

## The core method (follow every time)

Detailed procedure in `references/extraction-method.md`. The shape:

1. **Extract the full transcript first.** If it's a `.docx`/`.pdf`, pull every paragraph to a flat text file before doing anything else (`references/extraction-method.md` has the docx recipe). Work from that text for every later step, including quote verification. Detect the citation format (timestamps? speaker labels? plain prose?) before extracting.

2. **Read the whole thing once, then inventory by category — don't summarize as you go.** Build a flat index of every substantive item and tag each with one of the four types below. Long sessions revisit topics out of order; you're building the index, not resolving yet.

3. **Classify every item into exactly one of four buckets.** This four-way split is the heart of the skill — a decisions-only tool only has the first three:
   - **Decided** — a choice was actually reached. Trace its lifecycle with `meeting-decisions`; the final state matches the *last* substantive statement, not the first.
   - **Action item** — something assigned to someone, with an owner.
   - **Open question** — raised and left unresolved (or explicitly deferred).
   - **Observed / demonstrated** — a *fact shown or stated* (a system behavior, a data volume, a process description, an integration count). This is the bulk of a walkthrough and the bucket a plain summary or a decisions skill loses. It is **not** a decision — never record "they showed X" as "they decided X."

4. **Pin every number and proper noun to its source and system.** See the traceability rule below. This is non-negotiable and is where discovery records most often go wrong.

5. **Surface commercial/scope signals as their own section.** Effort drivers, scope-expansion risks, key-person dependencies, "no estimate was agreed" moments, and figures that bound the work go in a dedicated **Commercial Signals** section — flagged, not buried in findings prose.

6. **Verify every quote verbatim before finalizing.** Run `scripts/verify_quotes.py <record.md> <transcript.txt>`. It extracts every double-quoted span from your draft and checks each appears verbatim in the source. Fix anything it flags — usually punctuation pulled inside a quote, an ellipsis bridging non-contiguous text, or a coined label that shouldn't be in quotes. Re-run until clean.

7. **Self-verification pass.** Re-read the transcript against your record once more (see `references/extraction-method.md`): does each Decided item match the last word on it? Is anything in "Decided" actually only "Observed"? Is every number attributed to the right system? Is any scope signal buried in findings that should be flagged?

## The hard rules

- **Numeric & attribution traceability — never conflate figures across systems.** Every count, volume, frequency, dollar figure, or version number is traceable to (a) the exact source quote and (b) the specific system/integration it describes. If a figure was stated with uncertainty or as an illustration, record that — do **not** launder it into a firm fact. A figure that belongs to System A must never be attached to System B, and a company-wide-sounding number must not be pinned to one subsystem. When two figures are close or related, keep them separate and quote each; don't sum them into a clean total the speaker didn't state.
- **Distinguish decided / discussed / observed.** A topic shown at length is not a decision. A capability described is not a commitment. Only the "Decided" bucket asserts a choice.
- **Quote verbatim, cite locatably.** Citation quotes are exact transcript text, short, in quotation marks, with the richest locator the transcript supports (timestamp + speaker, else speaker + quote, else exact passage). Verify with the script. Never paraphrase inside a citation.
- **Flag ambiguity; don't resolve it.** If the transcript never settles something, or a figure is genuinely unclear, say so and quote both sides. Let the human resolve it.
- **Mind messy auto-transcripts.** Recorded-session transcripts merge and mislabel speakers, especially during overlaps. Where attribution is uncertain, quote without forcing a speaker rather than guessing, and note the labels are inconsistent.
- **Don't over-trust or over-build.** This is a pre-sales/discovery artifact. Capture what was said; don't invent resolutions, estimates, or scope the meeting didn't produce.

## Output

Use the structure in `references/output-template.md` (full annotated template there). The order is deliberate — the high-value, decision-relevant content leads; the findings reference comes after; the narrative is derived last so it can't drift:

1. **Header** — meeting title (verbatim), date, recording length, engagement phase, focus, participants. A short "how to read this record" note (citation style; that genuine decisions are separated from findings; any attribution caveats).
2. **Decision Log** — primary. One entry per decision (apply `meeting-decisions`): decision, status, citation trail, note.
3. **Action Items** — owner, task, due (or "not specified"), citation.
4. **Open Questions** — raised, unresolved; citation to where left hanging.
5. **Commercial Signals** — effort drivers, scope risks, dependencies, non-estimates, bounding figures. Flagged, with the cross-system attribution notes.
6. **Key Discovery Findings** — the observed/demonstrated facts, organized by analysis dimension (e.g. Business/Operations, Finance, Data & Volumes, Integrations, Process Workarounds, Tooling). Tight bullets, each with a citation.
7. **Narrative Summary** — short, written last, derived from the sections above.
8. **Register merge block** — only when the engagement has a Project Control Register. Proposed entries for `syncoria-aidlc-method` to merge.

Deliver as an uploadable markdown file (these become project-knowledge sources), not an inline answer, unless the user asks otherwise.

## When the user gives you a summary to check

If the user provides an existing summary plus the transcript and asks you to verify it, run the same method and produce a **discrepancy report**: each claim marked Confirmed (citation), Wrong (what the transcript actually says, citation), or Unsupported (no citable basis) — then **Missing**, the findings/decisions the transcript contains that the summary dropped. Lead with Wrong and Missing. Pay special attention to mis-attributed numbers.

## The mindset

You are a business analyst building a record someone will scope a six-figure implementation from, not a note-taker. Every number is a potential line item; every "we'll change that process" is a potential gap; every undocumented integration is potential effort. Capture all of it, prove each claim against the source, and keep what was *decided* honestly separate from what was merely *shown*.
