# Notes

- [2026-05-16 21:01] pick up pants from tailor tomorrow
- [2026-05-16 21:08] another note
- [2026-05-17 08:47] Daily brief: plugin consolidation done (review-file moved to personal-skills), codebase clean, no open TODOs — focus on new skills or personal-skills functionality

## Session summary — 2026-05-16

### Skills setup this session

| Skill | Plugin | Scope | How to invoke |
|---|---|---|---|
| `my-style` | personal-skills | user (global) | Automatic — loads on any coding task |
| `note` | personal-skills | user (global) | `/note <text>` — appends timestamped note to NOTES.md |
| `publish-skill` | personal-skills | user (global) | `/publish-skill "msg"` or `/publish-skill <path/to/skill>` |
| `daily-brief` | skills-tutorial | user (global, tutorial) | `/daily-brief` — git + notes + TODO summary |
| `review-file` | skills-tutorial | user (global, tutorial) | `/review-file <path>` — code review against style guide |
| `release-check` | skills-tutorial | user (global, tutorial) | `/release-check <version>` — pre-release checklist |

### Key locations

- **Global skills plugin**: `~/Documents/Claude/personal-skills/` — add new skills here
- **Tutorial plugin**: `~/Documents/Claude/Projects/skills-tutorial/` — reference/learning
- **Plugin registry**: `~/.claude/plugins/installed_plugins.json`
- **Local marketplace**: `~/.claude/local-marketplace/.claude-plugin/marketplace.json`

### How to add a new global skill

1. Create `~/Documents/Claude/personal-skills/skills/<name>/SKILL.md`
2. Run `/publish-skill "add <name>"` — handles git commit + cache update automatically

### Known limitation

`claude plugin update` fails for local plugins on Claude Code 2.1.143. `/publish-skill` works around this by manually copying to the cache and updating `installed_plugins.json`.
