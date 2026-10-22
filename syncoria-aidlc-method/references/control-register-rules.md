# Project Control Register (Artifact 00)

The engagement's living record of **what is currently true**: scope, decisions, assumptions, risks, open questions, action items and tasks. Every entry carries a citation. It is kept as a markdown file in the engagement's Claude Project knowledge, so every chat in that project can see it.

**Why it exists.** Settled things keep coming back: an excluded item returns as scope creep, a decided question (such as the edition) gets asked again, a confirmed assumption reappears as open. The cause is that nothing in front of the drafter says *this is settled, here, by whom.* The register is that thing. It only works if it is **read before anything is built, asked or answered, and changed only through the merge.**

**What it is not.** It is not a second scope contract. Signed artifacts (PSS, CVBS, CRs, Build Plan, Work Orders) stay the authority. For scope, the register indexes them, and it holds what they don't: meeting decisions, assumptions, risks, commitments. If it disagrees with a signed artifact, the signed artifact governs and the disagreement is a finding.

---

## Part 1 — The rules

### Rule 1 — Register first

On any engagement that has a register, **read it before you**:

- produce or revise any artifact;
- answer a question about scope, decisions, assumptions, commitments or status ("did we agree X?", "is Y in scope?");
- process new material (a transcript record, an email, a signed document).

This is step 0 of the input check. If the register arrives only as search excerpts, search it by topic for **every** item the work depends on, and say which entries you checked. If an engagement has **no register**, offer to create or bootstrap one (Part 7). Don't block the artifact on it (Path B applies), but say that nothing is protecting settled items.

### Rule 2 — Settled means settled

An entry is **settled** when its status is terminal (`Settled`, `Validated`, `Invalidated`, `In scope`, `Out of scope`, `Descoped`, `Answered`, `Withdrawn`) **and** its authority is A1–A3. An entry resting only on A4/A5 is `Proposed` whatever its type: write `Proposed` in its Status cell until it's confirmed. Settled entries **govern**. You don't re-derive them, re-ask them, or quietly use an alternative, even when the alternative comes from:

- your own reasoning, a template default, or general Odoo practice;
- an older document (a stale SoW, an early discovery record, an earlier artifact version);
- something said earlier in the current conversation;
- a new source that reopens the topic without resolving it.

If you think a settled entry is wrong, raise a **conflict** (Part 5). Until the user rules, the settled value is the one you use, and you say that you're using it.

### Rule 2a — The ask-check: look before you ask

**Before you put any question to the user or the customer, check it against the register.** That includes the blocker/recommended/context asks of the input check, the "confirm version and edition" asks in the CVBS and TTD dependencies, and the review's own intake questions. If the register settles it, **don't ask. State the answer and its ID**: "Odoo 19 (DEC-001), Community (DEC-002, confirmed by email 2026-08-14), on-premise (DEC-003)."

Re-ask only when:

- the entry is `Proposed` and the user hasn't confirmed it yet. Ask **once**, to *confirm* it rather than to get it fresh ("the register has DEC-002 as Community, from one meeting. Can you confirm?"). Record the answer (Part 3.2) and don't ask again in later chats;
- the entry has a row in §0c (a pending conflict or reopen);
- the artifact needs something more specific than the entry settles (the register says "Community", and the TTD also needs the exact minor version read off the instance). Ask only for the missing part, and say what is already settled.

**The ask-check stops questions to people. It never stops a read of the system.** Version, edition and installed modules read off the instance, and internals read off the deployed source, are verification, and the TTD's dated review trace requires them. Pass DEC-001/002 to `syncoria-customization-review` as the expected values. **Never write an expected value into the review trace as if it had been read**: the trace records only what was actually read, when and where. If the instance disagrees, raise a conflict and use the instance value in the TTD trace, marked pending. When handing work to another skill, pass the settled entries with their IDs.

### Rule 2b — The scope-creep check

Whenever a request, ticket, transcript, email or artifact draft contains an item, **check it against the `Out of scope` and `Descoped` `SCP` entries (rejected CRs included).** Match on the topic, not the wording ("a customer portal for order status" is the same item as "portal access for B2B customers"). On a match:

