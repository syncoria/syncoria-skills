---
name: technical-odoo-readme
description: Document an Odoo addon by reading the module end to end - manifest first to pin the Odoo serie, then models, views, reports, wizards, data, security and assets - and write README.md listing its features and main flows, each with the pull/merge request ids that built it. Use whenever asked to write or refresh a module's README/overview/documentation, inventory what a module does, or explain its flows and what it customises on top of Odoo base.
---

# Odoo module README

Produce a `README.md` that is an accurate inventory of what a module actually does,
derived from reading its code, not from its manifest blurb. Every feature line
carries the GitHub PR IDs that built it.

Non-negotiables:

- **Read `__manifest__.py` before any other file.** Its `version` names the Odoo
  serie the module was *written against*, and that decides which base you
  compare it to. "What it customises" is a statement about base behaviour, and
  base behaviour differs between series — compare against the wrong one and you
  will report customisations that do not exist and miss the ones that do.
  Treat the manifest as a claim: Step 0 also checks it against the serie this
  repo actually runs, because a stale version there is itself a finding.
- **Never invent a request id.** Pull/merge request numbers come from
  `scripts/module_history.sh` only. A change pushed without one is cited by
  short SHA, not guessed.
- **Never write a feature you have not seen in the code.** The manifest
  `description` is a claim to verify, not a source.
- **Cover the whole module.** Every model, view, report, wizard, controller,
  cron, JS asset and data file is either behind a listed feature or explicitly
  listed as supporting plumbing.

## Step 0 — Version gate (always first)

```bash
cd "$(git rev-parse --show-toplevel)"
sed -n '1,40p' <module>/__manifest__.py
```

Extract `version`, `depends`, `data`, `assets`, `license`, `application`.
The **declared serie** is the first two version segments (`19.0.1.0.0` → `19.0`).
A repo usually mixes series: take it from *this* module's manifest, never from
its neighbours. Keep it in `SERIE` for the commands below.

Then get the **runtime serie** — the Odoo this repo is actually configured to
run — from the same discovery script, with no argument. The script ships inside
this skill. `${CLAUDE_SKILL_DIR}` is that folder; run the script with the
project as the working directory. On claude.ai the same file is
`scripts/odoo_base_path.sh` in the skill folder copied into the sandbox.

```bash
"${CLAUDE_SKILL_DIR}/scripts/odoo_base_path.sh" | cut -f1 | sort -u
```

- **They match** — the normal case. Compare against that serie and move on.
- **They differ** — compare against the **declared** serie, because that is the
  base the code was written against, but report the mismatch under Notes. It is
  usually a module left behind by a migration. Check whether it is worse than
  cosmetic on the running serie:

  ```bash
  # ask the RUNTIME serie, not the declared one - it is the one loading the module
  # 1 = it enforces the serie, 0 = it does not
  RUNTIME=19.0
  "${CLAUDE_SKILL_DIR}/scripts/odoo_base_path.sh" "$RUNTIME" \
    | awk -F'\t' '$2=="community"{print $3}' | sed 's#/addons$##' | sort -u \
    | xargs -I{} sh -c '[ -f {}/odoo/modules/module.py ] && grep -c "def check_version" {}/odoo/modules/module.py'
  ```

  Where `check_version()` exists, Odoo rejects a 5-part version whose serie is
  not the running one: `installable = False`, with only a log line. The module
  is then silently dormant and nothing in the README describes live behaviour
  — say so explicitly. Verified present in 19.0, absent in 16.0 and 17.0; check
  rather than assume for any other serie.
