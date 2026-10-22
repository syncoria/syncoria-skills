# Syncoria Presentations Reference

Applies to: PowerPoint (.pptx), Google Slides, and any slide-based format.

Also read: `../SKILL.md` (brand pre-flight) and `../references/brand-system.md` (tokens).

> **v1.1 correction:** every color below labeled "Relay" now uses the correct hex `#C97B63`
> (warm terracotta), not the `#00B4C5` teal used in the previous version of this skill. Contrast
> guidance has also been added inline where small Relay text would fail AODA/WCAG AA — see
> `../references/compliance-aoda.md` for the full matrix.
>
> **v1.2 addition:** a real, designer-built master deck is now bundled at
> `../assets/templates/Syncoria_Deck_Template.pptx`. Read the "Starting From the Template" section
> below before building any new deck — start from this file, don't build slides from a blank
> presentation.

---

## Starting From the Template (do this first)

`assets/templates/Syncoria_Deck_Template.pptx` is a 14-slide, production master built by Syncoria
(20×11.25in canvas, 16:9). It uses the real Syncoria Font Family, the correct brand colors, and
already-composed layouts for the most common slide jobs. **Always duplicate slides from this file
rather than building a new deck from a blank presentation** — copying an existing on-brand slide
and swapping its text/data is far more reliable than reconstructing brand rules from scratch, and
it's what "better looking, better branded" actually means in practice.

> **Corrected on intake (2026-07-14):** the uploaded template originally used the same wrong teal
> (`#00B4C5`) documented in the v1.1 changelog — in team-photo placeholders, the timeline highlight,
> the comparison-table "Recommended" row, and the quote-slide background. All four were corrected
> to `#C97B63` before bundling (exact solid fills were re-hexed directly; the two raster graphics —
> the quote background and the flattened comparison-table image — were recolored with a
> color-distance-masked shift so only teal pixels moved and the navy/white/text pixels in the same
> images were left untouched). Confirmed the user (Fida-E Zaheer, brand owner) that terracotta
> `#C97B63` is the color of record; the template was the one that needed to change, not the guide.

### Slide Inventory (use this to pick the right starting slide)

| # | Slide | Layout | When to use |
|---|-------|--------|-------------|
| 1 | Cover | Navy full-bleed, logo top-left, title + subtitle, date/confidential label | Always slide 1 |
| 2 | Agenda | Light bg, numbered 01–05 rows with topic + rule | Deck roadmap, right after cover |
| 3 | Section Divider | Navy full-bleed, big number + section title + one-line description | Before each major section |
| 4 | Two-Column | Light bg, title + two bulleted columns split by a vertical rule | Comparing two lists side by side |
| 5 | Content + Callout | Light bg, paragraph + bullets on left, dark "KEY INSIGHT" card on right | Body content with one highlighted takeaway |
| 6 | Metrics (3-up) | Navy bg, three stat cards (big number + label) | Headline numbers / proof points |
| 7 | Quote | Terracotta gradient bg, large pull-quote, attribution | Client testimonial |
| 8 | Timeline | Light bg, 4-phase horizontal timeline, one phase highlighted in terracotta | Project phases / roadmap |
| 9 | Team | Light bg, 4 circular photo placeholders (terracotta fill) + name/role | Introducing the engagement team |
| 10 | Next Steps (3-up) | Navy bg, three numbered cards with arrows | Closing / call to action |
| 11 | Comparison Table | Light bg, flattened table graphic — navy header row, terracotta "Recommended" row | Option A vs. Option B decisions |
| 12 | Section header (title only) | Light bg, label + title, empty body | Reuse as a blank canvas for a custom content slide (e.g. feature/module overview) |
| 13 | Section header (title only) | Same as #12 | Reuse for another custom content slide (e.g. deliverables/status) |
| 14 | Back Cover | Navy full-bleed, logo + tagline + contact block | Always last slide |

### How to build a new deck from it

1. Open `assets/templates/Syncoria_Deck_Template.pptx` as the base file (python-pptx: load it
   directly rather than `Presentation()` with no argument).
