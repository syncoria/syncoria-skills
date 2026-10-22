---
name: technical-odoo-unit-tests
description: Write or update unit tests for an Odoo module - detect the Odoo serie from the manifest and the running configuration, probe that serie's own source for the test API it actually ships, treat a test-cases specification file as the source of truth over the code, and keep the diff scoped to what changed. Use whenever asked to write, add, update or fix tests for an Odoo module or addon, to cover a change or bug fix with tests, or to check an implementation against a documented test-case / user-flow file.
---

# Odoo unit tests

Write tests that would fail if the behaviour broke, against the test API of the
serie this module actually runs on, touching only what the change touched.

Non-negotiables:

- **Never assume an Odoo version, and never write a test API from memory.**
  The serie comes from the manifest and the running configuration; the API comes
  from reading that serie's own source. Base classes, helper names and import
  paths have all been added, moved and removed across series — a class that is
  standard in one is an `ImportError` in another, and that failure looks like a
  broken module rather than a broken test. Step 0 resolves both and is not
  optional.
- **A test-cases file, when one exists, outranks the code.** If the code
  disagrees with it, that is a finding to report — not a spec to encode into a
  test. Writing a test that asserts the buggy behaviour is the worst outcome of
  this skill: it certifies the bug and makes it permanent.
- **Never assert something you have not traced to a line of code.** For every
  assertion, know the method that produces the value.
- **Scope the diff to the change.** Do not reformat, rename or "improve"
  unrelated tests. A test file touched for no reason hides the real diff.
- **Never run tests against a database you were not given.** `-u <module>`
  reinstalls the module and can destroy data. Ask first, every time.

## Step 0 — Context gate (always first)

```bash
"${CLAUDE_SKILL_DIR}/scripts/test_context.sh" <module|path/to/module>
```

The script ships inside this skill: `${CLAUDE_SKILL_DIR}` is that folder. Run it
with the project as the working directory. One pass, no network, writes nothing. Works on any project layout (the addon
may sit at the repo root, under `addons/`, anywhere) and on any serie. It
reports:

- **the serie to target.** From the manifest when it declares one — applying
  Odoo's own `adapt_version` rule, so a 2/3-part version (`1.0`, `19.1.1`) is
  correctly reported as declaring *nothing*: Odoo prefixes the running serie to
  it, and such a module must be tested against the runtime instead. The Odoo
  source comes from `addons_path` in the first of these that yields one, and
  only that one: `$ODOO_ADDONS_PATH` (the path the user gave when asked),
  `*.conf` at the project root, then `~/.odoorc`. Commented lines are ignored,
  `~` is expanded, and a relative entry is resolved against its conf file's
  folder. Nothing else is searched.
- **the test API that serie actually ships**, read from its source: which base
  classes exist, which are present but deprecated, where `Form` lives, whether
  the serie ships its own `freeze_time`, which assertion helpers and utilities
  are available, and the import line that is correct there. Treat this block as
  authoritative and write against it.
- **wiring faults that silently disable tests**: a `test_*.py` missing from
  `tests/__init__.py`, a `tests/` with no `__init__.py`, or the module's root
  `__init__.py` importing `tests`.
- **this repo's own conventions** — the prevailing `@tagged` decorator and
  import style. Match what is already there; do not introduce a second style.
- the test-cases specification file, and the exact command to run the module's
  tests.

**When the script says STOP** — no Odoo source found, the declared serie is
not in the `addons_path` found, or that path holds more than one serie for a
module that declares none — ask the user before writing any test. Do not search
the disk and do not guess a path:

> I could not find the Odoo `<SERIE>` source from `odoo.conf` in this project or
> `~/.odoorc`. What is the absolute `addons_path` for it — community `addons`,
> `odoo/addons`, and enterprise if the module depends on it?

Pass the answer on every later call, since environment variables do not
survive between tool calls:

```bash
ODOO_ADDONS_PATH=/abs/odoo-19.0/addons,/abs/odoo-19.0/odoo/addons \
  "${CLAUDE_SKILL_DIR}/scripts/test_context.sh" <module>
```

Suggest the user add that line to `odoo.conf` at the project root so the next
run finds it alone. Only when the user says the source is not available, keep
to `TransactionCase`, which exists in every serie, and say in the report that
the API was not verified.

If the module cannot be identified from the request, infer it from the changed
files. If there are no changed files either, ask **one** question naming the
candidates — do not guess between modules.

## Step 1 — Scope: decide what must be tested

Tests follow a change; they are not a coverage quota.

```bash
git status --short -- <module>
git diff -- <module>
```

Map each changed hunk to a behaviour, and each behaviour to a test:

| What changed | What the test must pin |
|---|---|
| overridden base method | the base behaviour is still reachable **and** the new branch fires |
| new `@api.depends` compute | the trigger field writes, then the computed value |
| new `@api.constrains` | the valid case passes **and** the invalid one raises |
| new field with a default | the default lands on create, and on a copy if `copy=True` |
| domain / `search` change | a record inside the domain and one deliberately outside |
| bug fix | the exact input that used to break — this is a regression test |
| controller route | status code, auth, and the payload shape |

