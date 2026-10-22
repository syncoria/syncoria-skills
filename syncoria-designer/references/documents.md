# Syncoria Documents Reference

Applies to: Word documents (.docx) — reports, proposals, white papers, letters, briefs, SOWs.

Also read: `../SKILL.md` (brand pre-flight) and `../references/brand-system.md` (tokens).

> **v1.1 correction:** Relay is `#C97B63` (warm terracotta), not `#00B4C5` (teal) as in the
> previous version. This also changes the hyperlink color recommendation below — small Relay text
> on a white/Ghost White page fails AA contrast (3.09:1), so hyperlinks now default to Syncoria
> Blue. See `../references/compliance-aoda.md` for the full contrast matrix.

---

## Page Setup

| Setting | Value |
|---------|-------|
| Page size | Letter (8.5" × 11") for Canadian business standard |
| Margins | 1" (25.4mm) all sides — never less than 0.75" |
| Header height | 0.75" |
| Footer height | 0.5" |
| Gutter | 0 (single-column documents) |
| Columns | Single column body; two-column for comparison sections only |

---

## Typography Styles (Word Paragraph Styles)

Map these Word styles to Syncoria's type system:

| Word Style | Syncoria Weight | Size | Tracking | Leading | Color |
|-----------|----------------|------|----------|---------|-------|
| Title (cover) | Bold | 48pt | −10 | 0.9× | Ghost White or Carbon |
| Heading 1 | SemiBold | 24pt | 0 | 1.1× | Syncoria Blue |
| Heading 2 | SemiBold | 18pt | +10 | 1.2× | Syncoria Carbon |
| Heading 3 | Medium | 14pt | +10 | 1.3× | Syncoria Carbon |
| Body Text | Regular | 11pt | 0 | 1.5× | Syncoria Carbon |
| Caption / Label | Light | 8pt | +50 | — | Syncoria Carbon, ALL CAPS |
| Callout / Pull Quote | Medium | 14pt | +10 | 1.4× | Syncoria Blue (body-size callouts) or Relay only at 18pt+/bold |
| Footer text | Light | 8pt | +50 | — | Carbon at 60% |
| Hyperlink | Regular | 11pt | 0 | 1.5× | **Syncoria Blue**, underlined (corrected — Relay fails AA at body size, see note below) |

**Key rules:**
- All heading styles use Space Before: 16pt minimum, Space After: 8pt
- Body text: Space After 8pt, no first-line indent (use spacing instead)
- Never bold a heading that is already a Heading style — let the weight do the work
- Never use italic for emphasis — use SemiBold weight instead

**Hyperlink color note:** The source brand guide names Relay as the color for "links," but Relay
(`#C97B63`) on Ghost White/white is only `3.09:1` contrast — it fails the 4.5:1 AA requirement for
normal-size text. Use Syncoria Blue (`13.4:1`, AAA) for standard 11pt body hyperlinks instead.
Reserve Relay for large/bold text (18pt+/14pt+ bold), buttons, or non-text accents where the 3:1
threshold applies. Flag this brand-guide/accessibility tension to the brand owner if exact-Relay
links are a hard requirement.

---

## Document Structure

### Required Sections (in order)

1. **Cover Page**
2. **Table of Contents** (for documents >5 pages)
3. **Executive Summary** (1 page max for most documents)
4. **Body / Main Content** (H1 → H2 → H3 hierarchy)
5. **Appendices** (if applicable)
6. **Contact / Next Steps** (final page)

### Cover Page Design

- Background: Syncoria Blue (`#003056`) full page
- Logo: Ghost White main horizontal, top-left, safe area respected
- Document title: Bold weight, Ghost White, 48pt
- Subtitle / Client name: Medium weight, Ghost White, 24pt
- Date and version: Label style, Ghost White, bottom-left
- Relay (`#C97B63`) horizontal rule: 2pt, spanning full width above title block (decorative — no
  contrast requirement)
- Optional: Modular pattern element, Carbon or low-opacity Ghost White, right side
- Contact block, bottom-right, Label style, Ghost White — use the official block from
  `brand-system.md`:
  ```
  Syncoria Inc.
  33 Bloor Street East, 5th Floor, Suite E
  Toronto, ON  M4W 3H1
  syncoria.com
  ```

### Header (all body pages)

- Left: Syncoria logo (Carbon version, small — ~1.5cm height, safe area respected)
- Right: Document title in Label style (8pt, ALL CAPS, Carbon)
- Bottom border: 0.5pt rule, Syncoria Blue

### Footer (all body pages)

- Left: "© [Year] Syncoria Inc. | syncoria.com" — Label style
- Right: "Page [X] of [Y]" — Label style
- Top border: 0.5pt rule, Carbon at 30%

---

## Color Usage in Documents

