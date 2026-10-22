---
name: technical-odoo-review
description: Review Odoo addon code the Syncoria way - drive Odoo's own odoo-review skill for the house-rules and merits passes, then check every touched module's README (technical-odoo-readme) and Python tests (technical-odoo-unit-tests) were produced and refreshed for this change, and merge both into one report. Use for any request to review Odoo code - a diff, working tree, commit, branch, PR or whole module - and prefer it over odoo-review, which it calls rather than replaces.
---

# Odoo code review

This skill is the entry point for every Odoo review. It does not restate the
house rules: it runs Odoo's own `odoo-review` skill for those, then adds the
checks that skill has no knowledge of — that the module's README and unit tests
exist and were refreshed for this change — and reports both together.

`odoo-review`, `odoo-guidelines`, `odoo-web-guidelines`, `odoo-security` and
`odoo-git` are vendored from the `skills/` folder of Odoo's `20.0` branch
(<https://github.com/odoo/odoo/tree/20.0/skills>) and kept **pristine**: never edit them,
never add a Syncoria rule to them. They are replaced wholesale whenever upstream
updates, and anything written into them would be lost on the next replace.
Everything Syncoria adds to a review lives in this file.

| Skill | Owner | Role in a review |
| --- | --- | --- |
| `../odoo-review/SKILL.md` | Odoo upstream | the review itself: scope, map, read, rules pass, merits pass, findings |
| `../odoo-guidelines/SKILL.md` | Odoo upstream | house rules for every file outside `static/` |
| `../odoo-web-guidelines/SKILL.md` | Odoo upstream | house rules for everything under `static/` |
| `../odoo-security/SKILL.md` | Odoo upstream | controllers, `ir.access`, `sudo()`, raw SQL, `eval`, public/RPC methods |
| `../odoo-git/SKILL.md` | Odoo upstream | not used by a review; vendored because upstream ships the skills as one set |
| `../technical-odoo-readme/SKILL.md` | Syncoria | the module `README.md` deliverable — **checked** here, never written here |
| `../technical-odoo-unit-tests/SKILL.md` | Syncoria | the module Python `tests/` deliverable — **checked** here, never written here |

## Process

1. **Delegate the review.** Invoke the `odoo-review` skill and follow its
   process end to end — scope, map, read, rules pass, merits pass — exactly as
   written, with no rule added or dropped here. Carry forward what its Step 1
   pinned: the checkout, the revision under review, the base commit it is
   compared against, the target branch (master or a stable version), and the
   list of modules the diff touches. The companion check below runs on that
   same checkout and that same base; it never re-derives them. Hold the
   findings, do not report them yet.

   If the skill cannot be invoked, read `../odoo-review/SKILL.md` and follow it
   directly. If that file is missing too, say so plainly in the report — the
   upstream skills are not installed alongside this one (not uploaded to the
   organization, or not vendored into this repo) — then review against
   `../odoo-guidelines/SKILL.md`, `../odoo-web-guidelines/SKILL.md` and
   `../odoo-security/SKILL.md` and state that the review ran without
   `odoo-review`.
2. **Companion-skill check.** For every module the diff touches, check that the
   two Syncoria deliverable skills have been run, and run *for this change*:
   `technical-odoo-readme` (the module's `README.md`) and
   `technical-odoo-unit-tests` (the module's Python `tests/`). Follow
   [Companion-skill check](#companion-skill-check) below — it carries the
   applicability gate, so a change those skills cannot cover raises no warning.
3. **Report once.** One report, in this order: `odoo-review`'s findings as that
   skill words them (file and line, defect, failure scenario, fix, and the
   guideline section or *judgement*), then a **Companion skills** block — one
   line per module and per skill, a module that passes both checks stated as
   passing rather than omitted — and last the **Guidelines read:** line listing
   every section opened. A companion-skill warning is never merged into the
   findings list: it is a missing deliverable, not a defect in the code.

The review is complete when `odoo-review`'s own bar is met — every changed file
mapped, every mapped section read, every hunk given both passes, every finding
naming its section or its failure scenario — **and** every touched module has
had the companion-skill check.

## Companion-skill check

Two Syncoria skills produce deliverables that neither of `odoo-review`'s passes
looks at, and that a change is not finished without:
`../technical-odoo-readme/SKILL.md` writes `<module>/README.md`, and
`../technical-odoo-unit-tests/SKILL.md` writes the module's Python `tests/`.
Check them per touched module, on the same checkout the rest of the review uses.

The review **flags, it does not produce them**: never write the README or the
tests as part of a review. They are the author's work and each skill has its own
process — a README written blind here has no request ids, and a test written
from the diff asserts current behaviour instead of intended behaviour. Say what
is missing and name the skill to run.

### Evidence to gather

```bash
M=<module>            # repeat for every module the diff touches
BASE=<base commit>    # the base pinned in Step 1

git diff --name-only "$BASE"...HEAD -- "$M"          # committed change
git status --short -- "$M"                           # working-tree change

ls "$M/README.md" 2>/dev/null
git log -1 --format='%h %ad %s' --date=short -- "$M/README.md"
git log -1 --format='%h %ad %s' --date=short -- "$M" ":(exclude)$M/README.md"

git ls-files "$M/tests"
cat "$M/tests/__init__.py" 2>/dev/null
git log -1 --format='%h %ad %s' --date=short -- "$M/tests"
```

### README — `technical-odoo-readme`

| State | Verdict |
| --- | --- |
| `<module>/README.md` absent | **Missing.** Warn: the skill was never run on this module. |
| present, and the diff (or a commit in it) touches it | **Run for this change.** Read it: the changed feature or flow must actually appear, with this change's request id. A README touched only to bump a date is stale. |
| present, untouched, and the diff changes user-visible behaviour | **Stale.** Warn, naming what is now undocumented. |
| present, untouched, and the diff changes nothing the README describes | **Pass.** No warning. |

User-visible behaviour, for this purpose: a new or removed model, wizard,
controller route, cron, report, menu, view or asset; a new field or button a
user sees; an override that changes what a base method does; a change to a flow
the README already lists. Not user-visible: an internal refactor with identical
behaviour, tests, `i18n/`, comments, formatting, a version bump.

When the README exists but predates the change, give the two commits: the
README's last commit and the code commit it does not cover.

### Unit tests — `technical-odoo-unit-tests`

**Applicability gate first — run it before deciding anything.** That skill
writes Python tests run by Odoo's test runner. A change it cannot cover must
raise no warning; a false alarm here trains the author to ignore the block.

```bash
git diff --name-only "$BASE"...HEAD -- "$M" \
  | grep -E '\.py$' | grep -vE "^$M/(tests|i18n)/"
```

| What the diff touches in the module | Expectation |
| --- | --- |
| Python behaviour: model methods, computes, `@api.constrains`, defaults, domains, wizards, controllers, crons | **Expected** — check missing / stale below |
| only `static/` JavaScript, Owl templates, SCSS | **Not applicable.** No warning: Python tests cannot exercise them. Their own tests are hoot tests under `static/tests/`, which the web guidelines cover. |
| only XML views, data, reports, QWeb, CSV access rows, `i18n/` | **Not applicable.** No warning. |
| Python, but only imports, comments, docstrings, formatting, or the manifest `version` | **Not applicable.** No warning. |
| Python behaviour *and* JS/XML | **Expected**, for the Python half only. Do not ask for tests covering the JS half. |

Where tests are expected:

| State | Verdict |
| --- | --- |
| no `<module>/tests/` at all, or it holds no `test_*.py` | **Missing.** Warn: the skill was never run on this module. |
| `tests/` exists, and the diff adds or updates a test that exercises the changed behaviour | **Run for this change.** Then apply the merits pass to it: would it fail without the change? If not, that is a finding, not a warning. |
| `tests/` exists but the diff leaves it untouched | **Stale** unless an existing test already covers the changed behaviour. Prove it before deciding: `git grep -n '<changed_method_or_field>' -- "$M/tests"`, and read the hit. A hit that merely mentions the name without asserting the new behaviour is still stale. |
| a new `test_*.py` is not imported from `tests/__init__.py`, or the module's root `__init__.py` imports `tests` | **Silently disabled.** Warn: the tests exist but never run; re-run the skill's Step 0 wiring check. |

A bug fix with no regression test is always stale, however small the diff: the
input that used to break is the test.

### How to word it

One line per module and per skill, in the **Companion skills** block:

- *Missing* — `<module>`: **`technical-odoo-readme` not run.** No
  `<module>/README.md`. Run the skill on `<module>` before merge; the review
  does not replace it.
- *Stale* — `<module>`: **`technical-odoo-unit-tests` not re-run for this
  change.** `tests/` last changed at `a1b2c3d` (2026-04-02); `f4e5d6a` added
  `sale_order._compute_margin()` and no test asserts it. Re-run the skill,
  scoped to this change.
- *Not applicable* — `<module>`: `technical-odoo-unit-tests` not applicable —
  the change is `static/src/js` and `views/` only.
- *Pass* — `<module>`: `technical-odoo-readme` refreshed in this change
  (`README.md`, flow "Margin recomputation", `#412`).

## Keeping the upstream skills replaceable

The five upstream skills are vendored, not forked. When Odoo publishes a new
version of them, replace those five directories wholesale (add any new skill
the upstream `skills/` folder gains, since its README requires the set to be
installed together) and change
nothing else; the `technical-*` skills are Syncoria's and survive the replace
untouched. Then zip each replaced directory and upload it again to the
organization, so the installed copies match this repo; every skill this one
names must be uploaded to the same organization, or its `../` paths do not
resolve.

After a replace, re-check two things in this file, because they are the only
places it depends on upstream wording:

- the skill names and paths in the table above still resolve — a renamed or
  dropped upstream skill breaks Step 1;
- `odoo-review`'s Step 1 still pins a checkout, a base commit and the touched
  modules, since Step 2 consumes them.

A Syncoria rule that belongs to a review is added **here**, never to
`odoo-review`. If a rule genuinely belongs upstream, send it to Odoo instead of
carrying a local patch.