- **don't add the item as scope** to the artifact being drafted (a CR or Work Order proposing it is the exception);
- flag it: `Previously excluded: SCP-018 (Out of scope · A1 · PSS v1.0 §11 row 6 · signed by M. Tan, 2026-07-30)`. Always name who excluded it and when; if the register doesn't record who, say "excluder not recorded";
- route it: on a project, a Change Request candidate (`SCP-### Pending CR`); on a support ticket, a Work Order or project per Syncoria's service delivery rules. Never "just include it, it's small".

Items excluded **in a meeting but never written into the PSS** come back most often, because no signed document holds them. Record them as `Out of scope` at their real authority (usually A3) and put them in the next decision-confirmation note (Part 6) to lift them to A2.

### Rule 3 — Change only through the merge

Nothing is added to, changed in, or removed from the register except by the merge procedure in Part 4. **You never edit a settled entry on your own authority.** Additions that don't conflict with anything, confirming citations, and promotions backed by a confirming source can be applied directly and are listed in the change log. Anything that contradicts a settled entry goes to the user as a conflict.

### Rule 4 — Keep it current, and say so every time

A stale register is worse than none, because it looks authoritative. Currency can't depend on anyone remembering, so **every reply on an engagement ends with a register footer**, the standing reminder:

```
── Register ──────────────────────────────────────────
Read: v14 (updated 2026-09-22)
This turn: +2 ASM, DEC-019 promoted to Settled, ACT-033 closed. Written back ✓
Conflicts awaiting your ruling: DEC-012 cutover approach (see above). Please rule: keep / supersede / CR
Also: ACT-027 overdue 6 days (Maria, data templates) · 23 Sep session has no ledger entry. Merge its record?
```