- **Headings:** H1 in Syncoria Blue, H2–H3 in Carbon
- **Body text:** Always Carbon (`#1A1C22`) — never pure black
- **Hyperlinks:** Syncoria Blue (`#003056`) with underline — see hyperlink color note above
- **Callout boxes:** Light Ghost White background with 2pt left border in Relay (border is
  decorative, not text — fine at any size)
- **Tables:** Header row in Syncoria Blue (Ghost White text); alternating rows in Ghost White and Carbon at 5% opacity
- **Horizontal rules / dividers:** Syncoria Blue at 1pt, or Relay at 0.5pt for accent
- **Page background:** White (standard) — Ghost White is for digital; print white is appropriate for Letter pages

---

## Tables

| Element | Style |
|---------|-------|
| Header row | Syncoria Blue fill, Ghost White text, SemiBold, 11pt |
| Alternating rows | Row 1: White; Row 2: Carbon 5% opacity |
| Cell padding | 6pt top/bottom, 8pt left/right |
| Border | 0.5pt Carbon, outer border only (no internal vertical lines for clean look) |
| Caption above | Label style, ALL CAPS, "TABLE [N]: [TITLE]" |

---

## Callout / Highlight Boxes

For key insights, warnings, or important notes:

```
┌─ [2pt Relay left border] ─────────────────────────────┐
│  [Label: "KEY INSIGHT" in Relay, 8pt ALL CAPS — bold]  │
│  [Body text in Carbon, 11pt Regular]                  │
│  Background: Ghost White (#F9FAFB)                    │
└───────────────────────────────────────────────────────┘
```

Note: the "KEY INSIGHT" label in Relay at 8pt is small — since Relay on Ghost White fails AA at
body/label sizes, bold the label and keep it short (a label, not a sentence), or set it in Carbon
instead and use Relay only for the left border bar.

---

## Image & Figure Rules

- All images: Caption below in Label style ("FIGURE [N]: [DESCRIPTION]")
- Image borders: None (let white space frame them)
- Minimum image width: Full column width or 50% column width — avoid small floated images
- Alt text: Required for every image (right-click → Edit Alt Text in Word)
- Photography: Follows brand photography direction (dark, premium, architectural where possible)
- Diagrams: Use brand colors only; label with Label style text

---

## AODA / Accessibility for Documents

- Use built-in Word Heading styles (not manually bolded/sized text) — required for screen reader navigation
- Never skip heading levels (H1 → H3 without H2 is a violation)
- All images must have descriptive alt text
- Tables must have header row marked as such (Table Properties → Row → "Repeat as header row at the top of each page")
- Color contrast must meet 4.5:1 for all body text — see the corrected matrix in `compliance-aoda.md`
- Hyperlinks must be descriptive ("Read our case study" not "click here") and use Syncoria Blue, not Relay, at body size
- Use Word's Accessibility Checker (Review → Check Accessibility) before delivery
- When exporting to PDF: File → Export → Create PDF/XPS → Options → "Document structure tags for accessibility"

---

## Document Types & Specific Rules

### Proposal

- Executive Summary must lead with the client's problem statement, not Syncoria's credentials
- Use a "Our Understanding" section to mirror back the client's stated needs
- Investment/pricing section: always call it "Investment" not "Cost" or "Price"
- Include a clear Next Steps section with named owner, action, and date for each item
- Max 15 pages excluding appendices for mid-market clients (they won't read more)

### Report / White Paper

- Abstract/executive summary: 150–200 words maximum
- Findings must be numbered and summarized at the top before detail
- Data sources must be cited in footnotes (Label style, 8pt)
- Recommendations section: Use numbered list with Heading 3 for each recommendation

### Statement of Work (SOW)

- Use formal, legally precise language — no brand voice flourishes
- Include: Scope, Deliverables, Timeline, Assumptions, Exclusions, Fees, Payment Terms, Signatures
- All numbered clauses use Body Text style
- Tables for deliverables and milestones preferred over prose lists

### Letter / Correspondence

- Use full business letter format
- Syncoria letterhead on page 1 only (logo top-left, contact info top-right)
- Greeting: "Dear [Name]," — never "Hi" or "Hello" in formal correspondence
- Signature block: Name / Title / Syncoria Inc. / Phone / Email / syncoria.com
- Use the official address whenever a physical letterhead address is needed:
  ```
  Syncoria Inc.
  33 Bloor Street East, 5th Floor, Suite E
  Toronto, ON  M4W 3H1
  ```
- Don't invent a name/title for the signatory — ask the user, or if the letter is from Fida-E
  Zaheer (President), use +1 (416) 687-6372 / fida@syncoria.com per the official business card

---

## File Naming Convention

```
Syncoria_[DocumentType]_[Client/Project]_[YYYY-MM]_v[X.X].docx

Examples:
Syncoria_Proposal_AcmeCorp_2026-05_v1.0.docx
Syncoria_SOW_RetailProject_2026-06_v2.1.docx
Syncoria_WhitePaper_ERPMigration_2026-Q2_v1.0.docx
```
