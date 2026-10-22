# CVBS / TTD Exemplars — The Standard to Match

Condensed passages from the CVBS-014 / TTD-014 worked pair (Northwind Fabrication, purchase approval by buyer limit and product category). They are here to calibrate *how good is good enough* — the register, the density, the level at which a reason counts as a reason.

**Read these as a standard of writing, never as content.** Every Odoo internal, volume, name and date below belongs to that worked example. Carrying any of them into a real TTD violates the verification rule in `ttd-construction.md`. What you carry across is the *shape* of the sentence.

---

## 1. The alternatives table — quality goal 1

The single highest-value table in a TTD. Note that every rejection is a **capability** statement, each names what was examined, and one of them records that it was confirmed against the instance on a date.

> | Alternative considered | Why not |
> |---|---|
> | Configuration only, company threshold | Single amount, company-wide, no per-buyer or per-category dimension. **Fails the requirement, not merely inconvenient.** Confirmed against the instance on 2026-09-08. |
> | Studio field plus automation rule | Can add the fields, but cannot cleanly gate the standard confirm transition or restrict who releases it. The automation would have to fight the standard state machine, which is exactly the fragility the standard-first rule exists to avoid. |
> | Community approval module | Reviewed two candidates. Both introduce their own approval model and state, duplicating the standard state machine and increasing upgrade surface for a two-rule policy. Disproportionate for 6 buyers. |
> | New standalone approval model | Fails test 3. It reinvents a construct Odoo already provides and leaves the standard approval state unused and confusing. |

**What makes it strong:** "fails the requirement, not merely inconvenient" is the distinction that decides whether you build or go back to the customer. "Disproportionate for 6 buyers" is quality goal 4 doing real work in one clause.

**Weak version of the same row:** *"Configuration: not flexible enough."* — no setting named, no dimension named, no date, no verdict on whether the process could have flexed instead.

---

## 2. The review trace — quality goal 1

> - Version and edition checked: Odoo 19 Enterprise, read from Settings > General Settings on the production instance, 2026-09-08. Installed purchase module version recorded in the review notes.
> - Standard behavior found: the purchase module supports a two-step confirmation in which an order above a company-level amount is held in an approval state and released by a user in the Purchasing Manager group. The permission decision sits in an internal helper on the order model, and the confirm action consults it.
> - Where it stops: the threshold is a single company-level amount with no per-user dimension, and there is no product-attribute dimension at all. Neither can be expressed by configuration.
> - Therefore: extend the helper. **The state machine, the approval state, the approve action, the chatter and the activity mechanism are all reused unchanged.**

**What makes it strong:** the final sentence. Listing what is reused unchanged is how a TTD proves quality goal 3 — it converts "we used standard constructs" from a claim into an inventory.

---

## 3. Extension-point selection and the super() contract — quality goal 2

> This build extends the approval-permission hook, not the confirm button, and calls super() first. The vendor block therefore runs and can veto before any approval record is created. Verified by AC-23.

**What makes it strong:** three decisions in two sentences — which hook, in what order, and the business consequence of that order — plus the criterion that proves it. The narrower hook was chosen over the obvious one *because* it composes with the existing extension instead of racing it.

---

## 4. Conflict clearance — quality goal 2

> | Checked | Result |
> |---|---|
> | Addons extending the purchase order model | One found: `syn_vendor_block`, extends the confirm action. No collision, different hook, ordering verified. See section 2b. |
> | Addons extending the approval helper or the approve action | None found in the custom addons repository at the deployed branch. |
> | Automation rules on purchase order state change | One active rule sends a vendor email when an order reaches purchase state. It fires later than before for held orders, which is correct and was confirmed with the OPL. |
> | Anything else writing the order state | Nothing found beyond standard. |
> | Company-level two-step setting | Currently one-step. Must stay one-step. Added to the go-live checklist. |

**What makes it strong:** two things most TTDs miss entirely. Row 3 records an **intended side effect** and who confirmed it — that is the difference between a known behavior change and a week-one defect report. Row 5 checks a **standard setting** as a conflict source, not just other customizations, and pushes a consequence onto the go-live checklist.

**"None found" is a required answer.** A blank row reads as an unasked question.

---

## 5. Concerns and pitfalls — the register to match

