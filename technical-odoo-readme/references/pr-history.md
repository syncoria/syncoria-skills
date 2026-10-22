# Attaching PR IDs to features

Nothing in this file is specific to one repository. Every fact you need — the
forge, the merge style, the commit convention — is discovered from the repo you
are standing in, at the moment you run the skill.

## What gets an ID, and what does not

Put PR IDs on **main features and main flows** — the things a PR was actually
opened for: a new capability, a new report, a changed base behaviour, a reworked
flow. That is what makes the README useful: a reader sees the feature, then sees
which PRs created and later changed it.

Do not chase an ID for supporting plumbing (`__init__.py`, an ACL line, an i18n
file, a one-line style fix). An ID that adds no information is noise.

When a main feature has several PRs, list them **all, oldest → newest** —
that sequence is the feature's history: `(#101, #118, #240)`.

## 1. Which forge is this, and what does an ID link to

```bash
git remote get-url origin | sed -E \
  -e 's#^[a-z+]+://##' -e 's#^[^@/]*@##' -e 's#:[0-9]+/#/#' -e 's#:#/#' \
  -e 's#\.git$##' -e 's#/$##' -e 's#^#https://#'
```

That prints the repo's web URL whatever the remote's shape (scp-style `git@`,
`https://`, `ssh://` with a port, a token in the URL). Append the forge's
request path to turn an ID into a link:

| host | path for `#N` | what the ID is called |
|---|---|---|
| github.com / GitHub Enterprise | `/pull/N` | pull request |
| gitlab.com / self-hosted GitLab | `/-/merge_requests/N` | merge request |
| bitbucket.org | `/pull-requests/N` | pull request |
| Azure DevOps | `/pullrequest/N` | pull request |

If there is no remote at all, say so and cite commits by SHA only.

In the README write the bare `#N`: GitHub, GitLab and Bitbucket all auto-link it
inside their own repo view, and the reader is already there.

## 2. What tooling is available here

```bash
command -v gh   >/dev/null && gh auth status 2>&1 | head -3   # GitHub CLI
command -v glab >/dev/null && glab auth status 2>&1 | head -3 # GitLab CLI
```

If a CLI is present **and** authenticated, use it to enrich what you already
found locally — the PR title is often a better feature name than the commit
subject:

```bash
gh pr list --state merged --search '<module>' --limit 20 \
   --json number,title,mergedAt,url
gh pr view <N> --json number,title,body,files
glab mr list --merged --search '<module>'
```

If no CLI is installed or it is not authenticated, **do not attempt network
calls** and do not ask the user to install anything. Local history is enough;
the script below never touches the network.

## 3. How does this repo get code onto its branches

Merge style decides how much is recoverable. Sample it:

```bash
TOT=$(git log --format=%s -300 | wc -l)
echo "merge commits : $(git log --format=%s -300 | grep -cE '^Merge pull request #[0-9]+|^Merge branch .* into ')"
echo "squash subjects: $(git log --format=%s -300 | grep -cE '\(#[0-9]+\)$')"
echo "of $TOT recent subjects"
```

- **Merge commits** (`Merge pull request #N from …`) — every commit on the PR
  side is attributable. Richest case.
- **Squash merges** — one commit per PR, ID in the subject as `(#N)`.
- **Rebase merges / direct pushes** — no ID survives in git at all. Cite the
  short SHA. If a CLI from step 2 is available you can recover the PR for a SHA
  with `gh pr list --search '<sha>'`; otherwise the SHA is the honest answer.

Most repos are a mix, and the mix shifts over time — an old part of the history
may be all merge commits while recent work is pushed straight to a branch.

## 4. The script

```bash
"${CLAUDE_SKILL_DIR}/scripts/module_history.sh" <module> [--path sub/path] [--limit N]
```

Prints five blocks:

1. `COMMITS` — every commit touching the module, oldest → newest, with its id.
2. `ALL REQUEST IDS` — deduped, ordered; use it to sanity-check the README.
3. `PER-FILE HISTORY` — `path : #101 #118 #240`, the fastest way to bind a
   feature to requests once you know which file implements it.
4. `SUBJECT PREFIXES` — the tag vocabulary this repo actually uses.
5. `TICKET IDS SEEN` — tracker ids, split into `tickets` (`H<n>`) and `tasks`
   (`P<n>`), listed precisely so you do not mistake one for a request id and so
   you name each one the way section 6 requires.