2. For each slide you need, find the closest match in the inventory above, duplicate that slide
   (python-pptx doesn't support slide duplication natively — copy the slide's XML part and its
   relationships, or use a library/helper that does full slide cloning), then edit only the text
   runs, numbers, and image placeholders. Don't rebuild the shape/layout from scratch.
2b. Slides 12 and 13 are bare title-only canvases — use them as your starting point for any slide
   type not already covered by the other 12 (e.g. a bulleted feature list, a status table, a
   architecture diagram slide). Add content using the same fonts/colors/grid rules documented
   below rather than inventing a new visual style.
3. Delete any slides from the copy that the final deck doesn't need — don't ship unused template
   slides.
4. Re-run the brand and accessibility pre-flight (`../SKILL.md` Step 2 and Step 4) against the
   finished deck before delivering — a correct starting template doesn't guarantee correct edits.

The remaining sections in this file are the underlying design rules the template already follows —
use them when you need to build a slide type the template doesn't cover, or need to sanity-check
an edit.

---

## Slide Dimensions

- **Standard:** 16:9 — 33.87 cm × 19.05 cm (1920×1080px equivalent)
- **Always use widescreen format** — never 4:3 for new decks
- Bleed is not applicable for digital slides; full-bleed backgrounds are fine

---

## Slide Master Structure

Every Syncoria deck must be built from this master structure:

### Required Slide Types

| Slide Type | Description |
|-----------|-------------|
| **Cover** | Full Syncoria Blue or Carbon background, Ghost White logo (main horizontal), bold headline, subtitle in Medium weight |
| **Divider / Section Break** | Syncoria Blue background, large Subhead text in Ghost White, optional modular pattern element |
| **Content — Light** | Ghost White background, Carbon headings, Carbon body text, Relay accent for highlights (large text/graphics only — see contrast note) |
| **Content — Dark** | Syncoria Blue or Carbon background, Ghost White text, Relay for CTA elements |
| **Data / Chart** | Light background, Carbon axes and labels, Relay as primary data color, Blue as secondary |
| **Quote / Callout** | Left Relay border bar, large Subhead weight quote, Label attribution |
| **Team / People** | Light background, circular or square image crop, Carbon name in SemiBold, Label role |
| **Back Cover** | Mirrors cover — Blue or Carbon, Ghost White logo, URL, contact (see official contact block in `brand-system.md`) |

---

## Typography in Slides

Use the standard hierarchy scaled to the slide context:

| Level | Recommended Size (16:9) | Weight | Notes |
|-------|------------------------|--------|-------|
| Slide Title | 40–56px | SemiBold | Never exceed 2 lines |
| Section Label | 12px | Light | ALL CAPS, tracking +50 to +100 |
| Body | 18–24px | Regular | Max 6 lines per slide — if more, split the slide |
| Callout / Pull Quote | 28–40px | Medium | Relay or Carbon color — at this size Relay meets the 3:1 large-text threshold |
| Caption / Source | 12px | Light | ALL CAPS label style |
| CTA Text | 16–20px | SemiBold | See CTA color rule below — do not set small Relay text directly on Ghost White |

**Rule:** Never put more than 40 words of body text on a single slide. If you have more, split into two slides or convert to a visual.

**CTA color rule:** Relay on Ghost White at 16–20px (below the 24px/18pt large-text threshold) is
`3.09:1` contrast and **fails AA**. For CTA buttons on light slides, use a filled Relay button
with Carbon text (`5.27:1`, passes), or use Relay only as an outline/underline accent next to
Carbon or Blue text, not as the text color itself at this size.

---

## Layout Grid

- **Margins:** 64px (8px × 8) on all sides minimum
- **Content area:** Centered within margins
- **Columns:** Use 2 or 3 column layouts; never 4+ in a standard deck
- **Gutter:** 32px between columns
- **Alignment:** Always left-align body text; headlines may be left or centered depending on slide type (cover = centered, content = left)

---

## Color Application Per Slide Type

### Cover Slide
- Background: Syncoria Blue (`#003056`)
- Logo: Ghost White version (main horizontal), top-left, safe area respected
- Headline: Ghost White, Bold weight
- Subtitle: Ghost White, Medium weight, reduced opacity acceptable (80%)
- Optional: Modular pattern element bottom-right in Carbon or 20% opacity Ghost White

