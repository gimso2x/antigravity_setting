# 스킬 시스템 사용 가이드

> `.agent/skills/` 디렉토리의 스킬을 사용하고, 새로 만드는 방법.

---

## 목차
1. [스킬 전체 구조](#1-스킬-전체-구조)
2. [기존 스킬 사용법](#2-기존-스킬-사용법)
3. [새 스킬 생성법](#3-새-스킬-생성법)
4. [스킬 라우팅 규칙](#4-스킬-라우팅-규칙)

---

## 1. 스킬 전체 구조

```
.agent/skills/
├── _shared/                     # 모든 스킬이 공유하는 리소스
│   ├── skill-routing.md         # 키워드 → 스킬 매핑 규칙
│   ├── context-loading.md       # 컨텍스트 로딩 전략
│   ├── reasoning-templates.md   # 추론 템플릿
│   └── clarification-protocol.md # 명확화 프로토콜
│
├── commit/                      # Git 커밋 스킬
├── debug-agent/                 # 버그 진단/수정 스킬
├── frontend-agent/              # React/Next.js UI 구현 스킬
├── pm-agent/                    # 기획/태스크 분해 스킬
├── qa-agent/                    # 품질 검사/리뷰 스킬
└── skill-developer/             # 새 스킬 생성 메타 스킬
```

---

## 2. 기존 스킬 사용법

### 스킬 목록 및 트리거 키워드

| 스킬 | 용도 | 트리거 키워드 예시 |
|------|------|-------------------|
| **frontend-agent** | UI 컴포넌트 구현, 스타일링, 반응형 | "컴포넌트 만들어줘", "페이지 구현", "UI 수정" |
| **debug-agent** | 버그 찾기, 에러 수정, 성능 이슈 | "에러 수정해줘", "이 버그 고쳐줘", "왜 느린지 봐줘" |
| **qa-agent** | 코드 리뷰, 보안/성능/접근성 감사 | "리뷰 해줘", "보안 점검", "접근성 확인" |
| **pm-agent** | 요구사항 분해, 태스크 기획 | "이 기능 분해해줘", "태스크 정리", "스프린트 계획" |
| **commit** | Git 커밋 메시지 작성 | "커밋해줘", "커밋" |
| **skill-developer** | 새 스킬 생성/수정 | "새 스킬 만들어줘", "스킬 추가" |

### 사용 예시

#### 프론트엔드 작업
```
사용자: "로그인 폼 컴포넌트를 만들어줘"
→ frontend-agent가 활성화
→ resources/execution-protocol.md 절차를 따름
→ FSD-lite 아키텍처 + Radix UI + TypeScript로 구현
```

#### 버그 수정
```
사용자: "이 에러 좀 봐줘: TypeError: Cannot read property..."
→ debug-agent가 활성화
→ 재현 → 근본 원인 분석 → 최소 수정 → 회귀 테스트
```

#### 기획 → 구현 → 리뷰 파이프라인
```
1. "이 기능을 태스크로 분해해줘"     → pm-agent
2. "프론트엔드 구현 시작해줘"        → frontend-agent
3. "구현 완료됐으니 리뷰 해줘"       → qa-agent
4. "커밋해줘"                       → commit
```

### 각 스킬의 주요 리소스

| 리소스 파일 | 설명 | 사용하는 스킬 |
|------------|------|--------------|
| `execution-protocol.md` | 단계별 실행 절차 | 전체 |
| `examples.md` | 입출력 예시 | 전체 |
| `checklist.md` | 완료 전 검증 체크리스트 | frontend, qa |
| `error-playbook.md` | 에러 복구 플레이북 | 전체 |
| `react-patterns.md` | React 성능/컴포지션 패턴 (Vercel) | frontend |
| `ui-review-guidelines.md` | Web UI 리뷰 가이드 (Vercel) | qa |

---

## 3. 새 스킬 생성/수정 (skill-developer 사용법)

`skill-developer`는 스킬을 만들고 수정하는 **메타 스킬**입니다.  
채팅으로 요청하면 AI가 알아서 구조를 잡고, 파일을 만들고, 라우팅까지 등록합니다.

### 새 스킬 만들기

```
"Vitest 테스트 코드 작성을 도와주는 스킬을 만들어줘"
"API 통신 전담 스킬 만들어줘"
"i18n 번역 관리 스킬 추가해줘"
```

→ AI가 `SKILL.md` + `resources/` 생성 + `skill-routing.md` 매핑 추가

### 기존 스킬 수정하기

```
"frontend-agent에 Zustand 상태 관리 패턴을 추가해줘"
"debug-agent 체크리스트 업데이트해줘"
"qa-agent에 새 보안 룰 넣어줘"
```

→ AI가 대상 스킬 확인 → 변경 제안 → 승인 후 수정

---