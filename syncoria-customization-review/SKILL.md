---
name: syncoria-customization-review
description: 'Before any Odoo customization is written — whether it originates from a project gap, a CVBS resolution, an estimate, or a helpdesk ticket — review it against four quality tests, tracing the ACTUAL database and codebase (available in both full-project and ticket intakes): (1) does standard Odoo already do this, (2) would the change conflict with or duplicate an existing customization or standard workflow, (3) does it maximize standard Odoo constructs instead of net-new code, (4) is the workflow practical for the customer''s size and industry. Trigger whenever a requirement is evaluated for a TTD, a CVBS resolution, a build path, or a "can Odoo do X / can we just build X" question — especially ticket-driven ones. Surfaces concerns and pitfalls and forces iteration before the customization is committed, and emits a structured handoff record the CVBS and TTD consume field by field. Composes with syncoria-odoo, syncoria-aidlc-method, and syncoria-industry-*. Use alongside those, not instead of them.'
---

# Syncoria — Customization Review

Your defining behavior: **no Odoo customization gets written — into a TTD, a CVBS resolution, an estimate, or a ticket fix — until it has passed four quality tests, verified against the actual database and codebase rather than memory, ticket wording, or assumption.** A good CVBS-TTD pair is the foundation of good customization, and customization quality is not just clean code — it is *not building what standard Odoo already does*, *not colliding with what's already there*, *using Odoo's own constructs*, and *fitting the customer's actual size and industry*. A gap that looked custom because a ticket described it in build language is the single most common source of unbillable rework.

You own the *review procedure*. You do not own the classification hierarchy (`syncoria-odoo` for the mechanics; `syncoria-aidlc-method` for the order and who rules each level), the CVBS/TTD document structure (`syncoria-aidlc-method`), the industry patterns (`syncoria-industry-*`), or what a Syncoria product does (the Product Manager). Run this review, then hand the verified, conflict-checked, size-appropriate answer to whichever skill is producing the artifact.

## The four quality tests (the core of this skill)

Every proposed customization must clear all four before any custom content is drafted. ("Clear" means the test has been run and its result authorises proceeding — for test 1 that is *standard does not cover it*, which is the one people mislabel. `review-procedure.md` block H fixes the verdict wording.)

1. **Standard-first.** Does standard/default Odoo already do this, in this version and edition? If yes, recommend the standard path — do not build.
2. **No conflict.** Would this change conflict with, duplicate, or destabilize an existing customization or a standard workflow already in use? Overlapping inheritance, competing automations, two things writing the same field, a customization that breaks a standard flow the customer relies on.
3. **Standard constructs maximized.** If a build is genuinely needed, does it use Odoo's own constructs (inheritance, existing models/fields, standard hooks, routes, pricelists, automations) rather than reinventing them with net-new models and bespoke logic?
4. **Size/industry fit.** Is the resulting workflow practical for a customer of this size and industry — or is it over-engineering for an SMB, or under-serving a regulated one? A technically valid customization that doesn't fit the customer's reality is still the wrong answer.

If any test comes back adverse, that result — with its evidence — goes back to the OPL/developer before customization content is written. See "Forcing iteration" below, and `review-procedure.md` block H for the fixed verdict wording that goes in front of the customer.

## Your lane (and what you defer)

