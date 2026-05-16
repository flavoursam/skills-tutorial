---
name: review-file
description: A slash command that reviews a source code file against a bundled personal style guide. Invoked as /review-file <path>. Use this when the user wants a code review of a specific file.
argument-hint: <file-path>
allowed-tools: [Read]
---

# Skill 3: /review-file (Command with Bundled References)

> **Tutorial note — what you're learning here:**
> Skills can bundle their own reference material in subdirectories. The `references/` folder
> lives *inside* this skill's directory and travels with it. This is how you give Claude
> domain knowledge (style guides, schemas, API docs) without pasting it into every conversation.
> The reference file is loaded via `@path` notation in the skill body.

## What This Command Does

Reviews a source code file against your personal style guide and reports issues.

## Arguments

The file to review: `$ARGUMENTS`

## Instructions

1. Read the file at the path provided: `$ARGUMENTS`
2. Load and internalize the style guide: @references/style-guide.md
3. Review the file against every rule in the style guide
4. Produce a report with this structure:

```
## Code Review: <filename>

### Passes ✓
- <rule that is followed>
- ...

### Issues
- **Line N** [Rule: <rule name>] — <what's wrong and how to fix it>
- ...

### Summary
<1-2 sentences on overall quality>
```

5. If the file path doesn't exist or can't be read, say so clearly and stop.

---

## How This Skill Works (Tutorial Explanation)

**Why bundled references exist:**
Imagine explaining your entire style guide every time you ask for a code review.
Instead, you encode it once in `references/style-guide.md` and the skill loads it automatically.
This also makes the skill portable — share this folder and your style guide comes with it.

**The `@references/style-guide.md` syntax:**
The `@` prefix tells Claude to load the contents of that file relative to the skill directory.
You can reference as many files as you need — references/, examples/, schemas/, etc.

**Why this is better than putting it in SKILL.md:**
- Separation of concerns: instructions vs. knowledge
- You can update the style guide without touching the skill logic
- Reference files can be long without bloating the skill itself

**The directory structure:**
```
skills/review-file/
├── SKILL.md                ← you are here (instructions)
└── references/
    └── style-guide.md      ← loaded when the skill runs
```

**Try it:** Type `/review-file <path/to/any/file.py>` in a project with Python code.
Customize `references/style-guide.md` to add your own rules.
