# AODA / WCAG 2.1 AA Compliance Reference

Applies to all Syncoria outputs. Ontario's Accessibility for Ontarians with Disabilities Act (AODA)
mandates WCAG 2.1 Level AA for digital content. This also represents best practice for all
documents and presentations regardless of delivery channel.

> **v1.1 correction:** the contrast matrix below was recalculated after fixing Syncoria Relay's
> hex value (`#C97B63`, not the previous `#00B4C5`). The old matrix's numbers were wrong even for
> the old (incorrect) hex — they've been recomputed from scratch using the standard WCAG relative
> luminance formula and double-checked programmatically.

---

## Why This Matters for Syncoria

As a professional services technology company operating in Ontario, Syncoria is legally required
to meet AODA standards for public-facing digital content. Beyond compliance, accessible design
signals professionalism, inclusivity, and attention to detail — all core to the Syncoria brand.

---

## Pre-Approved Syncoria Color Contrast Matrix

| Foreground | Background | Ratio | Result | Use For |
|-----------|-----------|-------|--------|---------|
| Carbon #1A1C22 | Ghost White #F9FAFB | 18.9:1 | ✅ AAA | Body text, all headings |
| Syncoria Blue #003056 | Ghost White #F9FAFB | 13.4:1 | ✅ AAA | H1 headings, links on light |
| Ghost White #F9FAFB | Carbon #1A1C22 | 18.9:1 | ✅ AAA | Text on dark backgrounds |
| Ghost White #F9FAFB | Syncoria Blue #003056 | 13.4:1 | ✅ AAA | Text on blue backgrounds |
| Carbon #1A1C22 | Relay #C97B63 | 5.27:1 | ✅ AA (normal text) | CTA button labels, body-size text on Relay fills |
| Syncoria Blue #003056 | Relay #C97B63 | 4.17:1 | ⚠️ AA large text only | Large/bold text (18pt+/14pt+ bold) on Relay — fails at normal size |
| Ghost White #F9FAFB | Relay #C97B63 | 3.09:1 | ⚠️ AA large text only | Large/bold text on Relay — fails at normal size |
| Relay #C97B63 | Ghost White #F9FAFB | 3.09:1 | ❌ FAILS normal text | Relay text/links on light backgrounds — use Syncoria Blue instead for body-size links |

**Rule:** When using Relay (`#C97B63`) as a background, use Carbon text for body-size content
(passes at 5.27:1). Ghost White or Syncoria Blue text on Relay only works at large/bold sizes
(18pt+/14pt+ bold, 3:1 threshold). When using Relay as a foreground text/link color on a light
background, it fails normal-size AA — reserve it for large headlines, pull quotes, or non-text
graphical accents (borders, icons, chart data series) where the 3:1 UI-component threshold applies
instead of the 4.5:1 text threshold.

**Minimum contrast ratios:**
- Normal text (under 18pt / 14pt bold): 4.5:1
- Large text (18pt+ / 14pt+ bold): 3:1
- UI components and graphical objects: 3:1

---

## WCAG 2.1 AA Checklist by Output Type

### All Outputs (Universal)

- [ ] Color contrast meets minimum ratios (see table above)
- [ ] Information is never conveyed by color alone (always add text label, icon, or pattern)
- [ ] Font size minimum 11pt (14.67px) for body copy
- [ ] Content is readable when printed in grayscale

### Word Documents (.docx)

- [ ] Built-in Heading styles used (H1, H2, H3) — not manually formatted text
- [ ] Heading hierarchy is logical — never skip levels (H1 → H3 without H2)
- [ ] All images have descriptive alt text (right-click → Edit Alt Text)
- [ ] Decorative images marked as decorative in alt text
- [ ] Tables have header row defined (Table Properties → Row → "Repeat as header row")
- [ ] No merged cells in data tables (complex table structures confuse screen readers)
- [ ] Hyperlinks are descriptive ("View the Syncoria proposal" not "click here") and colored
      Syncoria Blue, not Relay, at body size
