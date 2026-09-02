# loadline

**A Claude Code status line that tells you how full your context actually is.**

```
Opus 5 (1M context) · my-project · ⎇ main · ██████░░░░ 62% 628k
```

One shell script. No API key, no network, no telemetry, no npm tree. It reads the transcript
Claude Code already writes to your disk and does arithmetic.

```bash
curl -fsSL https://raw.githubusercontent.com/SharminSirajudeen/loadline/main/install.sh | bash
```

Restart Claude Code. That's it.

---

## Why this exists

I was in a long session and wanted to know how close I was to filling the window. The tool I
was using told me **307%**.

The real answer was **62%**.

The tool assumed a 200,000-token context window. I was on a 1M-context model. It was dividing
by the wrong number and had been for the entire session — and because "307%" is obviously
nonsense, I ignored it, which meant I had no signal at all.

`loadline` reads the model name and divides by the right window.

## What it shows, and why only this

```
Opus 5 (1M context) · my-project · ⎇ main · ██████░░░░ 62% 628k
└─ model            └─ dir      └─ branch └─ load line, % of window, tokens
```

The bar is a **Plimsoll line** — the mark on a ship's hull showing how deep it may safely sit.
Green under 50%, amber under 80%, red above.

**There is deliberately no dollar figure.** I built one first, then measured it: my estimate
and another popular tool's estimate disagreed with Claude Code's own reported cost by 12% and
33% respectively, in opposite directions, with a standard deviation of 0.001 across repeated
readings — a stable, systematic error neither tool discloses. The transcript does not carry
enough information to reconstruct billing, so any number reconstructed from it is a guess
wearing a dollar sign. Claude Code itself knows; nothing else does.

Also: if you are on a subscription, cost is not your constraint. **The context window is.**

## Configuration

Auto-detects the window from the model name. Override if it guesses wrong:

```bash
LOADLINE_WINDOW=200000   # force a 200K window
```

Install elsewhere with `LOADLINE_DIR=/some/path`.

To wire it up by hand, in `~/.claude/settings.json`:

```json
{ "statusLine": { "type": "command", "command": "$HOME/.claude/scripts/loadline" } }
```

## Requirements

`jq`, `awk`, `bash`. Nothing else. Renders in ~70ms on a 3.5MB transcript because it reads only
the tail of the file, not the whole thing.

## What it is not

Not a cost tracker — see above. If you want spend reporting across many agent CLIs,
[ccusage](https://github.com/ryoppippi/ccusage) is far more complete than this will ever be;
just be aware of the window assumption and check its numbers against Claude Code's own.

## Licence

MIT.
