---
name: commit
description: Git 커밋 생성 — 브랜치명 접두어 형식, Conventional Commits 금지, PowerShell 호환
---

# Commit Skill

## When to use

- 사용자가 "커밋해줘", "commit", "저장해줘" 요청 시
- `/commit` 명령 실행 시

## 커밋 메시지 규칙

- **형식**: `[브랜치명] 변경 내용 요약`
- **금지**: `fix:`, `feat:`, `chore:` 등 Conventional Commits 접두어 사용 금지
- **PowerShell 환경**: `&&` 대신 `;` 사용

## 커밋 메시지 형식

```
[브랜치명] 변경 내용 요약

- 파일1: 변경 상세
- 파일2: 변경 상세
```

- 제목(subject)과 본문(body)을 `-m` 플래그 **두 번**으로 분리

## Workflow

### Step 1: 브랜치 및 변경 파일 확인

```powershell
git branch --show-current
git status
git diff --name-only
```

### Step 2: 파일 스테이징

**특정 파일만 스테이징** (절대로 `git add .` 또는 `git add -A` 사용 금지):

```powershell
git add <파일경로1> <파일경로2>
```

> **주의**: 경로에 괄호 `()`가 포함된 경우 반드시 따옴표로 감쌀 것
>
> ```powershell
> # ❌ 틀림
> git add src/app/(main)/page.tsx
> # ✅ 올바름
> git add "src/app/(main)/page.tsx"
> ```

### Step 3: 커밋 메시지 미리보기 확인

커밋 전 사용자에게 반드시 확인:

```
📝 커밋 메시지 미리보기:

[{{PROJECT_FEATURE_PREFIX}}] Dockerfile 빌드 단계 네트워크 진단 RUN 명령 추가

- Dockerfile-development: 빌드 단계에 curl/nslookup 네트워크 진단 RUN 명령 추가
- 내부 API 접근 가능 여부 확인 목적

스테이징된 파일:
- docker/Dockerfile-development

진행할까요? (Y/N)
```

### Step 4: 커밋 실행

제목(subject) + 본문(body)을 `-m` 플래그 두 번으로 작성:

```powershell
git add <파일경로>; git commit -m "[브랜치명] 변경 내용 요약" -m "- 파일1: 변경 상세`n- 파일2: 변경 상세"
```

예시:

```powershell
git add docker/Dockerfile-development; git commit -m "[{{PROJECT_FEATURE_PREFIX}}] Dockerfile 빌드 단계 네트워크 진단 RUN 명령 추가" -m "- Dockerfile-development: 빌드 단계에 curl/nslookup으로 네트워크 진단 RUN 명령 추가`n- 내부 API 접근 가능 여부 확인 목적"
```

> **PowerShell 줄바꿈**: 본문 내 줄바꿈은 `` `n `` 사용

## 안전 규칙 (절대 위반 금지)

- ❌ 사용자 확인 없이 커밋 금지
- ❌ `git add -A` 또는 `git add .` 사용 금지
- ❌ `.env`, `.env.local` 등 환경변수 파일 커밋 금지
- ✅ 항상 특정 파일명으로 명시적 스테이징
- ✅ 멀티라인 메시지는 `-m` 플래그 두 번 사용 (PowerShell)
- ✅ 경로에 `()`가 포함된 경우 따옴표로 감싸기