Then:

- A module with **no tests at all** and no stated scope: write a suite covering
  the module's main flows, not every method. Say which flows you chose.
- A changed behaviour with **no existing test**: add a focused test for it only.
- An existing test that covers changed code: **update it in place**.
- Never rewrite a whole test module unless the user explicitly asked for a
  rewrite.

## Step 2 — The test-cases specification file

If Step 0 found one, read **all** of it before writing any test, then follow
`references/test-cases-file.md`. That file defines the flow map to build, the
code cross-check, and — the part that matters — what to do when the code and
the document disagree: **stop and report, ask which one is wrong.** Do not
quietly write tests that match the code.

If no such file exists, intended behaviour comes from the code plus the user's
request, and any ambiguity worth one question is worth asking before writing.

## Step 3 — Write the tests

Layout: `<module>/tests/test_<subject>.py`, imported from
`<module>/tests/__init__.py`. Odoo imports that package itself when testing is
enabled, so the module's own `__init__.py` must **not** import `tests`.

**Base class and imports: use exactly what Step 0 probed.** Do not carry an
import over from another project or another serie. `TransactionCase` is the
default for model and business-logic tests — it exists in every serie, rolls
back after each test method, and takes shared fixtures in `setUpClass`. Use
`HttpCase` only for controller, portal or tour tests; it is far slower. If the
probe marked something ABSENT or DEPRECATED, it is not an option.

`references/test-api-probe.md` explains what varies between series and how to
re-probe by hand when the script cannot run.

Rules that hold on every serie:

- **Tag as the repo does.** Step 0 prints the prevailing decorator. The phase
  matters: `at_install` runs right after the module installs, `post_install`
  after all modules have loaded, and a test needing data or behaviour from a
  module that installs later must be `post_install`. Getting it wrong yields a
  test that passes alone and fails in a full run, or the reverse.
- **Build the minimum record graph.** Prefer `self.env.ref` on stable base XML
  ids over creating a chart of accounts by hand. If the probe reported a shared
  base test class, and the repo already uses it, use it too.
- **Assert state, not calls.** `self.assertEqual(picking.state, "done")` beats
  asserting that a method was invoked.
- **Assert errors precisely**: `with self.assertRaises(ValidationError):`, and
  `assertRaisesRegex` when the message is the contract.
- **Deterministic or it does not ship**: no network, no `datetime.now()`
  without freezing, no dependence on demo data that may be absent, no reliance
  on record ids or on the order of an unsorted `search`.
- **Never assume a python package is installed** — the manifest's
  `external_dependencies` are what the module needs, not what the test host has.
- **Name the test after the behaviour**: `test_invoice_blocked_when_partner_has_no_vat`,
  not `test_invoice_2`. When a test-cases file exists, put its case ID and title
  in the docstring.
- Cover, for each behaviour: the happy path, one edge case, one failure case.

## Step 4 — Verify before handing over

- [ ] Serie stated, with where it came from (manifest, or the runtime because
      the version declares none) — not assumed.
- [ ] Every class and helper used appears in Step 0's probe as available.
- [ ] Every new `test_*.py` is imported in `tests/__init__.py`; the module's
      root `__init__.py` does not import `tests`.
- [ ] Re-run Step 0: the wiring warnings it printed must all be gone.
- [ ] Every test method name describes the behaviour and starts with `test_`.
- [ ] No unrelated test file appears in `git diff --stat`.
- [ ] Nothing asserted that you cannot point to a file and line for.
- [ ] Python is at least importable:
      `python3 -m py_compile <module>/tests/*.py`

Then offer the run command from Step 0. **Ask for the database name and for
permission before running it** — `-u <module>` reinstalls the module.

## Report to the user

State, in this order:

1. Module, and the Odoo serie with where it came from.
2. Whether a test-cases file was found, and its path.
3. If one was found: the flow-vs-code result — cases that match and are tested
   as written, and every mismatch as *expected vs actual* with the file and
   line, plus the decision you need from the user.
4. The change scope the tests were chosen from.
5. Files created and files updated, and which existing tests you deliberately
   left alone.
6. Scenarios covered, referencing case IDs when there are any.
7. The run command, and the offer to run it.

## Anti-patterns

- Writing a test that asserts current behaviour *because* it is current — a test
  derived from the code cannot detect that the code is wrong.
- Using a base class, helper or import path from memory, from another project,
  or from a different serie, instead of the one Step 0 probed.
- Reading the serie from a sibling module, from the repo's other modules, or
  from the newest Odoo you know about, instead of from this module's manifest
  and this project's configuration.
- Asserting `assertTrue(record)` — true for every non-empty recordset; it pins
  nothing.
- A `setUpClass` that builds fixtures no test in the class uses.
- Reformatting or renaming untouched tests in the same commit.
- Running `-u <module>` against whatever database was lying around.
- Claiming tests pass without showing the run output.
