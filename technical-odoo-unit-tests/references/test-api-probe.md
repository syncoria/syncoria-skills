# Probing the test API of a serie

Odoo's test framework is not stable across series. Base classes have been
merged and removed, `Form` has moved, helpers have been added, and the way the
runner selects tests has changed. So this skill never states "Odoo does X" — it
reads the source of the serie in front of it and reports what is there.

`scripts/test_context.sh` does this automatically and its output is
authoritative. This file explains **what** it looks at and how to reproduce it
by hand when the script cannot run — a serie whose source is not on the machine,
an unusual layout, or a check the script does not cover.

## Finding the source to probe

The script reads `addons_path` from the first of these that yields an Odoo
root, and only that one: `$ODOO_ADDONS_PATH` (the path the user gave when
asked), `*.conf` at the project root, then `~/.odoorc`. When none does, it says
STOP and the user is asked. It walks each addons directory up to the
package root — the directory holding `odoo/release.py` (or `openerp/release.py`
on Odoo ≤ 9) — and reads the serie from `version_info` there.

To do it by hand:

```bash
ROOT=/path/to/odoo-checkout
sed -n '/^version_info/p' "$ROOT/odoo/release.py"      # the real serie
```

**Never take the serie from a sibling module, from the repo's other addons, or
from the newest Odoo you happen to know.** A repo commonly carries modules from
several series at once.

## Which serie a module targets

Odoo's own rule, in `odoo/modules/module.py` → `adapt_version()`:

- a version of **4–5 parts** beginning `<major>.<minor>.` declares that serie;
- a version of **2–3 parts** (`1.0`, `19.1.1`) declares nothing — Odoo prefixes
  the running serie to it. Such a module must be tested against the runtime.

Some series also define `check_version()` next to it: where it exists, a module
whose declared serie is not the running one is refused outright
(`installable = False`, with only a log line). Grep for it in the **runtime's**
source before assuming a mismatched module is merely stale:

```bash
grep -n "def check_version" "$ROOT/odoo/modules/module.py"
```

## What to probe, and why each matters

### Base classes

```bash
grep -nE "^class [A-Za-z]+" "$ROOT/odoo/tests/common.py"
```

`TransactionCase` and `HttpCase` exist in every serie worth testing.
Others have come and gone: classes have been **merged into `TransactionCase`
and kept as deprecated aliases for a while, then deleted**. A deleted class is
an `ImportError` that takes the module's whole suite down with it, so check
presence *and* deprecation:

```bash
grep -A6 -E "^class <Name>\b" "$ROOT/odoo/tests/common.py" | grep -i deprecat
```

If a class is present but the lines under it mention deprecation, do not use it
even though it still imports.

### Where `Form` lives

```bash
ls "$ROOT/odoo/tests/form.py" 2>/dev/null
grep -nE "^class Form\b" "$ROOT/odoo/tests/common.py" "$ROOT/odoo/tests/form.py" 2>/dev/null
grep -n "Form" "$ROOT/odoo/tests/common.py" | grep -i deprecat
```

`Form` has moved between modules inside the tests package, and the old location
kept working through a shim that emits a deprecation warning. Importing from
the package root (`from odoo.tests import Form`) is what survives the move —
`odoo/tests/__init__.py` re-exports it either way. Confirm with:

```bash
sed -n '1,20p' "$ROOT/odoo/tests/__init__.py"
```

### Freezing time

```bash
grep -nE "^class freeze_time\b|^def freeze_time\b" "$ROOT"/odoo/tests/*.py
```

Newer series ship their own `freeze_time` wrapper around `freezegun` that also
handles decorating a test *class*. Where it is absent, import `freezegun`
directly and check it is actually installed. Either way, a test that reads the
current date without freezing fails on one day of the year, in someone's
timezone.

### Assertion helpers and utilities

```bash
grep -nE "def assert[A-Za-z]+" "$ROOT"/odoo/tests/*.py
grep -nE "^class [A-Za-z]+" "$ROOT"/odoo/tests/*.py
```

Look for record-value assertions, query-count assertions, XML/HTML comparison,
a context manager capturing records created inside a block, and fuzzy
string/float comparators. The set grows with each serie. Prefer them over
hand-rolled loops — but only the ones the probe found.

### A shared base test class

```bash
grep -nE "^class [A-Za-z]*Common\b" "$ROOT/odoo/addons/base/tests/common.py" 2>/dev/null
```

Later series ship a `TransactionCase` subclass with the usual company and user
fixtures. It does not exist in older ones. Use it only if it is both present
and already used by the repo.

### How the runner finds tests

```bash
grep -rn "def get_test_modules" "$ROOT/odoo/tests/loader.py" "$ROOT/odoo/modules/module.py" 2>/dev/null
```

The file moved between series, but the mechanism has not: Odoo imports the
`tests` subpackage of the addon itself. Two consequences hold everywhere:

- `<module>/tests/__init__.py` must import every `test_*.py`. A file it does not
  import is never run, and nothing warns you.
- `<module>/__init__.py` must **not** import `tests`, or test code loads on
  every install.

### How the runner selects tests

```bash
sed -n '/--test-tags/,/^$/p' "$ROOT/odoo/tools/config.py" | head -30
grep -n "test_enable\|test_tags" "$ROOT/odoo/tools/config.py" | head
```

Where `--test-tags` exists its spec format is
`[-][tag][/module][:class][.method]`, an omitted tag means `standard` in include
mode, every test class carries `standard` and `at_install` until `@tagged`
removes them, and the option implies `--stop-after-init`. Older series have only
`--test-enable`, which runs everything the installed modules define. Read the
help text in the serie at hand rather than reciting flags.

## When the source is not available

Ask the user for it first (see Step 0 in `SKILL.md`). Only when they say it is
not available, say so in the report, and keep to what is true of every serie:
`TransactionCase`, `setUpClass`, `self.env`, `assertRaises`, and
`from odoo.tests import ...` for anything re-exported at the package root.
Do not guess at helpers; a test that fails to import is worse than a test that
uses a plain `assertEqual`.
