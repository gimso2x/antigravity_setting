---
description: Full QA review pipeline — security audit (OWASP Top 10), performance analysis, accessibility check (WCAG 2.1 AA), and code quality review
---

# MANDATORY RULES — VIOLATION IS FORBIDDEN

- **NEVER skip steps.** Execute from Step 1 in order.
- **You MUST use local tools throughout the workflow.**
  - Use code analysis tools (grep, list_dir, local search) for code analysis and review.
  - Read and write to files in the `.agent/tasks/` directory to record review results.
  - Track your progress step-by-step in `.agent/tasks/progress-qa.md`.
  - Base path: `.agent/tasks`

---

## Step 1: Identify Review Scope

Ask the user what to review: specific files, a feature branch, or the entire project.
If a PR or branch is provided, diff against the base branch to scope the review.

---

## Step 2: Run Automated Security Checks

// turbo
Run available security tools: `npm audit` (Node.js), `bandit` (Python), or equivalent.
Check for known vulnerabilities in dependencies. Flag any CRITICAL or HIGH findings.

---

## Step 3: Manual Security Review (OWASP Top 10)

Use local code analysis tools (`grep_search` and `list_dir`) to review code for:
- Injection (SQL, XSS, command)
- Broken auth, sensitive data exposure
- Broken access control, security misconfig
- Insecure deserialization
- Known vulnerable components
- Insufficient logging

---

## Step 4: Performance Analysis

Use local tools to check for:
- N+1 queries, missing indexes
- Unbounded pagination, memory leaks
- Unnecessary re-renders (React)
- Missing lazy loading
- Large bundle sizes, unoptimized images

---

## Step 5: Accessibility Review (WCAG 2.1 AA)

Check for:
- Semantic HTML, ARIA labels
- Keyboard navigation, color contrast
- Focus management, screen reader compatibility
- Image alt text

---

## Step 6: Code Quality Review

Use local code analysis tools (`grep_search` and `list_dir`) to check for:
- Consistent naming, proper error handling
- Test coverage, TypeScript strict mode compliance
- Unused imports/variables
- Proper async/await usage
- Public API documentation

---

## Step 7: Generate QA Report

Compile all findings into a prioritized report:
- **CRITICAL**: Security breaches, data loss risks
- **HIGH**: Blocks launch
- **MEDIUM**: Fix this sprint
- **LOW**: Backlog

Each finding must include: `file:line`, description, and remediation code.
Save the final report to `.agent/tasks/result-qa.md` (or `result-{agent}.md` format).