- **Read.** Version and date. **If you can't see the register**, ask for it: *"I can't see `project-control-register.md` in this chat. Please add it to project knowledge or attach it here, so I can check what's settled. Until then, nothing stops settled items from resurfacing."* Ask before building an artifact (Path B still applies if it can't be supplied). Never answer "what did we decide/assume/scope" from memory as if it were the register; ask for it, or label the answer unverified. If the user says no register exists and declines to create one, the line becomes `Register: none (declined [date])`. Don't ask again in this chat.
- **This turn.** What changed and whether it was saved. **If you can write**, write and mark ✓. **If you can't**, keep a running count (`Unsaved: 3 changes since v14`). Small changes from drafting an artifact (a new OQ or ASM) accumulate. Deliver the complete file as a download after merging a source, after a conflict ruling, when unsaved changes reach five, when the user signals they're wrapping up, or when they ask, and say: *"I can't update project knowledge from here. Please replace `project-control-register.md` with the attached v15 and remove the old copy. Until then other chats read v14."* Don't reprint the file inline every turn. Nothing changed: `This turn: no changes`.
- **Conflicts awaiting your ruling.** **Every** row in §0c, every turn, until ruled: ID, topic, the choices. A new conflict gets the full Part 5 block in the reply body. Conflicts never expire.
- **Also** (only when there's something): overdue `ACT`/`TSK`; `Proposed` entries older than the last gate; **unmerged material** (a meeting, email or signed document mentioned with no ledger entry), with an offer to merge it; no update for about two weeks on an active engagement.

**No register visible:** ask for it in the body, not only in the footer. Say "I can't see a register", not "there is no register", unless the user has confirmed that. The footer still shows all three lines (`Read: not visible · This turn: n/a · Conflicts: unknown until the register is available`).

Keep the footer to one line per item, and don't repeat what the body already said: point to it ("see conflict above"). Omit the footer only in chats unrelated to an engagement, never because nothing happened. `Read: v14 · no changes · Conflicts: none` is the proof it was checked.

---

## Part 2 — Structure

One file per engagement, named `project-control-register.md`, at the root of the engagement's project knowledge. Its sections (numbered **§0–§9** below, and cited that way throughout: "register §3") always appear in this order. This reference's own sections are called **Parts** so the two numberings can't be confused. Keep every section present, even when empty ("None yet"), so an empty section reads as checked rather than forgotten.

| Register § | Section | ID prefix | Holds |
|---|---|---|---|
| 0 | Header, engagement facts, sources, pending conflicts | `SRC-` | Register version; §0a engagement facts (each a `DEC`); §0b every source ever merged; §0c conflicts and reopens awaiting a ruling |
| 1 | Scope of Work | `SCP-` | Governing artifacts, in-scope items, **out-of-scope items**, pending scope changes |
| 2 | Decisions | `DEC-` | Choices reached, with who settled them and how firmly |
| 3 | Assumptions | `ASM-` | Things taken as true without proof, with the consequence if they are wrong |
| 4 | Risks | `RSK-` | Things that could go wrong, with owner and mitigation. A risk that has happened stays here as `Occurred` |
| 5 | Open Questions | `OQ-` | Raised and not yet resolved. Kept so that nobody records them as decided |
| 6 | Action Items | `ACT-` | Commitments made *to someone*, in a meeting or in writing, by either side |
| 7 | Tasks / To-do | `TSK-` | Syncoria's own internal work plan, not tied to a commitment made in a meeting |
| 8 | Superseded & Closed | — | Prior versions of changed entries; closed actions and tasks |
| 9 | Change log | — | One line per merge: what came in and what changed |

**Action item or task?** Promised to someone (in a meeting or in writing) → `ACT`, cited to where it was promised. Syncoria's own plan, promised to nobody → `TSK`. A missed `ACT` is a broken promise; a missed `TSK` is a slipped plan.

**Engagement facts.** The facts that every downstream skill needs, and so asks for, sit in a fixed block at the top of the file. Each fact is a `DEC` entry: `DEC-001` Odoo version · `DEC-002` edition (Community / Enterprise) · `DEC-003` hosting (Odoo Online / Odoo.sh / on-premise) · `DEC-004` localization and companies · `DEC-005` licensed user count · `DEC-006` target go-live. Reserve these IDs at creation even when nothing has been reached yet, so everyone knows where to look. Leave Value and Status as `—` and link the `OQ` that asks for it.

**IDs are permanent.** An ID names a *topic*, not a wording. Never reuse or renumber one. When an entry changes, it keeps its ID and gains a version (`DEC-012 v2`). The prior version moves to register §8 with a pointer. Artifacts cite register IDs, so a superseded ID tells you exactly which artifacts need revisiting.

---

## Part 3 — Entry schema

### Fields (the template's columns are authoritative for each section)

| Field | Rule |
|---|---|
| **ID + version** | `DEC-012 v1`. Version increments only through a ruled supersession |
| **Statement** | One or two sentences in the customer's language. Specific enough that the opposite would be obviously different ("PO approval by buyer limit only, no category rule", not "approvals discussed") |
| **Status** | From the vocabulary for that entry type, below |
| **Authority** | A level from the ladder in Part 3.1. This is what decides conflicts |
| **Citations** | At least one. Where the item was *reached* and, if separate, where it was *confirmed*. Format in Part 3.2 |
| **Settled by** | Person and role (customer-side and/or Syncoria), when the status is a settled one |
| **Date** | Date of the governing citation, not the date you wrote the entry |
| **Links** | Related register IDs, and the artifact + section that relies on or records it (`PSS v1.0 §3.2`, `CVBS-007 AC-4`, `GDL Sales row 3`) |

### Status vocabulary, and the extra fields each type needs

| Type | Statuses | Additional fields |
|---|---|---|
| `SCP` | `In scope` · `Out of scope` · `Pending CR` · `Descoped` | Governing artifact + section; CR number if one exists |
| `DEC` | `Proposed` · `Settled` · `Superseded` | `Proposed` = reached but not confirmed, or reported second-hand. Reopens are tracked in §0c, not as a status |
| `ASM` | `Open` · `Validated` · `Invalidated` · `Superseded` | **If wrong** (the consequence); **Blocking / non-blocking**, and for which artifact or gate; **Validate by** (who and when) |
| `RSK` | `Open` · `Mitigated` · `Occurred` · `Closed` | Likelihood H/M/L · Impact H/M/L · Owner · Mitigation · Trigger (the observable sign it is happening) |
| `OQ` | `Open` · `Answered` · `Withdrawn` | Owner · Needed by (date or gate) · **Blocks** (which DEC, artifact or gate) · Answered by (the DEC or ASM ID it became) |
| `ACT` | `Open` · `Done` · `Dropped` | Owner (named person, either side) · Due (or "not specified") · Evidence of completion · For `Dropped`: who released it and where |
| `TSK` | `Open` · `In progress` · `Done` · `Dropped` | Owner · Due · Depends on |

**Overdue is not a status.** It is computed from Due against today's date, and you report it whenever you read the register for status.

### Part 3.1 — Authority ladder

When two sources disagree, the higher authority governs. **A lower authority never overrides a higher one, however recent it is.**

| Level | Source | Can change a settled entry? |
|---|---|---|
| **A1 — Signed** | A signed artifact: PSS, CVBS, Change Request, Build Plan, Work Order, a signed UAT-as-SoW, the Hypercare Summary | Only through another signed artifact, in practice an approved CR |
| **A2 — Written confirmation** | Written confirmation from someone with authority on the customer's side (an email reply, approved minutes, a decision-confirmation reply), or a written ruling from Syncoria's Consulting Lead on a classification | Yes, via a ruled conflict |
| **A3 — Confirmed in meeting** | A decision cited at both the *reached* and *confirmed* points ("so we're settled on X"). For an assumption, risk or action: stated **and** explicitly accepted by the other side in the same meeting | Yes, via a ruled conflict |
| **A4 — Reached, unconfirmed** | Stated in a meeting once, never restated, confirmed or accepted | Can't override anything above it. Enters as `Proposed` |
| **A5 — Reported** | Second-hand ("the client told me…"), or recalled with no source | Can't override anything. Enters as `Proposed` with a confirmation `ACT` |

**Currency.** A source has authority only while it is current. A document replaced by a later version or by the signed PSS (for example, a pre-sales SoW) is marked `superseded` in the ledger's Current? column. It can't reopen anything and is used only to catch omissions. If an older A1 that is still in force disagrees with a later A2/A3, that is a conflict for the user, not an automatic win either way.

Rules that follow from the ladder:

- **A meeting cannot change signed scope.** If an A3 or A4 source "decides" something that contradicts an A1 scope entry, the scope entry stays as it is. You create an `SCP` entry with status `Pending CR`, plus an `OQ`, and flag it. That is a Change Request candidate, not a register update. Where it reads as a new requirement, it is also a chargeability question for the CR root-cause table in `methodology.md`.
- **For settled entries, within one level, the later source is the *candidate*, not the winner.** It still goes to the user. Later statements are often misremembered, misattributed or recirculated stale text, which is exactly what the register exists to catch.

### Part 3.2 — Citation format

Citations are short because the Sources ledger holds the detail: `SRC-### + locator + verbatim quote where there is one`.

- Transcript record: `SRC-007 @00:41:30 Maria (Ops Dir) — "big-bang on the 14th then"`. Use the locator rules from `meeting-decisions` (timestamp, else speaker + quote, else exact passage). Quotes are verbatim. Never invent a timestamp.
- Document: `SRC-003 PSS v1.0 §11, row 4`.
- Email: `SRC-011 email 2026-09-14, J. Devos → Fida, "Re: approval matrix" — "confirmed, buyer limit only"`.
- User in conversation: `SRC-014 Fida in chat, 2026-09-29 — "we settled on weekly payment runs"`. This is A5 unless the user names an A1–A3 source behind it. If they do, record that source, and add an `ACT` to file it if it isn't in the ledger. **When the user confirms a `Proposed` entry in chat**, add `confirmed by [user] in chat, [date]` to its citations and stop asking about it. Its authority is unchanged, and it goes into the next decision-confirmation note to reach A2. **A user's ruling on a conflict is not a ladder source.** It resolves the conflict, and the new version takes the authority of the governing source the user names.

**Raw transcripts are never added to project knowledge** (Syncoria policy). The ledger records the *structured* record that sits in knowledge (the discovery record or decision log) and, separately, where the raw recording or transcript lives, so a citation can still be checked against the original.

**Record only what a source gives.** That covers the parts of a field too: roles, titles, dates and locations. If the source gives a name without a role, write the name alone, or `role not stated`. If you cannot cite it, it is not a register entry. At most it is an `OQ` ("recalled as decided, no source found").

---

## Part 4 — The merge procedure

Run it whenever new material arrives on an engagement that has a register. Triggers:

- A transcript was processed. The input is the structured record. `syncoria-discovery-extraction` emits a register merge block. For a `meeting-decisions` log, build the candidate list from its decision log, action items and open questions. Don't go back to the raw transcript.
- An artifact was signed, or a CR was approved or rejected.
- An email or message arrived that decides, confirms, commits to or answers something.
- The user states something in chat ("we've agreed…", "they confirmed…", "drop that item").
- You produced an artifact that introduced new assumptions, risks or open questions.
- A phase gate closed (Part 6).

**Steps:**

1. **Ledger first.** Add the source to register §0b with its `SRC-` ID, date, type, title and location. **If it is already in the ledger, stop.** Merging the same source twice creates phantom confirmations.
2. **List the candidate items** from the source: decisions, assumptions, risks, questions, commitments, tasks, scope statements. Each needs its citation.
3. **Match each candidate against existing entries by topic, not wording.** "Big-bang cutover" and "single go-live weekend" are the same topic. Classify each one:
   - **New.** Nothing covers the topic yet. Add it with a status set by its authority level.
   - **Confirms.** Same topic, same substance. Add the citation. If it lifts a `Proposed` entry to A3 or above, promote it to `Settled`.
   - **Answers.** Resolves an `OQ`. Mark the OQ `Answered`, create the resulting `DEC` or `ASM`, and link both ways.
   - **Validates / invalidates.** Resolves an `ASM`. Set the status and cite it. An invalidated assumption triggers its "If wrong" consequence, so raise the linked `RSK`, `OQ` or CR candidate.
   - **Completes / drops.** Resolves an `ACT` or `TSK`. Record the evidence, or who released it.
   - **Reopens.** Revisits a settled topic without resolving it. Status and value stay unchanged. Record it in §0c and put it to the user once: keep, or reopen as an `OQ`. A ruling of keep removes the row and is logged on the entry as `contested, ruled keep`.
   - **Excluded scope.** Matches an `Out of scope` / `Descoped` `SCP` entry. Don't add it as scope. Flag it per Rule 2b and create the `Pending CR` entry.
   - **Amends.** An approved CR or signed artifact that explicitly changes an entry. It *is* the ruling: version the entry, log it, and list the affected artifacts.
   - **Conflicts.** Anything else that would change a settled entry, or a `Proposed` entry resting on higher authority than the new source. **Do not apply it.** Go to Part 5.
4. **Apply** the New, Confirms, Answers, Validates, Completes, Amends and Excluded-scope items. A source at equal or higher authority that revises a `Proposed` entry may revise it directly; log the old wording in the change log.
5. **Raise every conflict and reopen** in one grouped block (Part 5), in the same message as the merge summary, **and record each one in §0c**.
6. **Close out.** Give every new entry a concrete next ID (highest existing + 1 per prefix; never `SRC-0xx` placeholders). Where a required field isn't in the source (for example, an assumption's "If wrong"), write `not stated — see OQ-###` and raise the OQ. Never invent it. An OQ raised by the merge is owned by the OPL named in the header, marked `(assigned by merge)`. Add a change-log line: date, `SRC-`, counts of added / confirmed / promoted / closed / flagged, and the conflicts raised. Bump the register version (`v14 → v15`) and update "Last updated" with date **and time**. If project knowledge ever holds two register files, or the header you read is older than a version the user mentions, stop and ask which one is current before merging.
7. **Write it back** (Part 8), and report the result in the register footer (Rule 4).

