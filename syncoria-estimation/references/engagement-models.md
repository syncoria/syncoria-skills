# Engagement Models

The three ways Syncoria engages, and how each changes the estimate. The central idea: these redistribute *who does the work*, so the same scope yields three different Syncoria-effort profiles. Estimate the profile that matches the model.

## Full-Service Implementation

**Who does what:** Syncoria delivers end to end. The customer participates (async forms, training, UAT, data prep, sign-offs) but Syncoria does the configuring, customizing, migrating, and building.

**What Syncoria hours cover:** the full methodology delivery — the tier baselines in `sizing-baselines.md` describe this model directly. Discovery, mapping, training, specification, build, testing, go-live, PM.

**Estimate:** the full sizing-model hours for the scope. This is the baseline; the other two models are derived from it.

**Risk posture:** Syncoria controls execution, so effort is the most predictable of the three. Main risks are scope creep (managed by the PSS/CVBS gates) and customer responsiveness (gates the timeline).

**Pricing fit:** T&M early (pre-signed-scope), moving toward fixed-fee for the build once CVBS library and PSS v2.0 are signed. See `pricing-models.md`.

## Guided Implementation

**Who does what:** the customer's team drives the implementation; Syncoria advises, reviews, trains, and unblocks. The customer configures and (where they can) builds; Syncoria provides the methodology, checks the work at each gate, and steps in on hard problems.

**What Syncoria hours cover — estimate these, not doing hours:**
- **Enablement/training** — heavier than full-service; the customer's team must be capable of doing the work. Scale up training substantially.
- **Advisory sessions** — per-phase, per-module guidance; answering the customer's design questions.
- **Review & gate-checking** — reviewing the customer's process maps, configs, and specs; running the methodology gates on their output.
- **Escalation/unblocking** — a bank of hours for the hard gaps the customer can't solve, which Syncoria takes on.
- **PM/coordination** — lighter than full-service but real.

**What's NOT in Syncoria hours:** the bulk of configuration and customization doing — that's the customer's effort (which rises sharply vs. full-service; reflect it in customer-hours).

**Estimate:** typically a *fraction of full-service doing hours* but with *more coaching hours* and *higher variance*. Do not compute it as "full-service × a discount" — build it from the enablement + advisory + review + escalation components. Add a meaningful **risk buffer**: the customer's execution pace and quality are outside Syncoria's control, and slow or low-quality customer work pulls Syncoria back in.

**Risk posture:** highest variance of the three. The estimate depends heavily on the customer team's capability — assess it explicitly and range wide. A capable customer team makes guided efficient; a weak one drifts toward full-service effort anyway (flag this risk in the proposal).

**Pricing fit:** often T&M or a capped-advisory retainer, because Syncoria can't fix-price work it isn't doing. A fixed enablement package + T&M advisory is common.

## DIY / Self-Implementation with Support

**Who does what:** the customer implements. Syncoria provides the methodology, templates, and scheduled checkpoint reviews — a safety rail, not a delivery team.

**What Syncoria hours cover — estimate these:**
- **Onboarding to the method** — getting the customer's team running the AI-DLC methodology (or a lightweight version of it).
- **Template & asset handover** — the artifact templates, the process, the standard-first discipline.
- **Scheduled checkpoint/gate reviews** — a defined number of review points (e.g., scope review, pre-build review, pre-go-live review) where Syncoria checks the customer's work and flags risk.
- **A support allowance** — a bounded bank of Q&A / help hours.

**What's NOT in Syncoria hours:** essentially all delivery — configuration, customization, migration, build, testing. The customer owns it.

**Estimate:** the *smallest* Syncoria effort of the three, but with a **real floor** — onboarding, handover, and the review points cost regardless of scope. A tiny DIY project and a large one may have similar Syncoria hours because the cost is in the checkpoints and enablement, not the delivery volume. Estimate from the number of checkpoints + enablement + support allowance, largely decoupled from gap count.

**Risk posture:** Syncoria's *effort* risk is low (bounded scope), but *outcome* risk is high and largely the customer's — set expectations clearly in the proposal that success depends on the customer's execution. Protect Syncoria by defining exactly what the checkpoints cover and what happens if the customer's work fails a review (rework is theirs, or converts to a paid engagement).

**Pricing fit:** usually a fixed package (enablement + N checkpoints + support hours), because scope is bounded and defined. Overage beyond the support allowance is T&M.

## Comparing models in a proposal

Customers often want to see the options. When comparing:
- Show the **same scope** through all three models so the trade-off is clear: Syncoria effort/cost drops full → guided → DIY, while **customer effort and outcome-risk rise** in the same direction.
- Make the risk trade explicit — DIY is cheaper for Syncoria's part but puts delivery success on the customer.
- Recommend based on the customer's team capability, urgency, and risk appetite — not just price. A customer without ERP-capable staff choosing DIY on price alone is a failure waiting to happen; say so.

## Hybrid / phased models

Real engagements sometimes mix: full-service for the hard modules, guided for the simple ones; or DIY with a full-service "rescue" option. Estimate each portion in its own model and sum, and be explicit in the proposal about which parts are which. Flag hybrid arrangements as higher-coordination (add PM).
