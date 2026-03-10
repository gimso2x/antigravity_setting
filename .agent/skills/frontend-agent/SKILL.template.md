---
name: frontend-agent
description: 프론트엔드 UI/UX 전문가 — {{FRAMEWORK}}, {{LANGUAGE}}, 컴포넌트 구현, 화면/페이지/폼 개발
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

1. **Component Reuse**: Use `{{UI_LIBRARY}}` primitives first. Extend via composition.
2. **Design Fidelity**: Code must map 1:1 to Design Tokens. Resolve discrepancies before implementation.
3. **Rendering Strategy**: Default to {{PREFERRED_RENDERING_MODE}} (e.g. Server Components) for performance.
4. **Accessibility**: Semantic HTML, ARIA labels, keyboard navigation, and screen reader compatibility are mandatory.
5. **Tool First**: Check for existing solutions and tools before coding.

## 1. Tooling & Performance

- **Metrics**: Target First Contentful Paint (FCP) < 1s.
- **Optimization**: {{OPTIMIZATION_STRATEGIES}} (e.g. use `next/dynamic` for heavy components)
- **Responsive Breakpoints**: {{BREAKPOINTS}}
- **UI Workflow**: `{{PACKAGE_MANAGER}} install {{UI_PACKAGE_PREFIX}}/{component}` 로 필요한 컴포넌트 설치

## 2. Architecture ({{ARCHITECTURE_PATTERN}})

- **Root (`{{ROOT_DIR}}`)**: Shared logic (components, lib, types).
- **Feature (`{{FEATURE_DIR}}/*/`)**: Feature-specific logic. **No cross-feature imports.**

### Feature Directory Structure
```
{{FEATURE_DIR}}/[feature]/
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

| Category | Library |
|----------|---------|
| Date | `{{DATE_LIB}}` |
| Styling | `{{STYLING_LIB}}` |
| Hooks | `{{HOOKS_LIB}}` (Pre-made hooks preferred) |
| Utils | `{{UTILS_LIB}}` (First choice) |
| State | `{{STATE_LIB}}` |
| Forms | `{{FORM_LIB}}` |

## 4. Standards

- **Utilities**: Check `{{UTILS_LIB}}` first. If implementing custom logic, **>90% Unit Test Coverage** is MANDATORY.
- **Design Tokens**: Source of Truth is `{{DESIGN_TOKEN_PATH}}`. Never hardcode colors.
- **i18n**: Source of Truth is `{{I18N_PATH}}`. Never hardcode strings.

## 5. Component Strategy

### {{COMPONENT_STRATEGY}}

### Naming Conventions
| Type | Convention |
|------|------------|
| Files | `{{FILE_NAMING}}` (Name MUST indicate purpose) |
| Components/Types/Interfaces | `PascalCase` |
| Functions/Vars/Hooks | `camelCase` |
| Constants | `SCREAMING_SNAKE_CASE` |

### Imports
- Order: Standard > 3rd Party > Local
- {{PATH_ALIAS_RULE}} (e.g. Absolute `@/` is MANDATORY)
- **MUST use `import type`** for interfaces/types

## 6. UI Implementation ({{UI_LIBRARY}})

- **Usage**: Prefer {{UI_LIBRARY}} primitives over custom implementations.
- **Customization Rule**: Treat `{{UI_COMPONENTS_DIR}}/*` as read-only. Do not modify directly.
  - **Correct**: Create a wrapper (e.g., `components/common/ProductButton.tsx`) or use composition.
  - **Incorrect**: Editing `{{UI_COMPONENTS_DIR}}/button.tsx`.

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
- [ ] **Tests**: Logic covered by `{{TEST_LIB}}` where complex.
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
> Treat `{{UI_COMPONENTS_DIR}}/*` as read-only. Create wrappers for customization.
