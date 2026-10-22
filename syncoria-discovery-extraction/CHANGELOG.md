# Changelog — syncoria-discovery-extraction

Semver per the Skill Operating Model §3.5: major = behaviour/lane change · minor = new content · patch = correction.

---

## 1.1.0 — 2026-09-29 · SCR-2026-002 · effective immediately

Paired with `syncoria-aidlc-method` 1.2.0 (Project Control Register). Lane unchanged: this skill still only extracts.

### Added
- **Register merge block** (output section 8 / template §7). Emitted only when the engagement has a `project-control-register.md`. Lists the record's register-worthy items with citation and proposed authority (A3 reached + confirmed / A4 reached once), and flags items that touch a settled register entry or match an out-of-scope one. Propose-only: `syncoria-aidlc-method` applies the merge and puts conflicts to the user.
- Lane bullet naming `syncoria-aidlc-method` as the register's owner.

### Notes
- Frontmatter description unchanged. It sits at 1024 characters, **the ceiling**. Any future description edit must shorten it first.

## 1.0.0 — baseline (pre-2026-09-29)
Baseline as installed; first versioned in this changelog.
