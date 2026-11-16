## Plannotator Inbox

### Guide and connection

- Read `plannotator inbox --help` for the current agent guide when setting up
  or troubleshooting Inbox use. Follow it for connection and tool mechanics;
  the question-routing and coding-review rules below take precedence where
  they differ. Use `plannotator` from the shell environment.
- Register the connection once, following the guide for the current host.
  Check first: if a `plannotator-inbox` server already runs
  `plannotator inbox mcp`, change nothing. Do not replace an existing
  connection; report conflicting configuration instead.
- If a host reload or restart is needed for the connection to take effect,
  tell me what is required. Until then, use available Inbox tools or the
  guide's stdio fallback. Do not stop or restart the Inbox itself unless I
  ask; other agents share it.

### Questions and handoffs

Use Plannotator Inbox for every question, clarification and decision, including
brainstorming, requirements gathering and questions raised during an active
chat. These rules override question routing and cadence in skills and any
Plannotator-managed note, including its chat exceptions.

The coding-task review handoff below is the explicit exception: mirror its
invitation in Inbox and the session as one review request.

- Use the Inbox tools exposed by the current host/provider: `plannotator_inbox`
  in Pi, `pi__plannotator_inbox` through Pi's Cursor provider, or the tools
  exposed by the `plannotator-inbox` MCP server in other hosts. Use the actual
  exposed names and supported actions; names can differ between providers.
  Consult the `plannotator` skill for supported actions and the CLI fallback.
- Ask only what the conversation and available sources cannot answer. Put
  each decision in its own `:::question` block with enough context to answer
  without reading the chat. Group independent questions in one message; ask
  dependent follow-ups after the earlier answers arrive.
- Keep one thread per work stream. Read the thread before continuing it if
  its contents are not in the current context. Keep answers and follow-ups in
  that thread; do not duplicate questions in chat or another question tool.
- Put diagrams and screenshots in the message and attach the relevant files.
  Use Inbox instead of an interview form or a separate brainstorming visual
  companion.
- After sending, continue independent work. Leave dependent work pending and
  end the turn when nothing independent remains. A missing reply is not
  approval. Let replies return through the agent's integration; use
  `read_thread` when automatic delivery is unavailable.
- Hand over finished long work in the same thread with a short summary and
  the files to read. Chat may report status and link to the Inbox thread,
  but must not become a second question or approval channel.
- If Inbox is unavailable, report the connection problem and keep dependent
  work pending. Do not fall back to terminal questions, interview forms or
  chat questions.

### Board tracking

Keep one Board card per piece of work that outlasts a single reply. Skip
trivial things and do not create cards for work already done or stopped.
Maintain known work as it progresses; do not inventory every branch,
worktree or repository on every reply. A full Board inventory is a separate,
explicit request.

- Use the native Inbox card tool/action. If it is unavailable or has no card
  action, consult `plannotator card --help` and
  use the CLI. If a call answers `board_off`, tell me to turn the Board
  on in Inbox Settings → Capabilities and stop Board operations.
- Before creating a card, list cards with `op: "list"` and
  `asked_by: "anyone"`. Never make a second card for existing work;
  update it with `move`, `say` or `link`.
- Columns describe where the work stands, never whose move it is. Always
  pass `column` when creating a card or updating its active status:
  - `todo`: requested work that has not started.
  - `in_progress`: active research, planning, mocks, code or a draft PR.
    Asking me a question mid-work leaves it in `in_progress`.
  - `in_review`: your part is done and deliberately handed to me.
    Set `you` to what I owe and link the decision's Inbox thread with
    `thread_id` so the action opens it.
  - `backlog`: an unsolicited idea or follow-up. A card I put there
    is mine to move; it does not authorize you to start.
- Give each card a 2–5 word `title` naming the work, never a sentence.
  Put your last word about its status in one line in `say`. Link its
  PR with `pr` and issue with `ref`, using owner/repo#123 or a full
  URL. Add further links with `op: "link"`.
- Use `initiative` only for an extensive effort spanning several cards
  or PRs. Reuse a fitting initiative from the list; most cards need none.
- For work in another repository, pass that folder as `project_path`.
  If the project has no Board yet, send one short Inbox message from that
  project, then retry.
- Move the card to `in_review` at a review handoff. Board status never
  replaces explicit approval. Use `ship` only after observing that work
  is finished, including required approval, or its PR has merged. Use
  `drop` for cancelled work and give a reason.

### Coding task review

After a coding task, stop at **ready for review** and obtain my explicit
approval before marking the task complete. This includes source, tests,
scripts and runtime configuration, even small changes. Questions, no-change
tasks, and plan/document-only work retain their existing review workflows.

For coding handoffs, these rules override general completion, automatic
review-opening and Inbox delivery instructions:

- The parent agent sends one handoff for the task. Subagents report to their
  parent rather than requesting their own human reviews.
- Finish implementation and relevant checks, then prepare a patch of this
  task's changes, including new files. Exclude unrelated and manual changes
  without changing my staging or resetting any work. Report check failures
  and limitations honestly.
- Consult the `plannotator` skill. Use Inbox's `get_guide_brief` and
  `submit_guide` to save a guided review with the exact patch. Prefer the
  native Inbox tool; otherwise use the documented CLI fallback. Keep the
  review in this work stream's existing thread when there is one.
- Save the review for me to open when I choose. Do not open a browser,
  launch a live review server, or invoke an automatically opening review
  command for this handoff. Do not change global browser settings; other
  review workflows keep their existing behavior.
- Prepare one handoff body with the change summary, verification results
  and an invitation to review the saved changes in Plannotator. Pass that
  body to `submit_guide` and reproduce it verbatim in the session response.
  Put the returned Inbox thread link beside the session copy. This is one
  review request shown in two places, not two approval decisions. Do not
  add a separate approval question or use a blocking question tool.
- End the turn after the handoff and leave completion pending. My explicit
  approval in Inbox or this session must refer to the latest submitted
  changes. Silence, closing the viewer and acknowledgement alone are not
  approval. Let feedback arrive through the integration; read the thread
  later when automatic delivery is unavailable.
- Address requested revisions, rerun relevant checks and submit an updated
  review with the same mirrored handoff before awaiting approval again.
- If review preparation or Inbox delivery fails, report the blocker in the
  session and leave completion pending. Do not claim delivery or approval,
  or open a browser as a fallback. Preserve existing permissions for
  commits, pull requests and publishing; this policy grants none.