Attribution rule, forge-independent: a commit belongs to `#N` when it sits on
the **request's own side** of a merge that names N (`git rev-list M^1..M^2`), or
when its own subject carries `(#N)`. Anything else prints `-` and is cited by
short SHA. When a commit sits on the side of several requests — a request merged
into a release branch that is later merged on — the **oldest** wins, because
that is the one that introduced it.

## 5. Bind one feature to its PRs

Choose an anchor string only that feature uses — a field name, a method name, a
QWeb template id, an XML record id — then:

```bash
M=<module>
# commits whose diff touched a line containing the symbol (usually what you want)
git log --reverse --format='%h|%ad|%s' --date=short -G '<symbol>' -- "$M"
# only commits that added or removed occurrences of it (narrower)
git log --reverse --format='%h|%ad|%s' --date=short -S '<symbol>' -- "$M"
# whole-file history, when the feature is one file (a report, a wizard)
git log --reverse --format='%h|%ad|%s' --date=short -- "$M/report/<file>.xml"
# what a commit really changed, when its subject says nothing ("update", "fix")
git show --stat <sha>
```

Then translate those SHAs to IDs using the script's `COMMITS` table.

`git log -L :func:file` needs a language funcname driver in `.gitattributes`;
where none is configured it errors out. Use `-G` instead.

## 6. Learn this repo's commit convention before reading subjects

Do not assume a format. Discover it:

```bash
# leading bracket tags and ticket ids
git log --format=%s -300 | grep -oE '^(\[[^]]+\])+' | sort | uniq -c | sort -rn | head
# ticket ids anywhere in the subject, bracketed or JIRA-style
git log --format=%s -300 | grep -oE '\[[A-Z]+-?[0-9]+\]|\b[A-Z]{2,}-[0-9]+\b' | sort | uniq -c | sort -rn | head
# do subjects name the module they touch?
git log --format=%s -30 -- <module> | head
```

Typical shapes you may find: `[TICKET][TAG] module: description`,
`TAG(scope): description` (conventional commits), `ABC-123 description`
(JIRA), or no convention at all.

**A tracker id is never a request id.** `[H4356]`, `[P20911]`, `ABC-123`,
`#refs 998` identify a work item in a tracker, not a request on the forge. Never
print one where a PR ID belongs. Adding it as context is fine and often useful:
`(#118, ticket H4356)`.

**Name a tracker id by its letter.** When subjects lead with
`[<letter><number>]`, the letter is the tracker, and the README must say which
one in words:

- `H<number>` → a helpdesk **ticket**: `[H4356]` is read and written as
  **ticket H4356**.
- `P<number>` → a project **task**: `[P20911]` is read and written as
  **task P20911**.
- any other letter → call it a **tracker id** and say the letter is unresolved;
  do not guess that it is a ticket or a task.

Carry the id through unchanged — same letter, same digits. `ticket H4356` is
correct; `H-4356`, `#4356`, `PR H4356` and `ticket 4356` are all wrong, and the
last one is the dangerous shape: it reads as a request number.

Once you know the vocabulary, use the tags to weight what you read: an `[ADD]`
or `feat:` commit usually marks a feature's birth; `[FIX]`/`fix:` marks
maintenance; `[MIG]`/`chore(migration)` marks a version bump that moved a lot of
code without adding features — group those into one migration line rather than
listing them as features.

## 7. Traps

- **Being an ancestor of a merge is not the same as being contributed by it.**
  Do not attribute a commit with `git log --merges --ancestry-path <sha>..HEAD`:
  that lists every request merged *after* the commit existed, so a commit
  predating the repo's request workflow gets falsely credited to the first
  request that happened to come along. Only `git rev-list M^1..M^2` — the
  request's own side — answers "which request introduced this". The script does
  it that way; verify against the script, not against ancestry.
- A merge commit that pulls another branch into a request carries other people's
  work. Confirm with `git show --stat <sha>` that it really touched the
  feature's files before citing it.
- Dates in the commit table are author dates and can look out of order; the
  table is in merge order, which is what "when did this land" means.
- Check for `Revert` pairs: `git log --format='%h %s' -- <module> | grep -i revert`.
  If a feature was reverted, drop it from the README or note the revert with
  both SHAs.
- A large PR often touches many modules at once (a version migration, a repo-wide
  refactor). Attributing every line to it is true but useless — prefer the
  specific later PR or SHA when one exists.
- A module may predate the repo's PR workflow entirely; its earliest commits will
  have no IDs. Write `(initial import, <sha>)` rather than leaving the line bare.