Report the merge to the user in this order: **conflicts first**, then **excluded-scope matches**, then promotions and closures, then additions, then anything overdue. The user needs to see the conflicts. The additions can be read in the file.

---

## Part 5 — Conflicts

A conflict is any candidate that would change a settled entry (other than an explicit amendment by an approved CR or signed artifact, which is merged), or a `Proposed` entry resting on higher authority than the new source. Present each one like this:

```
CONFLICT — DEC-012 (Cutover approach)
Register says:   Big-bang cutover on 14 Nov. Settled · A3 · SRC-007 @01:15:02 Maria — "fine, big-bang on the 14th then"
New source says: Phased by warehouse. A4 · SRC-019 @00:22:10 Priya — "we'll do the east warehouse first"
Ladder verdict:  A4 cannot override A3. The register value governs.
Likely cause:    Priya was not at the 07 session. Possibly unaware, or possibly a real change of mind.
Recommendation:  Keep DEC-012. Add OQ-031 for the OPL to confirm with Maria in writing whether phasing is now wanted.
                 If it is, this touches PSS §10 (A1), so it is a Change Request, not a register edit.
Your call:       keep · supersede (state the governing source) · convert to CR candidate
```

While a conflict is pending, it is re-raised in the register footer of every reply until the user rules (Rule 4). Until then, the higher-authority value governs; at equal authority, the register's value governs. Say which one you're using ("using DEC-012 v1; conflict pending"). Never produce an artifact on the new value "provisionally" without saying so.

