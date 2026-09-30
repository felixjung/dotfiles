/**
 * Plan mode with plannotator-tui review and pi-subagents execution.
 *
 * `/plan [path]` restricts the agent to read-only exploration plus markdown
 * writes. The agent finishes by calling `submit_plan`, which hands the terminal
 * to plannotator-tui. After the TUI exits, new annotations are sent back as
 * feedback, or the plan is approved and the agent delegates execution to
 * pi-subagents.
 */

import { spawn, spawnSync } from "node:child_process";
import { existsSync, readdirSync, readFileSync, realpathSync } from "node:fs";
import { homedir } from "node:os";
import { extname, isAbsolute, join, relative, resolve } from "node:path";
import type { AgentMessage } from "@earendil-works/pi-agent-core";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const STATE_ENTRY = "plan-review";
const CONTEXT_MESSAGE = "plan-review-context";
const SUBMIT_TOOL = "submit_plan";
const TUI_BINARY = "plannotator-tui";

const READ_ONLY_AGENTS = new Set(["scout", "researcher", "oracle", "evidence-auditor"]);
const READ_ONLY_SUBAGENT_ACTIONS = new Set(["list", "status", "guide"]);

// Bash commands that modify state. Checked before the allowlist below.
const DESTRUCTIVE_PATTERNS = [
	/\brm\b/i,
	/\brmdir\b/i,
	/\bmv\b/i,
	/\bcp\b/i,
	/\bmkdir\b/i,
	/\btouch\b/i,
	/\bchmod\b/i,
	/\bchown\b/i,
	/\bln\b/i,
	/\btee\b/i,
	/\btruncate\b/i,
	/\bdd\b/i,
	/(^|[^<])>(?!>)/,
	/>>/,
	/\bnpm\s+(install|uninstall|update|ci|link|publish)/i,
	/\byarn\s+(add|remove|install|publish)/i,
	/\bpnpm\s+(add|remove|install|publish)/i,
	/\bpip\s+(install|uninstall)/i,
	/\bbrew\s+(install|uninstall|upgrade)/i,
	/\bgit\s+(add|commit|push|pull|merge|rebase|reset|checkout|switch|restore|branch\s+-[dD]|stash|cherry-pick|revert|tag|init|clone)/i,
	/\bsudo\b/i,
	/\bkill\b/i,
	/\bpkill\b/i,
	/\bkillall\b/i,
	/\b(vim?|nvim|nano|emacs|code|subl)\b/i,
];

// Read-only commands allowed while planning.
const SAFE_PATTERNS = [
	/^\s*(cat|head|tail|less|more|grep|rg|find|fd|ls|eza|tree|pwd|echo|printf|wc|sort|uniq|diff|file|stat|du|df)\b/,
	/^\s*(which|whereis|type|env|printenv|uname|whoami|id|date|jq|awk|bat)\b/,
	/^\s*sed\s+-n/i,
	/^\s*git\s+(status|log|diff|show|branch|remote|blame|config\s+--get)/i,
	/^\s*git\s+ls-/i,
	/^\s*npm\s+(list|ls|view|info|search|outdated|audit)/i,
	/^\s*gh\s+(pr|issue|repo|run)\s+(view|list|diff|checks)/i,
	/^\s*curl\s/i,
];

function isSafeCommand(command: string): boolean {
	return !DESTRUCTIVE_PATTERNS.some((p) => p.test(command)) && SAFE_PATTERNS.some((p) => p.test(command));
}

function isMarkdownInside(inputPath: string, cwd: string): boolean {
	if (!inputPath) return false;
	const rel = relative(resolve(cwd), resolve(cwd, inputPath));
	if (rel === "" || rel.startsWith("..") || isAbsolute(rel)) return false;
	return [".md", ".mdx"].includes(extname(inputPath).toLowerCase());
}

// Every `agent` named anywhere in a subagent call (single, parallel tasks, chain steps).
function collectAgents(value: unknown, agents: string[] = []): string[] {
	if (Array.isArray(value)) {
		for (const item of value) collectAgents(item, agents);
	} else if (value && typeof value === "object") {
		for (const [key, child] of Object.entries(value)) {
			if (key === "agent" && typeof child === "string") agents.push(child);
			else collectAgents(child, agents);
		}
	}
	return agents;
}

