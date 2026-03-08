# Workspace GEMINI.md 초기화 가이드

> 이 문서를 LLM 에이전트(Antigravity, Claude, Cursor 등)에 붙여넣으면,
> 에이전트가 현재 프로젝트를 분석하고 workspace용 `GEMINI.md`를 자동 생성합니다.

---

## 사용법

아래 텍스트를 복사하여 LLM 에이전트 채팅에 붙여넣으세요:

```
현재 프로젝트를 분석해서 workspace용 GEMINI.md를 프로젝트 루트에 생성해줘.
아래 가이드를 따라줘:

1. 다음 파일들을 확인해서 기술 스택을 파악해:
   - package.json (프레임워크, 라이브러리, 패키지 매니저)
   - tsconfig.json (TypeScript 설정, path alias)
   - next.config.* (Next.js App Router / Pages Router)
   - tailwind.config.* (TailwindCSS 버전)
   - .eslintrc* / eslint.config.* (린트 규칙)
   - vite.config.* (Vite 사용 여부)
   - 디렉토리 구조 (src/, app/, pages/, components/ 등)

2. 분석 결과를 토대로 프로젝트 루트에 GEMINI.md를 생성해줘.
   아래 템플릿을 기반으로, 이 프로젝트에 맞게 내용을 채워 넣어:

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

3. 파일이 이미 존재하면 기존 내용을 보존하면서 병합해줘.
4. 불확실한 부분은 주석으로 표시하고, 확인이 필요하다고 알려줘.
5. workspace GEMINI.md 생성이 완료되면, 이 init.md 파일을 삭제해줘.
```

---

## 참고사항

- 이 프롬프트는 프로젝트의 실제 구조를 LLM이 직접 읽어서 판단하기 때문에, 프로젝트마다 다른 맞춤형 결과가 생성됩니다.
- 생성된 `GEMINI.md`는 workspace 레벨 설정으로, global `~/.gemini/GEMINI.md`와 함께 동작합니다.
- Global 설정 = 언어, 페르소나, 코딩 스타일 등 공통 룰
- Workspace 설정 = 프로젝트별 기술 스택, 디렉토리 구조, 컨벤션