**When the user rules** (remove the §0c row). For an A1 entry, offer only keep or convert to a CR candidate:

- **Keep.** Record the ruling in the change log. Add the conflicting source to the entry as `contested, ruled keep — [date, by]`, so the same claim can't reopen it again later without new evidence.
- **Supersede.** Create the new version (`DEC-012 v2`) with the governing citation and the ruling. Move v1 to register §8 with `superseded by v2 — [date, ruled by, SRC]`. List every artifact that cites the ID as **affected**. If any of those artifacts is signed, the change is a CR, not a supersession.
- **CR candidate.** Record `SCP-### Pending CR` and link it. The entry keeps its current value until the CR is approved.

**The ruling itself needs a source.** "User said so in chat" is fine. Record it as `SRC-### Fida in chat` with the date. Without that, a future reader can't tell a ruled supersession from drift.

---

## Part 6 — Where the register plugs into the method

| Moment | Register obligation |
|---|---|
| **Phase 1, kickoff** | Create the register from the Charter and PSS v1.0. Every PSS "TBD" becomes an `OQ` with an owner and a needed-by gate. PSS §2 NOT-in-scope modules and §11 out-of-scope items become `SCP` `Out of scope` entries |
| **Every artifact** | Draw from the register and cite IDs; merge new items afterwards; list IDs relied on in the self-check |
| **Gap Decision Log (07)** | Each classification outcome is a `DEC` linked to its GDL row (the most re-litigated decision: "can't we just customize it?") |
| **CVBS (08)** | The customer's process-flex answer is a `DEC`, never asked again in different words. The CVBS §6 out-of-scope items become `SCP` `Out of scope` entries linked to it (A1 once signed) |
| **TTD (09)** | §11.3 blocking assumptions mirrored as `ASM` entries with the same ID and gate. The register keeps the customer-language statement; the TTD adds the technical detail |
| **Change Request (13)** | An approved CR supersedes the affected `SCP` or `DEC` entries (A1). A rejected CR is recorded as an `SCP` `Out of scope` entry with governing source `CR-### rejected [date]`, so it doesn't come back as a new request |
| **Every phase gate** | **Reconcile**: confirm every `Proposed` entry or turn it into an `OQ`, review open `ACT`s, chase due `ASM`s. Send the customer a **decision-confirmation note** listing what was settled this phase. Their written reply lifts those entries to A2. The note carries only `DEC`, `SCP` and `ASM` statements in the customer's language, with dates: never RSK, TSK, chargeability views, ladder verdicts or conflict analysis. This habit does more than anything else to stop drift |
| **PSS v2.0** | Reconcile first: every `In scope` / `Out of scope` entry appears, every `Validated` assumption is stated, every scope `OQ` is resolved or named as an exclusion |
| **Triage** | Triage builds the register (Part 7) |
| **Claude contradicted the register** | Say so in one line so the user can log it as a wrong-output case for the skill |