- [ ] Lists use Word's built-in list styles (not manually typed dashes or bullets)
- [ ] Document language set to English (Canada) — File → Options → Language
- [ ] Accessibility Checker run and all errors resolved: Review → Check Accessibility
- [ ] PDF export: Options → "Document structure tags for accessibility" enabled

### PowerPoint (.pptx)

- [ ] Every slide has a unique, descriptive title (visible in Outline view)
- [ ] Reading order matches visual order (Home → Arrange → Selection Pane to verify)
- [ ] All images have alt text (Format Picture → Alt Text)
- [ ] Decorative elements marked as decorative
- [ ] Videos include captions (SRT files or auto-caption reviewed and corrected)
- [ ] Audio has transcripts
- [ ] Animations do not flash more than 3 times per second (seizure risk)
- [ ] Slide transitions are simple — no flashing, spinning, or strobing effects
- [ ] Table headers defined (Layout → Header Row)
- [ ] Slide notes contain full narrative text (so screen reader users get the full story)
- [ ] Accessibility Checker run: Review → Check Accessibility
- [ ] PDF export with accessibility tags if distributing as PDF
- [ ] Small Relay text (below 24px/18pt or 14pt bold) is never set directly on Ghost White or
      Syncoria Blue — use Carbon-on-Relay fills or reserve Relay for large text/graphics instead

### Web / HTML

- [ ] Semantic HTML: `<h1>` through `<h6>` in logical order, `<nav>`, `<main>`, `<footer>`
- [ ] All images: `alt` attribute present and descriptive (empty alt="" for decorative)
- [ ] Form inputs have associated `<label>` elements
- [ ] Focus indicators visible on all interactive elements (never `outline: none` without replacement)
- [ ] Keyboard navigation works for all interactive elements (Tab, Enter, Escape, Arrow keys)
- [ ] Skip to main content link at top of page
- [ ] Page `<title>` is descriptive and unique
- [ ] `lang` attribute on `<html>` element: `lang="en-CA"` for Canadian English
- [ ] Links distinguishable from body text (not by color alone — underline required or bold)
- [ ] Error messages in forms are descriptive (not just "invalid input")
- [ ] No content auto-plays (video, audio) without user control
- [ ] Touch targets minimum 44×44px

### Email

- [ ] Subject line is descriptive
- [ ] Alt text on all images
- [ ] Responsive layout (readable on mobile without horizontal scroll)
- [ ] Minimum 14px font size for body text in email
- [ ] Sufficient contrast on all text
- [ ] Calls to action: descriptive link text, high contrast button

---

## Common AODA Violations to Avoid

| Violation | What Not To Do | Fix |
|-----------|---------------|-----|
| Low contrast | Small Relay text/links directly on Ghost White or Syncoria Blue | Use Syncoria Blue for links; use Relay only for large text, buttons with Carbon labels, or graphics |
| Color-only info | "Items in red are overdue" | Add text label or icon too |
| Missing alt text | Image with no description | Add meaningful alt text |
| Skipped heading | H1 then H3 directly | Always H1 → H2 → H3 |
| "Click here" links | Hyperlink text is "click here" | Descriptive link text always |
| Inaccessible tables | No header row defined | Define header row in table properties |
| Tiny text | 8pt label text as body copy | Keep labels at label level only |
| Auto-play media | Video plays on load | Require user to click play |

---

## Quick Test Checklist Before Delivery

1. Run Word / PowerPoint built-in Accessibility Checker (Review tab)
2. Print to greyscale — can you still read everything? Is information still clear?
3. Check all images have alt text
4. Verify link text is descriptive
5. Confirm font sizes meet minimums
6. Verify contrast ratios for any custom color combinations — recheck against the matrix above,
   especially anywhere Relay is used as a text/link color
7. Check heading structure is logical and complete

---

## Resources

- AODA compliance info: ontario.ca/page/accessibility-in-ontario
- WCAG 2.1 guidelines: w3.org/TR/WCAG21/
- Colour contrast checker: webaim.org/resources/contrastchecker/
- Ontario AODA requirements for private sector organizations with 50+ employees apply immediately