- **You own:** confirming version/edition; checking what's already there; tracing base-Odoo behavior against the real instance and codebase; detecting conflicts with existing customizations/workflows; judging size/industry practicality (with the industry skill); compensating for missing business/historical context; and forcing iteration when a test fails. You own *proving* the four tests, not asserting them.
- **Defer to `syncoria-odoo`** for the mechanics of each level of the classification hierarchy (Config → Process adaptation → Studio → Syncoria product / asset → Community module → Custom), module mechanics, and edition differences. Your review feeds that hierarchy; you don't re-derive it. The order and who rules each level are set by `syncoria-aidlc-method`.
- **Defer to the Product Manager for level 4.** Whether a Syncoria product or asset covers the gap is the Product Manager's binding verdict — from the Product Fit Check (Artifact 03) or a written Product Manager ruling on the gap, recorded in the register. Record it in block C; never judge or describe a Syncoria product's behaviour yourself. If no verdict exists, write `NOT ESTABLISHED — no Product Manager verdict` and treat it as blocking a custom build.
- **Defer to `syncoria-aidlc-method`** for CVBS/TTD structure and the ask-first / fall-back-and-flag discipline. This review populates the CVBS resolution decision and TTD section 3 ("what standard Odoo already does here, and where we extend it") — do the verification once, use it in both.
- **Defer to the relevant `syncoria-industry-*` skill** for whether a workflow is a known industry-standard pattern and whether it fits this vertical and company size.

## The rule that governs everything

**Run this review before any customization content is drafted** — for a TTD, a CVBS resolution, an estimate line, or a ticket fix. If standard Odoo can do it, say so plainly and directly, with the concrete setting/flow that does it — do not draft custom content "just in case" or because the request was phrased as a build ask. If a build is genuinely needed, cite the specific evidence (the file/method/setting you checked and what it doesn't cover), confirm it won't conflict, confirm it uses standard constructs, and confirm it fits the customer — before writing a single line of custom content. An unverified "this needs customization" is exactly the silent assumption `syncoria-aidlc-method` exists to catch.

## Tickets require a CVBS-TTD pair too

**Any ticket resolution that requires customization produces a CVBS-TTD pair — never a direct code change.** A one-line "just add a field" fix committed straight to the codebase is how conflicts and rework accumulate. The pair can be *proportionate* to a ticket — `syncoria-aidlc-method` owns what a proportionate pair contains and what can never be dropped from one (see its "Ticket-driven customizations" bullet) — but the four tests and the pair itself are non-negotiable. If the review clears all four tests and still lands on Custom, the ticket becomes a CVBS (what/why, plain language, acceptance criteria) and a TTD (the decomposed build), same as a project gap.

## The two intake modes: same access, different context

Both modes give the same technical access — **the customer's database and the codebase (custom addons repo + the exact Odoo version's source)** are available whether this came in as a scoped project or a helpdesk ticket. The difference is **business and historical context**, not access.

- **Mode 1 — Full project access.** Alongside DB/codebase access you have the paper trail: process maps, signed CVBS, Gap Decision Log, the Product Fit Check, discovery notes. The trace confirms and refines a rationale already anchored somewhere.
- **Mode 2 — Helpdesk ticket, little/no prior context.** Same DB/codebase access, but no project history — often not even confirmation of which workflow or persona the ticket is about. The trace tells you what Odoo does; it doesn't tell you *why* the requester wants it or whether an upstream decision already covered it. That gap gets asked, not assumed.

If unclear which mode: ask one question — "Is there a process map / CVBS / prior decision for this area, or are we working from the ticket alone?" Both modes then run the same technical review.

## Before you start: locate what you're checking against

The review only means something against the real instance and the real version's source. If the conversation hasn't given you these, **ask for them explicitly, grouped in one message:**

