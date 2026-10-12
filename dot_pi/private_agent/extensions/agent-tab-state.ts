// Report pi's status to the terminal tab bars (Zellij, WezTerm).
//
// Claude Code calls ~/.config/zellij/scripts/zellij-agent-state from its
// hooks; pi has no hooks, so this extension makes the same call from pi's
// lifecycle events. See that script for the state it records.
//
// Reports are sent one at a time, in order: each is a separate process, and
// two spawned back to back (running, then done) could otherwise finish in the
// wrong order and leave the tab showing a stale state. Like herdr's pi
// extension, a report waiting behind a running one is replaced by any newer
// one, since only the latest state matters.
//
// Best-effort and silent: inside a sandbox (pisbx) the script is absent, and a
// failed spawn must never disturb the session.
// @ts-nocheck

import { spawn } from "node:child_process";
import os from "node:os";
import path from "node:path";

const script = path.join(os.homedir(), ".config/zellij/scripts/zellij-agent-state");
const TIMEOUT_MS = 3000;

export default function (pi) {
  let sessionId;
  let cwd = process.cwd();
  // Overlapping prompts (ui_prompt_start can nest) must not flip back to
  // "running" while one is still open.
  let prompts = 0;
  let active = false;
  // The last run ended in an error. Set at agent_end but only reported at
  // agent_settled, because pi may still retry a failed run.
  let failed = false;
  // Only the interactive session owns a tab; subagents and headless runs
  // (print/RPC) would otherwise report under the same terminal pane.
  let tui = false;

  let queued; // args of the next report, if one is waiting
  let draining; // promise of the drain loop while it runs

  function send(args) {
    return new Promise((resolve) => {
      let timer;
      const done = () => {
        clearTimeout(timer);
        resolve();
      };
      try {
        const child = spawn(script, ["--agent", "pi", ...args], {
          stdio: ["pipe", "ignore", "ignore"],
        });
        timer = setTimeout(() => {
          child.kill();
          done();
        }, TIMEOUT_MS);
        child.on("error", done);
        child.on("close", done);
        child.stdin.on("error", () => {});
        child.stdin.end(JSON.stringify({ session_id: sessionId, cwd }));
      } catch {
        done();
      }
    });
  }

  async function drain() {
    while (queued) {
      const args = queued;
      queued = undefined;
      await send(args);
    }
    draining = undefined;
  }

  function report(...args) {
    queued = args;
    draining ??= drain();
    return draining;
  }

  function remember(ctx) {
    try {
      const id = ctx?.sessionManager?.getSessionId?.();
      if (typeof id === "string" && id) sessionId = `pi-${id}`;
    } catch {}
    if (typeof ctx?.cwd === "string" && ctx.cwd) cwd = ctx.cwd;
  }

  function publish() {
    report(prompts > 0 ? "waiting" : active ? "running" : failed ? "error" : "done");
  }

  pi.on("session_start", (_event, ctx) => {
    // Headless modes have no terminal tab to decorate.
    if (ctx?.mode !== "tui") return;
    tui = true;
    remember(ctx);
    active = ctx?.isIdle?.() === false;
    failed = false;
    prompts = 0;
    if (active) publish();
  });

  pi.on("agent_start", (_event, ctx) => {
    if (!tui) return;
    remember(ctx);
    active = true;
    failed = false;
    publish();
  });

  pi.on("agent_end", (event) => {
    if (!tui) return;
    const last = event?.messages?.findLast?.((m) => m?.role === "assistant");
    failed = last?.stopReason === "error";
  });

  pi.on("agent_settled", (event, ctx) => {
    if (!tui) return;
    if (ctx?.isIdle?.() !== true) return;
    active = false;
    // An aborted run (Escape) is not a failure.
    if (event?.aborted) failed = false;
    publish();
  });

  pi.on("ui_prompt_start", () => {
    if (!tui) return;
    prompts += 1;
    publish();
  });

  pi.on("ui_prompt_end", () => {
    if (!tui) return;
    prompts = Math.max(0, prompts - 1);
    publish();
  });

  pi.on("session_shutdown", async (_event, ctx) => {
    if (!tui) return;
    remember(ctx);
    // Replaces anything still queued and is awaited, so pi cannot exit before
    // the state file is gone.
    await report("clear");
  });
}
