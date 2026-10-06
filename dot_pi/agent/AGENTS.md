# Pi Guidelines

Applies in addition to `~/AGENTS.md`.

## Delegation

Delegation to pi-subagents is authorized without asking for:

- codebase recon before implementing (`scout`)
- external docs/API research (`researcher`)
- post-implementation review fanout (`reviewer`)
- second opinion before risky or irreversible changes (`oracle`, read-only)

Keep implementation in the parent session unless the task is multi-seam.
One writer per worktree. Launch async and yield rather than blocking.

The no-overwrite rule in `~/AGENTS.md` applies to subagent writer lanes too.

See the bundled pi-subagents skill for orchestration mechanics.

## Asking the user

Default to `ask_user_question` (terminal dialog). Group related questions into
one call (up to 4) rather than asking them one at a time.

Use `interview` (browser form) only when:

- the user asks to be interviewed or for a form
- running a planning or requirements-gathering session with more than 4
  questions, gathered in a single form
- questions need diagrams, tables, charts, or image uploads

Never use `interview` for a single question or a series of one-off questions;
each call forces a switch to the browser.
