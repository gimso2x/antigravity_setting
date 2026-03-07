---
description: PM planning workflow — analyze requirements, select tech stack, decompose into prioritized tasks with dependencies, and define API contracts
---

# MANDATORY RULES — VIOLATION IS FORBIDDEN

- **NEVER skip steps.** Execute from Step 1 in order.
- **You MUST use local task files throughout the workflow.**
  - Use code analysis tools (grep, list_dir, local search) to analyze the existing codebase.
  - Read and write to files in the `.agent/tasks/` directory to record planning results.
  - Base path: `.agent/tasks`
---

## Step 1: Gather Requirements

Ask the user to describe what they want to build. Clarify:
- Target users
- Core features (must-have vs nice-to-have)
- Constraints (tech stack, existing codebase)
- Deployment target (web, mobile, both)

---

## Step 2: Analyze Technical Feasibility

// turbo
If an existing codebase exists, use local code analysis tools to scan:
- directory listing (`list_dir`) for project structure and architecture patterns.
- text search (`grep_search`) to identify reusable code and what needs to be built.

---

## Step 3: Define API Contracts

// turbo
Design API contracts between frontend and backend. Per endpoint:
- Method, path, request/response schemas
- Auth requirements, error responses

---

## Step 4: Decompose into Tasks

// turbo
Break down the project into actionable tasks. Each task must have:
- Assigned agent (frontend/backend/mobile/qa/debug)
- Title, acceptance criteria
- Priority (P0-P3), dependencies

---

## Step 5: Review Plan with User

Present the full plan: task list, priority tiers, dependency graph, agent assignments.
**You MUST get user confirmation before proceeding to Step 6.**

---

## Step 6: Save Plan

// turbo
Save the approved plan:
1. `.agent/tasks/plan.md`
2. Write the plan summary into the task file directly.

The plan is now ready for `/coordinate` or `/orchestrate` to execute.