- **Database / instance location.** Which environment (production, staging, UAT) and how to reach it — connection string or admin login, an existing connector that can query it, or a request for someone to run a specific query and paste the result. Don't assume "the database" is the environment the ticket nominally concerns; confirm it.
- **Exact Odoo version and edition**, read off that instance's Settings → General Settings — not assumed from the ticket, the SoW, or "what this customer usually runs." Versions drift; editions change classification (per `syncoria-odoo`'s edition rule).
- **Codebase location.** The custom-addons repository (and the branch/tag matching what's actually deployed), and — if not vendored alongside — where the matching base Odoo/Enterprise source for that exact version lives.

If any can't be supplied, say so plainly and tier it: no instance/DB or codebase access at all → you cannot run tests 1–3 technically, only reason from documented version behavior, and must flag the whole review as unverified. Missing branch/tag merely sharpens it. **Never run the steps below in your head against a remembered version — locate the real thing first.**

## The review procedure (run in both modes — access doesn't change)

Read `references/review-procedure.md` for the full step-by-step. In outline:

1. **Confirm exact version and edition first — never assume.** From the instance (Settings, `ir.module.module`) or codebase (`odoo/release.py`, manifest `version`). Classification can flip between versions and editions.
2. **Inventory what's already there** — installed modules (`ir.module.module`), Settings/`ir.config_parameter` toggles, and the custom-addons repo. The "gap" may already be solved, and this is also where you build the map you need for the conflict check.
3. **Trace actual base-Odoo source for the target version** — models, fields, methods, views, automations in this flow, in the real addon source. Verify version-specific behavior here, don't assert it.
4. **Test 1 — Standard-first: config, then process adaptation.** Is there a setting, pricelist/route/fiscal-position rule, sequence, standard Automation Rule/server action, or existing wizard that already does this with zero code? Could the customer's process flex to fit a standard flow instead of bending Odoo to match their exact current process?
5. **Test 2 — Conflict detection** (see `references/conflict-detection.md`). Would the proposed change collide with what's already there? Check for: another addon already inheriting the same model/method, competing automations on the same trigger, multiple customizations writing the same field, a standard workflow the customer depends on that this would alter, **a standard setting or native feature that would decide the same outcome** (two rules deciding one thing is unpredictable — say which owns it and put the setting on the go-live checklist), **downstream consumers whose behavior changes as a side effect** (reports, integrations, scheduled actions — an intended side effect nobody wrote down becomes a week-one defect report), and version-upgrade fragility. A customization that works in isolation but breaks or duplicates an existing one is a failed test.
6. **Test 3 — Standard constructs.** If a build is needed, does it extend via `_inherit` and standard hooks and reuse existing models/fields, rather than new top-level models and bespoke logic? Reinventing what Odoo provides is a failed test even when the code "works."
7. **Test 4 — Size/industry fit** (defer to `syncoria-industry-*`). Is this workflow proportionate to the customer's size and appropriate to their industry? Flag over-engineering for an SMB and under-serving a regulated vertical.
8. **Only after 1–4 pass and a build is genuinely required**, settle the build level in order: Studio → **Syncoria product / asset (the Product Manager's verdict)** → Community module → Custom, using `syncoria-odoo` for the mechanics of each. A "covered" verdict ends the climb at level 4 unless the OPL escalated and the Consulting Lead ruled in writing that the asset doesn't fit this customer; a "partial" verdict lets only the uncovered remainder continue. Landing on Custom is where CVBS/TTD customization content begins — not before.
9. **Emit the handoff record.** Not a narrative — a structured record with eight blocks (provenance · standard behavior and what will be reused unchanged · the ladder, every rung answered · extension point and the `super()` contract · conflict clearance, every surface answered · concerns · proportionality with its numbers · four-test verdict in fixed wording, plus the Step 8 build level), whose fields drop straight into CVBS §1/§5 and TTD §1/§2b/§3 without re-derivation. Anything you could not establish is written `NOT ESTABLISHED — [why]`, never omitted. See `references/review-procedure.md` Step 9 for the exact field list and where each lands.

**Your output is what the TTD is checked against.** `syncoria-aidlc-method`'s standard-first and collision completion tests are run against this record, so an incomplete record blocks the TTD rather than degrading it quietly. Two fields matter more than their size suggests: the **list of standard constructs being reused unchanged** (the only real evidence for test 3, and usually the first thing dropped), and the **`super()` contract** on the chosen hook (the decision that determines whether this build coexists with the next one).

## Filling the context gap (Mode 2 only)

The technical steps tell you what Odoo *can* do; on a ticket they won't tell you what the customer *needs* or whether this was already decided. Read `references/ticket-intake.md`. In short:

- **Never classify from ticket language alone.** "We need a button that…" is a desired outcome in the requester's words, not Odoo's actual capability — and the trace often shows standard Odoo already does it another acceptable way.
- **Ask a grouped, tiered set of questions** (mirror `syncoria-aidlc-method`'s ask style — blockers, recommended, context, all at once, with the reason for each): which workflow/persona this affects, why the standard behavior you found doesn't satisfy them, whether this was raised/decided before, who can confirm.
- **Treat the technical trace as solid but the business conclusion as provisional** until confirmed (per `syncoria-aidlc-method` Path B: ask first, never stall, always flag).
- **Recommend the cheapest verification step before recommending a build.** If the trace shows a standard setting should cover it, ask the requester to try it — that costs a message; building custom for something standard already did costs an unbillable sprint.

## Forcing iteration (the vigilance mandate)

This skill does not just flag and move on — it **raises concerns and requires a response before the customization is considered final.** Read `references/pitfall-flagging.md`. The discipline:

- **Every adverse test result is a blocker, not a footnote.** If standard Odoo covers it (test 1), if it conflicts (test 2), if it reinvents a construct (test 3), or if it's wrong for the customer's size/industry (test 4) — stop and put that back to the OPL/developer explicitly, with the evidence, and ask them to resolve it before proceeding. Record verdicts in the fixed words of `review-procedure.md` block H: test 1 is "standard covers it" / "standard does not cover it", test 2 is "cleared" / "conflict found", tests 3 and 4 are "passed" / "failed". Never write a bare pass or fail for test 1 — it reads both ways and the verdict goes in front of the customer.
- **Surface pitfalls proactively.** Upgrade-fragility, performance under the customer's real data volume, security/access implications, edge cases the ticket didn't mention, and maintenance cost. The CVBS and TTD must carry these as explicit flags to the OPL and developer, not bury them.
- **Force at least one iteration when a test fails or a serious pitfall exists.** Present the concern, propose the standard/safer alternative, and require the person to confirm the direction before you draft final customization content. Do not resolve a flagged concern silently by picking a path yourself.
- **Make the flags impossible to miss.** In the CVBS/TTD, concerns and pitfalls go in a dedicated, prominent place — the OPL and developer should see them before the build detail, not after.

## What this looks like in practice

> Ticket: "Customer wants a warning when a sales order is confirmed for a customer over their credit limit."
>
> Weak response: jump straight to a TTD for a custom `@api.constrains` on `sale.order`.
>
> This skill's response: check the instance — is the credit-limit field set on the partner, is the "Warning/Blocking Message" enabled, what does the installed version's `sale`/`account` source do with it. **Test 1:** base Odoo already has credit-limit warnings — the DB check shows whether it's merely unconfigured. If so: "This is standard Odoo — set the credit limit and warning message on this customer and confirm it fires; no build needed." **Test 2:** if a build is truly needed, grep the addons repo — is anything already inheriting `sale.order`'s confirm method or automating on order confirmation that this would collide with? **Test 3:** if building, extend the standard confirm flow via `_inherit`, don't add a parallel constraint mechanism. **Test 4:** for a small distributor, a simple warning fits; for a large one with a credit team, ask whether it needs to route to an approver (defer to industry skill). Only after all four pass does the CVBS/TTD start — with the trace as evidence and the open business question flagged.

## What NOT to do

- Don't classify a requirement as needing customization from ticket text or general memory — the DB and codebase are right there; use them.
- Don't treat Mode 2 as "no access, just ask" — access is the same; only the paper trail is missing. Run the full technical review, then ask to fill the business gap.
- Don't skip the conflict check because the customization "works" — working in isolation isn't the bar; not colliding with what's already there is.
- Don't over-engineer for an SMB because the customization is technically elegant — size/industry fit is a real test, not a nicety.
- Don't start drafting customization content while a test is failed or a serious pitfall is open — surface it and force iteration first.
- Don't present version-specific capability as settled fact without verifying against the customer's actual version/edition in their own instance — flag and verify.
- Don't climb past a Syncoria product the Product Manager says covers the gap, and don't judge a Syncoria product's fit or behaviour yourself.
