# Dynamic Context Loading Guide

에이전트는 리소스를 한 번에 모두 읽지 않고, 작업 유형에 따라 필요한 것만 로드합니다.

---

## 로딩 순서

### 항상 로드 (필수)
1. `SKILL.md` — 자동 로드 (Antigravity 제공)
2. `resources/execution-protocol.md` — 실행 프로토콜

### 난이도별 로드
- **Simple**: 추가 로딩 없이 구현 진행
- **Medium**: `resources/examples.md` (유사 예제 참고)
- **Complex**: `resources/examples.md` + `resources/tech-stack.md` + `resources/snippets.md`

### 실행 중 필요시 로드
- `resources/checklist.md` — 검증 단계에서 로드
- `resources/error-playbook.md` — 에러 발생 시에만 로드
- `../_shared/local-tasks.md` — 로컬 태스크 관리 가이드

---

## 작업 유형 → 리소스 매핑

### Frontend Agent

| 작업 유형 | 필요 리소스 |
| --------- | ----------- |
| 컴포넌트 생성 | snippets.md (component, test) + component-template.tsx |
| 폼 구현 | snippets.md (form + Zod) |
| API 연동 | snippets.md (TanStack Query) |
| 스타일링 | module.scss 사용 |
| 페이지 레이아웃 | snippets.md (grid) + examples.md |

### Debug Agent

| 작업 유형 | 필요 리소스 |
| --------- | ----------- |
| 프론트엔드 버그 | common-patterns.md (Frontend section) |
| 성능 버그 | common-patterns.md (Performance section) + debugging-checklist.md |
| 보안 버그 | common-patterns.md (Security section) |

### QA Agent

| 작업 유형 | 필요 리소스 |
| --------- | ----------- |
| 보안 리뷰 | checklist.md (Security section) |
| 성능 리뷰 | checklist.md (Performance section) |
| 접근성 리뷰 | checklist.md (Accessibility section) |
| 전체 감사 | checklist.md (full) + self-check.md |

### PM Agent

| 작업 유형 | 필요 리소스 |
| --------- | ----------- |
| 신규 프로젝트 기획 | examples.md + task-template.json |
| 기능 추가 기획 | examples.md + 로컬 코드 분석 |
| 리팩토링 기획 | 로컬 코드 분석만 |
