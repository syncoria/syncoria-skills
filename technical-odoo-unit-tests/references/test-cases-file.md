# Working from a test-cases specification file

A test-cases file is a statement of **intended** behaviour, written by whoever
specified the feature. The code is an attempt at that intent. When they
disagree, the document wins until a human says otherwise — so the disagreement
must surface as a question, never as a test quietly asserting whatever the code
happens to do today.

## Where it is looked for

`scripts/test_context.sh` searches, stopping at the first hit:

1. `<module>/tests/test_cases.md`, `<module>/tests/TEST_CASES.md`
2. `<module>/test_cases.md`, `<module>/TEST_CASES.md`
3. `<module>/docs/test_cases.md`, `<module>/docs/TEST_CASES.md`
4. any `*.md` / `*.txt` / `*.yaml` / `*.yml` under the module whose name
   contains `test_case`, `test-cases`, `test_scenario` or `user_flow`

If the user names a file elsewhere, use theirs — their path beats the search.

## 1. Read the whole file first

Not the section that looks relevant. A precondition three cases earlier, or a
role named once in an intro paragraph, usually decides how the fixture must be
built. Partial reading is how a test ends up asserting the right value for the
wrong actor.

## 2. Build the flow map

For each case, extract and write down:

| Field | Why it matters to the test |
|---|---|
| Case ID and title | goes in the test docstring, so a failure points back here |
| Actor / role | decides `with_user()` — a rule passes as admin and fails as a user |
| Preconditions | what `setUpClass` must build, and no more |
| Steps | the calls the test makes, in order |
| Expected result | the assertions |
| State changes / side effects | fields, messages, activities, moves to assert |
| Negative paths | which exception, and which message |

A case whose expected result is "it works" is not testable. Ask what observable
thing changes.

## 3. Cross-check each step against the code

Trace every step to the model method, controller or view logic that implements
it, and confirm the code actually produces the stated result. Keep the file and
line for each — the report needs them.

Treat all of these as a **mismatch**:

- a documented step with no implementation;
- a different field, state or value than the case expects;
- a different actor, group or record rule than the case assumes — check
  `ir.model.access.csv` and the record rules, not only the Python;
- a documented negative path with no validation or no raise;
- a different order of operations, when the order is observable (a notification
  sent before the record is saved, a field computed after it is read);
- a case that depends on a module not in `depends`.

Not a mismatch, and not worth reporting: wording, formatting, a field the
document names loosely but that resolves to the same one.

## 4. When the code and the document disagree — stop

Do not write the test for that case yet. Report each mismatch as:

```
Case TC-07 "Agent cannot approve their own order"
  expects : ValidationError when approver == creator
  actual  : <module>/models/sale_order.py:142 checks only group membership,
            a creator in the approver group approves their own order
  fix     : add the equality check in _check_approver before the group test
```

Then ask the user to choose, once, for all mismatches found:

- **a)** apply the proposed code fix, then write tests matching the document;
- **b)** the document is out of date — update it, then write tests matching the
  code;
- **c)** skip the mismatched cases and test only what already agrees.

Write the tests for every case that *does* agree in the meantime; a pending
decision on TC-07 is no reason to leave TC-01..TC-06 unwritten.

If the file is ambiguous or incomplete for a step, ask **one** question covering
every ambiguity found — not one question per case.

## 5. When they agree

Generate one test method per case wherever it is practical, and put the case ID
and title in the docstring:

```python
def test_agent_cannot_approve_own_order(self):
    """TC-07 - Agent cannot approve their own order."""
```

That docstring is the whole point of the mapping: a failure in CI names the case
that broke, so whoever reads it can go back to the specification rather than
reverse-engineering the intent from the assertion.

Do not silently drop a case because it is awkward to test. Either test it, or
list it in the report as not covered, with the reason.