---

## Part 7 — Bootstrapping on an in-flight project

1. Collect every available source: signed artifacts, drafts, structured meeting records, emails, the go-live plan, configuration notes. Put each one in the ledger with its date and authority level.
2. Merge them **oldest first**, so that later material arrives as confirmations, answers or conflicts against earlier material rather than being blended with it.
3. Mark the register header `Bootstrapped [date] from N sources`. Mark every entry that rests only on A4 or A5 sources as `Proposed`, even if everyone "knows" it is decided.
4. Conflicts found are **listed for the user, not resolved**. They show where the team's shared understanding has split.
5. Send the customer a decision-confirmation note on the high-impact `Proposed` entries to turn folklore into A2 facts.

---

## Part 8 — Writing it back

- **Can write** (for example, a Projects tool with a write method): write the full file back to the same path. Read, change, write the whole file.
- **Can't write**: deliver the complete file on the Rule 4 schedule, with the instruction to **replace** the old file. Never a diff, never a second copy: two registers in one project is worse than none.
- Markdown only, never through the `.docx` generator. Customer-facing extracts are produced separately.

**Size discipline.** Keep statements short and push the detail into the linked artifact. When register §8 outgrows the live sections, move closed entries older than the previous phase to `project-control-register-archive.md`, with a one-line pointer. Superseded versions of live entries stay, because they explain the current version.

