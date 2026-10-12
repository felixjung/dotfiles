---
name: documents
description: Write and review product and design documents — PRDs, technical specs, and ADRs — from fixed templates, with review in Plannotator. Use when the user wants to write a PRD or product requirements document, when superpowers brainstorming writes its spec, when an architectural decision needs recording, or when asked to review one of these documents.
---

# Documents

Templates for the documents that come before an implementation plan, and the review
step every one of them goes through.

| Document | Path | Template |
|----------|------|----------|
| PRD | `docs/prds/YYYY-MM-DD-<topic>.md` | [prd-template.md](prd-template.md) |
| Technical spec | `docs/specs/YYYY-MM-DD-<topic>.md` | [spec-template.md](spec-template.md) |
| ADR | `docs/adrs/NNNN-<decision-slug>.md` | [adr-template.md](adr-template.md) |
| Implementation plan | `docs/plans/YYYY-MM-DD-<topic>.md` | superpowers `writing-plans` (not here) |

Paths are relative to the repository root. Keep every template heading. Write "None"
under a heading that doesn't apply rather than deleting it, and drop the `<!-- Source -->`
comment and the bracketed guidance from the finished document.

## Flow

PRD → spec (+ ADRs) → implementation plan → execution.

Start wherever the user is: a well-understood change can begin at the spec, and not
every spec needs a PRD. Each document is approved before the next one starts.

1. **PRD** — this skill (below).
2. **Spec** — superpowers `brainstorming`, writing its spec with this skill's template.
3. **ADRs** — written during brainstorming when an architectural decision is made.
4. **Plan** — superpowers `writing-plans`, using its own template, linking the spec.

## Writing a PRD

1. Ask for a detailed description of the problem and any ideas for solutions.
2. Explore the repository to check the user's claims and understand the current state.
3. Interview the user until you share an understanding of goals, users, journeys,
   requirements, and how success is measured. Ask one question at a time.
4. Write the PRD from the template. Number every goal, journey, requirement, metric, and
   open question (`G1`, `UJ-1`, `FR-1`, ...) so reviews and later documents can cite them.
5. Run the review gate.

## Writing a spec

When superpowers brainstorming reaches "write the design doc", use the spec template
and path above instead of `docs/superpowers/specs/`. Brainstorming's required content
maps onto the template:

- Agreed understanding (what the user said vs. what you assumed) → Problem and users
- Architecture, components, data flow → Design
- Error handling → Failure and recovery
- Testing → Verification, tied to each requirement
- PRD, ADRs → Related decisions

Requirements trace back to PRD `FR-`/`NFR-` ids when there is a PRD.

## Writing an ADR

Write one when a choice is architecturally significant: picking one of brainstorming's
2–3 approaches, choosing a dependency or protocol, or anything that will outlive the
feature. One decision per ADR.

- Number it with the next free four-digit number in `docs/adrs/` (`0001`, `0002`, ...).
- Status starts as `Proposed` and becomes `Accepted` when its review gate is approved.
- List every option brainstorming considered under Considered options.
- Link it from the spec's Related decisions.

## Review gate

Every document is reviewed in Plannotator before the next stage starts:

```json
{ "action": "annotate", "target": "docs/specs/2026-10-08-example.md", "gate": true }
```

Call the `plannotator` tool with that input, then end your turn and wait. The decision
arrives as a new message.

- **Approved**: that document is approved. Update its Status line and move on.
- **Feedback**: address every comment, then open the review again. Notes that come with
  an approval are guidance, not a change request.
- To review a spec together with its ADRs, pass a list as `target`.

This gate replaces superpowers' "please review the spec" chat prompt. Don't use
`/plannotator-plan-mode` or `plannotator_submit_plan` for these documents.

If the `plannotator` tool isn't available, ask the user to run
`/plannotator-annotate <path>` and wait for their feedback.
