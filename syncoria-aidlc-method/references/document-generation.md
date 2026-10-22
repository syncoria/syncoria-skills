# Document Generation

How to produce Syncoria artifacts as on-brand files. The rule that fixes formatting drift: **never free-hand a document. Run the bundled generator script.** The script owns the brand; `artifact-specs.md` owns the structure (mirroring the templates of record in `template-library.md`); you supply the content.

## The workflow (always this)

1. **Decide: file or inline?** Generate a file when the user wants a deliverable to keep, sign, send, or edit (Charter, PSS, Module Scope List, CVBS, TTD, Build Plan, UAT, CR, Hypercare, process map, TCR, Decision Confirmation Note, status report, tracker, checklist). Answer inline when they're thinking through a decision, triaging, or want a quick draft to react to. When unsure, ask.
2. **Pick the format from the template** (`template-library.md`): `.docx` for documents, `.xlsx` for workbooks (11 UAT Script, 12 UAT Log, Data Migration Tracker, Go-Live Readiness Checklist), markdown for the register.
3. **For a `.docx`:** build a JSON content spec following the artifact's structure in `references/artifact-specs.md`.
4. **Run the generator** (code execution required):
   ```
   node scripts/generate_artifact.js <spec.json> <output.docx>
   ```
5. The script applies the full Syncoria brand automatically — navy cover banner with artifact number, Montserrat, navy section heads, instruction boxes, grey fill areas, blue-header tables, callouts, and the customer/Syncoria sign-off block. You never set a font or color by hand.

## Why the script, not free-handing

Free-handing a `.docx` from a prose description produces generic, inconsistent output — wrong fonts, no banners, drifting structure. The whole point of the generator is that the brand and the layout are **executed the same way every time**. If you find yourself writing docx layout code or styling inline, stop and use the script. The only thing that varies per artifact is the content spec.

## Building the spec

- Match the artifact's section list in `artifact-specs.md` exactly — same sections, same order, same tables, same columns.
- Block types available (documented at the top of `generate_artifact.js`): `section`, `subhead`, `para`, `instruction`, `fill` (grey answer area), `callout`, `bullets`, `numbers`, `table`, `space`, `pagebreak`.
- Runs inside paragraphs support `{"t":"text","b":true,"i":true,"code":true,"color":"blue|teal|amber|green|steel|red"}`.
- Set `"signoff": true` for customer-facing artifacts to append the signature block.
- `meta` carries the document-information fields in the order `artifact-specs.md` lists them; `subtitle` carries the phase line.
- Supporting artifacts use these header values: TCR → `artifactNumber` "TCR", `artifactName` "Technical Consult Request" · Decision Confirmation Note → "DCN", "Decision Confirmation Note" · Weekly Status Report → "WSR", "Weekly Status Report".
- **A drafted artifact is not a blank template.** Replace `instruction` boxes and `[fill]` placeholders with content. Keep an instruction only where the customer still has to act (the Prep Form questions they answer, the Gap Feedback Form they complete). Where an input is missing, write `[MISSING — based on assumption: …]` rather than leaving a placeholder.

## If the customer Project has its own template

If an actual `.docx` or `.xlsx` template is uploaded in the Project's Knowledge, match its structure exactly (it overrides both the Drive library and the generic structure in `artifact-specs.md`). Still render via the script so the brand is consistent. If the uploaded template differs visually from the house brand, flag that to the user rather than silently picking one. Tell the user every structural difference from `artifact-specs.md` too, and suggest logging it in the Skill Improvement project's learning log (`template-library.md` rule 3).

## The Project Control Register is not generated

Artifact 00 is a markdown file kept in project knowledge and edited through the merge procedure in `control-register-rules.md`. Never render it with the generator. The customer-facing Decision Confirmation Note drawn from it is usually an email. If the customer wants a signable page, render it via the script with the DCN structure in `artifact-specs.md` (Decisions · Assumptions we are relying on · Confirmed out of scope · Open questions) and `signoff: true`.

## Spreadsheets and other formats

Workbook artifacts — 11 UAT Acceptance Script, 12 UAT Log, the Data Migration Tracker and the Go-Live Readiness Checklist — are produced as `.xlsx` with the xlsx document skill for the build mechanics, using the exact sheets, meta rows, columns, dropdown values and summary formulas in `artifact-specs.md`. The Build Register (10) and a combined UAT + Scope-of-Work may also be produced as workbooks when the customer wants one. Formulas stay live (the UAT Log summary is computed from the log, never typed). TTD may also be produced as markdown for a developer who prefers it, but the default deliverable is the branded `.docx`.

## The self-check (every artifact ends with this)

After generating, append a short self-check in chat (not in the file), as defined in SKILL.md "When you build" (it includes the register IDs relied on and any pending conflicts). On in-flight projects this is where fallbacks and assumptions get surfaced.

## Brand tokens (reference — the script applies these; do not hand-set)

`scripts/brand.js` is the single source of brand truth for generated documents: Navy `#003056`, Teal `#005F6B`, Carbon `#1A1C22` (body), Ghost `#F9FAFB` / Light `#EEF3F8` (backgrounds), Steel `#6B7F93` (muted), Amber `#BA7517` (instructions). Font: Montserrat.

**Known difference (SCR-2026-003, open):** the Drive templates of record follow Brand Guide V1.0_2026, which has no Teal or Amber — instruction boxes there use Syncoria Relay `#C97B63` with a light tint. Until `brand.js` is aligned, documents rendered by the script will show the generator's colors, not the template's. That is cosmetic; structure is what must match. Don't hand-set colors to compensate.

## Runtime note (first use)

The generator needs the `docx` npm library. If a run fails with "Cannot find module 'docx'", install it once in the working directory:
```
npm install docx
```
Then re-run the generator. The `brand.js` and `generate_artifact.js` files themselves are self-contained; only this one library is needed.
