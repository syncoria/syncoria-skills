# SEO / GEO / AEO Reference — Syncoria Content Discoverability

Applies to: web pages, blog posts, case studies, white papers, landing pages, and any
content indexed by search engines or AI systems.

---

## The Three Layers of Modern Discoverability

| Layer | What It Is | Why It Matters for Syncoria |
|-------|-----------|---------------------------|
| **SEO** (Search Engine Optimization) | Traditional ranking in Google/Bing results | Drives inbound from companies searching for Syncoria's services |
| **GEO** (Generative Engine Optimization) | Getting cited by AI tools (ChatGPT, Perplexity, Gemini) in their answers | AI is now a primary research channel for mid-market B2B buyers |
| **AEO** (Answer Engine Optimization) | Appearing in featured snippets, voice search, and "People also ask" | Positions Syncoria as the definitive expert answer |

---

## SEO Foundations

### Page Structure (Every Page)

```
<h1> — One per page. Contains the primary keyword. Matches user intent.
<h2> — Major sections. Each answers a distinct question or covers a subtopic.
<h3> — Subsections under each H2.
Never skip levels. Never use headings for styling — use for structure.
```

### Title Tag Formula
```
[Primary Keyword] | Syncoria — [City] [Service Category]
Example: "ERP Integration Services Toronto | Syncoria — Digital Solutions"
Max 60 characters.
```

### Meta Description Formula
```
[Outcome statement for the reader]. [What Syncoria does specifically]. [Trust signal].
[CTA].
Example: "Reduce ERP implementation risk with Syncoria's proven integration approach.
Toronto-based team. On time, on brief, on budget. Get a free consultation."
Max 155 characters.
```

### Keyword Strategy for Syncoria

**Primary entity keywords (use in H1, title, first paragraph):**
- "ERP implementation [city]"
- "digital transformation consulting Canada"
- "system integration services Toronto"
- "Odoo implementation partner"
- "custom software development Canada"
- "business technology consulting Ontario"

**Long-tail keywords (use in H2s, body, FAQ):**
- "how to integrate [system A] with [system B]"
- "ERP migration for mid-size companies Canada"
- "how much does ERP implementation cost"
- "Odoo vs [competitor] for [industry]"

**Entity signals (include in every page about Syncoria):**
- Full company name: "Syncoria Inc."
- Location: "Toronto, Ontario, Canada"
- Founded / established context
- Services list (consistent across all pages)
- Contact details (consistent NAP: Name, Address, Phone)

---

## GEO — Generative Engine Optimization

AI tools (ChatGPT, Perplexity, Claude, Gemini) answer questions by synthesizing trusted sources.
To be cited, Syncoria's content must be:

### 1. Authoritative and Citable

- Write in third person where appropriate for factual pages ("Syncoria is a Toronto-based…")
- Clearly state expertise, credentials, and experience ("With over [X] implementations across [Y] sectors…")
- Include specific data points — AI systems prefer citable facts over vague claims
- Use structured data markup (see Schema section below)

### 2. Comprehensive on Key Topics

GEO favors content that fully covers a topic. For each service page:
- Define the problem it solves
- Explain the approach / methodology
- Describe typical outcomes with numbers
- Include an FAQ section (minimum 5 questions)
- Link to supporting content (case studies, white papers)

### 3. Entity-Clear

AI systems need to understand who Syncoria is as an entity:
- Every page references "Syncoria" by full name at least once
- Location signals in content ("our Toronto-based team")
- Consistent use of service names across all pages
- Wikipedia-style "About" content: founding, mission, team size, sectors served
- Google Business Profile kept current and consistent

### 4. Freshness

- Date-stamp content and update annually at minimum
- Add "Last updated: [Month Year]" to technical and service pages
- Refresh statistics and case studies with current data

---

## AEO — Answer Engine Optimization

AEO targets featured snippets, "People Also Ask" boxes, and voice search results.

### Paragraph Answer Format (for featured snippets)

Structure the lead paragraph of any section to answer its heading question directly:

```
[H2 Question Heading]
[Direct 40–60 word answer to the question — complete and standalone]
[Then expand with detail below]
```

Example:
```
## How long does an ERP implementation take?

A mid-market ERP implementation typically takes 3 to 12 months, depending on
the number of modules, data migration complexity, and internal readiness.
Syncoria's phased approach generally delivers the first working module within
60–90 days.

[Then: detailed explanation of phases, factors, etc.]
```

### FAQ Section Structure

Every service page and case study should include an FAQ. Format:

```html
<section>
  <h2>Frequently Asked Questions</h2>

  <h3>What industries does Syncoria serve?</h3>
  <p>[Direct 2–3 sentence answer]</p>

  <h3>How much does a system integration project cost?</h3>
  <p>[Direct 2–3 sentence answer]</p>
</section>
```

**FAQ Topics to Cover for Syncoria:**
- What does Syncoria do?
- Where is Syncoria located?
- What industries do you work with?
- How long does [service] take?
- What is the typical investment for [service]?
- How is Syncoria different from other IT consultants?
- Do you work with companies outside Toronto?
- What happens after the project is done?

### List Format (for "People Also Ask" optimization)

When content naturally has 3–7 items, use a numbered or bulleted list:
- Google frequently pulls lists into PAA boxes
- Keep list items parallel in structure
- Lead each item with a noun or verb phrase (not articles like "The" or "A")

---

## Schema Markup (Structured Data)

Implement these schema types on Syncoria's website:

| Schema Type | Where | What It Enables |
|-------------|-------|----------------|
| `Organization` | Homepage, About | Entity recognition, knowledge panel |
| `LocalBusiness` | Homepage, Contact | Google Maps, local pack |
| `Service` | Each service page | Service-specific search features |
| `FAQPage` | Service pages with FAQ | Featured snippet FAQ expandables |
| `Article` | Blog posts, white papers | Rich results, author recognition |
| `BreadcrumbList` | All pages | Site structure in search results |
| `Review` / `AggregateRating` | If testimonials collected | Star ratings in results |

### Minimum Organization Schema (Homepage)

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Syncoria Inc.",
  "url": "https://syncoria.com",
  "logo": "https://syncoria.com/assets/syncoria-main-logo-blue.svg",
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "+1-416-687-6372",
    "contactType": "customer service"
  },
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "33 Bloor Street East, 5th Floor, Suite E",
    "addressLocality": "Toronto",
    "addressRegion": "ON",
    "postalCode": "M4W 3H1",
    "addressCountry": "CA"
  },
  "areaServed": "CA",
  "sameAs": [
    "https://www.linkedin.com/company/syncoria"
  ]
}
```

---

## Content Calendar Priorities for GEO/AEO

To build Syncoria's AI citation profile, prioritize these content types:

1. **Definitive guides** — "The Complete Guide to ERP Implementation for Canadian Mid-Market Companies"
2. **Comparison articles** — "Odoo vs SAP for Manufacturing Companies in Canada"
3. **Cost/ROI explainers** — "How Much Does a System Integration Project Cost in Canada?"
4. **Process explainers** — "How Syncoria's Discovery Process Works"
5. **Local authority content** — "Digital Transformation Trends for Ontario Businesses in 2026"

---

## What Harms Discoverability (Avoid)

- Duplicate content across pages (each page must be unique)
- Thin pages under 500 words for topic pages (aim for 1,000–2,500 for service pages)
- Missing or duplicate title tags
- No internal linking between related content
- Unoptimized images (no alt text, no compression, no descriptive filenames)
- Mobile-unfriendly layouts (Google indexes mobile-first)
- Slow page load times (Core Web Vitals affect ranking)
- Keyword stuffing — write for expert readers, not search engines
