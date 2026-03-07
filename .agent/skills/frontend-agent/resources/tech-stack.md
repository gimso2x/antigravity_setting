# Frontend Agent - Tech Stack Reference

## Core Stack
- **Framework**: Next.js 15+ (App Router), React 19+
- **Language**: TypeScript (strict mode)
- **Styling**: module.scss
- **Components**: Radix UI
- **State**: Zustand
- **Forms**: React Hook Form + Zod
- **API Client**: TanStack Query
- **Testing**: Vitest, React Testing Library, Playwright

## Code Standards
- Explicit TypeScript interfaces for props
- SCSS Modules for styling (NO inline styles)
- Semantic HTML with ARIA labels
- Keyboard navigation support

## Project Structure

```
src/
  app/           # Next.js App Router pages
  components/
    ui/          # Reusable primitives (button, card)
    [feature]/   # Feature components
  lib/
    api/         # API clients (TanStack Query hooks)
    hooks/       # Custom hooks
  types/         # TypeScript types
```
