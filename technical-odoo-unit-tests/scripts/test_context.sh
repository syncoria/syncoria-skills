#!/usr/bin/env bash
# test_context.sh <module|path/to/module>
#
# Resolves everything that differs between projects and between Odoo series by
# reading THIS repo and THIS machine - never by assuming a version:
#
#   * the module, wherever it sits in the repo, and the serie it targets
#     (using Odoo's own version rule, so a 2/3-part version is reported as
#     declaring nothing rather than as serie "1.0")
#   * the Odoo source to probe, from $ODOO_ADDONS_PATH, then addons_path in
#     *.conf at the project root, then ~/.odoorc - first hit only
#   * which test classes and helpers that serie ACTUALLY ships, probed from its
#     source, so tests are written against the API that exists in it
#   * the tests already present, and the wiring faults that silently skip them
#   * the test-cases specification file
#   * the exact command to run only this module's tests
#
# Never touches the network and never writes anything.
set -euo pipefail

ARG="${1:-}"
[ -n "$ARG" ] || { echo "usage: test_context.sh <module|path/to/module>" >&2; exit 2; }

manifest_of() {   # <dir> -> prints the manifest path, or nothing
  local d="${1%/}"
  for n in __manifest__.py __openerp__.py; do   # __openerp__.py: Odoo <= 9
    [ -f "$d/$n" ] && { printf '%s\n' "$d/$n"; return 0; }
  done
  return 1
}

# accept a path (relative to where the user stands) or a bare module name
MDIR=""
if manifest_of "$ARG" >/dev/null 2>&1; then MDIR="$(cd "${ARG%/}" && pwd -P)"; fi

cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
REPO="$PWD"
NAME="$(basename "${ARG%/}")"

if [ -z "$MDIR" ]; then
  if manifest_of "$REPO/$ARG" >/dev/null 2>&1; then
    MDIR="$(cd "$REPO/${ARG%/}" && pwd -P)"
  else
    # the addon may live under addons/, src/, or any other layout
    HIT="$(find "$REPO" -maxdepth 5 \( -name __manifest__.py -o -name __openerp__.py \) \
            -path "*/$NAME/*" -not -path '*/node_modules/*' -not -path '*/.git/*' 2>/dev/null | head -1 || true)"
    [ -n "$HIT" ] && MDIR="$(dirname "$HIT")"
  fi
fi
[ -n "$MDIR" ] || { echo "no Odoo module '$NAME' found under $REPO (no __manifest__.py)" >&2; exit 2; }
MANIFEST="$(manifest_of "$MDIR")"
MOD="$(basename "$MDIR")"
REL="${MDIR#"$REPO"/}"

section() { printf '\n== %s ==\n' "$1"; }

# ---------------------------------------------------------------- manifest --
# ast.literal_eval reads the manifest whatever quoting style it uses; the sed
# fallback below covers a manifest literal_eval refuses (a computed value).
META="$(python3 - "$MANIFEST" <<'PY' 2>/dev/null || true
import ast, sys
try:
    m = ast.literal_eval(open(sys.argv[1], encoding='utf-8').read())
except Exception:
    raise SystemExit
if isinstance(m, dict):
    print(m.get('version', ''))
    print(','.join(m.get('depends', []) or []))
    print(','.join((m.get('external_dependencies') or {}).get('python', []) or []))
PY
)"
VERSION="$(printf '%s\n' "$META" | sed -n 1p)"
DEPENDS="$(printf '%s\n' "$META" | sed -n 2p)"
PYDEPS="$(printf '%s\n' "$META" | sed -n 3p)"
[ -n "$VERSION" ] || VERSION="$(sed -nE "s/.*['\"]version['\"][[:space:]]*:[[:space:]]*['\"]([^'\"]+)['\"].*/\1/p" "$MANIFEST" | head -1)"