- **The script exits 1** — no Odoo source was found, or the declared serie is
  not in the `addons_path` it found. Follow
  [When the script finds nothing](#when-the-script-finds-nothing).

A 2- or 3-part version (`1.0`, `19.1.1`) is not a serie declaration at all:
Odoo rewrites it by prefixing the running serie (`1.0` → `19.0.1.0`), so it
always passes the check and tells you nothing. Use the runtime serie for those.

Map the serie to the Odoo source **on this machine**. Never hard-code a path:
the skill is shared, and every laptop lays its checkouts out differently.

```bash
SERIE=19.0   # whatever the manifest said
"${CLAUDE_SKILL_DIR}/scripts/odoo_base_path.sh" "$SERIE"
```

Rows are `serie <TAB> kind <TAB> addons_dir <TAB> where it was discovered`:

```
19.0  community   <root>/odoo-19.0/addons                 conf:<repo>/odoo.conf
19.0  community   <root>/odoo-19.0/odoo/addons            conf:<repo>/odoo.conf
19.0  enterprise  <root>/enterprise-19.0                  conf:<repo>/odoo.conf
```

`kind` is `community`, `enterprise`, or `extra` (OCA and other third-party
bundles). A serie usually has two community rows - `.../addons` holds
stock/sale/account, `.../odoo/addons` holds the core ones (base, web) - so
always search both. Pipe the roots into `xargs`:

```bash
BASE_SH="${CLAUDE_SKILL_DIR}/scripts/odoo_base_path.sh"
SERIE=19.0

"$BASE_SH" "$SERIE" | awk -F'\t' '$2=="community"{print $3}' \
  | xargs grep -rn "<field_the_module_redefines> = fields" --include='<base_model>.py'

"$BASE_SH" "$SERIE" | awk -F'\t' '$2=="enterprise"{print $3}' \
  | xargs grep -rln "_inherit = '<base.model>'"
```

Repeat that pipeline in each command - shell variables do not survive between
tool calls, and `ROOTS=$(...)` then `grep ... $ROOTS` silently searches a single
bogus path under zsh, which does not word-split unquoted variables.

The script reads `addons_path` from these sources, in order, and uses only the
first one that yields an Odoo directory outside the project:

1. `$ODOO_ADDONS_PATH` — the path the user gave when asked (below).
2. `*.conf` at the project root (`odoo.conf`, ...).
3. `~/.odoorc`.

Commented lines are ignored, `~` is expanded, and a relative entry is resolved
against the folder of its conf file. Nothing else is searched: not a running
`odoo-bin`, not IDE run configs, not `import odoo`.

### When the script finds nothing

The script exits 1 when no source yields a directory, or when the serie asked
for is not among what was found; stderr says which. Then **stop and ask the
user** — do not search the disk, and do not guess a path:

> I could not find the Odoo `<SERIE>` source from `odoo.conf` in this project or
> `~/.odoorc`. What is the absolute `addons_path` for it — community `addons`,
> `odoo/addons`, and enterprise if the module depends on it?

Pass the answer on every later call, since environment variables do not
survive between tool calls:

```bash
ODOO_ADDONS_PATH=/abs/odoo-19.0/addons,/abs/odoo-19.0/odoo/addons,/abs/enterprise-19.0 \
  "${CLAUDE_SKILL_DIR}/scripts/odoo_base_path.sh" "$SERIE"
```

Suggest the user add that line to `odoo.conf` at the project root so the next
run finds it alone. Only when the user says the source is not available,
document the module from its own code and say in the handover that the
base-comparison step was skipped. **Do not fall back to a different serie**; a
v16 base would misdescribe v19 code.

## Step 1 — Inventory pass (what exists)

Do not summarise yet. Build a file map.

```bash
M=<module>
git ls-files "$M" | grep -vE '__pycache__|\.pyc$|\.po$|\.pot$' | sort
wc -l $(git ls-files "$M" | grep -E '\.(py|xml|js|scss)$') | sort -n | tail -30
```

Read, in this order, and completely — not just headers:

1. `__manifest__.py` (done in Step 0) — `data` order tells you load dependencies.
2. `models/*.py` — for each class note `_name` vs `_inherit` vs `_inherits`, new
   fields, overridden methods, new methods, `@api.depends/constrains/onchange`.
3. `wizard/*.py` — transient models and what they act on.
4. `controllers/*.py` — routes, auth, portal/website surface.
5. `views/*.xml` — new views/actions/menus vs `inherit_id` patches; note the
   `xpath`/`position` targets, they name the base UI being changed.
6. `report/*.py` + `report/*.xml` — QWeb templates, paperformats, report actions,
   AbstractModel report parsers.
7. `data/*.xml`, `data/*.csv` — crons, sequences, mail templates, seeded records.
8. `security/*.xml` + `ir.model.access.csv` — new groups, record rules, ACLs.
9. `static/src/**` — OWL components, patches of base components, SCSS overrides.
10. `i18n/` — presence only; do not list translations as features.

Record for every file: what it adds, and which base thing it touches.

## Step 2 — Trace the main flows

A feature list without flows is a field dump. For each entry point found above,
follow the call chain until it reaches persistence or UI:

- button in a view → `type="object"` method → what it writes → what recomputes
- cron → method → records affected
- controller route → template / JSON response
- `@api.depends` chain → stored computed fields → what reads them
- report action → parser → QWeb template → data it pulls

Name 1–4 **main flows** for the module. Each flow gets a short ordered
description in the README (trigger → steps → result). Use real method and model
names so a developer can jump straight in.

## Step 3 — Separate base override from new build

For every `_inherit` model and every `inherit_id` view, compare intent against
the base source **of the serie from Step 0** — that is the flow the module is
actually changing:

```bash
BASE_SH="${CLAUDE_SKILL_DIR}/scripts/odoo_base_path.sh"
SERIE=19.0   # from the manifest, Step 0
ROOTS() { "$BASE_SH" "$SERIE" | awk -F'\t' -v k="$1" '$2==k{print $3}'; }

# is the field base's, or does the module add it?
ROOTS community | xargs grep -rn "move_ids = fields" --include='stock_picking.py'
# what did the overridden base method do before?
ROOTS community | xargs grep -rn -A15 "def _has_to_be_paid" --include='account_move.py'
# which base view is being xpath'd
ROOTS community | xargs grep -rn 'id="vpicktree"' --include='*.xml'
# and check enterprise too when the module depends on an enterprise addon
ROOTS enterprise | xargs grep -rln "_inherit = 'stock.picking'"
```

Define `ROOTS()` again in every command block; it does not persist.

Classify each item as one of:

- **New object** — `_name` model, new wizard, new report, new route.
- **Base extension** — field added to a base model, new button/tab in a base view.
- **Base behaviour change** — an overridden base method or a redefined base field
  (`move_ids = fields.One2many(domain=...)` style). These are the risky ones:
  state what base did and what the module makes it do instead.
- **Pure styling/UX** — SCSS, sticky headers, label changes.

The README must make the third category visible; it is what breaks on upgrade.

## Step 4 — Request-ID archaeology

```bash
"${CLAUDE_SKILL_DIR}/scripts/module_history.sh" <module>
```

Five blocks: the module's commits with the pull/merge request behind each, the
deduped ordered id list, a per-file id list, the subject-prefix vocabulary this
repo uses, and the tracker ids seen, split into tickets and tasks. The script is
forge-agnostic (GitHub/Bitbucket `Merge pull request #N`, GitLab
`See merge request x!N`, squash `(#N)`) and never touches the network.

**Read the letter on every tracker id you list.** Subjects here lead with
`[<letter><number>]`, and the letter says which tracker the work item lives in:

| in the log | what it is | how you write it |
|---|---|---|
| `[H6087]` | helpdesk ticket | **ticket H6087** |
| `[P20911]` | project task | **task P20911** |
| anything else (`[ABC-123]`, `[X99]`) | unknown tracker | `tracker id ABC-123`, and say the letter is unresolved |

Use that wording everywhere the README names one — feature lines, flow steps,
Notes, History. Keep the letter and the digits exactly as the log has them:
never write "PR H6087", never drop the `H`/`P`, never renumber, and never turn
`H6087` into `#6087`.

To bind a *specific* feature to its requests, pickaxe an anchor symbol — a field,
a method, an XML record id — and translate the SHAs with the script's commit
table:

```bash
M=<module>
git log --reverse --format='%h|%ad|%s' --date=short -G '<field_or_method>' -- "$M"
git log --reverse --format='%h|%ad|%s' --date=short -- "$M/report/<file>.xml"
```

Read `references/pr-history.md` for forge detection, merge styles, discovering
this repo's commit convention, and the traps.

Rules for the ids printed in the README:

- **Main features and main flows carry ids.** That is the point: the reader sees
  a feature and sees which requests created and later changed it. Supporting
  plumbing (an `__init__.py`, an ACL line, a translation) does not need one.
- List **all** ids for such a feature, oldest → newest: `(#101, #118, #240)` —
  the order is the feature's history.
- A change pushed without a request is cited by short SHA: `(#118, a1b2c3d4)`.
- Never merge two features' ids into one line to save space.
- Never print a tracker id where a request id belongs; add it as context if
  useful, named by its letter: `(#118, ticket H6087)`, `(#118, task P20911)`.
- If a feature predates the repo's request workflow, write `(initial import, <sha>)`.

## Step 5 — Write the document

Use `references/readme-template.md`. Write to **`<module>/README.md`**, always,
in every module — one filename, no per-module branching, one place to look.

If `<module>/README.md` already exists, refresh it in place: keep it as the same
document, rewrite the sections this skill owns, and preserve anything hand-written
that the code still supports. Do not create a second file alongside it.

Two side effects of that filename worth knowing — they change what you write, not
where you write it:

- Odoo resolves a module's Apps-page description from
  `odoo/modules/module.py` → `README = ['README.rst', 'README.md', 'README.txt', 'README']`,
  first match wins, and only when the manifest has no `description`. So when the
  manifest has no `description` and no `README.rst` shadows it, this file becomes
  end-user-facing text on the Apps page. Keep the opening paragraph readable by a
  non-developer; the internal material (request ids, override tables, known debt)
  stays further down where it belongs.
- Many addons ship an OCA `README.rst` generated by `oca-gen-addon-readme` from a
  `readme/` fragment directory, carrying a source digest and "changes will be
  overwritten". `README.rst` sorts before `README.md` in Odoo's list, so where one
  exists it keeps the Apps page and `README.md` is the engineering document only.

Leave any existing `README.rst` and `readme/` fragments untouched; do not migrate
their content and do not delete them. If one contradicts what the code says, note
the contradiction in the README's Notes section rather than editing it.

Language: English by default, matching the commit log and the surrounding docs.
Write it in the language the user asked for if they asked.

Audience: a developer or consultant who has never opened this module and needs
to know what it does, what it touches in base, and where each part came from.

## Verification before handing over

- [ ] Manifest version read first, and the README's stated serie matches it.
- [ ] Written to `<module>/README.md`; any `README.rst` and `readme/` fragments
      left untouched.
- [ ] Every file from Step 1 is accounted for (feature, plumbing, or noted).
- [ ] Every main feature and main flow carries at least one request id or SHA,
      in chronological order.
- [ ] Every id printed appears in the script's output — spot-check two:
      `git log --oneline --merges --grep='#<N>'`
- [ ] Every overridden base method is named with model + method.
- [ ] No claim in the README that you cannot point at a file and line for.

## Anti-patterns

- Copying `summary`/`description` from the manifest as the feature list.
- "Improves the picking flow" — say which model, which method, which result.
- Guessing a request number from a tracker ticket id — they are different systems.
- Reading only `models/` and skipping `views/`, `data/` and `static/`.
- Comparing a module against whatever serie the rest of the repo uses instead of
  the serie in its own manifest.
