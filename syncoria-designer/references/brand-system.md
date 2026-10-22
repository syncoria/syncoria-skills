# Syncoria Brand System Reference

**Version:** V1.0_2026 (source guide) — skill packaging v1.1 (corrected 2026-07-13)
**Designed by:** Rami Hage-Obeid
**Status:** Active — dynamic document, request updates frequently

---

## Brand Narrative

**Who we are:** Syncoria develops digital products that help businesses connect with their customers, improve their systems, and grow. We provide technology bridges that solve business issues in partnership with clients across a wide range of sectors.

**What we deliver:** Quality · Reliability · Communication · Value

**Brand personality:** Competence, reliability, intelligence, and commitment to success. We project an image that inspires trust and confidence. Audience should feel secure in their choice to engage with Syncoria.

**Name meaning:**
- *Synchronization* = shared rhythm among customers, technologies, products, and services
- *Sensoria* = the entire sensory and intellectual brain apparatus
- Together: a brand that connects intelligently and moves forward with purpose

---

## Color System

### Approved Palette (Exhaustive — no other colors permitted)

| Name | Hex | RGB | CMYK | Role |
|------|-----|-----|------|------|
| Ghost White | `#F9FAFB` | 249 / 250 / 251 | 0.8 / 0.4 / 0 / 1.57 | Primary background, light surfaces |
| Syncoria Blue | `#003056` | 0 / 48 / 86 | 100 / 44.19 / 0 / 66.27 | Primary brand, headers, dark backgrounds |
| Syncoria Carbon | `#1A1C22` | 26 / 28 / 34 | 0 / 0 / 0 / 90 | Near-black, replaces neutral black entirely |
| Syncoria Relay | `#C97B63` | 201 / 123 / 99 | 0 / 38.81 / 50.75 / 21.18 | Accent only — CTAs, links, interactive states, emphasis |

> **Corrected in v1.1:** Syncoria Relay was previously listed in this skill as `#00B4C5` (a teal/cyan).
> That value does not appear anywhere in the source Brand Guide V1.0_2026. The guide's actual
> "Color Palette" page (p.8) defines Relay as `#C97B63`, RGB 201/123/99 — a warm terracotta/copper,
> confirmed against the rendered PDF swatch. Every reference to Relay in this skill has been updated
> to the correct value. If a newer brand guide version changes this again, update here first.

### Color Usage Rules

- **Ghost White** is the default background for light-mode documents and slides
- **Syncoria Blue** is the primary brand color — headers, cover pages, dark sections
- **Syncoria Carbon** replaces black throughout. Never use #000000 or pure black
- **Syncoria Relay** is used sparingly. One or two instances per layout maximum. Never as a background color for large areas of body text. See `references/compliance-aoda.md` for the corrected contrast matrix — Relay fails AA contrast for **body-size** text against both Ghost White and (barely) against itself as a background with white text; it is safe for large/bold text, buttons, and graphical accents
- Tints and shades of brand colors are not specified and should be avoided unless explicitly approved
- No gradients unless derived from brand colors and approved in context
- CMYK values are approximations — visually validate for print applications

---

## Typography

### Typeface

