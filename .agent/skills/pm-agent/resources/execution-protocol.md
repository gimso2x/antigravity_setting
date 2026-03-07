# PM Agent - Execution Protocol

## Step 0: Prepare
1. **Assess difficulty** — see `../_shared/difficulty-guide.md`
   - **Simple**: Lightweight plan, 3-5 tasks | **Medium**: Full 4 steps | **Complex**: Full + API contracts
2. **Clarify requirements** — follow `../_shared/clarification-protocol.md` (critical for PM)
   - Check **Uncertainty Triggers**: business logic, security/auth, existing code conflicts?
   - Determine level: LOW → proceed | MEDIUM → present options | HIGH → ask immediately
3. **Use reasoning templates** — for architecture decisions, use `../_shared/reasoning-templates.md` (decision matrix)
4. **Check lessons** — read cross-domain section in `../_shared/lessons-learned.md`

**⚠️ Intelligent Escalation**: When uncertain, escalate early. Don't blindly proceed.

Follow these steps in order (adjust depth by difficulty).

## Step 1: Analyze Requirements
- Parse user request into concrete requirements
- Identify explicit and implicit features
- List edge cases and assumptions
- Ask clarifying questions if ambiguous
- Use local code analysis (`list_dir`, `grep_search`) if there is an existing codebase to understand current architecture

## Step 2: Design Architecture
- Select tech stack (frontend, backend, mobile, database, infra)
- Define API contracts (method, path, request/response schema)
- Design data models (tables, relationships, indexes)
- Identify security requirements (auth, validation, encryption)
- Plan infrastructure (hosting, caching, CDN, monitoring)

## Step 3: Decompose Tasks
- Break into tasks completable by a single agent
- Each task has: agent, title, description, acceptance criteria, priority, dependencies
- Minimize dependencies for maximum parallel execution
- Priority tiers: 1 = independent (run first), 2 = depends on tier 1, etc.
- Complexity: Low / Medium / High / Very High
- Save to `.agent/plan.json` and `.agent/brain/current-plan.md`

### Phase Sizing 가이드라인

| 규모 | 페이즈 수 | 예상 시간 | 예시 |
|------|----------|----------|------|
| **Small** | 2-3 | 3-6h | 다크모드 토글, 새 폼 컴포넌트, 단일 API 엔드포인트 |
| **Medium** | 4-5 | 8-15h | 인증 시스템, 검색 기능, CRUD 모듈 |
| **Large** | 6-7 | 15-25h | AI 검색, 실시간 협업, 대규모 리팩토링 |

- 각 페이즈는 **1-4시간 이내**에 완료 가능한 단위로 분해
- 페이즈별 Quality Gate를 통과해야 다음 페이즈 진행 가능
- 계획 문서는 `resources/plan-template.md` 템플릿 활용

## Step 4: Validate Plan
- Check: Can each task be done independently given its dependencies?
- Check: Are acceptance criteria measurable and testable?
- Check: Is security considered from the start (not deferred)?
- Check: Are API contracts defined before frontend/mobile tasks?
- Output task-board.md for task tracking

## On Error
See `resources/error-playbook.md` for recovery steps.