# Odoo's own rule (modules/module.py:adapt_version): a 2-3 part version is
# prefixed with the RUNNING serie, so it declares no serie of its own. Only a
# 4-5 part version starting with "<major>.<minor>." is a serie declaration.
NPARTS="$(printf '%s' "$VERSION" | awk -F. '{print NF}')"
DECLARED=""
if [ "${NPARTS:-0}" -ge 4 ]; then
  DECLARED="$(printf '%s' "$VERSION" | cut -d. -f1,2)"
  case "$DECLARED" in [0-9]*.[0-9]*) ;; *) DECLARED="" ;; esac
fi

section "module"
printf 'module            : %s\n' "$MOD"
printf 'path              : %s\n' "$REL"
printf 'manifest version  : %s\n' "${VERSION:-<unreadable>}"
if [ -n "$DECLARED" ]; then
  printf 'declared serie    : %s\n' "$DECLARED"
else
  printf 'declared serie    : none (%s-part version - Odoo prefixes the running serie)\n' "${NPARTS:-0}"
fi
printf 'depends           : %s\n' "${DEPENDS:-<none>}"
[ -n "$PYDEPS" ] && printf 'python deps       : %s (a test must not assume these are installed)\n' "$PYDEPS"

# ---------------------------------------------------------------- runtimes --
RT="$(mktemp)"; trap 'rm -f "$RT"' EXIT

# Sources, in order. The first one that yields an Odoo root is the only one
# used; the others are not merged in:
#   1. $ODOO_ADDONS_PATH - the comma-separated path the user gave when asked
#   2. addons_path in *.conf at the project root
#   3. addons_path in ~/.odoorc

record_root() {   # <dir> <source-label>   -> serie \t pkg \t root \t bin \t src
  local d="${1:-}" src="${2:-}" root pkg="" serie bin
  [ -d "$d" ] || return 0
  root="$(cd "$d" 2>/dev/null && pwd -P)" || return 0
  case "$root" in "$REPO"|"$REPO"/*) return 0 ;; esac   # the project's own addons
  for _ in 1 2 3 4; do
    for p in odoo openerp; do [ -f "$root/$p/release.py" ] && { pkg="$p"; break; }; done
    [ -n "$pkg" ] && break
    root="$(dirname "$root")"; [ "$root" = "/" ] && return 0
  done
  [ -n "$pkg" ] || return 0
  serie="$(sed -nE 's/^version_info[[:space:]]*=[[:space:]]*\(([0-9]+),[[:space:]]*([0-9]+).*/\1.\2/p' "$root/$pkg/release.py" | head -1)"
  [ -n "$serie" ] || return 0
  bin="-"
  for b in odoo-bin openerp-server; do [ -f "$root/$b" ] && { bin="$root/$b"; break; }; done
  printf '%s\t%s\t%s\t%s\t%s\n' "$serie" "$pkg" "$root" "$bin" "$src" >> "$RT"
}

