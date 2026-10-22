# Conflict Detection

Test 2 of the review: would this customization conflict with, duplicate, or destabilize something already in the instance — another customization or a standard workflow the customer relies on? This is the highest-value check for a mature instance, because the more customizations already exist, the more likely a new one collides. A customization that works in isolation but breaks or duplicates an existing one is a defect, not a delivery.

Run these checks against the inventory built in the review procedure's Step 2 (installed modules + a grep of the custom-addons repo).

## What to check for

### 1. Overlapping model/method inheritance
Search the addons repo for existing `_inherit` on the same model and overrides of the same method the new customization would touch.
- Two addons overriding `sale.order.action_confirm` can silently break each other depending on load order and whether each calls `super()`.
- Flag: any existing override of the method you plan to extend. The new TTD must account for it — chain correctly through `super()`, and document the interaction.

### 2. Competing automations on the same trigger
Check base Automation Rules / server actions (`base.automation`, `ir.actions.server`) and any custom automations firing on the same event (on-create/write of the same model, same state change).
- Two automations on "sale order confirmed" may both fire, in undefined order, with conflicting effects.
- Flag: existing automation on the trigger the customization uses. Decide whether to extend the existing one rather than add a competing one.

### 3. Multiple writers to the same field
Identify every place — standard compute, existing customization, automation — that already writes the field the new customization would set or compute.
- A stored computed field plus a customization both writing it produces race conditions and wrong values.
- Flag: any field the customization writes that something else also writes. Resolve who owns it.

### 4. Altering a standard workflow the customer depends on
The customization may change a standard flow that the customer (or another customization) relies on working the standard way.
- Overriding invoice creation, stock move generation, or a state transition can break downstream standard behavior or reporting the customer uses daily.
- Flag: any standard downstream behavior that depends on the flow being changed. Trace what consumes the output of the method you're altering.

### 5. Duplicating an existing customization
The exact need may already be met by a customization elsewhere in the repo, built for a different module or persona.
- Flag: an existing customization that already does this (or 80% of it) — extend or reuse it rather than building a parallel one. Duplicate customizations are a maintenance and conflict liability.

### 6. A standard setting or native feature that decides the same outcome
The most-missed conflict source, because the check usually looks only at *other customizations*. Standard Odoo may already have a toggle, threshold, approval feature or rule governing the same decision. If both are live, two rules decide one outcome and the behavior becomes unpredictable — and it will look like an intermittent bug, not a design fault.
- Search Settings and `ir.config_parameter` for the feature area, and read what the standard flow does when that setting is on.
- Flag: any standard setting or native feature that overlaps the decision. **Resolve by naming which one owns the decision**, stating the required setting state, and adding it to the go-live checklist. Where possible have the build log a warning at load time if it finds the setting in the wrong state, rather than silently layering two rules.

### 7. Downstream consumers of what's being changed
Anything that reads the output of the flow being altered: reports, exports, integrations, scheduled actions, dashboards, other workflows.
- A customization that holds a record in an earlier state changes *when* downstream things fire, even when it changes nothing about *what* they do.
- Flag: each consumer, and whether its behavior changes. Where the change is intended, record it as an intended side effect **and name who confirmed it**. An intended behavior change that nobody wrote down arrives as a week-one defect report.

### 8. Upgrade fragility and shared dependencies
- Does the customization depend on a standard method/field that's historically volatile across versions?
- Does it share a model/field with another customization such that a future change to one breaks the other?
- Flag: fragile dependencies and coupled customizations, so the TTD's upgrade-risk section carries them.

## How to run it efficiently

1. From Step 2's inventory, list every custom addon that touches the target model(s).
2. Grep those addons for `_inherit`, the target method names, `@api.depends`/compute on the target fields, and automation definitions on the target triggers.
3. Check Settings and `ir.config_parameter` in the same feature area for a native feature governing the same decision (check 6).
4. Trace what consumes the output of the flow being altered (check 7).
5. For each hit, determine: does it *collide* (same method/field/trigger, conflicting effect), *duplicate* (already does this), *compete* (a standard setting deciding the same outcome), or *couple* (shares a dependency)?
6. Record each as cleared (checked, no conflict) or found (with the specific addon/file/method/setting and the nature of the conflict). **Record every surface, including the clean ones** — "None found" is the answer the TTD's conflict-clearance table requires, and a blank row there reads as an unasked question.

## The output

The conflict check produces one of:
- **Cleared** — "Checked addons X, Y, Z touching `sale.order`; no overlapping override of `action_confirm`, no competing automation on confirm, no other writer of the target field. Safe to extend."
- **Conflict found** — the specific collision/duplication/coupling, named to the file and method, handed back to the OPL/developer as a blocker to resolve before the customization is finalized (per `pitfall-flagging.md`).

A "cleared" result is not optional boilerplate — it's the evidence that the new customization was actually checked against the instance's real customization landscape, which is exactly what prevents the "two customizations that each worked in the demo" failure.