function subagentBlockReason(input: Record<string, unknown>): string | undefined {
	if (input.workflow !== undefined || input.script !== undefined) {
		return "workflows and scripts can't run while planning";
	}
	if (typeof input.action === "string") {
		return READ_ONLY_SUBAGENT_ACTIONS.has(input.action) ? undefined : `action "${input.action}" isn't available while planning`;
	}
	const blocked = collectAgents(input).filter((agent) => !READ_ONLY_AGENTS.has(agent));
	if (blocked.length > 0) {
		return `only read-only agents (${[...READ_ONLY_AGENTS].join(", ")}) can run while planning; blocked: ${blocked.join(", ")}`;
	}
	return undefined;
}

// --- plannotator-tui annotations -------------------------------------------

interface TuiAnnotation {
	id: string;
	body?: string;
	state?: string;
	updated_at?: string;
	anchor?: { quote?: string; plannotator_tui?: { kind?: string; quote?: string } };
}

// Same lookup order as plannotator-tui: PLANNOTATOR_DATA_DIR, an existing
// ~/.plannotator, $XDG_DATA_HOME/plannotator, then ~/.plannotator.
function plannotatorDataDir(): string {
	if (process.env.PLANNOTATOR_DATA_DIR) return process.env.PLANNOTATOR_DATA_DIR;
	const home = join(homedir(), ".plannotator");
	if (existsSync(home)) return home;
	if (process.env.XDG_DATA_HOME) return join(process.env.XDG_DATA_HOME, "plannotator");
	return home;
}

function readAnnotations(planPath: string): TuiAnnotation[] | undefined {
	const root = join(plannotatorDataDir(), "clients", "plannotator-tui", "annotations");
	if (!existsSync(root)) return undefined;
	for (const project of readdirSync(root, { withFileTypes: true })) {
		if (!project.isDirectory()) continue;
		for (const slug of readdirSync(join(root, project.name), { withFileTypes: true })) {
			const file = join(root, project.name, slug.name, "annotations.json");
			if (!slug.isDirectory() || !existsSync(file)) continue;
			try {
				const record = JSON.parse(readFileSync(file, "utf-8"));
				if (record.path && realpathSync(record.path) === planPath) return record.annotations ?? [];
			} catch {
				// Unreadable or stale record; keep looking.
			}
		}
	}
	return undefined;
}

function annotationKey(annotation: TuiAnnotation): string {
	return `${annotation.id}@${annotation.updated_at ?? ""}`;
}

function formatAnnotations(planPath: string, annotations: TuiAnnotation[]): string {
	const lines = [`# Annotations on ${planPath}`];
	annotations.forEach((annotation, i) => {
		const kind = annotation.anchor?.plannotator_tui?.kind ?? "comment";
		const quote = annotation.anchor?.plannotator_tui?.quote ?? annotation.anchor?.quote;
		const label = kind === "looks_good" ? "Looks good" : kind === "delete" ? "Delete" : "Comment on";
		lines.push("", `## Annotation ${i + 1}`, quote ? `${label}: "${quote}"` : label);
		if (annotation.body?.trim()) lines.push(`> ${annotation.body.trim().replace(/\n/g, "\n> ")}`);
	});
	return lines.join("\n");
}

function exportAnnotations(planPath: string): string | undefined {
	const result = spawnSync(TUI_BINARY, ["--export", planPath], { encoding: "utf-8" });
	const output = result.stdout?.trim();
	if (result.status !== 0 || !output || output === "No annotations.") return undefined;
	return output;
}

// Hand the terminal to plannotator-tui the way pi's external editor does.
function runTui(ctx: ExtensionContext, planPath: string): Promise<number | null> {
	return ctx.ui.custom<number | null>((tui, _theme, _keybindings, done) => {
		tui.stop();
		process.stdout.write("\x1b[2J\x1b[H");
		const child = spawn(TUI_BINARY, [planPath], { stdio: "inherit", env: process.env });
		const finish = (code: number | null) => {
			tui.start();
			tui.requestRender(true);
			done(code);
		};
		child.on("error", () => finish(null));
		child.on("close", (code) => finish(code));
		return { render: () => [], invalidate: () => {} };
	});
}

