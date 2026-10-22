# Artifact Template Library — the templates of record

Every AI-DLC artifact has a master template in Syncoria's Google Drive. **The template is the structure of record**: `artifact-specs.md` mirrors it section for section, and anything this skill produces must match it. This file says where each template lives, what format it is, when it's used, and how to use it.

**Library:** Syncoria Implementation Kit (AI-DLC) → `02 Artifact Templates`
https://drive.google.com/drive/folders/1wsSr9ig2ZCvtxhCPnPOkqjqOVxxx2TlR
Kit root (guide, Odoo project template, decks, playbook): https://drive.google.com/drive/folders/1LtEAAqO3qbedvzIDsg4dFvLsMzQ-wAXW

---

## The rules

1. **Copy, never edit the master.** For an engagement, the OPL copies the template into the customer's folder (`[Customer] / Internal` or `[Customer] / Shared with [Customer]`). When you produce an artifact, you produce the customer copy; you never point anyone at the master to fill in.
2. **Structure from `artifact-specs.md`, which mirrors the template.** Build the content spec from the artifact's section in `artifact-specs.md`. If you notice the template and the spec disagree, the template wins for this artifact; tell the user it's a skill defect and suggest logging it in the Skill Improvement project's learning log so it goes through an SCR.
3. **A customer-specific template overrides both.** If the engagement's project knowledge holds the customer's own version of a template, match it (see `document-generation.md`). Tell the user every structural difference from `artifact-specs.md` and suggest logging it in the Skill Improvement project's learning log. Whether it's customer tailoring or drift in the master is for the SCR to decide, not a condition for logging.
4. **Format follows the template.** `.docx` templates are rendered through the generator. `.xlsx` templates are produced as workbooks with the xlsx skill, using the exact sheets and columns in `artifact-specs.md`. The register (00) is markdown, never generated.
5. **Fill-in guidance stays out of finished artifacts.** Templates carry "How to fill this in" boxes and `[fill]` placeholders. A drafted artifact replaces them with content. Where an input is genuinely missing, write `[MISSING — based on assumption: …]` instead of leaving the placeholder (Path B).
6. **Template changes are skill changes.** A template edited in Drive without a matching `artifact-specs.md` change drifts the method. Changes go through an SCR that updates both in the same release.

---

## Core artifacts (00–14)