> | Concern | Why it matters | How this build handles it |
> |---|---|---|
> | **Standard two-step setting still active** | If the company-level threshold is also switched on, two rules decide the same thing and behavior becomes unpredictable. | The company setting is left at one-step and this build owns the decision. Section 5 states the precedence explicitly, and the go-live checklist includes confirming the setting. |
> | **Security of the limit field** | A buyer who can edit their own limit defeats the entire control. | The field is restricted at field level to the administrator group, and the limit is tracked so any change is evidenced. AC-18, AC-30, AC-31. |
> | **Maintenance cost** | Buyer limits are ongoing master data with no natural owner. | Accepted by the customer in CVBS §5. Named owner is the purchasing administrator. **Not a technical mitigation, a documented handover item for hypercare.** |

**What makes it strong:** every resolution cites the criteria that prove it, and the last row refuses to dress an organisational cost up as a technical fix. A concern honestly marked "accepted, not solved, owned by X" is worth more than a mitigated-sounding sentence.

---

## 6. Cost of getting it wrong — the three directions

> - **Too permissive:** an order slips through unapproved and the audit finding stays open. This is the failure the customer is paying to remove, **so the design fails safe. Where the system cannot tell, it holds the order rather than releasing it.**
> - **Too restrictive:** everyday orders queue behind an approver and the purchasing function slows down. Roughly 500 orders a month are confirmed, of which only 75 to 95 should ever be held.
> - **Silent:** an order held with no approver assigned stalls with nobody noticing. Every held order must have a named recipient or a group fallback.

**What makes it strong:** the fail-safe direction is declared, so every ambiguous branch in the logic section has a default the developer can derive without asking. The "too restrictive" bullet carries real volumes, which is what makes the proportionality judgment checkable.

---

## 7. Field rationale — the third column earning its place

> | Field | Type and behavior | Business meaning and why it exists |
> |---|---|---|
> | `syn_po_approval_limit` | Monetary, company dependent, tracked, not required, **no default** | The maximum order total this buyer may commit without approval, per company. **No default on purpose: an unset limit must mean 'ask', not 'unlimited'** (AC-06). Company dependent because a buyer can act for two companies with different authority (AC-13). |
> | `syn_po_plant_approval` | Boolean, default False, tracked | Marks a category whose purchase always needs Plant Manager approval regardless of value. **Held on the category rather than the product so the control survives new products being added, which is the audit point.** |
> | `syn_required_approver_group` | Selection, computed, stored, derived from the reason | Single place that expresses the precedence rule. **Derived rather than entered so the two can never disagree.** |
> | `syn_limit_applied` | Monetary, readonly, written at confirmation | The buyer limit used for the decision, **kept for evidence so an auditor can see what the rule was at the time, not what it is today.** |

**What makes it strong:** four distinct patterns worth reusing — the fail-safe default, the placement choice justified by what it must survive, derive-so-they-cannot-disagree, and the evidence stamp. None of these restate the field name.

**Weak version:** *"`syn_po_approval_limit` — Monetary — the buyer's approval limit."* Says nothing a developer could not guess, and loses the three decisions that actually mattered.

---

## 8. New-model justification — quality goal 3

> | Model | Type | Why a new model is justified |
> |---|---|---|
> | `syn.purchase.reject.wizard` | TransientModel | A transient wizard is the standard Odoo construct for capturing a mandatory input before an action. One field, reason (Text, required). **No persistent model is added by this build.** |

**What makes it strong:** the last sentence is a positive statement a reviewer can check. Silence on new models is not the same as adding none.

---

## 9. Edge cases — the table, not the paragraph

> | Case | Expected behavior |
> |---|---|
> | Order total exactly equal to the limit | Not held. The limit is inclusive (AC-04). |
> | Zero or negative total (credit style) | Limit rule does not apply. Category rule still applies (AC-07). |
> | Order currency differs from company currency | Converted at the order date. Both figures visible on the order (AC-14). |
> | Line added to a held order | Reason recomputes. The order stays held. No second activity. |
> | Category flag turned on after an order was approved | Approved orders are not reassessed. Only a later increase reassesses them (AC-27). |
> | Two approvers acting simultaneously | First wins, second sees a clear message, no duplicate (AC-22). |
> | Approver archived after the activity was created | The activity stays visible to the group through the standard filter. Fallback applies at scheduling time only (AC-21). |

**What makes it strong:** each is a *decision*, not a description of a risk. "The limit is inclusive" settles an argument that would otherwise happen at UAT. The last two are the classes most often skipped — concurrency and the archived related record.

