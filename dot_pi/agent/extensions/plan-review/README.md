# plan-review

Plan mode for pi. The agent explores the codebase and writes a markdown plan. You review
the plan in [plannotator-tui](https://github.com/plannotator/plannotator-tui), and when you
approve it, the agent carries it out through pi-subagents.

It works in any terminal and doesn't need Herdr or a browser.

## Requirements

- `plannotator-tui` on `PATH`. It's installed from `plannotator/tap`; see
  `.chezmoidata/packages.yaml`. With Homebrew 6, run `brew trust plannotator/tap` once.
- `pi-subagents`, to run approved plans.
- An interactive pi session. Review isn't available in print or RPC mode.

## Usage

1. Run `/plan` to start plan mode. To choose the plan file, pass its path, for example
   `/plan plans/auth.md`. Otherwise the agent picks `plans/<short-name>.md`. While plan mode
   is on, the status line shows `⏸ plan`.
2. Describe the task. The agent explores, asks questions, and keeps the plan file up to date.
3. When the plan is ready, the agent calls `submit_plan`. pi pauses and opens the plan in
   `plannotator-tui`.
4. Annotate the plan, then quit with `q`. Useful keys:
   - Select text with the mouse, or with `v` and the movement keys.
   - `c` comment, `a` looks good, `d` delete.
   - `c` on a block comments on the whole block.
5. Back in pi, choose one:
   - **Send feedback**: the agent gets the notes you added since the last review, edits the
     plan and submits it again.
   - **Approve and execute**: plan mode ends and the agent runs the plan with the
     `subagent` tool. It picks how to split the work (worker, parallel, chain, reviewer).
     Any notes go along as guidance.
   - **Keep planning**: the agent stops and waits for your next message.

Run `/plan` again to leave plan mode without approving. Plan mode survives `/resume`.

## Restrictions while planning

| Tool | Allowed |
|------|---------|
| `write`, `edit` | Only `.md`/`.mdx` files inside the working directory |
| `bash` | Read-only commands (`cat`, `rg`, `git log`, `git diff`, `gh pr view`, …) |
| `subagent` | Only `scout`, `researcher`, `oracle`, `evidence-auditor`, plus the `list`, `status` and `guide` actions. Workflows and scripts are blocked |

These checks catch mistakes. They aren't a sandbox.

## How feedback is collected

`plannotator-tui` saves every annotation as JSON when you make it, under
`~/.plannotator/clients/plannotator-tui/annotations/` (or `$PLANNOTATOR_DATA_DIR`). After
the TUI closes, the extension finds the record for the plan file and sends only the open
annotations the agent hasn't seen, by id and last edit. Editing a note sends it again.
If no record is found, it falls back to `plannotator-tui --export`, which sends every note.

You don't need `E` (send) in the TUI. Outside Herdr it only copies to the clipboard.

## Relation to @plannotator/pi-extension

That package is installed for browser code review (`/plannotator-review`). Its own plan
mode (`/plannotator-plan-mode`, `Ctrl+Alt+P`, `--plan`) reviews plans in the browser and
isn't used here. Once `plannotator-tui` can review diffs
([plannotator-tui#59](https://github.com/plannotator/plannotator-tui/issues/59)), the web
extension can go.
