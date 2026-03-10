# 프로젝트 초기화 가이드 (Antigravity + Cursor)

> 이 문서를 LLM 에이전트에 붙여넣으면,
> 에이전트가 현재 프로젝트를 분석하고 **두 가지 설정 파일을 한 번에** 자동 생성합니다.
>
> - `GEMINI.md` (Antigravity/Gemini 워크스페이스 설정)
> - `.cursor/rules/project-context.mdc` (Cursor 워크스페이스 규칙)

---

## 사용법

아래 텍스트를 복사하여 LLM 에이전트 채팅에 붙여넣으세요:

```
현재 프로젝트를 분석해서 아래 두 파일을 모두 생성해줘:
1. 프로젝트 루트에 GEMINI.md
2. .cursor/rules/project-context.mdc

아래 가이드를 따라줘:

## 공통 분석

다음 파일들을 확인해서 기술 스택을 파악해:
- package.json (프레임워크, 라이브러리, 패키지 매니저)
- tsconfig.json (TypeScript 설정, path alias)
- next.config.* (Next.js App Router / Pages Router)
- tailwind.config.* (TailwindCSS 버전)
- .eslintrc* / eslint.config.* (린트 규칙)
- vite.config.* (Vite 사용 여부)
- 디렉토리 구조 (src/, app/, pages/, components/ 등)

## 파일 1: GEMINI.md (프로젝트 루트)

분석 결과를 토대로 아래 템플릿을 채워 GEMINI.md를 생성해줘:

---
# Workspace Rules (프로젝트별 설정)

## 프로젝트 기술 스택
- **프레임워크**: (예: Next.js 14 App Router / React 18 + Vite / Vue 3)
- **언어**: (예: TypeScript strict 모드)
- **스타일링**: (예: TailwindCSS 3.x / SCSS / CSS Modules / styled-components)
- **상태관리**: (예: Zustand / Redux Toolkit / Jotai / 없음)
- **UI 라이브러리**: (예: Radix UI / shadcn/ui / MUI / Ant Design / 없음)
- **테스트**: (예: Vitest + Testing Library / Jest / 없음)
- **패키지 매니저**: (예: pnpm / yarn / npm)

## 디렉토리 구조
- (예: `src/app/` — App Router 라우팅)
- (예: `src/components/` — 재사용 컴포넌트)
- (예: `src/hooks/` — 커스텀 훅)
- (예: `src/lib/` — 유틸리티)

## Path Alias
- (예: `@/*` → `src/*`)

## 프로젝트 컨벤션
- (프로젝트에서 감지되는 패턴이나 특이사항을 기재)
- (예: barrel exports 사용, API route 패턴 등)

## 이 프로젝트에서 주의할 점
- (예: 레거시 Pages Router와 App Router 혼용)
- (예: 특정 라이브러리 버전 제약 사항)
---

## 파일 2: .cursor/rules/project-context.mdc

같은 분석 결과를 아래 Cursor 규칙 형식으로도 생성해줘:

---
description: 이 프로젝트의 기술 스택 및 컨벤션
---

# 프로젝트 컨텍스트

## 기술 스택
- **프레임워크**: (위와 동일)
- **언어**: (위와 동일)
- **스타일링**: (위와 동일)
- **상태관리**: (위와 동일)
- **UI 라이브러리**: (위와 동일)
- **테스트**: (위와 동일)
- **패키지 매니저**: (위와 동일)

## 디렉토리 구조
(GEMINI.md와 동일하게 채워 넣어)

## Path Alias
(GEMINI.md와 동일하게 채워 넣어)

## 프로젝트 컨벤션
(GEMINI.md와 동일하게 채워 넣어)

## 주의사항
(GEMINI.md와 동일하게 채워 넣어)
---

## 파일 3: .agent/skills/*/SKILL.md & .cursor/rules/*.mdc (스킬 파일 생성 및 템플릿 삭제)

기술 스택과 컨벤션은 파일 1과 파일 2에 정의했으므로 스킬 파일에 중복해서 넣지 마.
대신, `.agent/skills/` 하위의 모든 `SKILL.template.md` 파일들을 그대로 읽어들여 다음 두 가지 행동을 수행해줘:
1. 템플릿과 동일한 `.agent/skills/*/` 하위 위치에 `SKILL.md` 이름으로 저장한다. (Antigravity 용도)
2. 해당 내용을 **Cursor 규칙 형식(.mdc)**으로 변환하여 `.cursor/rules/` 디렉토리 안에 각각 저장한다. (예: `.cursor/rules/skill-frontend-agent.mdc`)

생성이 모두 완료되면, 더 이상 필요 없는 `.agent/skills/` 하위의 모든 `SKILL.template.md` 파일들과, 방금 복사해 와서 붙여넣기를 완료한 `CURSOR_GLOBAL_RULES.md` 파일도 모두 삭제해줘.

---

## 공통 규칙
- 파일이 이미 존재하면 기존 내용을 보존하면서 병합해줘.
- 불확실한 부분은 주석으로 표시하고, 확인이 필요하다고 알려줘.
- 모든 작업이 완료되면, 이 init.md 파일도 삭제해줘.
```

---

## 참고사항

- 이 프롬프트는 프로젝트의 실제 구조를 LLM이 직접 읽어서 판단하기 때문에, 프로젝트마다 다른 맞춤형 결과가 생성됩니다.
- **GEMINI.md**: workspace 레벨 설정으로, global `~/.gemini/GEMINI.md`와 함께 동작합니다.
- **project-context.mdc**: `.cursor/rules/` 내 다른 규칙들과 함께 동작합니다.
- 한 번의 요청으로 두 도구의 설정을 동시에 생성하므로, 분석 결과의 일관성이 보장됩니다.