// --- extension ----------------------------------------------------------------

interface PlanReviewState {
	enabled: boolean;
	planPath?: string;
	delivered?: string[];
}

export default function planReview(pi: ExtensionAPI): void {
	let enabled = false;
	let planPath: string | undefined;
	let delivered = new Set<string>();
	let contextPending = false;

	function persist(): void {
		pi.appendEntry<PlanReviewState>(STATE_ENTRY, { enabled, planPath, delivered: [...delivered] });
	}

	function setSubmitToolActive(active: boolean): void {
		const tools = pi.getActiveTools().filter((name) => name !== SUBMIT_TOOL);
		pi.setActiveTools(active ? [...tools, SUBMIT_TOOL] : tools);
	}

	function updateStatus(ctx: ExtensionContext): void {
		ctx.ui.setStatus(STATE_ENTRY, enabled ? ctx.ui.theme.fg("warning", "⏸ plan") : undefined);
	}

	function enter(ctx: ExtensionContext, path: string | undefined): void {
		enabled = true;
		planPath = path?.trim() || undefined;
		delivered = new Set();
		contextPending = true;
		setSubmitToolActive(true);
		updateStatus(ctx);
		persist();
		ctx.ui.notify("Plan mode on. Writes are limited to markdown files; submit_plan opens plannotator-tui.");
	}

	function exit(ctx: ExtensionContext): void {
		enabled = false;
		contextPending = false;
		setSubmitToolActive(false);
		updateStatus(ctx);
		persist();
	}

	pi.registerCommand("plan", {
		description: "Toggle plan mode with plannotator-tui review (optional: plan file path)",
		handler: async (args, ctx) => {
			if (enabled) {
				exit(ctx);
				ctx.ui.notify("Plan mode off. Full access restored.");
			} else {
				enter(ctx, args);
			}
		},
	});

	pi.registerTool({
		name: SUBMIT_TOOL,
		label: "Submit Plan",
		// Run after any write/edit in the same batch so the reviewed file is current.
		executionMode: "sequential",
		description:
			"Submit the markdown plan file for review in plannotator-tui. Only available in plan mode. " +
			"The user annotates the plan and either sends feedback (revise the same file, then call this again) " +
			"or approves it for execution through pi-subagents.",
		parameters: Type.Object({
			path: Type.String({ description: "Path to the markdown plan file inside the working directory." }),
		}),
		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			const text = (value: string) => [{ type: "text" as const, text: value }];
			if (!enabled) {
				return { content: text("Error: plan mode is off. The user starts it with /plan."), details: {}, isError: true };
			}
			if (ctx.mode !== "tui") {
				return { content: text("Error: plan review needs the interactive terminal."), details: {}, isError: true };
			}
			const inputPath = (params as { path: string }).path;
			const absolute = resolve(ctx.cwd, inputPath);
			if (!isMarkdownInside(inputPath, ctx.cwd) || !existsSync(absolute)) {
				return {
					content: text(`Error: ${inputPath} must be an existing .md file inside the working directory.`),
					details: {},
					isError: true,
				};
			}
			planPath = inputPath;
			const realPath = realpathSync(absolute);

			const exitCode = await runTui(ctx, realPath);
			if (exitCode === null) {
				return {
					content: text(`Error: couldn't start ${TUI_BINARY}. Is it installed and on PATH?`),
					details: {},
					isError: true,
				};
			}

			let feedback: string | undefined;
			let newKeys: string[] = [];
			const annotations = readAnnotations(realPath);
			if (annotations) {
				const fresh = annotations.filter((a) => (a.state ?? "open") === "open" && !delivered.has(annotationKey(a)));
				newKeys = fresh.map(annotationKey);
				if (fresh.length > 0) feedback = formatAnnotations(inputPath, fresh);
			} else {
				feedback = exportAnnotations(realPath);
			}

			const approve = "Approve and execute with subagents";
			const revise = "Send feedback";
			const wait = "Keep planning";
			const choice = await ctx.ui.select(
				feedback ? `Plan review: ${newKeys.length || "new"} new note(s)` : "Plan review: no new notes",
				feedback ? [revise, approve, wait] : [approve, wait, revise],
			);

			for (const key of newKeys) delivered.add(key);

			if (choice === approve) {
				exit(ctx);
				const lines = [
					`Plan approved: ${realPath}`,
					"Plan mode is over and its restrictions no longer apply.",
					"Execute the plan by delegating to pi-subagents with the subagent tool; you are authorized to delegate.",
					"Pick the split that fits (worker, parallel tasks, chain, reviewer pass) and keep implementation out of this session.",
				];
				if (feedback) lines.push("", "Notes from the review:", "", feedback);
				return { content: text(lines.join("\n")), details: { approved: true } };
			}

			persist();
			if (choice === revise) {
				return {
					content: text(
						[
							feedback ?? "The user asked for changes but left no annotations. Ask them what to change.",
							"",
							`Revise ${inputPath} with targeted edits, then call ${SUBMIT_TOOL} again with the same path.`,
						].join("\n"),
					),
					details: { approved: false },
				};
			}
			return {
				content: text("The user is still reviewing the plan. Stop here and wait for their next message."),
				details: { approved: false },
				terminate: true,
			};
		},
	});

	pi.on("tool_call", async (event, ctx) => {
		if (!enabled) return;
		if (event.toolName === "write" || event.toolName === "edit") {
			const path = event.input.path as string;
			if (!isMarkdownInside(path, ctx.cwd)) {
				return { block: true, reason: `Plan mode: writes are limited to markdown files inside the working directory. Blocked: ${path}` };
			}
		} else if (event.toolName === "bash") {
			const command = event.input.command as string;
			if (!isSafeCommand(command)) {
				return { block: true, reason: `Plan mode: only read-only commands are allowed. Blocked: ${command}` };
			}
		} else if (event.toolName === "subagent") {
			const reason = subagentBlockReason(event.input as Record<string, unknown>);
			if (reason) return { block: true, reason: `Plan mode: ${reason}.` };
		}
	});

	// Deliver the planning instructions once per plan-mode entry.
	pi.on("before_agent_start", async () => {
		if (!enabled || !contextPending) return;
		contextPending = false;
		const target = planPath ? `Write the plan to ${planPath}.` : "Write the plan to plans/<short-name>.md.";
		return {
			message: {
				customType: CONTEXT_MESSAGE,
				display: false,
				content: [
					"[PLAN MODE]",
					"You are planning, not implementing. Don't change the codebase: writes are limited to markdown files,",
					"bash to read-only commands, and subagents to read-only agents.",
					"",
					`Explore the code, then keep a plan file up to date as you learn. ${target}`,
					"Structure it as Context, Approach, Files to modify, Reuse, Steps (a markdown checklist), and Verification.",
					"Ask the user when you hit a decision you can't settle from the code.",
					"",
					`When the plan is ready, call ${SUBMIT_TOOL} with its path. The user reviews it in plannotator-tui.`,
					`On feedback, edit the same file in place and call ${SUBMIT_TOOL} again.`,
					`End each turn either by asking the user a question or by calling ${SUBMIT_TOOL}.`,
				].join("\n"),
			},
		};
	});

	// Drop the planning instructions from context once plan mode is off.
	pi.on("context", async (event) => {
		if (enabled) return;
		return {
			messages: event.messages.filter(
				(m) => (m as AgentMessage & { customType?: string }).customType !== CONTEXT_MESSAGE,
			),
		};
	});

	pi.on("session_start", async (_event, ctx) => {
		const entry = ctx.sessionManager
			.getEntries()
			.filter((e: { type: string; customType?: string }) => e.type === "custom" && e.customType === STATE_ENTRY)
			.pop() as { data?: PlanReviewState } | undefined;
		enabled = entry?.data?.enabled ?? false;
		planPath = entry?.data?.planPath;
		delivered = new Set(entry?.data?.delivered ?? []);
		setSubmitToolActive(enabled);
		updateStatus(ctx);
	});
}
