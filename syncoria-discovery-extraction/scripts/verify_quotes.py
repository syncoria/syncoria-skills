#!/usr/bin/env python3
"""
verify_quotes.py — Verify every quoted span in a discovery record is verbatim in the source.

Usage:
    python verify_quotes.py <record.md> <transcript.txt>

It extracts every double-quoted span from the markdown record and checks that each one
appears verbatim in the source transcript. Editorial inserts inside a quote (e.g. "[Odoo]")
are stripped before checking, since those are the writer's clarifications, not source text.

Exit code 0 if all spans verify; 1 if any are missing (so it can gate a workflow).

Typical reasons a span is flagged (and the fix):
  - Punctuation pulled inside the quote (".", ",") -> move it outside the closing quote.
  - An ellipsis bridging non-contiguous text       -> split into two quoted fragments.
  - A coined label / section heading in quotes      -> drop the quotes; only source text is cited.
  - Casing or spacing mismatch                      -> match the source exactly.
"""
import re
import sys


def load(path):
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def extract_quoted_spans(md_text):
    """Return every straight-double-quoted span in the markdown."""
    return re.findall(r'"([^"]+)"', md_text)


def normalize_editorial(span):
    """Strip bracketed editorial inserts like ' [Odoo]' that the writer added inside a quote."""
    return re.sub(r"\s*\[[^\]]+\]", "", span)


def verify(record_path, transcript_path):
    md = load(record_path)
    src = load(transcript_path)

    spans = extract_quoted_spans(md)
    missing = []
    for span in spans:
        if normalize_editorial(span) not in src:
            missing.append(span)

    total = len(spans)
    ok = total - len(missing)
    print(f"Quoted spans: {total} | verbatim OK: {ok} | MISSING: {len(missing)}")
    for m in missing:
        print(f"  MISSING -> {m!r}")
    return len(missing) == 0


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(2)
    clean = verify(sys.argv[1], sys.argv[2])
    sys.exit(0 if clean else 1)
