---
name: daily-brief
description: A slash command that generates a daily project brief by orchestrating three parallel subagents — one reads recent git commits, one reads NOTES.md, one scans for TODO/FIXME items. Invoked as /daily-brief.
argument-hint: [project-path]
allowed-tools: [Agent]
---

# Skill 4: /daily-brief (Orchestration with Subagents)

> **Tutorial note — what you're learning here:**
> This skill introduces *orchestration* — the most powerful pattern in Claude Code skills.
> Instead of one Claude doing everything serially, this skill spawns 3 specialized subagents
> that run IN PARALLEL, then synthesizes their output. Each agent has a narrow, focused job.
> The skill is the conductor; the agents are the musicians.

## What This Command Does

Spawns 3 parallel subagents to gather project intelligence, then synthesizes a concise daily
brief covering: recent commits, saved notes, and open TODO items.

## Arguments

Optional project path: `$ARGUMENTS` (defaults to current directory if empty)

## Instructions

Determine the target directory:
- If `$ARGUMENTS` is provided, use that path
- Otherwise, use the current working directory

**Step 1 — Spawn all 3 agents IN PARALLEL (single message, multiple tool calls):**

Spawn these three agents simultaneously using the `Agent` tool:

**Agent 1 — git-reader** (`@agents/git-reader.md`):
- Task: "Read the git log for the last 7 days in [target directory] and summarize the recent work."

**Agent 2 — notes-reader** (`@agents/notes-reader.md`):
- Task: "Read NOTES.md in [target directory] and extract the 5 most recent notes."

**Agent 3 — todo-scanner** (`@agents/todo-scanner.md`):
- Task: "Scan all source files in [target directory] for TODO and FIXME comments and list them."

**Step 2 — Wait for all 3 agents to complete.**

**Step 3 — Synthesize a brief with this structure:**

```
## Daily Brief — [date]

### Recent Work (last 7 days)
[git-reader summary — 3-5 bullet points]

### Notes
[notes-reader output — most recent 5 notes]

### Open TODOs
[todo-scanner output — grouped by file]

### Today's Focus
[1-2 sentence synthesis: based on the above, what's the most important thing to work on today?]
```

---

## How This Skill Works (Tutorial Explanation)

**Why orchestration matters:**
Serial execution: Claude reads git log → reads notes → scans TODOs → synthesizes. Total: ~30s.
Parallel execution: All 3 run simultaneously → synthesize. Total: ~10s.
But speed isn't the only benefit. Each agent is a *specialist* — it gets a focused prompt,
focused context, and produces higher-quality output than one generalist doing everything.

**The `agents/` directory:**
Each `.md` file in `agents/` defines a specialized Claude instance with its own:
- System prompt (what it knows and how it behaves)
- Model override (use Haiku for simple reads, Opus for complex judgment)

**Parallel vs sequential:**
- Parallel: agents that don't depend on each other → spawn in one message
- Sequential: when Agent B needs Agent A's output → spawn A, wait, then spawn B
This skill is fully parallel. Skill 5 shows a sequential pipeline.

**`@agents/git-reader.md` syntax:**
When you reference `@agents/filename.md` in an Agent spawn, Claude loads that file as
the agent's instructions. You're not spawning a generic Claude — you're spawning a
Claude that has read a specific prompt defining its role and behaviour.

**Try it:** Open a project with some git history and type `/daily-brief`.
Watch as 3 agents run in parallel and their output is synthesized for you.