add_path_list() {  # "a,b,c" <base-dir> <source-label>
  local list="${1:-}" base="${2:-}" src="${3:-}" p
  printf '%s\n' "$list" | tr ',' '\n' | while IFS= read -r p; do
    p="$(printf '%s' "$p" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
    [ -n "$p" ] || continue
    case "$p" in
      "~")   p="$HOME" ;;
      "~/"*) p="$HOME/${p#\~/}" ;;
      /*)    ;;
      *)     p="$base/$p" ;;
    esac
    record_root "$p" "$src"
  done
}
from_conf() {      # <conf-file>
  local f="${1:-}" line
  [ -f "$f" ] || return 0
  line="$(grep -iE '^[[:space:]]*addons_path[[:space:]]*=' "$f" 2>/dev/null | tail -1 || true)"
  [ -n "$line" ] || return 0
  add_path_list "${line#*=}" "$(cd "$(dirname "$f")" && pwd -P)" "conf:$f"
}
ask_user() {       # <reason>
  echo "$1"
  echo "Checked: \$ODOO_ADDONS_PATH, addons_path in *.conf at $REPO, addons_path in ~/.odoorc."
  echo "STOP and ask the user for the absolute addons_path of that Odoo source, then"
  echo "rerun as:"
  echo "  ODOO_ADDONS_PATH=/abs/odoo/addons,/abs/odoo/odoo/addons $0 $ARG"
  echo "Do NOT assume a serie or guess a path."
}

[ -n "${ODOO_ADDONS_PATH:-}" ] && add_path_list "$ODOO_ADDONS_PATH" "$PWD" "user:ODOO_ADDONS_PATH"
if [ ! -s "$RT" ]; then
  for f in "$REPO"/*.conf; do from_conf "$f"; done
fi
[ -s "$RT" ] || from_conf "$HOME/.odoorc"

section "odoo sources on this machine"
if [ -s "$RT" ]; then
  # a root without a server binary is an addons bundle (enterprise, OCA), not a
  # runtime: show it only when nothing better exists for that serie
  sort -u "$RT" | awk -F'\t' 'NR==FNR{ if($4!="-") has[$1]=1; next }
       $4=="-" && has[$1] { next }
       { printf "%-6s %-55s %s\n", $1, $3, $5 }' "$RT" -
else
  ask_user "none found."
fi

section "serie verdict"
SERIES="$(cut -f1 "$RT" 2>/dev/null | sort -u | tr '\n' ' ' | sed 's/ $//')"
RUNTIME="$(printf '%s' "$SERIES" | tr ' ' '\n' | sed '/^$/d' | sort -V | tail -1)"
if [ -n "$DECLARED" ]; then
  TARGET="$DECLARED"
  if printf '%s\n' "$SERIES" | tr ' ' '\n' | grep -qx "$DECLARED"; then
    echo "Target Odoo $DECLARED - declared by the manifest, and installed here."
  else
    [ -n "$SERIES" ] && ask_user "Module declares $DECLARED but the addons_path found has only [$SERIES]."
    echo "Only if the user says the $DECLARED source is not available: write for"
    echo "$DECLARED with TransactionCase and say the API could not be probed."
  fi
else
  TARGET="$RUNTIME"
  echo "No serie declared: Odoo prefixes the running serie, so the tests must"
  echo "target the runtime: ${TARGET:-<unknown>}."
  [ "$(printf '%s' "$SERIES" | wc -w | tr -d ' ')" -gt 1 ] \
    && echo "The addons_path found holds more than one serie [$SERIES] - STOP and ask the user which one runs this project."
fi

ROW="$(awk -F'\t' -v s="${TARGET:-}" '$1==s && $4!="-"{print; exit}' "$RT" 2>/dev/null || true)"
[ -n "$ROW" ] || ROW="$(awk -F'\t' -v s="${TARGET:-}" '$1==s{print; exit}' "$RT" 2>/dev/null || true)"
PKG="$(printf '%s' "$ROW" | cut -f2)"
ROOT="$(printf '%s' "$ROW" | cut -f3)"
BIN="$(printf '%s' "$ROW" | cut -f4)"
SRC="$(printf '%s' "$ROW" | cut -f5)"

# a module whose serie is not the running one may be refused outright: ask the
# RUNTIME's source whether it enforces that, instead of assuming a version
if [ -n "$DECLARED" ] && [ -n "$RUNTIME" ] && [ "$DECLARED" != "$RUNTIME" ]; then
  RROW="$(awk -F'\t' -v s="$RUNTIME" '$1==s{print; exit}' "$RT")"
  RPKG="$(printf '%s' "$RROW" | cut -f2)"; RROOT="$(printf '%s' "$RROW" | cut -f3)"
  if [ -n "$RROOT" ] && grep -q "def check_version" "$RROOT/$RPKG/modules/module.py" 2>/dev/null; then
    echo "NOTE: the running serie ($RUNTIME) has check_version(): it refuses a module"
    echo "      whose serie is not its own (installable=False, log line only)."
    echo "      This module may be dormant on it, not merely stale."
  fi
fi

# ------------------------------------------------------------- API probing --
section "test API in serie ${TARGET:-?} (probed, not assumed)"
COMMON="$ROOT/$PKG/tests/common.py"
if [ -z "$ROOT" ] || [ ! -f "$COMMON" ]; then
  echo "source for serie ${TARGET:-?} not available here - cannot probe."
  echo "Ask the user for it first (see above). Only if it is not available: state"
  echo "in the report that the API was not verified, and keep to TransactionCase,"
  echo "which exists in every serie."
else
  echo "source: $ROOT/$PKG/tests/"
  have() {   # <name> -> 0 if the class exists anywhere in the tests package
    grep -rqE "^class $1\b" "$ROOT/$PKG/tests/"*.py 2>/dev/null
  }
  where() { grep -rlE "^class $1\b" "$ROOT/$PKG/tests/"*.py 2>/dev/null | head -1; }
  for c in TransactionCase SingleTransactionCase HttpCase SavepointCase HttpSavepointCase; do
    if have "$c"; then
      f="$(basename "$(where "$c")")"
      if grep -A6 -E "^class $c\b" "$(where "$c")" | grep -qi 'deprecat'; then
        printf '  %-22s present in %s but DEPRECATED - do not use\n' "$c" "$f"
      else
        printf '  %-22s available (%s)\n' "$c" "$f"
      fi
    else
      printf '  %-22s ABSENT in this serie - using it is an ImportError\n' "$c"
    fi
  done

  # Form moved between series; compute the import that is correct HERE
  if [ -f "$ROOT/$PKG/tests/form.py" ]; then
    FORM_IMPORT="from $PKG.tests import Form"
    grep -qi 'deprecat' "$COMMON" 2>/dev/null && \
      printf '  %-22s in tests/form.py; tests.common.Form is deprecated here\n' "Form" \
      || printf '  %-22s in tests/form.py\n' "Form"
  elif grep -qE "^class Form\b" "$COMMON" 2>/dev/null; then
    FORM_IMPORT="from $PKG.tests import Form"
    printf '  %-22s in tests/common.py\n' "Form"
  else
    FORM_IMPORT=""
    printf '  %-22s not found\n' "Form"
  fi

  printf '  helpers              :'
  for h in assertRecordValues assertQueryCount assertXMLEqual assertHTMLEqual; do
    grep -rqE "def $h\b" "$ROOT/$PKG/tests/"*.py 2>/dev/null && printf ' %s' "$h"
  done; printf '\n'
  printf '  utilities            :'
  for u in RecordCapturer freeze_time Like Approx WhitespaceInsensitive; do
    grep -rqE "^class $u\b|^def $u\b" "$ROOT/$PKG/tests/"*.py 2>/dev/null && printf ' %s' "$u"
  done; printf '\n'
  grep -rqE "^class freeze_time\b" "$ROOT/$PKG/tests/"*.py 2>/dev/null \
    || echo "  freeze_time          : not shipped by this serie - use freezegun directly"
  [ -f "$ROOT/$PKG/addons/base/tests/common.py" ] && \
    grep -qE "^class BaseCommon\b" "$ROOT/$PKG/addons/base/tests/common.py" 2>/dev/null && \
    printf '  %-22s available (%s.addons.base.tests.common)\n' "BaseCommon" "$PKG"
  echo "  suggested imports    : from $PKG.tests import TransactionCase, tagged${FORM_IMPORT:+, Form}"
fi

# ------------------------------------------------------------ test wiring --
section "existing tests"
if [ -d "$MDIR/tests" ]; then
  find "$MDIR/tests" -name '*.py' -not -path '*__pycache__*' | sed "s#^$REPO/##; s/^/  /" | sort
  if [ -f "$MDIR/tests/__init__.py" ]; then
    for t in "$MDIR"/tests/test_*.py; do
      [ -f "$t" ] || continue
      b="$(basename "$t" .py)"
      grep -qE "(^|[^_[:alnum:]])$b([^_[:alnum:]]|$)" "$MDIR/tests/__init__.py" \
        || echo "  !! $b is NOT imported in tests/__init__.py - Odoo will never run it"
    done
  else
    echo "  !! tests/ exists but has no __init__.py - Odoo cannot import it"
  fi
else
  echo "  no tests/ directory - this module has no tests yet"
fi
if [ -f "$MDIR/__init__.py" ] && grep -qE '^[[:space:]]*from[[:space:]]+\.[[:space:]]+import[[:space:]].*\btests\b|^[[:space:]]*from[[:space:]]+\.tests\b|^[[:space:]]*import[[:space:]]+tests\b' "$MDIR/__init__.py"; then
  echo "  !! $MOD/__init__.py imports tests - it must not; Odoo imports the"
  echo "     tests package itself, only when testing is enabled."
fi

section "test conventions used in this repo"
T="$(grep -rhoE '@tagged\([^)]*\)' --include='test_*.py' "$REPO" 2>/dev/null | sort | uniq -c | sort -rn | head -3 || true)"
[ -n "$T" ] && printf '%s\n' "$T" | sed 's/^/  /' || echo "  no @tagged in this repo yet"
I="$(grep -rhE '^from [a-z_]*(\.[a-z_]+)* import .*(TransactionCase|Form|BaseCommon|tagged)' --include='test_*.py' "$REPO" 2>/dev/null | sort | uniq -c | sort -rn | head -5 || true)"
[ -n "$I" ] && printf '%s\n' "$I" | sed 's/^/  /' || echo "  no existing test imports to copy - follow the probe above"

# ---------------------------------------------------------- spec discovery --
section "test-cases specification file"
SPEC=""
for c in "$MDIR/tests/test_cases.md" "$MDIR/tests/TEST_CASES.md" \
         "$MDIR/test_cases.md" "$MDIR/TEST_CASES.md" \
         "$MDIR/docs/test_cases.md" "$MDIR/docs/TEST_CASES.md"; do
  [ -f "$c" ] && { SPEC="$c"; break; }
done
[ -n "$SPEC" ] || SPEC="$(find "$MDIR" -type f \( -name '*.md' -o -name '*.txt' -o -name '*.yaml' -o -name '*.yml' \) \
    -not -path '*__pycache__*' 2>/dev/null | grep -iE 'test[_-]case|test[_-]scenario|user[_-]flow' | sort | head -1 || true)"
if [ -n "$SPEC" ]; then
  printf 'found: %s (%s lines)\n' "${SPEC#"$REPO"/}" "$(wc -l < "$SPEC" | tr -d ' ')"
  echo "READ IT IN FULL before writing tests - it is the source of truth for the"
  echo "intended flow, and code that disagrees with it is a finding, not a spec."
else
  echo "none found - derive intended behaviour from the code and the user's request."
fi

# ------------------------------------------------------------ run command --
section "run only this module's tests"
if [ -n "$BIN" ] && [ "$BIN" != "-" ]; then
  CONF=""
  case "$SRC" in
    conf:*) CONF="${SRC#conf:}"; case "$CONF" in /*) ;; *) CONF="$REPO/$CONF" ;; esac ;;
  esac
  [ -n "$CONF" ] && [ -f "$CONF" ] || CONF=""
  printf '%s \\\n' "$BIN"
  [ -n "$CONF" ] && printf '  -c %s \\\n' "$CONF"
  [ "$SRC" = "user:ODOO_ADDONS_PATH" ] && printf '  --addons-path=%s,%s \\\n' "$ODOO_ADDONS_PATH" "$(dirname "$MDIR")"
  printf '  -d <database> -u %s \\\n' "$MOD"
  if grep -q 'test.tags\|test_tags' "$ROOT/$PKG/tools/config.py" 2>/dev/null; then
    printf '  --test-tags "/%s" --stop-after-init --log-level=test\n' "$MOD"
  else
    # older series ship only --test-enable, which runs everything
    printf '  --test-enable --stop-after-init --log-level=test\n'
  fi
  echo
  echo "-u reinstalls the module first: run it against a scratch/staging database,"
  echo "never a production one. Ask the user for the database name and for"
  echo "permission before running it."
else
  echo "no server binary found for serie ${TARGET:-<unknown>} - ask the user how they run tests."
fi
