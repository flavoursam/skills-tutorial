# Personal Code Style Guide

This is Sam's personal style guide used by the `/review-file` skill.
Edit this file to add, remove, or modify rules. Changes take effect immediately.

---

## General Rules

### Rule: no-obvious-comments
Do not add comments that describe *what* the code does — the code itself does that.
Only allow comments that explain *why* something non-obvious is done.
**Bad:** `# increment counter`
**Good:** `# offset by 1 because the API uses 1-based indexing`

### Rule: explicit-over-clever
Prefer explicit, readable code over one-liners or clever tricks.
A future reader should understand the intent in 5 seconds.
**Bad:** `result = [x for x in items if x][0] if items else None`
**Good:** A named variable or a short function with a clear name

### Rule: no-magic-numbers
Any numeric literal that isn't 0 or 1 must be assigned to a named constant.
**Bad:** `if retries > 3:`
**Good:** `MAX_RETRIES = 3` / `if retries > MAX_RETRIES:`

### Rule: single-responsibility
Functions should do one thing. If the function name contains "and", it probably does two things.
**Bad:** `def fetch_and_parse_and_save(url):`
**Good:** Three separate functions, composed by a caller

---

## Python-Specific Rules

### Rule: py-type-hints
Top-level functions must have type annotations on parameters and return values.
**Bad:** `def get_user(id):`
**Good:** `def get_user(id: int) -> User:`

### Rule: py-no-bare-except
Never use a bare `except:` clause — always catch a specific exception type.
**Bad:** `except:`
**Good:** `except ValueError:` or `except (KeyError, TypeError):`

### Rule: py-f-strings
Use f-strings for string interpolation; avoid `.format()` and `%` formatting.
**Bad:** `"Hello, %s" % name`
**Good:** `f"Hello, {name}"`

---

## JavaScript/TypeScript-Specific Rules

### Rule: ts-explicit-types
Avoid using `any` type. If the type is genuinely unknown, use `unknown` and narrow it.
**Bad:** `function process(data: any)`
**Good:** `function process(data: unknown)`

### Rule: js-const-first
Default to `const`. Use `let` only when reassignment is necessary. Never use `var`.

### Rule: js-no-implicit-return
Arrow functions that span multiple lines must use an explicit `return` statement.
**Bad:** `const fn = (x) => { x + 1 }`
**Good:** `const fn = (x) => { return x + 1 }`

---

## Naming Rules

### Rule: descriptive-names
Variable and function names should be self-describing — avoid single letters except loop
indices (`i`, `j`) and conventional math variables.
**Bad:** `d`, `tmp`, `data2`, `x`
**Good:** `elapsed_seconds`, `retry_count`, `user_record`

### Rule: boolean-names
Boolean variables and functions should read as yes/no questions.
**Bad:** `active`, `check_auth()`
**Good:** `is_active`, `has_permission()`
