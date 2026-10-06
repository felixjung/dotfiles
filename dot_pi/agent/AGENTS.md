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
