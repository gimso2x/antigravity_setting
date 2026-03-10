# Cursor 프로젝트 컨텍스트 초기화 가이드

> 이 문서를 Cursor AI 채팅에 붙여넣으면,
> AI가 현재 프로젝트를 분석하고 `.cursor/rules/project-context.mdc`를 자동 생성합니다.

---

## 사용법

아래 텍스트를 복사하여 Cursor 채팅에 붙여넣으세요:

```
현재 프로젝트를 분석해서 .cursor/rules/project-context.mdc를 생성해줘.
아래 가이드를 따라줘:

1. 다음 파일들을 확인해서 기술 스택을 파악해:
   - package.json (프레임워크, 라이브러리, 패키지 매니저)
   - tsconfig.json (TypeScript 설정, path alias)
   - next.config.* (Next.js App Router / Pages Router)
   - tailwind.config.* (TailwindCSS 버전)
   - .eslintrc* / eslint.config.* (린트 규칙)
   - vite.config.* (Vite 사용 여부)
   - 디렉토리 구조 (src/, app/, pages/, components/ 등)

2. 분석 결과를 토대로 .cursor/rules/project-context.mdc를 생성해줘.
   아래 템플릿을 기반으로, 이 프로젝트에 맞게 내용을 채워 넣어:

---
description: 이 프로젝트의 기술 스택 및 컨벤션
---

# 프로젝트 컨텍스트

## 기술 스택
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
- (프로젝트에서 감지되는 패턴이나 특이사항)
- (예: barrel exports 사용, API route 패턴 등)

## 주의사항
- (예: 레거시 Pages Router와 App Router 혼용)
- (예: 특정 라이브러리 버전 제약 사항)
---

3. 기존 `.agent/skills/` 하위의 모든 `SKILL.template.md` 파일들을 읽어들여라.
   그 후 현재 프로젝트 환경과 스택에 맞추어 내용(예: `{{FRAMEWORK}}` 변수 등)을 수정한 뒤, 해당 내용을 **Cursor 규칙 형식(.mdc)**으로 변환하여 `.cursor/rules/` 디렉토리 안에 각각 저장해줘. (예: `.cursor/rules/skill-frontend-agent.mdc`)

4. 파일이 이미 존재하면 기존 내용을 보존하면서 병합해줘.
5. 불확실한 부분은 주석으로 표시하고, 확인이 필요하다고 알려줘.
6. 파일 생성이 모두 완료되면, 이 init.md 파일을 삭제해줘.
```

---

## 참고사항

- 이 프롬프트는 프로젝트의 실제 구조를 AI가 직접 읽어서 판단하기 때문에, 프로젝트마다 다른 맞춤형 결과가 생성됩니다.
- 생성된 `project-context.mdc`는 다른 `.mdc` 규칙들과 함께 동작하여 프로젝트 맥락을 제공합니다.
- Global 설정 = `CURSOR_GLOBAL_RULES.md` (Settings → Rules에 붙여넣기)
- Workspace 규칙 = `.cursor/rules/*.mdc` (공통 규칙 + 프로젝트 컨텍스트)
