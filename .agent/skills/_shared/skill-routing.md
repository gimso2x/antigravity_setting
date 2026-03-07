# Skill Routing Map

작업 내용에 따라 올바른 스킬을 선택하는 라우팅 규칙.

---

## 키워드 → 스킬 매핑

| 사용자 요청 키워드 | 스킬 |
|-------------------|------|
| UI, 컴포넌트, 페이지, 폼, 화면 | **frontend-agent** |
| 스타일, SCSS, 반응형, CSS | **frontend-agent** |
| 성능, 최적화, 렌더링, 번들 | **frontend-agent** |
| 컴포지션, 컴파운드, 상태관리 | **frontend-agent** |
| 버그, 에러, 크래시, 느림 | **debug-agent** |
| 리뷰, 보안, 성능 감사 | **qa-agent** |
| 접근성, WCAG, a11y | **qa-agent** |
| 기획, 분해, 태스크, 스프린트 | **pm-agent** |
| 커밋, 저장, git | **commit** |
| 스킬 생성, 스킬 추가, 스킬 구조 | **skill-developer** |

---

## 인텐트 패턴 매칭

키워드 매칭으로 부족할 때, 사용자 의도를 정규식 패턴으로 매칭:

| 패턴 | 스킬 |
|------|------|
| `(만들\|생성\|추가).*?(컴포넌트\|UI\|페이지\|폼)` | **frontend-agent** |
| `(최적화\|개선\|빠르게).*?(렌더링\|번들\|성능)` | **frontend-agent** |
| `(버그\|에러\|오류).*?(수정\|고치\|해결)` | **debug-agent** |
| `(리뷰\|검사\|감사).*?(보안\|성능\|접근성)` | **qa-agent** |
| `(분해\|기획\|분석).*?(요구사항\|기능\|태스크)` | **pm-agent** |
| `(만들\|추가\|수정).*?스킬` | **skill-developer** |

---

## 파일 패턴 매칭

현재 편집 중인 파일 경로로 스킬 자동 매칭:

| 파일 패턴 | 스킬 |
|-----------|------|
| `src/**/*.tsx`, `src/**/*.scss` | **frontend-agent** |
| `src/features/**/*` | **frontend-agent** |
| `.agent/skills/**/*` | **skill-developer** |
| `*.test.ts`, `*.spec.ts` | **qa-agent** |

---

## 가드레일 (Guardrail) 규칙

특정 작업 시 반드시 참조해야 하는 스킬:

| 조건 | 가드레일 스킬 | 동작 |
|------|--------------|------|
| `components/ui/*` 수정 시도 | **frontend-agent** | ⚠️ 직접 수정 차단, 래퍼 생성 권장 |
| 디자인 토큰 하드코딩 감지 | **frontend-agent** | ⚠️ `packages/design-tokens` 참조 권장 |
| 새 스킬 생성 | **skill-developer** | 구조 검증 필수 |

---

## 실행 순서 규칙

- pm → frontend → qa (기획 → 구현 → 리뷰)
- debug → qa (버그 수정 → 리뷰)
- qa-agent는 항상 마지막 (구현 완료 후 리뷰)
- skill-developer는 독립 실행 (다른 스킬과 순서 무관)
