## Coding task review

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
