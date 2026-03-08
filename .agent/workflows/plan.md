---
description: PM planning workflow — analyze requirements, select tech stack, decompose into prioritized tasks with dependencies, and define API contracts
---

# MANDATORY RULES — VIOLATION IS FORBIDDEN

- **NEVER skip steps.** Execute from Step 1 in order.
- **You MUST use local task files throughout the workflow.**
  - Use code analysis tools (grep, list_dir, local search) to analyze the existing codebase.
  - Read and write to files in the `.agent/tasks/` directory to record planning results.
  - Track your progress step-by-step in `.agent/tasks/progress-pm.md`.
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

## Step 5: Risk Assessment & Rollback Strategy

// turbo
각 페이즈에 대해 리스크를 식별하고 롤백 전략을 수립합니다.

**리스크 식별 (4대 영역)**:
- **기술 리스크**: API 변경, 성능 이슈, 데이터 마이그레이션
- **의존성 리스크**: 외부 라이브러리 업데이트, 서드파티 서비스 가용성
- **일정 리스크**: 복잡도 미지수, 차단 의존성
- **품질 리스크**: 테스트 커버리지 갭, 회귀 가능성

**평가 매트릭스**:

| 리스크 | 확률 (Low/Mid/High) | 영향 (Low/Mid/High) | 완화 전략 |
|--------|---------------------|---------------------|----------|
| (식별된 리스크 기입) | | | |

**롤백 전략**: 각 페이즈별로 실패 시 되돌리는 방법을 명시합니다.
- 어떤 코드 변경을 되돌려야 하는지
- DB 마이그레이션 롤백 필요 여부
- 설정 복원 항목

---

## Step 6: Review Plan with User

Present the full plan: task list, priority tiers, dependency graph, agent assignments, **risk assessment**.
**You MUST get user confirmation before proceeding to Step 7.**

---

## Step 7: Save Plan

// turbo
Save the approved plan:
1. `.agent/tasks/plan.md`
2. Update `.agent/plan.json` if necessary according to `pm-agent` rules.

The plan is now ready for `frontend-agent`, `qa-agent`, etc. to execute by reading the task board.
