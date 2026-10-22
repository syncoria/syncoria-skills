# Triage Playbook — Assessing In-Flight Projects

Use this when the user wants to make sense of an existing/messy Odoo project rather than build a single artifact. The goal: determine where the project actually sits in the methodology, inventory what exists vs. what's signed, identify the gaps, and produce a prioritized action plan. Triage uses the same dependency map as building — it just runs the check across every artifact at once.

## The triage sequence

### Step 1 — Establish the current phase
Ask (or infer from available material) what the most-advanced state of the project is. Map it:

| What's happening now | Current phase |
|----------------------|---------------|
| Still gathering requirements / discovery | 2 |
| Customer trained, using staging, surfacing gaps | 3 |
| Gaps identified, specs being written | 4 |
| Specs done, build being planned | 5 |
| Developers building in staging | 6 |
| Customer testing | 7 |
| Go-live imminent or live / hypercare | 8 |

If modules are at different phases (common), record the most-advanced as the project phase but note the laggards — they may still benefit from upstream artifacts.

### Step 2 — Inventory artifacts: exists? signed?
Walk the 14 artifacts (and the register, 00). For each, record one of: **Missing / Exists-unsigned / Exists-stale / Signed**. The signed/unsigned distinction is the crux — in this methodology an unsigned artifact provides little protection. Pay special attention to:
- Is there a signed scope document (PSS, or any equivalent SoW)? Often the biggest gap.
- Are there signed CVBS for the customizations being built?
- Are there TTDs for what developers are building?
- Are process maps confirmed by the customer?

### Step 2b — Bootstrap (or refresh) the Project Control Register
The inventory in Step 2 is also the register bootstrap: the same sources, merged oldest first, per `control-register-rules.md` Part 7. Mark entries that rest only on unconfirmed or second-hand sources as `Proposed`. **List conflicts; don't resolve them.** Where the team's shared understanding has split (the same topic settled two ways in two places) is usually the most important finding triage produces, and it goes at the top of the Step 5 plan. Excluded-scope items that keep resurfacing belong in the plan's "now" list as candidates for the decision-confirmation note.

### Step 3 — Determine migration mode
Based on phase and go-live proximity:
- **Thorough retrofit** — early phase (≤4) and/or go-live far off (>90 days). Retrofit upstream artifacts properly.
- **Quick win** — late phase (≥7) or go-live imminent (<30 days). Don't dig up the past; apply gates to remaining work and create a combined scope-of-record.
- **Hybrid** — in between. Retrofit what still protects downstream work; skip what's too late to matter.

### Step 4 — Identify the gaps that matter
Not every missing artifact is worth retrofitting. A missing Prep Form from Phase 2 doesn't matter once you're in build. What matters is whatever still protects downstream work or signature:
- **Always matters:** a signed scope document (protects every CR decision and the go-live boundary); signed acceptance basis (CVBS or a UAT-as-SoW) before/at UAT.
- **Matters if build isn't done:** signed CVBS and TTDs for unbuilt customizations.
- **Stops mattering once passed:** prep forms, process maps for already-built modules (document lessons instead).

### Step 5 — Produce the prioritized plan
Output a **now / next / later / skip** action list. For each action: what to do, which artifact/prompt produces it, and why it matters at this phase. Be honest about "skip" — telling the user a retrofit isn't worth it is as valuable as recommending one.

## The retrofit move (very common)

When a project reached late stages with nothing signed, the highest-value single action is usually a **combined Scope-of-Work + UAT document** that captures current reality and gets signed — serving retroactively as both the scope baseline and the acceptance basis. Build it from the most-current sources (go-live plan, configuration notes, demonstrated workflows, integration scope), with the stalest sources (old SoW, old use cases) used only to catch omissions and always flagged, never silently trusted.

From there, a retroactive **PSS v2.0** can be assembled with the signed UAT+SoW as its spine, and the customizations listed as the behavior-specifications-of-record in lieu of individual signed CVBS.

## Triage principles

- **Settled once is settled.** Once the register exists, triage reads it first and doesn't re-ask what it settles.
- **Check, don't assume.** Ask what exists before declaring gaps. The user often has more than they realize, scattered across docs.
- **Signed is the bar.** "We have a scope doc" and "we have a *signed* scope doc" are different findings. Always clarify.
- **Stale sources are flagged, never trusted.** A stale SoW that conflicts with current reality is a risk to surface, not a source to copy.
- **Honesty about lateness.** If an artifact's protective value has passed, say "skip, document the lesson" rather than busy-work.
- **Shortest path to protection.** The point of triage isn't methodology purity — it's getting the project the scope control and acceptance basis it still needs, as efficiently as possible.
