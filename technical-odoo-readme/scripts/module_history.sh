#!/usr/bin/env bash
# module_history.sh <module_dir> [--path <sub/path>] [--limit N]
#
# Commit history of a module with the pull/merge request id behind each commit,
# plus a per-file breakdown. Safe to run from anywhere inside the repo, and it
# never touches the network. Nothing here is specific to one repo or one forge.
#
# A commit is attributed to request #N when either
#   * it is reachable from the request side of a merge commit that names N
#     ("Merge pull request #N ..." on GitHub/Bitbucket, "See merge request x!N"
#     on GitLab), or
#   * its own subject carries the id, as "(#N)" from a squash merge.
# Commits pushed straight to the branch show "-": cite their short SHA instead.
#
# Subject prefixes like [H6087] / [P20911] are TRACKER ids, never request ids:
# H<n> is a helpdesk ticket ("ticket H6087"), P<n> is a project task
# ("task P20911"). The last block groups them that way.
set -euo pipefail

MODULE=""; SUBPATH=""; LIMIT=0
while [ $# -gt 0 ]; do
  case "$1" in
    --path)  SUBPATH="$2"; shift 2 ;;
    --limit) LIMIT="$2";   shift 2 ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    *) MODULE="${1%/}"; shift ;;
  esac
done
[ -n "$MODULE" ] || { echo "usage: module_history.sh <module_dir> [--path sub/path] [--limit N]" >&2; exit 2; }

cd "$(git rev-parse --show-toplevel)"
MODULE="$(basename "$MODULE")"
[ -d "$MODULE" ] || { echo "no such module directory: $MODULE" >&2; exit 2; }
TARGET="$MODULE"; [ -n "$SUBPATH" ] && TARGET="$MODULE/$SUBPATH"

MAP="$(mktemp)"; LOG="$(mktemp)"; trap 'rm -f "$MAP" "$LOG"' EXIT

# sha -> request id, from the merge commits ---------------------------------
# --reverse walks the merges oldest first, so when a commit sits under several
# merges (a request merged into a release branch that is later merged on), the
# FIRST one recorded is the request that actually introduced it.
# The NUL goes FIRST: git puts a newline between commits, so a trailing
# separator would glue that newline to the front of the next record.
git log --merges --reverse --format='%x00%H%x09%s %b' HEAD 2>/dev/null \
  | tr '\n' ' ' | tr '\0' '\n' \
  | while IFS="$(printf '\t')" read -r m text; do
      [ -n "${m:-}" ] || continue
      pr=""
      case "$text" in
        *'Merge pull request #'*) pr="${text#*Merge pull request #}"; pr="${pr%%[!0-9]*}" ;;
        *'erge request '*'!'*)    pr="${text##*!}"; pr="${pr%%[!0-9]*}" ;;
      esac
      [ -n "$pr" ] || continue
      { echo "$m	$pr"; git rev-list "${m}^1..${m}^2" 2>/dev/null | sed "s/\$/	$pr/"; } || true
    done > "$MAP"

# Shared awk prelude: load the map once, resolve an id from sha or subject.
# One awk process per block - never one per commit, that is what made this slow.
read -r -d '' PRELUDE <<'AWK' || true
BEGIN {
  while ((getline line < MAPFILE) > 0) {
    i = index(line, "\t")
    if (!i) continue
    sha = substr(line, 1, i-1)
    if (!(sha in pr)) pr[sha] = substr(line, i+1)   # oldest merge wins
  }
}
function reqid(sha, subj,   p, s) {
  p = pr[sha]
  if (p != "") return p
  if (match(subj, /\(#[0-9]+\)[ \t]*$/)) { s = substr(subj, RSTART, RLENGTH); gsub(/[^0-9]/, "", s); return s }
  if (match(subj, /Merge pull request #[0-9]+/)) { s = substr(subj, RSTART, RLENGTH); sub(/.*#/, "", s); return s }
  if (match(subj, /![0-9]+/)) { return substr(subj, RSTART+1, RLENGTH-1) }
  return ""
}
AWK

# the module's own commits, fetched once ------------------------------------
if [ "$LIMIT" -gt 0 ]; then
  git log --reverse --format='%H%x09%ad%x09%s' --date=short -n "$LIMIT" -- "$TARGET" > "$LOG"
else
  git log --reverse --format='%H%x09%ad%x09%s' --date=short -- "$TARGET" > "$LOG"
fi

echo "### COMMITS for $TARGET (merge order, oldest -> newest)"
echo "date        sha       PR        subject"
awk -F'\t' -v MAPFILE="$MAP" "$PRELUDE"'
{ p = reqid($1, $3); printf "%s  %s  %-9s %s\n", $2, substr($1,1,8), (p=="" ? "-" : "#" p), $3 }
' "$LOG"

echo
echo "### ALL REQUEST IDS TOUCHING $TARGET (chronological, deduped)"
awk -F'\t' -v MAPFILE="$MAP" "$PRELUDE"'
{ p = reqid($1, $3); if (p != "" && !(p in seen)) { seen[p]=1; printf "#%s ", p } }
END { print "" }
' "$LOG"

echo
echo "### PER-FILE HISTORY (path : request ids, bare sha when pushed without one)"
git log --reverse --format='%x01%H%x09%s' --name-only -- "$MODULE" \
  | awk -v MAPFILE="$MAP" "$PRELUDE"'
/^\x01/ {
  line = substr($0, 2); i = index(line, "\t")
  sha = substr(line, 1, i-1); subj = substr(line, i+1)
  p = reqid(sha, subj); tag = (p == "" ? substr(sha,1,8) : "#" p)
  next
}
NF == 0 { next }
/__pycache__|\.pyc$/ { next }
{
  key = $0 SUBSEP tag
  if (!(key in seen)) { seen[key]=1; ids[$0] = (($0 in ids) ? ids[$0] " " tag : tag) }
  if (!($0 in listed)) { listed[$0]=1; order[++n] = $0 }
}
END { for (j = 1; j <= n; j++) printf "%s : %s\n", order[j], ids[order[j]] }
' | sort

echo
echo "### SUBJECT PREFIXES (this repo's convention, as used on $TARGET)"
{ git log --format='%s' -- "$TARGET" \
    | grep -oE '^(\[[^]]+\])+|^[a-z]+(\([^)]+\))?:' || true; } \
  | sort | uniq -c | sort -rn | head -12

echo
# Tracker ids, grouped by the letter that names their tracker. H<n> is a
# helpdesk ticket, P<n> is a project task; anything else stays unclassified
# rather than being guessed at. None of these is ever a request id.
echo "### TRACKER IDS SEEN (NOT request ids, never print as #N)"
{ git log --format='%s' -- "$TARGET" \
    | grep -oE '\[[A-Za-z]+-?[0-9]+\]|\b[A-Z]{2,}-[0-9]+\b' || true; } \
  | tr -d '[]' | sort -u \
  | awk '
      /^[Hh][0-9]+$/ { h = h " H" substr($0, 2); next }
      /^[Pp][0-9]+$/ { p = p " P" substr($0, 2); next }
      { o = o " " $0 }
      END {
        printf "tickets - write as \"ticket H<n>\" :%s\n", (h == "" ? " -" : h)
        printf "tasks   - write as \"task P<n>\"   :%s\n", (p == "" ? " -" : p)
        printf "other   - tracker id, letter unresolved :%s\n", (o == "" ? " -" : o)
      }'
