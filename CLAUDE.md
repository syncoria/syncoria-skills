# CLAUDE.md

Grounding for Claude Code (claude.ai/code) when working in this repository.

## What this repo is

The Syncoria skills library: Claude skills used for Odoo implementation work (methodology, product grounding, estimation, design, code review). It contains no application code. Each top-level folder is one skill, and the content is Markdown plus a few supporting assets and scripts.

## Layout

Each skill folder follows the same shape:

- `SKILL.md` (required): YAML frontmatter (`name`, `description`) followed by the instructions. The `description` is what triggers the skill, so keep it specific about *when* to use it.
- `references/` or `guidelines/`: detail files that `SKILL.md` points to and loads on demand.
- `scripts/`, `assets/`, `examples/`: supporting files (for example, the document generator in `syncoria-aidlc-method/scripts/`, brand fonts, logos and templates in `syncoria-designer/assets/`).
- `CHANGELOG.md`: present on the methodology skills.

## Skill groups

| Group | Skills |
|-------|--------|
| Syncoria methodology | `syncoria-aidlc-method`, `syncoria-customization-review`, `syncoria-discovery-extraction`, `syncoria-estimation`, `meeting-decisions` |
| Odoo and industry grounding | `syncoria-odoo`, `syncoria-industry-manufacturing` |
| Brand and design | `syncoria-designer` |
| Odoo code standards | `odoo-guidelines`, `odoo-web-guidelines`, `odoo-git`, `odoo-review`, `odoo-security` |
| Syncoria technical Odoo | `technical-odoo-readme`, `technical-odoo-review`, `technical-odoo-unit-tests` |
| Plugin tooling | `cowork-plugin-management_cowork-plugin-customizer`, `cowork-plugin-management_create-cowork-plugin` |

## Ownership boundaries

Skills defer to each other and should not duplicate content:

- `syncoria-odoo` owns Odoo mechanics (what is native, config vs. custom, models, upgrade safety).
- `syncoria-aidlc-method` owns process and artifact structure (Charter, PSS, CVBS, TTD, UAT and so on).
- `syncoria-customization-review` owns the four-test review of any customization before it is built.
- `syncoria-industry-*` skills own vertical-specific patterns.
- The `odoo-*` skills hold code standards. `technical-odoo-*` skills layer Syncoria's workflow on top of them.

Put new content in the skill that owns it and cross-reference rather than copy.

## Conventions

- Keep `SKILL.md` lean. Move long detail into `references/` and link to it from `SKILL.md`.
- Write the frontmatter `description` as trigger conditions ("Use when...") plus what the skill does and what it defers to.
- When changing a methodology skill, add an entry to its `CHANGELOG.md`.
- The `odoo-guidelines` and `odoo-web-guidelines` skills have an `AUTHORING.md` describing how to edit their rules. Read it before changing those rules.
- Never commit customer data, credentials or project records. Examples must be anonymized.
- Git commits follow Odoo's format (see `odoo-git`): `[TAG] scope: short header`, then a why-first body.

## Working in this repo

- There is no build or test step. Validate by checking that every `SKILL.md` has valid frontmatter and that every file it references exists.
- Skills here are also installed as Claude skills elsewhere. Treat a skill name and its `description` as a public interface: renaming a folder changes how the skill is invoked.
- `syncoria-designer/assets/` contains binary files (fonts, logos, a PPTX template). Do not edit them as text.
