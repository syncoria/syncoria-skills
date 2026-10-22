# Pitfall Flagging & Forcing Iteration

The vigilance mandate. This skill does not flag a concern and move on — it **raises concerns, makes them impossible to miss, and requires a response before the customization is considered final.** The goal is to force at least one iteration when a quality test fails or a serious pitfall exists, so problems get caught at review time (cheap) instead of at build or go-live (expensive).

## Every adverse test result is a blocker

If any of the four tests comes back adverse, that is a blocker to be resolved with the OPL/developer before customization content is finalized — not a note buried in the document. Record the verdict in the fixed words of `review-procedure.md` block H; the shorthand below is for this file only:
- **Test 1 resolves to "standard covers it":** stop. Recommend the standard path; do not build. If someone insists on building anyway, require an explicit, recorded reason. (Note the verdict wording — this test is never recorded as "passed" or "failed," because both readings occur in practice. Use the fixed words in `review-procedure.md` block H.)
- **Test 2 returns "conflict found":** stop. Name the specific collision/duplication and require a resolution (extend the existing customization, reassign field ownership, re-sequence automations) before proceeding.
- **Test 3 failed, it reinvents a construct:** push back with the standard construct that should be used instead; require agreement before drafting.
- **Test 4 failed, wrong for size or industry:** surface the mismatch and the proportionate alternative; require the OPL to confirm the direction.

## Pitfalls to surface proactively

Beyond the four tests, actively look for and flag these — they are the pitfalls that don't show up until later:
- **Upgrade fragility** — dependence on volatile standard methods/fields; Studio customizations that migrate poorly; overrides that will silently break on the next version.
- **Performance under real data volume** — logic that's fine on demo data but slow at the customer's actual record counts (computed fields without stored/indexed design, per-record loops, unbatched writes).
- **Security and access implications** — who can see/do the new thing; record rules that should scope it; data exposure the requester didn't consider.
- **Unstated edge cases** — the states, exceptions, and volumes the ticket or CVBS didn't mention but the flow will hit (empty values, cancellations, multi-company, multi-currency, returns).
- **Maintenance cost** — every custom line is a forever liability; flag when the ongoing cost outweighs the benefit, especially for an SMB.
- **Downstream impact** — reports, integrations, or other workflows that consume the output of what's being changed.

## How to force the iteration

1. **Present the concern before the build detail.** In the CVBS/TTD, concerns and pitfalls go in a dedicated, prominent section that the OPL and developer see *first* — not an appendix.
2. **Propose the safer/standard alternative alongside the concern.** Don't just raise a problem; offer the path that avoids it.
3. **Require confirmation of direction before drafting final customization content.** "Before I write this TTD: standard Odoo already does X (test 1), and if we build anyway it will collide with addon Y (test 2). Do you want to (a) use the standard path, (b) resolve the conflict this specific way, or (c) proceed with a recorded reason? I'll draft once you confirm." Do not resolve a flagged concern silently by choosing a path yourself.
4. **Make the flags survive into the artifacts.** The confirmed resolution and the residual risks stay in the CVBS (business-facing pitfalls the customer should accept) and the TTD (technical pitfalls the developer must handle) — so the vigilance isn't lost once the conversation ends.

## The tone of the flags

Flag as a careful colleague protecting the project, not as an obstacle. The point is not to block work — it's to make sure the work that proceeds is the right work. A well-flagged concern reads as "here's a cheaper/safer way and why," which the OPL and developer will thank you for, not resent. But firmness matters: a serious concern that gets waved through silently is exactly the failure this skill exists to prevent, so a flagged blocker genuinely blocks until answered.

## What goes where

- **In the CVBS** (business-facing): pitfalls the customer/OPL must understand and accept — a workflow that's heavier than their size warrants, a change that reverses an earlier decision, a maintenance cost, an edge case that affects how they work.
- **In the TTD** (developer-facing): technical pitfalls the developer must handle — the conflict to chain around, the performance design, the security scoping, the upgrade-risk surface, the edge cases to code for.
- **In the conversation, up front**: any failed test or serious pitfall that must be resolved before either document is finalized.

The measure of success: a competent OPL and developer, reading the finished pair, encounter no surprise later that this review could have caught — because every one was surfaced, flagged, and resolved at review time.
