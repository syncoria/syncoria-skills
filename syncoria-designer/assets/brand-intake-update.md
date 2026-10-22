# Syncoria Brand Intake — Update Template

Use this form when the brand system is updated. Fill in changed values and
update the corresponding sections in `references/brand-system.md`.

---

## Color Updates

| Token Name | Old Hex | New Hex | Old CMYK | New CMYK | Date Changed |
|-----------|---------|---------|----------|----------|-------------|
| Syncoria Relay | #00B4C5 (incorrect — never appeared in source guide) | #C97B63 | 100/8.63/0/22.75 | 0/38.81/50.75/21.18 | 2026-07-13 |

## Typography Updates

| Element | Old Value | New Value | Date Changed |
|---------|-----------|-----------|-------------|
| Primary typeface | | | |
| Fallback typeface | | | |
| Base body size | | | |
| Heading scale anchor | | | |

## Logo Updates

| Change | Description | New File Name | Date |
|--------|-------------|--------------|------|
| | | | |

## Spacing / Grid Updates

| Element | Old Value | New Value | Date |
|---------|-----------|-----------|------|
| Base unit | 8px | | |
| Standard margin | 64px | | |

## New Brand Elements Added

Describe any new graphic elements, patterns, illustration styles, or
photography direction added to the system:

```
2026-07-13: Added official contact/letterhead block (address, syncoria.com) to
brand-system.md and documents.md, sourced from the business-card application page
in Brand Guide V1.0_2026. Also added practical font-embedding guidance for
generating branded PPTX/DOCX files using the bundled assets/fonts/*.otf files.
```

## Version Log

| Version | Date | Summary of Changes | Updated By |
|---------|------|--------------------|-----------|
| V1.0 | 2026 | Initial brand system | Rami Hage-Obeid |
| Skill v1.1 | 2026-07-13 | Corrected Syncoria Relay hex from the erroneous #00B4C5 (teal) to the source guide's actual #C97B63 (terracotta), verified by rendering the original Brand Guide V1.0_2026 PDF pages directly. Recalculated the entire WCAG contrast matrix (the v1.0 numbers were arithmetically wrong even for the old, incorrect hex). Changed body-size hyperlink color from Relay to Syncoria Blue to meet AA contrast. Added official Syncoria address/contact block and font-embedding instructions. | Claude (Cowork), verified against source PDF |
| Skill v1.2 | 2026-07-14 | Added the user-provided master deck (`Syncoria Deck Template.pptx`, 14 slides, last modified by Fida-E Zaheer 2026-07-10) to `assets/templates/`. On inspection the template itself used the same incorrect teal #00B4C5 in four places: team-photo placeholders (solid fill, slide 9), the timeline highlight box (solid fill, slide 8), the comparison-table "Recommended" row and the quote-slide background (both baked into flattened raster images, slides 7 and 11). Confirmed with Fida-E Zaheer that #C97B63 terracotta is the color of record, not #00B4C5 — the template needed correction, not the brand guide. Fixed the two solid-fill slides by direct hex substitution and the two raster images with a color-distance-masked recolor (only pixels close to the exact teal were shifted; navy/white/text pixels in the same images were left untouched — verified by re-rendering and sampling pixel values before/after). Documented the full 14-slide inventory and template-first workflow in `references/presentations.md`. | Claude (Cowork), corrected and re-verified by rendering |
| | | | |

---

**After updating:** Notify all design, marketing, and development team members.
Update this log and increment the version number in SKILL.md frontmatter.