---

## 10. The transaction rule, stated once, plainly

> If confirmation fails for an unrelated reason, the transaction rolls back and no activity or stamp survives. **Do not create the activity before the state transition succeeds** (AC-23).

One sentence that prevents the most common category of half-completed record.

---

## 11. Security written as a control, not a checkbox

> | Item | Rule | Business reason |
> |---|---|---|
> | Approve action | Group check plus self-approval block, enforced in the method, not only in the view. | AC-16, AC-17. **View-level hiding alone is not a control.** |
> | Record rules | None added. Standard purchase record rules and multi-company rules are unchanged. | **Stated explicitly so the reviewer knows it was considered and not forgotten.** |

Both rows are exemplary for the same reason: they state the thing that is *not* being relied on.

---

## 12. Assumptions with consequences and a gate

> | # | Assumption | If wrong |
> |---|---|---|
> | A1 | The limit compares against the order total including tax. | If it should exclude tax, section 5.1 changes and every amount criterion needs restating in the CVBS. |
> | A3 | Every named buyer will have a limit loaded before go-live. | If not, those buyers hit the fallback and every order is held, **which will look like a defect on day one.** |
>
> **Gate:** Assumptions A1 and A3 are blockers. Do not start the build until the OPL has confirmed both in writing.

**What makes it strong:** the "if wrong" column lets the OPL confirm in seconds instead of reconstructing the consequence, and the gate box separates the two that stop the build from the three that don't.

---

## 13. The honesty caveat every worked example needs

> **Worked-example caveat.** The Odoo internals named below (method names, setting names, storage behavior of company-dependent fields) are illustrative for this template. On a real TTD every one of them is read off the customer's actual instance and the matching version source before the document is written, and the version and date of that read are recorded in the section 1 meta line and again in the section 3 trace. **Never carry these names over from one project to another without re-tracing them.**

Reproduce a box like this in any TTD that still contains unverified internals, and list each one as a blocking `[VERIFY: …]` item in §11.3.

---

## From the CVBS side — what caps TTD quality

A TTD cannot be more precise than the CVBS it implements. Three passages from CVBS-014 that make a strong TTD possible:

### The singularity test, argued rather than asserted

> One trigger (a buyer confirms a purchase order), one decision (does this order need approval and from whom), one outcome (the order either becomes a purchase order or waits for a named approver). The two rules cannot be built or signed separately because an order can breach both at once and the system must decide once, not twice. Splitting them would leave neither half usable on its own.
>
> **Note on criteria count.** This CVBS carries a high number of acceptance criteria. That is coverage, not aggregation. The singularity test counts triggers, decisions and outcomes. Criteria that exist only to cover boundaries, failures, permissions and existing records do not count toward it.

The note matters: it stops a reviewer using AC count as a proxy for scope creep, which is how thorough CVBSs get wrongly split.

### The review verdict, on the customer-facing document

> Customization review completed 2026-09-08. Test 1 standard-first: **standard does not cover it** — the standard threshold is single and company-wide. Test 2 conflict: **cleared** — one existing customization touches order confirmation and the approach chains around it. Test 3 standard constructs: **passed** — the build extends the standard approval state rather than adding a parallel mechanism. Test 4 size and industry fit: **passed** — proportionate for a 140-person fabricator with 6 buyers. Build level: custom. Full trace in TTD-014 section 3.

Four verdicts, one date, one cross-reference, and the build level. The customer sees that the cheaper paths were tested; the TTD carries the evidence.

**On the wording:** the worked example originally wrote test 1 as "failed." That reads two ways — *the test failed* or *standard failed to cover it* — and it is going in front of a customer, so use the fixed words from `syncoria-customization-review`'s `review-procedure.md` block H instead, as above.

### Standard-first including the process-flex question

> The customer was asked whether the policy could flex to a single company-wide threshold instead, and declined, because the tooling control is an audit finding.

Process adaptation is the rung of the ladder most often skipped. Recording that it was offered and declined — with the customer's reason — is what makes the custom build defensible.

---

## How to use this file

When drafting, write the section, then find its exemplar here and ask: *is mine this specific?* The most common gap is not structure — the structure comes from `ttd-construction.md` — it is that a real TTD's sentences say less per line than these do. If a row in your table could be true of any project, it is not yet carrying a reason.
