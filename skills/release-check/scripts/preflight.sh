#!/usr/bin/env bash
# Pre-release preflight checks
# Exits 0 if all checks pass, 1 if any fail.
# Usage: preflight.sh <version>

VERSION="${1:-unknown}"
PASS=true

echo "=== Preflight: $VERSION ==="
echo ""

# Check 1: Is this a git repo?
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "❌ Not a git repository"
  exit 1
fi
echo "✓ Git repository detected"

# Check 2: No uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "❌ Uncommitted changes detected:"
  git status --short
  PASS=false
else
  echo "✓ Working tree is clean"
fi

# Check 3: No untracked files (optional — comment out if too strict)
UNTRACKED=$(git ls-files --others --exclude-standard | grep -v "NOTES.md" | wc -l | tr -d ' ')
if [ "$UNTRACKED" -gt 0 ]; then
  echo "⚠️  $UNTRACKED untracked file(s) (non-blocking)"
  git ls-files --others --exclude-standard | grep -v "NOTES.md" | head -5
else
  echo "✓ No untracked files"
fi

# Check 4: Run tests (if a test runner is detected)
echo ""
echo "--- Test Runner ---"
if [ -f "package.json" ] && grep -q '"test"' package.json 2>/dev/null; then
  echo "Running: npm test"
  if npm test --silent 2>&1; then
    echo "✓ Tests passed"
  else
    echo "❌ Tests failed"
    PASS=false
  fi
elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || find . -name "test_*.py" -maxdepth 3 | grep -q .; then
  echo "Running: python -m pytest -q"
  if python -m pytest -q 2>&1; then
    echo "✓ Tests passed"
  else
    echo "❌ Tests failed"
    PASS=false
  fi
else
  echo "⚠️  No test runner detected (skipping)"
fi

echo ""
echo "=== Preflight Complete ==="

if [ "$PASS" = true ]; then
  echo "✅ All checks passed — ready to proceed"
  exit 0
else
  echo "❌ Some checks failed — fix before releasing"
  exit 1
fi
