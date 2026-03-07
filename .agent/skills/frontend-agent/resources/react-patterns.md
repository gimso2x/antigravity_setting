# React 성능 최적화 & 컴포지션 패턴

> Vercel Labs `react-best-practices` + `composition-patterns` 기반 가이드.  
> 58개 규칙, 8개 카테고리를 우선순위별로 정리.

---

## 1. Waterfall 제거 (CRITICAL)

| 규칙 | 설명 |
|------|------|
| `async-parallel` | 독립 작업은 `Promise.all()` 사용 |
| `async-defer-await` | await를 실제 사용하는 분기로 이동 |
| `async-suspense-boundaries` | Suspense로 콘텐츠 스트리밍 |

```tsx
// ❌ 순차적 (Waterfall)
const user = await getUser();
const posts = await getPosts();

// ✅ 병렬 (Parallel)
const [user, posts] = await Promise.all([getUser(), getPosts()]);
```

---

## 2. 번들 사이즈 최적화 (CRITICAL)

| 규칙 | 설명 |
|------|------|
| `bundle-barrel-imports` | barrel 파일 대신 직접 import |
| `bundle-dynamic-imports` | `next/dynamic`으로 무거운 컴포넌트 지연 로드 |
| `bundle-defer-third-party` | 분석/로깅은 hydration 후 로드 |
| `bundle-preload` | hover/focus 시 preload로 체감 속도 향상 |

```tsx
// ❌ barrel import
import { Button, Modal, Table } from '@/components';

// ✅ 직접 import
import { Button } from '@/components/ui/button';
```

---

## 3. 서버 사이드 성능 (HIGH)

| 규칙 | 설명 |
|------|------|
| `server-cache-react` | `React.cache()`로 요청별 중복 제거 |
| `server-dedup-props` | RSC props에서 중복 직렬화 방지 |
| `server-parallel-fetching` | 컴포넌트 구조를 병렬 fetch 가능하게 재구성 |
| `server-serialization` | 클라이언트 컴포넌트에 전달하는 데이터 최소화 |

---

## 4. 리렌더 최적화 (MEDIUM)

| 규칙 | 설명 |
|------|------|
| `rerender-derived-state` | 원시 값 대신 파생 boolean 구독 |
| `rerender-derived-state-no-effect` | 렌더 중 파생, Effect 사용 금지 |
| `rerender-functional-setstate` | 안정적 콜백을 위해 함수형 setState 사용 |
| `rerender-lazy-state-init` | 비용 높은 초기값은 함수로 전달 |
| `rerender-memo` | 비용 높은 작업을 메모이즈된 컴포넌트로 추출 |

```tsx
// ❌ Effect로 파생 상태
const [isAdmin, setIsAdmin] = useState(false);
useEffect(() => {
  setIsAdmin(user.role === 'admin');
}, [user.role]);

// ✅ 렌더 중 파생
const isAdmin = user.role === 'admin';
```

---

## 5. JavaScript 성능 (LOW-MEDIUM)

| 규칙 | 설명 |
|------|------|
| `js-index-maps` | 반복 조회는 Map 구축 |
| `js-set-map-lookups` | O(1) 조회를 위해 Set/Map 사용 |
| `js-early-exit` | 함수에서 빠르게 return |
| `js-combine-iterations` | 여러 filter/map을 하나의 루프로 결합 |

---

## 6. 컴포지션 패턴 (HIGH)

### Boolean Props 금지
```tsx
// ❌ Boolean prop 증식
<Card isCompact isBordered isHighlighted hasIcon />

// ✅ 컴파운드 컴포넌트
<Card variant="compact">
  <Card.Header icon={<StarIcon />} />
  <Card.Body highlighted />
</Card>
```

### State Management 분리
```tsx
// ✅ Provider에서만 상태 관리 방법을 알고 있음
// UI 컴포넌트는 context interface만 소비
interface CartContext {
  state: { items: Item[]; total: number };    // 읽기 전용
  actions: { addItem: (id: string) => void }; // 변경 함수
  meta: { isLoading: boolean };               // 메타 정보
}
```

### Children over Render Props
```tsx
// ❌ renderX props
<Layout renderHeader={() => <Header />} renderFooter={() => <Footer />} />

// ✅ children 합성
<Layout>
  <Layout.Header><Header /></Layout.Header>
  <Layout.Footer><Footer /></Layout.Footer>
</Layout>
```

---

## 참조
- [Vercel React Best Practices](https://github.com/vercel-labs/agent-skills/tree/main/skills/react-best-practices)
- [Vercel Composition Patterns](https://github.com/vercel-labs/agent-skills/tree/main/skills/composition-patterns)
