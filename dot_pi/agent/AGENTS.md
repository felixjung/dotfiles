# Pi Guidelines

Applies in addition to `~/AGENTS.md`.

## Delegation

Delegation to pi-subagents is authorized without asking for:

- codebase recon before implementing (`scout`)
- external docs/API research (`researcher`)
- post-implementation review fanout (`reviewer`)
- second opinion before risky or irreversible changes (`oracle`, read-only)

Keep implementation in the parent session unless the task is multi-seam or
unless I pick subagent-driven execution at a superpowers plan handoff; that
authorizes its per-task implementer and reviewer subagents.
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

During superpowers brainstorming, follow its cadence instead: one question per
`ask_user_question` call. Its visual companion may be offered for questions
that are clearer shown than told.

## Superpowers

These override the superpowers skills' defaults.

- **Documents:** PRDs, specs and ADRs follow the `documents` skill, under
  `docs/prds/`, `docs/specs/` and `docs/adrs/`. Implementation plans go to
  `docs/plans/YYYY-MM-DD-<topic>.md` with the `writing-plans` template. Never
  write to `docs/superpowers/`.
- **Reviews:** every request to review a PRD, spec, ADR or plan goes through the
  `documents` skill's review gate (`plannotator` annotate with `gate: true`),
  not a chat prompt. Don't use `/plannotator-plan-mode` or
  `plannotator_submit_plan`.
- **Tasks:** track skill checklists and plan tasks with the `todo` tool. Never
  create a `TODO.md`.
- **Worktrees:** `using-git-worktrees` creates them with `wt switch -c <branch>`,
  never under `.worktrees/`.
- **Finishing:** in `finishing-a-development-branch`, use the `git-committer`
  and `pull-request-opener` skills for commits and pull requests.