| # | Artifact | Template file | Format | Phase | Odoo template task(s) | Owner | Signed by |
|---|---|---|---|---|---|---|---|
| 00 | Project Control Register | [00 Project Control Register (template).md](https://drive.google.com/file/d/1mCFhPIegDOIpKq8G40FC5i32FEElORTi/view) | Markdown, kept in the customer's Claude Project knowledge | All | c01 | OPL | — (Decision Confirmation Note at each gate) |
| 01 | Project Charter | [01 Project Charter.docx](https://drive.google.com/file/d/1duLvi7CrRqhRn2d1mWNNH_9qAo3U2ADt/view) | .docx | 1 | k03, k05 | OPL | Customer |
| 02 | Project Scope Statement (PSS) v1.0 / v2.0 | [02 Project Scope Statement (PSS).docx](https://drive.google.com/file/d/1HKN35Z_LkEcsa0ZOTXF5JX8JDadAT4AZ/view) | .docx | 1 + 4 | k06, s01, m01l | OPL | Customer (twice) |
| 03 | Module Scope List & Product Fit Check | [03 Module Scope List & Product Fit Check.docx](https://drive.google.com/file/d/1Mu-dOZHoaT-o0-q61-I73TffTAxeOxqu/view) | .docx | 1 | k04 | OPL; Product Manager (Fit Check) | Customer |
| 04 | Process Prep Form | [04 Process Prep Form.docx](https://drive.google.com/file/d/1ks57oX9JV09UA-d22abSYh-DKmjYPtRI/view) | .docx | 2 | m01a | AI + OPL | — |
| 05 | Current-State Process Map | [05 Current-State Process Map.docx](https://drive.google.com/file/d/1fK2RregYUCB9mDcWsYJR4kY352gqdrgz/view) | .docx | 2 | m01c, m01d | AI + OPL | Customer (written confirmation) |
| 06 | Gap Feedback Form | [06 Gap Feedback Form.docx](https://drive.google.com/file/d/11lGlZI1aQ7hmgotR6xfP2TgXtjBVp9Jf/view) | .docx | 3 | m01h | AI + OPL | — |
| 07 | Gap Decision Log | [07 Gap Decision Log.docx](https://drive.google.com/file/d/13GzvDJLe-zYJQqys2s7g4FccVkd_wFzF/view) | .docx | 3 | m01i, m01j | OPL; audited by Consulting Lead | Joint |
| 08 | CVBS | [08 CVBS - Customer-Validated Behavior Specification.docx](https://drive.google.com/file/d/1quTfFCUAOqPjfRaQoHwWSZNj7KxZvQBw/view) | .docx | 4 | x01c, x01d | AI + OPL | Customer (before any TTD) |
| 09 | TTD | [09 TTD - Technical Translation Document.docx](https://drive.google.com/file/d/1jcp09PBGIitWDV2C9hNGv-Co6hncTN-R/view) | .docx (markdown on request) | 4 | x01e | OPL | — (gated by the signed CVBS) |
| 10 | Build Register & Build Plan | [10 Build Register & Build Plan.docx](https://drive.google.com/file/d/1YyEX5juRIh49n9hv8wylvo_bhiUCg_5_/view) | .docx | 5 | b01, b05 | OPL + Dev Lead | Customer |
| 11 | UAT Acceptance Script | [11 UAT Acceptance Script.xlsx](https://drive.google.com/file/d/1di-bEr0vWbdxgnaW_OtRPQSD6FtcPdmi/view) | .xlsx | 7 | u01, x01i | AI + OPL | Tester (on the script) |
| 12 | UAT Log | [12 UAT Log.xlsx](https://drive.google.com/file/d/1xbUMQ2Fh642O41OLBUOXPn_L4hE__6vn/view) | .xlsx | 7 | u02 | Customer + OPL | Customer |
| 13 | Change Request | [13 Change Request.docx](https://drive.google.com/file/d/1hPYPpI9GA9e_LPNW_AyRXwPKHwD9xhon/view) | .docx | Any | c04, c04a | OPL (AM prices) | Customer |
| 14 | Hypercare Summary | [14 Hypercare Summary.docx](https://drive.google.com/file/d/1lWFDr8B-PpOX5uqezVq0vBp-6FSOH0mv/view) | .docx | 8 | l05 | OPL | Customer (project close) |

## Supporting artifacts

These aren't numbered phase artifacts, but each has a template and a fixed structure (`artifact-specs.md`, "Supporting artifacts"), and the method depends on them.

| Key | Artifact | Template file | Format | When | Odoo template task(s) | Owner | Signed by |
|---|---|---|---|---|---|---|---|
| TCR | Technical Consult Request | [TCR - Technical Consult Request.docx](https://drive.google.com/file/d/1xgj6eVhRhh_uWEeHcMFJiGem7FF5nu0L/view) | .docx | Any time before Phase 5 that a feasibility, effort or build-approach question needs the Development Lead | c05, x01b | OPL → Development Lead | — (Dev Lead answers in writing) |
| DCN | Decision Confirmation Note | [Decision Confirmation Note.docx](https://drive.google.com/file/d/1EYO8O-Hwtswpb-E4uccfdu3-QDyAofgV/view) | .docx, or the same content as an email | Every phase gate | c01, every GATE task | OPL | Customer's written reply (lifts entries to A2) |
| WSR | Weekly Status Report | [Weekly Status Report.docx](https://drive.google.com/file/d/1jltShKw4bZCFiT909qv2LxmFa3XdyY9G/view) | .docx (or email) | Every Friday | c02 | OPL | — |
| DMT | Data Migration Tracker | [Data Migration Tracker.xlsx](https://drive.google.com/file/d/1_lNBXqO3ZbS__KX68uGH2ul_-_ieeBlu/view) | .xlsx | Created in Phase 3, planned in 5, used in 6–8 | m01k, b04, d02, u05, l02 | Functional Consultant | — (customer confirms each spot-check in writing) |
| GLC | Go-Live Readiness Checklist | [Go-Live Readiness Checklist.xlsx](https://drive.google.com/file/d/1_LQWiHIyWG3tbrnoPSZTrEJO7wG_8fGp/view) | .xlsx | Before Go / No-Go and cutover | g07, l01 | OPL + Functional Consultant | Customer sponsor's GO |

## Other kit material (not artifacts)

Reference these when the user asks how the process runs, or when an artifact's task points to them. They are not produced by this skill.

| Item | Link | Use |
|---|---|---|
| START HERE guide | [00 START HERE - How We Run an Odoo Implementation.docx](https://drive.google.com/file/d/1ZGAvwVawZ4sRfeA7wjbrespeiGwI9Eot/view) | The process in one read |
| Odoo project template | [Syncoria_AIDLC_Project_Template_Import.xlsx](https://drive.google.com/file/d/1i6nPGvi04UXPHPL_86IoOvqRtrZV31Pa/view) | Stages = phases; task IDs above refer to this template (`syncoria_kit.task_<id>`) |
| Customer kickoff deck | [Syncoria_Kickoff_Customer_Template.pptx](https://drive.google.com/file/d/1dBcaiDAhCO6_yijahCYH3u2aZ92kaz9K/view) | Kick-off meeting (k05) |
| Phase briefing decks 2–8 | [Phase Briefings folder](https://drive.google.com/drive/folders/1L1ij7W9vGa_ZKTotNvtnXFrw1AdPRTMW) | Opening each phase with the customer |
| Team training deck | [Syncoria_AIDLC_Team_Training.pptx](https://drive.google.com/file/d/1mwfqWqIuzG4i2oLvQsgxdH0q3x-29kXs/view) | Onboarding Syncoria staff |
| Delivery Playbook | [Delivery Playbook - Connectors, Sessions, Data & Go-Live.docx](https://drive.google.com/file/d/1n9diIjGnxF4VE-zwXQUXwo0uSUUkgSmK/view) | Connector notes, training session guides, import templates and load order, practice go-live, go-live audit, typical risks |

---

## Business areas, not just modules

The Odoo project template carries Phases 2–4 on one task per **business area** (`MOD · [Business area]`). A business area is how the customer runs the work, which isn't always one Odoo module: a company may run purchasing and inventory as one flow. When you produce per-area artifacts (04, 05, 06, 07), write the business area under the template's **Module** meta label as the customer names it, and list the Odoo modules it touches after it.

## When Drive isn't reachable

You don't need the template file open to produce an artifact: `artifact-specs.md` carries its structure. If the user asks for "the template" itself, give the link above rather than recreating it. If a link has stopped working, say so and ask the user for the current location rather than guessing.
