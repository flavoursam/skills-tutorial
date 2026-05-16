---
name: note
description: A slash command for quickly saving timestamped notes to NOTES.md in the current project. Invoked by the user as /note <text>.
argument-hint: <your note text>
allowed-tools: [Read, Write, Bash]
---

# Skill 2: /note (Command Skill)

> **Tutorial note — what you're learning here:**
> This is your first slash command. Three new frontmatter fields appear:
> - `argument-hint`: shown in autocomplete to remind you what to type
> - `allowed-tools`: pre-approves specific tools so Claude doesn't prompt for permission
> Unlike Skill 1, this skill only runs when you explicitly type `/note`.

## What This Command Does

Appends a timestamped note to `NOTES.md` in the current working directory.

## Arguments

The user typed: `$ARGUMENTS`

## Instructions

1. Get today's date and time by running: `date '+%Y-%m-%d %H:%M'`
2. Check if `NOTES.md` exists in the current directory
3. If it doesn't exist, create it with a `# Notes` heading
4. Append this line to `NOTES.md`:
   ```
   - [YYYY-MM-DD HH:MM] <the note text from $ARGUMENTS>
   ```
5. Confirm to the user: "Note saved." (nothing else)

## Example

User types: `/note Fixed the login redirect bug — was missing the return statement`

`NOTES.md` gets:
```markdown
# Notes

- [2026-05-16 14:32] Fixed the login redirect bug — was missing the return statement
```

---

## How This Skill Works (Tutorial Explanation)

**Why command skills exist:**
Some workflows are triggered by the user, not by context. Slash commands give you a
keyboard-shortcut-style interface to repeatable tasks.

**`argument-hint`:**
When you type `/note` in Claude Code, you'll see `<your note text>` as a hint.
This is purely cosmetic — it guides you on what to pass.

**`allowed-tools`:**
Without this, Claude would prompt for permission every time it runs `date` or writes a file.
With `allowed-tools: [Read, Write, Bash]`, those tools are pre-approved for this skill only.

**`$ARGUMENTS`:**
Everything the user types after `/note ` becomes `$ARGUMENTS`. The skill body is a template
that references this variable — Claude substitutes it at runtime.

**Try it:** Type `/note this is my first skill note` in any project.
