# .cursor/rules (Cursor 전용)

이 폴더의 `.mdc` 파일들은 `.agent/` 스킬/워크플로를 Cursor 워크스페이스 규칙으로 변환한 것입니다.

## 파일 구성

| 파일                     | 소스 (.agent)                                | 설명                          |
| ------------------------ | -------------------------------------------- | ----------------------------- |
| `coding-standards.mdc`   | `_shared/` + `CURSOR_GLOBAL_RULES.md`        | 수정 원칙, 명확화, 추론       |
| `frontend-standards.mdc` | `skills/frontend-agent/`                     | FSD-lite, Radix, 스택, 네이밍 |
| `debug-workflow.mdc`     | `skills/debug-agent/` + `workflows/debug.md` | 버그 진단/수정                |
| `plan-workflow.mdc`      | `skills/pm-agent/` + `workflows/plan.md`     | 기획/태스크 분해              |
| `review-workflow.mdc`    | `skills/qa-agent/` + `workflows/review.md`   | QA/리뷰                       |
| `commit-rules.mdc`       | `skills/commit/`                             | Conventional Commits          |

## 배포

```powershell
.\scripts\setup.ps1 -TargetPath "타겟경로" -WorkspaceAgent cursor
```

## 전역 규칙

소스 레포의 `CURSOR_GLOBAL_RULES.md`를 Cursor **Settings → Rules for AI**에 붙여넣으세요.
