# Pi with local Ollama on an M4 Max (64GB)

The dotfiles register these models on `http://127.0.0.1:11434/v1` and add them
to Pi's scoped model cycle on both work and personal machines.

| Model | Download size, approximately | Suggested use as the session model |
| --- | --- | --- | --- |
| `gemma4:12b-mlx` | 7.7GB | Short searches, extraction, bounded research |
| `qwen3.6:35b-mlx` | 23GB | General coding session and subagents |
| `qwen3.8:27b-mlx` | 18GB | Review, reasoning, ambiguous questions |

These are starting recommendations, not benchmarks on this machine. The 35B
Qwen is a mixture of experts with roughly 3B active parameters; its total
weights still need to fit in memory. Download size excludes runtime buffers
and context caches. Select one model per Pi session and let its subagents use
that same model. Loading all three models together leaves little of 64GB for
macOS, development tools, and caches. Ollama can serve multiple models when
memory permits, but the setup below caps residency at one. With one parallel
request per model, async subagents will queue. Launch local tasks sequentially.

## Setup

Inspection on 2026-11-02 found Ollama **0.24.0**, Pi **1.4.0**, and only
`qwen3-coder:30b` installed (GGUF, Q4_K_M). The new models have not been
downloaded or exercised. Upgrade Ollama to **0.40.0 or later** before using
this set; supported architectures use MLX by default from that release.
Explicit `-mlx` tags make the intended model variants visible in Pi.

Upgrade using the same method used to install the running Ollama server,
restart it, and check `ollama --version` and `/api/version` agree. Then:

```sh
ollama pull qwen3.6:35b-mlx
chezmoi diff ~/.pi/agent/models.json ~/.pi/agent/settings.json
chezmoi apply ~/.pi/agent/models.json ~/.pi/agent/settings.json
```

Pull `gemma4:12b-mlx` or `qwen3.8:27b-mlx` only if you want to try one as
the session model.

Fish shortcuts in `~/.config/fish/conf.d/ollama.fish` provide `ollama-start`
for the Homebrew service, `ollama-code` for Qwen 3.6, `ollama-meetings` for
Qwen 3.8, and `ollama-fast` for Gemma 4. For example:

```fish
ollama-code 'Explain this Go function'
ollama-meetings 'Summarize these meeting notes'
```

MacWhisper does not use shell aliases. In Settings > AI Services, add Ollama at
`http://localhost:11434`, refresh the model list, and select
`qwen3.8:27b-mlx` for meeting summaries. Download that model with
`ollama pull qwen3.8:27b-mlx` first. Try `gemma4:12b-mlx` if faster summaries
are more useful than the larger model's quality. Long transcripts still need
to fit the server context; increase it beyond 32K only after checking memory.

### Match the server context to Pi

The new Pi entries declare **32,768 tokens** of total context, with at most
8,192 output tokens. This is a conservative starting budget for this machine.
Pi's `contextWindow` is accounting metadata: it does **not** configure Ollama's
KV cache or server context. Configure the Ollama server process explicitly.
For a manually started server, stop the existing server first, then run:

```sh
OLLAMA_CONTEXT_LENGTH=32768 OLLAMA_NUM_PARALLEL=1 OLLAMA_MAX_LOADED_MODELS=1 ollama serve
```

For an app or service, set those variables in its launch environment and
restart it; exporting them only in the Pi shell does not change a running
Ollama server. Confirm the effective context with `ollama ps` after a request.
Alternatively, Ollama documents per-model `PARAMETER num_ctx` in a Modelfile;
if you create named variants, update Pi's model IDs to match. Increase server
context and Pi metadata together after measuring memory.
The pre-existing GGUF entry retains its original metadata; its 256K declaration
also needs a matching server context if you select it.

## Select models and check delegation

```sh
pi --provider ollama --model qwen3.6:35b-mlx
```

In Pi, `/model` selects a model and `/scoped-models` controls the cycle.
After reloading Pi, `/subagents-models` shows the effective role mapping.

`agentOverridesByProvider.ollama` activates when the **parent session** uses
the Ollama provider. All six configured roles inherit the parent's selected
model, so roles do not trigger model swaps. Scout and researcher have thinking
off; worker uses
medium and the review roles use high. These are Pi requests, not guaranteed
distinct reasoning budgets: the server/model may treat nonzero levels alike.
Project settings and explicit per-run overrides can replace this routing.
Other custom roles can specify their own models, so this mapping is not a
global offline enforcement policy.

The existing cloud startup default and cloud role mappings remain available.
The memory consolidation and interview generation settings still name cloud
models; switching the main model to Ollama alone is not a fully offline profile.
Async delegation remains enabled globally; launch local tasks sequentially to
avoid queued requests. Missing models fail rather than
silently downloading or falling back to a cloud provider.

The Docker `pisbx` kit includes the same model registry, but its loopback
address points inside the container. Host Ollama needs a separately configured
reachable endpoint before these models can work in that sandbox.

## Verification

Both `work` and `personal` settings templates rendered successfully through
`chezmoi execute-template` and parsed as JSON. All six Ollama role mappings
inherit the selected session model. `git diff --check` passed. These changes
are in the chezmoi source only; live configuration has not been applied and
MLX inference, tool calls, and reasoning behavior remain untested.

## Sources

- [Pi compatible endpoints and scoped models](https://pi.dev/docs/latest/models)
- [pi-subagents override precedence and provider routing](https://github.com/nicobailon/pi-subagents/blob/main/docs/models.md)
- [Ollama 0.40.0 MLX defaults](https://github.com/ollama/ollama/releases/tag/v0.40.0)
- [Gemma 4 variants](https://ollama.com/library/gemma4)
- [Qwen 3.6 variants](https://ollama.com/library/qwen3.6)
- [Qwen 3.8 variants](https://ollama.com/library/qwen3.8)
- [Ollama OpenAI compatibility and context setup](https://docs.ollama.com/api/openai-compatibility)