**Syncoria Font Family** — custom geometric sans-serif, proprietary asset.
- Slightly extended proportions; each character occupies space with purpose
- Clean terminals, controlled curves
- Five weights: **Light · Regular · Medium · SemiBold · Bold**
- No third-party font substitution permitted
- Web: embed via supplied WOFF2 files (convert from the bundled OTFs if WOFF2 isn't available)
- System fallback (only when embedding is impossible): **Montserrat**
- Mixing typefaces is **not permitted** across any application

### Using the Syncoria Font in Generated Files

The real font files are bundled in this skill at `assets/fonts/`:

```
assets/fonts/Light.otf      → internal family name "Syncoria Font Family Light"
assets/fonts/Regular.otf    → internal family name "Syncoria Font Family"
assets/fonts/Medium.otf     → internal family name "Syncoria Font Family Medium"
assets/fonts/SemiBold.otf   → internal family name "Syncoria Font Family SemiBold"
assets/fonts/Bold.otf       → internal family name "Syncoria Font Family Bold"
```

These are verified as legitimate OpenType fonts (checked via the font's internal `name` table), not
placeholders — use them, not Montserrat, whenever generating a Syncoria PPTX or DOCX.

**Practical steps when building a deck or document:**

1. **Install the fonts into the working environment before generating the file**, so the tool
   rendering/measuring text (LibreOffice, python-pptx, python-docx, etc.) can find them:
   ```
   mkdir -p ~/.local/share/fonts
   cp assets/fonts/*.otf ~/.local/share/fonts/
   fc-cache -f
   ```
2. **Reference the exact internal family name** in the file (e.g. in python-pptx:
   `run.font.name = "Syncoria Font Family"` for Regular, `"Syncoria Font Family SemiBold"` for
   SemiBold, etc.) — Office/LibreOffice matches fonts by internal name, not the filename.
3. **Embed the fonts in the output file itself** when possible, so the typeface displays correctly
   for the recipient even if their machine doesn't have it installed:
   - PowerPoint: File → Options → Save → "Embed fonts in the file" (or the equivalent
     `EmbedTrueTypeFonts` setting if generating programmatically)
   - Word: File → Options → Save → "Embed fonts in the file"
   - If the generation pipeline can't embed fonts programmatically, note this limitation to the
     user and recommend they enable embedding manually before sending the file externally, or
     ship the OTF files alongside the deliverable.
4. **If font embedding isn't available in the current tool chain**, fall back to Montserrat and
   flag this explicitly in your response — don't silently substitute a different typeface.

---

### Type Hierarchy

| Level | Weight | Scale Rule | Print Size | Digital Size | Tracking | Leading |
|-------|--------|-----------|-----------|--------------|----------|---------|
| Bold | Bold | Headline × 2 | 72pt+ | 96px+ | −10 to 0 | 0.9× type size |
| Headline | SemiBold | Anchor | 32–64pt | 40–72px | 0 to +20 | 1.1× type size |
| Subhead | Medium | Headline ÷ 1.75 | 18–28pt | 24–40px | +10 to +30 | 1.3× type size |
| Body | Regular | Headline ÷ 3.5 | 12–16pt | 16–24px | 0 to +10 | 1.5× type size |
| Label | Light | Always 12px fixed | 8–11pt | 12px fixed | +50 to +100 | — |

**Label rule:** Always uppercase. Always 12px digital / 8–11pt print. No exceptions.

### Sizing Discipline

- **All sizes must snap to the nearest multiple of 8** (8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 96...)
- Choose a headline anchor size, then derive all other levels from the ratios
- Example with 56px headline anchor:
  - Bold: 112px
  - Headline: 56px
  - Subhead: 32px
  - Body: 16px
  - Label: 12px

---

## Logo System

### Three Versions

| Version | Use Case | Files Available |
|---------|----------|----------------|
| **Main** (horizontal logotype) | Standard use — headers, letterheads, slides | Blue / Carbon / Ghost White |
| **Stack** (vertical lockup) | When horizontal space is limited | Blue / Carbon / Ghost White |
| **Logomark** (mark only) | Compact spaces; only when brand recognition is established | Blue / Carbon / Ghost White |

All six SVG combinations are bundled in `assets/logos/`.

### Color Application by Background

| Background | Use This Logo |
|-----------|--------------|
| Ghost White or light backgrounds | Carbon or Blue version |
| Syncoria Blue background | Ghost White version |
| Syncoria Carbon background | Ghost White version |
| Photography / imagery | Use version with highest contrast; avoid busy backgrounds |

### Safe Area — Logotype (Main)

Clear space on all 4 sides = **1× the logomark's height**
No text, images, graphics, or decorative elements may enter this zone.

### Safe Area — Logomark (Standalone)

Clear space on all 4 sides = **1× the vertical height of the medium-sized modules**
No other elements may enter this space.

### Logo Forbidden Uses

| ❌ Never Do This |
|----------------|
| Apply drop shadows |
| Scale disproportionally (always maintain aspect ratio) |
| Tilt or rotate |
| Change colors (even to brand colors other than approved versions) |
| Outline the logo |
| Place on busy or photographic backgrounds |
| Rearrange elements |
| Apply effects, glows, or transparency |
| Recreate or redraw from memory — always use supplied SVG files in `assets/logos/` |

---

## Graphic System (Modular Pattern)

The Syncoria logomark extends into a modular graphic system:

- Extract individual module shapes from the logomark
- These can be rotated (90°), repeated, and distributed to form patterns
- Patterns retain the logic of the mark: integration, connectivity, digital structure
- Used for: backgrounds, texture elements, dividers, presentation layouts
- Must always use approved brand colors only
- Never so dense that it competes with content

**Construction logic:**
1. Take a module element
2. Connect it
3. Tilt 90 degrees
4. Connect again
5. Repeat to build pattern

---

## Spacing System

- **Base unit: 8px**
- All margins, padding, gutters, and spacing values must be multiples of 8
- Recommended spacing scale: 8 / 16 / 24 / 32 / 40 / 48 / 64 / 80 / 96

---

## Photography & Imagery Direction

Based on brand applications observed in the guide (not an explicit written rule — inferred from
the apparel/merchandise mockups):

- **Tone:** Dark, premium, architectural — deep navy, charcoal, and near-black environments
- **Subjects:** Professional environments, technology context, materials with texture (matte surfaces, fine details)
- **Lighting:** Dramatic, directional — highlights on surfaces, dark negative space
- **Avoid:** Stock photo feel, overly bright/cheerful imagery, casual settings, busy street photography as backgrounds
- **With logo:** Never place logo over complex photography — use solid color panels or sufficient contrast zones

---

## Applications Reference

Confirmed directly from the official brand guide's applications pages:

- **Business cards:** Ghost White/white face with Carbon name/title text and Blue logomark, full
  contact block (see below); Syncoria Blue back with Ghost White logo (main horizontal) and
  `syncoria.com`
- **Apparel:** Ghost White logo (stack lockup) on Syncoria Blue garment — simple, centered placement
- **Branded merchandise:** Full logomark centered, brand name below in SemiBold

### Official Contact / Letterhead Block

Taken directly from the business-card application in the source guide:

```
Syncoria Inc.
33 Bloor Street East, 5th Floor, Suite E
Toronto, ON  M4W 3H1

syncoria.com
```

Use this for cover pages, letterheads, and back-cover/contact slides. Individual name/title/phone/
email should be supplied per person (the guide's example: Fida-E Zaheer, President,
+1 (416) 687-6372, fida@syncoria.com) — don't invent a different name or title for other staff.

---

## What This Brand Is Not

To prevent drift, Syncoria's visual identity should never feel:
- Playful or casual (wrong personality register)
- Generic tech-blue (Carbon differentiates from commodity SaaS aesthetics)
- Cluttered or ornate (restraint is a core principle)
- Cool-toned only (Relay's terracotta is intentionally warm — don't reach for teal/cyan as an accent)
- Humanistic/handcrafted (this is a precision engineering brand)
