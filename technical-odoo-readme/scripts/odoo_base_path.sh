#!/usr/bin/env bash
# odoo_base_path.sh [serie]
#
# Discovers the Odoo source trees available on THIS machine, with no hard-coded
# paths. Prints one TSV row per addons directory found:
#
#   serie <TAB> kind <TAB> addons_dir <TAB> where it was discovered
#
# kind is community | enterprise | extra (OCA and other third-party bundles).
# With a serie argument (e.g. 19.0) only that serie is printed.
#
# Sources, in order. The first one that yields a directory outside the project
# is the only one used; the others are not merged in:
#   1. $ODOO_ADDONS_PATH - the comma-separated path the user gave when asked
#   2. addons_path in *.conf at the project root
#   3. addons_path in ~/.odoorc
# In a conf file, `~` is expanded and a relative entry is resolved against the
# folder holding that conf file.
#
# Exit 1 when nothing is found, or when the requested serie is not among what
# was found: ask the user for the absolute addons_path, then rerun with
# ODOO_ADDONS_PATH set. Never guess a path and never fall back to another serie.
set -euo pipefail

WANT="${1:-}"
REPO="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CAND="$(mktemp)"; ROOTS="$(mktemp)"
trap 'rm -f "$CAND" "$ROOTS"' EXIT

add_cand() {            # dir source-label
  local p="${1:-}" src="${2:-}"
  [ -n "$p" ] && [ -d "$p" ] || return 0
  p="$(cd "$p" 2>/dev/null && pwd -P)" || return 0
  case "$p" in "$REPO"|"$REPO"/*) return 0 ;; esac   # the project's own addons
  printf '%s\t%s\n' "$p" "$src" >> "$CAND"
}
split_addons_path() {   # "a,b,c" base-dir source-label
  local list="${1:-}" base="${2:-}" src="${3:-}" part
  printf '%s\n' "$list" | tr ',' '\n' | while IFS= read -r part; do
    part="$(printf '%s' "$part" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
    [ -n "$part" ] || continue
    case "$part" in
      "~")   part="$HOME" ;;
      "~/"*) part="$HOME/${part#\~/}" ;;
      /*)    ;;
      *)     part="$base/$part" ;;
    esac
    add_cand "$part" "$src"
  done
}
from_conf() {           # conf-file
  local f="${1:-}" line
  [ -f "$f" ] || return 0
  line="$(grep -iE '^[[:space:]]*addons_path[[:space:]]*=' "$f" 2>/dev/null | tail -1 || true)"
  [ -n "$line" ] || return 0
  split_addons_path "${line#*=}" "$(cd "$(dirname "$f")" && pwd -P)" "conf:$f"
}
not_found() {           # reason
  {
    echo "$1"
    echo "Checked: \$ODOO_ADDONS_PATH, addons_path in *.conf at $REPO, addons_path in ~/.odoorc."
    echo "Ask the user for the absolute addons_path of the Odoo source (community,"
    echo "and enterprise if the module depends on it), then rerun every call as:"
    echo "  ODOO_ADDONS_PATH=/abs/odoo/addons,/abs/odoo/odoo/addons,/abs/enterprise $0 ${WANT}"
  } >&2
  exit 1
}

# 1. the path the user gave -------------------------------------------------
[ -n "${ODOO_ADDONS_PATH:-}" ] && split_addons_path "$ODOO_ADDONS_PATH" "$PWD" "user:ODOO_ADDONS_PATH"

# 2. project config at the repo root ----------------------------------------
if [ ! -s "$CAND" ]; then
  for f in "$REPO"/*.conf; do from_conf "$f"; done
fi

# 3. ~/.odoorc ----------------------------------------------------------------
[ -s "$CAND" ] || from_conf "$HOME/.odoorc"

[ -s "$CAND" ] || not_found "No Odoo source found."

# classify -------------------------------------------------------------------
sort -u -t"$(printf '\t')" -k1,1 "$CAND" | while IFS="$(printf '\t')" read -r dir src; do
  root="$dir"; serie=""
  for _ in 1 2 3 4; do
    [ -f "$root/odoo/release.py" ] && break
    root="$(dirname "$root")"; [ "$root" = "/" ] && break
  done
  if [ -f "$root/odoo/release.py" ]; then
    serie="$(sed -nE 's/^version_info[[:space:]]*=[[:space:]]*\(([0-9]+),[[:space:]]*([0-9]+).*/\1.\2/p' "$root/odoo/release.py" 2>/dev/null | head -1 || true)"
  fi
  # bundles shipped without release.py (OCA, third-party): take the serie from a manifest
  if [ -z "$serie" ]; then
    serie="$( { grep -hm1 -r --include='__manifest__.py' -E "'version'[[:space:]]*:[[:space:]]*'[0-9]+\.[0-9]+\." "$dir" 2>/dev/null || true; } \
        | sed -nE "s/.*'([0-9]+\.[0-9]+)\..*/\1/p" | head -1 || true)"
  fi
  if [ -z "$serie" ]; then
    serie="$(printf '%s\n' "$dir" | sed -nE 's|.*[^0-9]([0-9]{2}\.0)([^0-9/]*)?/?$|\1|p' | head -1 || true)"
  fi
  [ -z "$serie" ] && serie="unknown"

  kind=community
  if [ -d "$dir/web_studio" ] || [ -d "$dir/account_accountant" ]; then
    kind=enterprise
  elif [ ! -d "$dir/base" ] && [ ! -d "$dir/account" ]; then
    kind=extra
  fi

  printf '%s\t%s\t%s\t%s\n' "$serie" "$kind" "$dir" "$src"
done | sort -u > "$ROOTS"

if [ -n "$WANT" ]; then
  out="$(awk -F'\t' -v s="$WANT" '$1==s' "$ROOTS")"
  [ -n "$out" ] || not_found "Odoo serie $WANT is not in the addons_path found. Found: $(cut -f1 "$ROOTS" | sort -u | tr '\n' ' ')(from $(cut -f4 "$ROOTS" | sort -u | tr '\n' ' '))"
  printf '%s\n' "$out"
else
  cat "$ROOTS"
fi
