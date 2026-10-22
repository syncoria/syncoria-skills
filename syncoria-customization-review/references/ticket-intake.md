# Ticket Intake — Filling the Business-Context Gap (Mode 2)

On a helpdesk ticket you have the same technical access as a full project (database + codebase), but none of the paper trail. The technical review tells you what Odoo *can* do; it will not tell you what the customer actually *needs* or whether this was already discussed and decided. That missing context gets asked — never assumed.

## The core discipline

**Never classify from ticket language alone.** "We need a button that emails the customer when…" or "can it show the margin on the quote…" describes a desired outcome in the requester's words, not Odoo's actual capability. The technical trace very often shows standard Odoo already does it a different, equally acceptable way — so the trace comes first, and it reframes the conversation from "build this" to "here's what standard does; does that meet the need?"

## The grouped, tiered questions

Mirror `syncoria-aidlc-method`'s ask style — one message, tiered, with the reason for each. Adapt to the ticket, but cover:

**Blockers (needed to resolve correctly):**
- **Which workflow and persona** does this actually affect? (The ticket names a symptom; you need the real process and who lives in it.)
- **Why doesn't the standard behavior satisfy them?** If Step 4 of the review found standard Odoo already does something close, state it and ask why it's insufficient — often it isn't, and the ticket resolves with configuration.
- **Who can confirm the resolution?** The requester may not own the process.

**Recommended (materially improves the answer):**
- **Was this raised or decided before?** There may be a prior Gap Decision Log entry or a deliberate reason it works the way it does. Changing it could reverse an earlier decision.
- **Real data volumes / frequency** for this flow — affects both whether a customization is warranted and how it must perform.

**Context (sharpens fit):**
- **Customer size and industry specifics** for the size/industry test (defer the judgment to the industry skill).
- **Any constraints** — compliance, integrations, downstream consumers of this data.

## The cheapest-verification-first rule

If the technical trace shows a standard setting *should* already cover this, **recommend trying it before recommending a build.** "Base Odoo has this — the credit-limit warning just isn't configured on this customer. Please set the credit limit and warning message and confirm the warning fires." That costs one message. Scoping and building a custom solution for something standard Odoo already did costs an unbillable sprint. Always spend the message before the sprint.

## Provisional conclusion, explicit flags

Treat the technical trace as solid but the business conclusion as **provisional** until confirmed (per `syncoria-aidlc-method` Path B — ask first, never stall, always flag). You may proceed to build from the best available (trace + ticket + answers received), but the CVBS/TTD must explicitly flag:
- What wasn't confirmed by a signed artifact or a process owner.
- Any assumption made about the persona, workflow, or intent.
- Whether this might reverse an earlier decision you couldn't find a record of.

## When the ticket still requires customization

If, after the trace and the questions, all four quality tests genuinely land on "custom needed," the ticket produces a **proportionate CVBS-TTD pair** (`syncoria-aidlc-method`'s "Ticket-driven customizations" bullet defines what such a pair contains and what can never be dropped from it) — lighter than a full signed-project customization, but a real pair: a plain-language CVBS (what/why + acceptance criteria) the requester or process owner confirms, and a TTD carrying the trace as evidence, the conflict-check result, and the flagged assumptions. Never a direct code commit off a ticket.
