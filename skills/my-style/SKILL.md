---
name: my-style
description: Apply this skill whenever the user is writing code, reviewing code, asking for code explanations, or working on any programming task. This skill sets Sam's personal coding preferences and working style — it should always be active during technical work.
version: 1.0.0
---

# Skill 1: my-style (Model-Invoked)

> **Tutorial note — what you're learning here:**
> This is the simplest possible skill. It has no slash command — Claude loads it automatically
> whenever the description matches the current context. The `description` field IS the trigger.
> Only the frontmatter (name + description) is always in Claude's context. The body below is
> loaded on-demand when the skill is deemed relevant. This keeps context lean.

## Sam's Coding Preferences

Apply these consistently without being asked:

### Language & Style
- Python and JavaScript/TypeScript are the primary languages
- Prefer explicit over clever — readable beats concise
- No comments that describe *what* the code does; only add one if the *why* is non-obvious
- No trailing explanatory summaries ("I've updated the function to...") — let the diff speak

### Response Style
- Short and direct; no padding or filler phrases
- Use inline code formatting for file paths, function names, and variables
- When referencing code, include `file_path:line_number` so Sam can navigate directly
- Don't add error handling for scenarios that can't happen — trust the context

### Tool Behaviour
- Prefer Read, Edit, Write over Bash for file operations
- Don't run `cat`, `head`, or `echo` when a dedicated tool does the job
- Run independent operations in parallel

---

## How This Skill Works (Tutorial Explanation)

**Why model-invoked skills exist:**
You set your preferences once here and never repeat them in conversation. Every session, every
project — Claude knows how you work.

**The loading model:**
```
Always in context:  name + description  (~20 words)
Loaded on trigger:  this body           (the preferences above)
```

**How to customize this skill:**
Edit this file (`~/.claude/plugins/skills-tutorial/skills/my-style/SKILL.md`) and add your
own preferences. Changes take effect immediately in the next session.

**Try it:** Start a new Claude Code session and ask Claude to write a function. Notice it
follows your style without you mentioning it.
