# PM Agent - Error Recovery Playbook

When you encounter a failure during planning, follow these recovery steps.

---

## Requirements Ambiguous

**Symptoms**: User request is vague ("Make me a good app", "Make it better")

1. Break down what you DO understand
2. List specific assumptions you're making
3. Create plan based on reasonable assumptions
4. Mark assumptions clearly: `⚠️ Assumption: [description]`
5. **NEVER do this**: Create tasks while still ambiguous — agents will lose direction

---

## Existing Codebase Unknown

**Symptoms**: Planning for an existing project but don't know the architecture

1. Use `list_dir` ("src/") or `list_dir` ("app/")
2. Look for framework indicators: `package.json`, `pyproject.toml`, `pubspec.yaml`
3. Check for existing patterns: `grep_search` ("@app.get|@app.post") (FastAPI)
4. If code is completely unavailable: note in plan "architecture assumptions — verify before execution"

---

## Task Decomposition Too Granular or Too Coarse

**Self-check**:
- Each task should take 1 agent, 10-20 turns
- If a task needs < 5 turns: merge with a related task
- If a task needs > 30 turns: split into sub-tasks
- If unsure: err on the side of fewer, larger tasks

---

## Dependency Deadlock

**Symptoms**: Task A depends on B, B depends on A (circular)

1. Identify the cycle
2. Break it by defining an API contract or shared interface first
3. Create a priority-0 task: "Define API contracts" (no dependencies)
4. Both tasks then depend on the contract, not on each other

---

## Tech Stack Decision Unclear

**Symptoms**: Multiple valid options, no clear winner

1. Check existing codebase — consistency wins over "better" tech
2. If greenfield: use the project's default stack (see SKILL.md tech-stack references)
3. Default choices:
   - Frontend: Next.js 15 + TypeScript + module.scss
4. Note decision rationale in plan: `tech_decision: { choice: "X", reason: "Y" }`

---

## Quota Issues

If rate-limited, stop API calls, save progress, and record `Status: quota_exceeded`.

---

## State Storage Error

If `.agent/tasks/` is not writeable, fall back to outputting the complete plan structure to standard output.

---

## General Principles

- **Plans are not code**: They don't need to be perfect. Agents can adjust during execution
- **Blocked**: If no progress after 5 turns, save current state, `Status: blocked`
- **No code writing**: PM only plans — delegate implementation to other agents
