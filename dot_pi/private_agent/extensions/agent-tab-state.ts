// Report pi's status to the terminal tab bars (Zellij, WezTerm).
//
// Claude Code calls ~/.config/zellij/scripts/zellij-agent-state from
// its hooks; pi has no hooks, so this extension makes the same call from
// pi's lifecycle events. See that script for the state it records.
//
// Best-effort and silent: inside a sandbox (pisbx) the script is absent, and a
// failed spawn must never disturb the session.
// @ts-nocheck

import { spawn } from "node:child_process";
import os from "node:os";
import path from "node:path";

const script = path.join(os.homedir(), ".config/zellij/scripts/zellij-agent-state");

export default function (pi) {
  let sessionId;
  let cwd = process.cwd();
  // Overlapping prompts (ui_prompt_start can nest) must not flip back to
  // "running" while one is still open.
  let prompts = 0;
  let active = false;
  // Only the interactive session owns a tab; subagents and headless runs
  // (print/RPC) would otherwise report under the same terminal pane.
  let tui = false;

  function report(...args) {
    try {
      const child = spawn(script, ["--agent", "pi", ...args], {
        stdio: ["pipe", "ignore", "ignore"],
        detached: true,
      });
      child.on("error", () => {});
      child.stdin.on("error", () => {});
      child.stdin.end(JSON.stringify({ session_id: sessionId, cwd }));
      child.unref();
    } catch {}
  }

  function remember(ctx) {
    try {
      const id = ctx?.sessionManager?.getSessionId?.();
      if (typeof id === "string" && id) sessionId = `pi-${id}`;
    } catch {}
    if (typeof ctx?.cwd === "string" && ctx.cwd) cwd = ctx.cwd;
  }

  function publish() {
    report(prompts > 0 ? "waiting" : active ? "running" : "done");
  }

  pi.on("session_start", (_event, ctx) => {
    // Headless modes have no terminal tab to decorate.
    if (ctx?.mode !== "tui") return;
    tui = true;
    remember(ctx);
    active = ctx?.isIdle?.() === false;
    prompts = 0;
    if (active) publish();
  });

  pi.on("agent_start", (_event, ctx) => {
    if (!tui) return;
    remember(ctx);
    active = true;
    publish();
  });

  pi.on("agent_settled", (_event, ctx) => {
    if (!tui) return;
    if (ctx?.isIdle?.() !== true) return;
    active = false;
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

  pi.on("session_shutdown", (_event, ctx) => {
    if (!tui) return;
    remember(ctx);
    report("clear");
  });
}
