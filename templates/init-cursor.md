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

3. 기술 스택과 컨벤션은 project-context에 정의했으므로 스킬 파일에 중복해서 넣지 마.
   대신, `.agent/skills/` 하위의 모든 `SKILL.template.md` 파일들을 그대로 읽어들인 뒤, 해당 내용을 **Cursor 규칙 형식(.mdc)**으로 변환하여 `.cursor/rules/` 디렉토리 안에 각각 저장해줘. (예: `.cursor/rules/skill-frontend-agent.mdc`)

4. 변환되어 생성된 스킬 파일이 이미 존재하면 기존 내용을 보존하면서 병합해줘.
5. 불확실한 부분은 주석으로 표시하고, 확인이 필요하다고 알려줘.
6. 파일 생성이 모두 완료되면, `.agent/skills/` 하위의 모든 `SKILL.template.md` 파일들과 이 init.md 파일, **그리고 방금 복사했던 `CURSOR_GLOBAL_RULES.md` 파일도 이제 더 이상 필요 없으니 모두 삭제해줘.**
```

---

## 참고사항

- 이 프롬프트는 프로젝트의 실제 구조를 AI가 직접 읽어서 판단하기 때문에, 프로젝트마다 다른 맞춤형 결과가 생성됩니다.
- 생성된 `project-context.mdc`는 다른 `.mdc` 규칙들과 함께 동작하여 프로젝트 맥락을 제공합니다.
- Global 설정 = 루트에 복사되었던 `CURSOR_GLOBAL_RULES.md` (Settings → Rules에 붙여넣고 나면 자동 삭제됩니다.)
- Workspace 규칙 = `.cursor/rules/*.mdc` (공통 규칙 + 프로젝트 컨텍스트)