---

## Part 9 — Template

```markdown
# Project Control Register — [Customer] · [Project]

**Register version:** v1 · **Last updated:** YYYY-MM-DD by [name] · **Bootstrapped:** [date, N sources | n/a — created at kickoff]
**Current phase:** [n — name] · **OPL:** [name] · **Customer lead:** [name, role]

> Read before building or answering anything on this project. Settled entries govern. Change them only
> through a merge, and route conflicts to the OPL. Signed artifacts outrank this register. For scope,
> this register indexes them. Check here before asking anything. If it's settled below, don't ask.

## 0. Engagement facts & sources

### 0a. Engagement facts (DEC-001…006, reserved)
| ID | Fact | Value | Status | Authority | Date | Citation | Links |
|---|---|---|---|---|---|---|---|
| DEC-001 | Odoo version | — | — | | | | OQ-001 |
| DEC-002 | Edition (Community / Enterprise) | — | — | | | | OQ-002 |
| DEC-003 | Hosting (Odoo Online / Odoo.sh / on-premise) | — | — | | | | |
| DEC-004 | Localization & companies | — | — | | | | |
| DEC-005 | Licensed users | — | — | | | | |
| DEC-006 | Target go-live | — | — | | | | |

### 0b. Sources ledger
| SRC | Date | Type | Title / description | Authority | Current? | Where it lives |
|---|---|---|---|---|---|---|
| SRC-001 | | Signed artifact | Project Charter | A1 | yes | knowledge: charter.docx |

### 0c. Pending conflicts and reopens (re-raised in every reply until ruled)
| Entry | Topic | New source (SRC @locator) | Ladder verdict | Raised (date, reg v) |
|---|---|---|---|---|

## 1. Scope of Work
**Governing artifacts:** PSS [v, signed date | unsigned] · CVBS library [n signed] · CRs [approved list] · Build Plan [signed date]

### In scope
| ID | Item | Status | Authority | Date | Governing source | Citation | Links |
|---|---|---|---|---|---|---|---|

### Out of scope (incl. descoped and rejected CRs)
| ID | Item | Status | Authority | Date | Governing source | Excluded by | Citation |
|---|---|---|---|---|---|---|---|

### Pending scope changes
| ID | Proposed change | Raised in | CR # | Chargeability view | Status |
|---|---|---|---|---|---|

## 2. Decisions
(From DEC-007 on. DEC-001…006 live in §0a.)

| ID | Decision | Status | Authority | Settled by | Date | Citations (reached → confirmed) | Links |
|---|---|---|---|---|---|---|---|

## 3. Assumptions
| ID | Assumption | Status | Authority | If wrong | Blocking? (for what) | Validate by | Citations | Links |
|---|---|---|---|---|---|---|---|---|

## 4. Risks
| ID | Risk | L | I | Owner | Mitigation | Trigger | Status | Citations |
|---|---|---|---|---|---|---|---|---|

## 5. Open Questions
| ID | Question | Owner | Needed by | Blocks | Status | Answered by | Citations |
|---|---|---|---|---|---|---|---|

## 6. Action Items
| ID | Action | Owner | Due | Status | Evidence / released by | Citations |
|---|---|---|---|---|---|---|

## 7. Tasks / To-do
| ID | Task | Owner | Due | Depends on | Status | Source (plan or person that set it) |
|---|---|---|---|---|---|---|

## 8. Superseded & Closed
| ID + version | Former statement | Superseded by / closed | Ruling (date, by, SRC) |
|---|---|---|---|

## 9. Change log
| Register v | Date | Source(s) | Added | Confirmed | Promoted | Closed | Flagged / conflicts |
|---|---|---|---|---|---|---|---|
```
