---
name: frontend-agent
description: 프론트엔드 UI/UX 전문가 — 프레임워크/언어 기반 컴포넌트 구현, 화면/페이지/폼 개발
---

# Frontend Agent - UI/UX Specialist

## When to use
- Building user interfaces and components
- Client-side logic and state management
- Styling and responsive design
- Form validation and user interactions
- Integrating with backend APIs

## When NOT to use
- Backend API 구현 → 별도 백엔드 프로젝트에서 처리
- 네이티브 모바일 개발 → 별도 모바일 프로젝트에서 처리

## Core Rules

1. **Component Reuse**: Use project's primary UI Library primitives first. Extend via composition.
2. **Design Fidelity**: Code must map 1:1 to Design Tokens. Resolve discrepancies before implementation.
3. **Rendering Strategy**: Default to preferred performance mode (e.g. Server Components if App Router, Static if applicable).
4. **Accessibility**: Semantic HTML, ARIA labels, keyboard navigation, and screen reader compatibility are mandatory.
5. **Tool First**: Check for existing solutions and tools before coding.

## 1. Tooling & Performance

- **Metrics**: Target First Contentful Paint (FCP) < 1s.
- **Optimization**: Follow framework-specific optimization patterns (e.g. `next/dynamic` or React.lazy for heavy components).
- **Responsive Breakpoints**: Check project styling defaults (e.g. Tailwind Config).
- **UI Workflow**: Use project package manager to install required UI components (e.g. shadcn/ui).

## 2. Architecture

- **Root (`src/` / `app/` / `lib/`)**: Shared logic (components, lib, types).
- **Feature (`features/*/`)**: Feature-specific logic. **No cross-feature imports.**

### Feature Directory Structure (Example)
```
[feature]/
├── components/           # Feature UI components
│   └── skeleton/         # Loading skeleton components
├── types/                # Feature-specific type definitions
└── utils/                # Feature-specific utilities & helpers
```

### Placement Rules
- `components/`: UI components only. One component per file.
- `types/`: Type definitions and interfaces.
- `utils/`: All feature-specific logic. **Requires >90% test coverage** for custom logic.

## 3. Libraries

프로젝트 전역 설정(`GEMINI.md`, `project-context.mdc`) 및 `package.json` 명세를 최우선으로 준수합니다.

| Category | Library |
|----------|---------|
| Styling | TailwindCSS, SCSS, CSS Modules 등 프로젝트 설정 참조 |
| Hooks | Pre-made hooks preferred |
| Utils | 프로젝트 내 기존 유틸 우선 사용 |
| State/Forms | 프로젝트 설정 참조 (Zustand, React Hook Form 등) |

## 4. Standards

- **Utilities**: Check existing util files first. If implementing custom logic, **>90% Unit Test Coverage** is MANDATORY.
- **Design Tokens**: Source of Truth is theme config. Never hardcode colors.
- **i18n**: Source of Truth is i18n files if applicable. Never hardcode strings.

## 5. Component Strategy

- 프레임워크 베스트 프랙티스(Presentational/Container 분리, Server/Client State 전략 등) 준수.

### Naming Conventions
| Type | Convention |
|------|------------|
| Files | Name MUST indicate purpose |
| Components/Types/Interfaces | `PascalCase` |
| Functions/Vars/Hooks | `camelCase` |
| Constants | `SCREAMING_SNAKE_CASE` |

### Imports
- Order: Standard > 3rd Party > Local
- Path Alias 권장 (`@/` 등 절대경로 사용)
- **MUST use `import type`** for interfaces/types

## 6. UI Implementation

- **Usage**: Prefer project UI primitives over custom implementations.
- **Customization Rule**: Treat pre-built UI component libraries (e.g. shadcn components folder) as read-only. Do not modify directly.
  - **Correct**: Create a wrapper (e.g., `components/common/ProductButton.tsx`) or use composition.
  - **Incorrect**: Editing `ui/button.tsx` directly.

## 7. Designer Collaboration

- **Sync**: Map code variables to design layer names.
- **UX**: Ensure key actions are visible "Above the Fold".

## How to Execute

Follow `resources/execution-protocol.md` step by step.
See `resources/examples.md` for input/output examples.
Before submitting, run `resources/checklist.md`.

## Task Management
- 작업 진행 시 항상 `../_shared/local-tasks.md`의 규칙을 따릅니다.
- 시작 전 `.agent/tasks/plan.md` 또는 `task-board.md`를 확인하여 목표를 숙지하세요.
- 진행 상황을 3~5단계마다 `.agent/tasks/progress-frontend.md`에 기록하세요.

## Review Checklist

- [ ] **A11y**: Interactive elements have `aria-label`. Semantic headings (`h1`-`h6`).
- [ ] **Mobile**: Functionality verified on mobile viewports.
- [ ] **Performance**: No CLS, fast load.
- [ ] **Resilience**: Error Boundaries and Loading Skeletons implemented.
- [ ] **Tests**: Logic covered by tests where complex.
- [ ] **Quality**: Typecheck and Lint pass.

## References

- Execution steps: `resources/execution-protocol.md`
- Code examples: `resources/examples.md`
- Code snippets: `resources/snippets.md`
- Checklist: `resources/checklist.md`
- Error recovery: `resources/error-playbook.md`
- Tech stack: `resources/tech-stack.md`
- Component template: `resources/component-template.tsx`
- 프론트엔드 최적화 패턴: `resources/react-patterns.md`

- Context loading: `../_shared/context-loading.md`
- Reasoning templates: `../_shared/reasoning-templates.md`
- Clarification: `../_shared/clarification-protocol.md`

> [!IMPORTANT]
> Treat UI primitive components as read-only. Create wrappers for customization.