### Light Content Slides
- Background: Ghost White (`#F9FAFB`)
- Slide title: Carbon (`#1A1C22`), SemiBold
- Body: Carbon, Regular
- Accent lines / dividers: Relay (`#C97B63`) — decorative, not text, so no contrast requirement
- CTA or highlight: Relay button fill with Carbon text (see CTA color rule above)
- Logo: Not required on every slide; if used, Carbon or Blue version, bottom-right corner, small size

### Dark Content Slides
- Background: Syncoria Blue (`#003056`) or Carbon (`#1A1C22`)
- All text: Ghost White
- Accent: Relay sparingly, at large sizes (headlines/pull quotes) or as a graphic element
- Logo: Ghost White version if used

### Section Divider Slides
- Full bleed Syncoria Blue background
- Section title in Ghost White, SemiBold or Medium
- Section number as Label (12px, ALL CAPS, Relay color) — Blue background makes this `4.17:1`,
  AA-safe only because Label text at 12px is bold/tracked; if it reads too fine in practice, use
  Ghost White for the label instead and reserve Relay for the divider's graphic accent
- Modular pattern can be used as right-side background element

---

## Charts & Data Visualization

- **Primary data series:** Syncoria Relay (`#C97B63`)
- **Secondary data series:** Syncoria Blue (`#003056`)
- **Tertiary / additional:** Carbon at 60% opacity
- **Axis labels:** 12px Light, Carbon, ALL CAPS Label style
- **Chart title:** 16–18px SemiBold, Carbon
- **Gridlines:** Ghost White or very light Carbon (never intrusive)
- **Never use:** Red, green, blue-green/teal, orange, or any off-brand color in charts
- **Accessibility:** Never use color alone to distinguish data — always add labels or patterns.
  This matters more with the corrected palette, since Relay (terracotta) and Syncoria Blue can be
  harder to distinguish for some color-vision-deficient viewers than a blue/teal pairing would
  have been — add data labels or distinct patterns/markers, not color alone

---

## AODA / Accessibility for Slides

- Minimum 18pt (24px) for body text — smaller text fails accessibility at reading distance
- All slide content must be in logical reading order in the slide panel (Title → Content)
- Every image must have alt text set in PowerPoint's Format Picture → Alt Text
- Avoid text on images unless contrast is verified (use solid color overlays)
- Decorative graphic elements should be marked "Decorative" in alt text
- Use PowerPoint's Accessibility Checker before delivery
- Export to PDF with "Document structure tags for accessibility" enabled

---

## Deck Construction Rules

1. **Start with Cover, end with Back Cover** — always
2. **Section dividers** before every major content section
3. **One idea per slide** — if you're tempted to add more, make another slide
4. **Slide count guideline:** 1 slide per minute of speaking time (30-min meeting = ~25–30 slides max)
5. **Consistent footer** on content slides: slide number bottom-right, Syncoria URL bottom-left (12px Label)
6. **No transitions or animations** that are purely decorative — if animation is used, it must aid comprehension
7. **Presenter notes** should be written for every content slide — the slide is the visual, the notes are the script

---

## File Naming Convention

```
Syncoria_[DocumentType]_[Audience/Project]_[YYYY-MM]_v[X.X].pptx

Examples:
Syncoria_Proposal_AcmeCorp_2026-05_v1.0.pptx
Syncoria_CaseStudy_RetailSector_2026-Q2_v2.1.pptx
Syncoria_CompanyOverview_2026_v1.0.pptx
```

---

## Presentation Types & Their Tone

| Deck Type | Tone | Emphasis |
|-----------|------|----------|
| Sales / Proposal | Confident, outcome-focused | Client pain points, Syncoria solutions, ROI |
| Company Overview | Authoritative, trust-building | Team, track record, local presence |
| Case Study | Evidence-driven, specific | Numbers, timeline, before/after |
| Technical / Solution | Precise, structured | Architecture, integrations, process |
| Executive Summary | Concise, strategic | Decision-ready, top-line only |
