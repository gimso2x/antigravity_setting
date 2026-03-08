# 🚀 Antigravity Setting

AI 에이전트(Antigravity, Claude, Cursor 등)를 위한 공유 설정 레포.  
어떤 프로젝트든 동일한 `.agent/` 스킬 + 워크플로우 + 글로벌 규칙을 빠르게 적용할 수 있습니다.

---

## 📦 포함 내용

| 항목              | 경로                     | 설명                                              |
| ----------------- | ------------------------ | ------------------------------------------------- |
| **Skills**        | `.agent/skills/`         | frontend, debug, pm, qa, commit, skill-developer  |
| **Workflows**     | `.agent/workflows/`      | `/debug`, `/plan`, `/review`                      |
| **Global Rules**  | `GEMINI.md`              | Antigravity 글로벌 규칙                           |
| **Cursor Global** | `CURSOR_GLOBAL_RULES.md` | Cursor Settings → Rules 붙여넣기용                |
| **Cursor Rules**  | `.cursor/rules/`         | Cursor 워크스페이스 규칙 (.mdc)                   |
| **Init Prompt**   | `init.md`                | 프로젝트 분석 → workspace GEMINI.md 생성 프롬프트 |

---

## ⚡ 설치 방법

### 1. 레포 clone + 스크립트 실행

```powershell
# 1) 이 레포를 아무 곳에 clone (최초 1회)
git clone https://github.com/gimso2x/antigravity_setting.git

# 2-A) Antigravity (기본)
& C:\path\to\antigravity_setting\scripts\setup.ps1 -TargetPath "C:\your\project"

# 2-B) Cursor IDE
& C:\path\to\antigravity_setting\scripts\setup.ps1 -TargetPath "C:\your\project" -WorkspaceAgent cursor
```

스크립트가 수행하는 작업:

- ✅ `.agent/` → 타겟 프로젝트에 복사 (기존 있으면 덮어쓰기)
- ✅ `GEMINI.md` → `~/.gemini/GEMINI.md` 글로벌 설정 (기존 백업)

### 2. Workspace GEMINI.md 생성

`init.md`의 프롬프트를 LLM 에이전트에 붙여넣으면, 프로젝트를 분석하고 맞춤형 workspace `GEMINI.md`를 자동 생성합니다.

자세한 내용은 [init.md](./init.md)를 참고하세요.

---

## 📁 전체 구조

```
.
├── .agent/                       # Antigravity 전용
│   ├── skills/
│   │   ├── _shared/              # 공유 리소스
│   │   ├── commit/               # Git 커밋 스킬
│   │   ├── debug-agent/          # 버그 진단/수정 스킬
│   │   ├── frontend-agent/       # React/Next.js UI 구현 스킬
│   │   ├── pm-agent/             # 기획/태스크 분해 스킬
│   │   ├── qa-agent/             # 품질 검사/리뷰 스킬
│   │   └── skill-developer/      # 새 스킬 생성 메타 스킬
│   └── workflows/
│       ├── debug.md              # /debug 워크플로우
│       ├── plan.md               # /plan 워크플로우
│       └── review.md             # /review 워크플로우
├── .cursor/                      # Cursor IDE 전용
│   └── rules/
│       ├── coding-standards.mdc  # 코딩 기본 규칙
│       ├── frontend-standards.mdc# 프론트엔드 전문 규칙
│       ├── debug-workflow.mdc    # 버그 진단/수정
│       ├── plan-workflow.mdc     # 기획/태스크 분해
│       ├── review-workflow.mdc   # QA/리뷰
│       └── commit-rules.mdc     # Git 커밋 규칙
├── scripts/
│   └── setup.ps1                 # 초기화 스크립트
├── GEMINI.md                     # Antigravity 글로벌 규칙
├── CURSOR_GLOBAL_RULES.md        # Cursor 글로벌 규칙
├── init.md                       # Workspace GEMINI.md 생성 프롬프트
└── README.md                     # 이 파일
```

---

## 🔄 업데이트

설정을 업데이트하려면 이 레포에서 변경 후 `setup.ps1`을 다시 실행하면 됩니다.
