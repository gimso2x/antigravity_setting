# 🚀 Antigravity Setting

AI 에이전트(Antigravity, Claude, Cursor 등)를 위한 공유 설정 레포.
어떤 프로젝트든 동일한 `.agent/` 스킬 + 워크플로우 + 글로벌 규칙을 빠르게 적용할 수 있습니다.

---

## 📦 포함 내용

| 항목 | 경로 | 설명 |
| ----------------- | ------------------------ | ------------------------------------------------- |
| **Skills** | `.agent/skills/` | frontend, debug, pm, qa, commit, skill-developer |
| **Workflows** | `.agent/workflows/` | `/debug`, `/plan`, `/review` |
| **Global Rules** | `GEMINI.md` | Antigravity 글로벌 규칙 (검증 프로토콜 포함) |
| **Cursor Global** | `CURSOR_GLOBAL_RULES.md` | Cursor Settings → Rules 붙여넣기용 |
| **Cursor Rules** | `.cursor/rules/` | Cursor 워크플레이스 규칙 (.mdc) |
| **Init Prompt** | `templates/init-*.md` | 프로젝트 분석 → workspace GEMINI.md 생성 프롬프트 |

---

## ✨ 주요 기능 (OpenCode Superpowers 통합)

### 검증 프로토콜
- **Evidence Before Claims**: 완료 주장 전 반드시 검증 명령 실행
- **Iron Law**: "NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST"
- **Red Flags**: "should", "probably", "seems to" 사용 시 즉시 중단

### 난이도 기반 실행
| Difficulty | 실행 깊이 |
|------------|----------|
| **Simple** | 바로 구현 (빠른 수정, 단일 파일) |
| **Medium** | 분석 → 구현 → 검증 (간소화) |
| **Complex** | 전체 프로토콜 + 체크포인트 |

### 명확화 프로토콜
| Level | 행동 |
|-------|------|
| **LOW** | 기본값 적용 후 진행, 가정 기록 |
| **MEDIUM** | 2-3개 옵션 제시 → 사용자 선택 |
| **HIGH** | 진행 불가, 구체적 질문 필수 |

### 아키텍처 결정 매트릭스
기술 선택 시 체계적인 평가:
- Performance, Implementation complexity, Team familiarity, Scalability, Existing code consistency

---

## ⚡ 설치 방법

### 1. 레포 clone + 스크립트 실행

```powershell
# 1) 이 레포를 아무 곳에 clone (최초 1회)
git clone https://github.com/gimso2x/antigravity_setting.git

# 2-A) Antigravity (기본)
& C:\\path\\to\\antigravity_setting\\scripts\\setup.ps1 -TargetPath "C:\\your\\project"

# 2-B) Cursor IDE
& C:\\path\\to\\antigravity_setting\\scripts\\setup.ps1 -TargetPath "C:\\your\\project" -WorkspaceAgent cursor
```

스크립트가 수행하는 작업:

- ✅ `.agent/` → 타겟 프로젝트에 복사 (기존 있으면 덮어쓰기)
- ✅ `GEMINI.md` → `~/.gemini/GEMINI.md` 글로벌 설정 (기존 백업)

### 2. Workspace GEMINI.md 생성

`templates/init-antigravity.md`의 프롬프트를 LLM 에이전트에 붙여넣으면, 프로젝트를 분석하고 맞춤형 workspace `GEMINI.md`를 자동 생성합니다.

---

## 📁 전체 구조

```
.
├── .agent/                    # Antigravity 전용
│   ├── skills/
│   │   ├── _shared/           # 공유 리소스 (clarification, reasoning)
│   │   ├── commit/            # Git 커밋 스킬
│   │   ├── debug-agent/       # 버그 진단/수정 (4-Phase 프로토콜)
│   │   ├── frontend-agent/    # React/Next.js UI 구현
│   │   ├── pm-agent/          # 기획/태스크 분해 (brainstorming 통합)
│   │   ├── qa-agent/          # 품질 검사/리뷰 (검증 게이트)
│   │   └── skill-developer/   # 새 스킬 생성 메타 스킬
│   └── workflows/
│       ├── debug.md           # /debug 워크플로우
│       ├── plan.md            # /plan 워크플로우
│       └── review.md          # /review 워크플로우
├── .cursor/                   # Cursor IDE 전용
│   └── rules/
│       ├── coding-standards.mdc
│       ├── frontend-standards.mdc
│       ├── debug-workflow.mdc
│       ├── plan-workflow.mdc
│       ├── review-workflow.mdc
│       └── commit-rules.mdc
├── scripts/
│   ├── setup.ps1              # PowerShell 초기화
│   └── setup.sh               # Bash 초기화
├── templates/
│   ├── init-antigravity.md    # Antigravity용
│   ├── init-cursor.md         # Cursor용
│   └── init-both.md           # 둘 다
├── GEMINI.md                  # Antigravity 글로벌 규칙
├── CURSOR_GLOBAL_RULES.md     # Cursor 글로벌 규칙
└── README.md                  # 이 파일
```

---

## 🔄 업데이트

설정을 업데이트하려면 이 레포에서 변경 후 `setup.ps1`을 다시 실행하면 됩니다.
