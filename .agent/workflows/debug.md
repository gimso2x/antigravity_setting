---
description: Structured bug diagnosis and fixing workflow — reproduce, diagnose root cause, apply minimal fix, write regression test, and scan for similar patterns
---

# MANDATORY RULES — VIOLATION IS FORBIDDEN

- **NEVER skip steps.** Execute from Step 1 in order.
- **You MUST use local tools throughout the workflow.**
  - Use code analysis tools (grep, list_dir, local search) for bug investigation.
  - Read and write to files in the `.agent/tasks/` directory to record debugging results.
  - Track your progress step-by-step in `.agent/tasks/progress-debug.md`.
  - Base path: `.agent/tasks`

---

## Step 1: Collect Error Information

Ask the user for:
- Error message, steps to reproduce
- Expected vs actual behavior
- Environment (browser, OS, device)

If an error message is provided, proceed immediately.

---

## Step 2: Reproduce the Bug

// turbo
Use local text search (`grep_search`) with the error message or stack trace to locate the error in the codebase.
Use `grep_search` or directory listing (`list_dir`) to identify the exact function and file.

---

## Step 3: Diagnose Root Cause

Use local search tools (`grep_search`) to trace the execution path backward from the error point.
Identify the root cause — not just the symptom. Check:
- null/undefined access
- Race conditions
- Missing error handling
- Wrong data types
- Stale state

---

## Step 4: Propose Minimal Fix

Present the root cause and proposed fix to the user.
- The fix should change only what is necessary.
- Explain why this fixes the root cause, not just the symptom.
- **You MUST get user confirmation before proceeding to Step 5.**

---

## Step 5: Apply Fix and Write Regression Test

// turbo
1. Implement the minimal fix.
2. Write a regression test that reproduces the original bug and verifies the fix.
3. The test must fail without the fix and pass with it.

---

## Step 6: Scan for Similar Patterns

// turbo
Use local search tools (`grep_search`) to search the codebase for the same pattern that caused the bug.
Report any other locations that may have the same vulnerability. Fix them if confirmed.

---

## Step 7: Document the Bug

Save a bug report in `.agent/tasks/bug-report.md`:
- Symptom, root cause
- Fix applied, files changed
- Regression test location
- Similar patterns found
