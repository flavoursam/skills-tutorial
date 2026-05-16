---
name: release-check
description: A slash command that runs a full pre-release checklist for a given version tag. Runs a preflight shell script first, then orchestrates two sequential agents to draft a changelog and verify version consistency. Invoked as /release-check <version>.
argument-hint: <version> (e.g. v1.2.0)
allowed-tools: [Bash, Agent]
---

# Skill 5: /release-check (Full Pipeline — Scripts + Sequential Agents)

> **Tutorial note — what you're learning here:**
> This is the full pattern. It combines three things:
> 1. A **shell script** for deterministic preflight checks (git status, test runner)
> 2. A **sequential agent pipeline** — changelog writer first, then version checker
> 3. A **structured output artifact** — a release readiness report
>
> The key new concept: *when to use a script vs an agent.*
> Scripts for deterministic tasks (pass/fail, grep, run tests).
> Agents for judgment tasks (writing prose, consistency analysis).

## What This Command Does

Runs a full pre-release pipeline for version `$ARGUMENTS`:
1. Preflight script — checks git cleanliness and runs tests
2. Changelog agent — drafts a CHANGELOG entry from git log since last tag
3. Version checker agent — verifies version numbers are consistent across files
4. Produces a release readiness report

## Arguments

The version to release: `$ARGUMENTS` (required, e.g. `v1.2.0`)

## Instructions

**Guard clause:** If `$ARGUMENTS` is empty, reply: "Usage: /release-check <version>" and stop.

---

### Step 1 — Run Preflight Script (BLOCKING — must pass before continuing)

Run the preflight script:
```bash
bash ~/.claude/plugins/skills-tutorial/skills/release-check/scripts/preflight.sh "$ARGUMENTS"
```

The script exits 0 on success, non-zero on failure. It prints its own output.

**If the script exits non-zero:**
- Show the script output
- Print: "Preflight failed. Fix the issues above before releasing."
- STOP — do not proceed to agents

**If the script exits 0:** Continue to Step 2.

---

### Step 2 — Changelog Agent (spawn and wait)

Spawn the changelog writer with this task:
"Draft a CHANGELOG.md entry for version $ARGUMENTS in the current directory.
Use git log to find all commits since the last git tag (or since the beginning if no tags exist).
Group commits into: Features, Bug Fixes, Internal/Refactoring.
Use standard Keep a Changelog format."

Use agent definition: @agents/changelog-writer.md

Wait for this agent to complete before continuing.

---

### Step 3 — Version Checker Agent (spawn and wait)

Spawn the version checker with this task:
"Check that the version $ARGUMENTS appears consistently across all version-declaring files
in the current directory (package.json, pyproject.toml, setup.py, Cargo.toml, VERSION, etc.).
Report which files have the version set and whether they all match $ARGUMENTS."

Use agent definition: @agents/version-checker.md

Wait for this agent to complete.

---

### Step 4 — Produce Release Readiness Report

Synthesize all results into this report:

```
## Release Readiness Report — $ARGUMENTS
Generated: [date]

### Preflight ✓
[preflight script summary]

### Changelog Draft
[changelog-writer output]

### Version Consistency
[version-checker output]

### Release Status
[One of:]
✅ READY TO RELEASE — all checks passed
⚠️  REVIEW NEEDED — [list specific issues]
❌ NOT READY — [list blocking issues]
```

---

## How This Skill Works (Tutorial Explanation)

**Scripts vs Agents — the decision rule:**
| Task | Use |
|------|-----|
| Is the directory clean? (`git status`) | Script |
| Do tests pass? (`pytest`, `npm test`) | Script |
| Does a pattern exist in files? (`grep`) | Script |
| Write a CHANGELOG entry | Agent (judgment) |
| Are version numbers consistent? | Agent (judgment across many file formats) |
| Summarize recent commits | Agent |

Scripts are fast, deterministic, and don't consume tokens.
Agents are flexible, can handle ambiguity, and produce prose.

**Sequential pipeline:**
Unlike Skill 4 where agents ran in parallel, this pipeline is sequential:
- Preflight MUST pass before agents run (no point drafting a changelog if the repo is dirty)
- Changelog runs before version checker (consistent ordering, cleaner report)

**The exit code contract:**
The preflight script communicates success/failure through its exit code (0 = pass, non-zero = fail).
This is the Unix convention — skills can leverage any shell tool that follows it.

**`scripts/` directory:**
Shell scripts, Python scripts, any executable — bundled alongside the skill.
Claude runs them via Bash, capturing output and exit codes.

**Try it:** In a project with git history, type `/release-check v0.1.0`.
If you have no version files, that's fine — the version checker will say so.
