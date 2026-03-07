# Web UI 리뷰 가이드라인

> Vercel Labs `web-design-guidelines` 기반.  
> UI 코드 리뷰 시 체크할 항목들.

---

## 사용 시점
- UI 코드 리뷰 요청 시
- "접근성 확인", "디자인 감사", "UX 리뷰" 요청 시
- 배포 전 최종 UI 검수 시

## 리뷰 체크리스트

### 1. 레이아웃 & 반응형
- [ ] 모바일 (320px) ~ 데스크탑 (1440px) 대응
- [ ] 스크롤 방향이 일관적인가 (가로 스크롤 방지)
- [ ] 컨텐츠가 뷰포트에 맞는가 (오버플로우 없음)
- [ ] Safe area (노치, 하단 바) 대응

### 2. 인터랙션 & 피드백
- [ ] 클릭/탭 가능한 요소에 호버/포커스 상태
- [ ] 로딩 상태 표시 (스켈레톤 or 스피너)
- [ ] 에러 상태 시 사용자에게 명확한 메시지
- [ ] 폼 제출 시 버튼 비활성화 (중복 방지)

### 3. 접근성 (A11y)
- [ ] 모든 이미지에 `alt` 텍스트
- [ ] 인터랙티브 요소에 `aria-label`
- [ ] 색상 대비 4.5:1 이상 (WCAG AA)
- [ ] 키보드만으로 모든 기능 사용 가능
- [ ] Focus trap (모달/다이얼로그)

### 4. 성능
- [ ] LCP (Largest Contentful Paint) < 2.5s
- [ ] CLS (Cumulative Layout Shift) < 0.1
- [ ] FID (First Input Delay) < 100ms
- [ ] 이미지 `next/image` 사용 (lazy loading)

### 5. 타이포그래피 & 색상
- [ ] 디자인 토큰 사용 (하드코딩 금지)
- [ ] 일관된 폰트 사이즈 체계
- [ ] 라인 높이 적절 (1.4~1.6)
- [ ] 긴 텍스트에 `text-overflow: ellipsis` 처리

### 6. 네비게이션 & 구조
- [ ] 뒤로가기 동작 정상
- [ ] URL이 현재 상태를 반영
- [ ] 404/에러 페이지 구현
- [ ] 시맨틱 HTML 사용 (`nav`, `main`, `section`)

## 리뷰 출력 형식

```
파일:줄번호 — [심각도] 설명

예시:
src/components/Header.tsx:15 — [HIGH] 클릭 가능한 로고에 aria-label 누락
src/app/page.tsx:42 — [MEDIUM] 하드코딩된 색상 (#333) → 디자인 토큰 사용 권장
```

## 참조
- [Vercel Web Interface Guidelines](https://github.com/vercel-labs/web-interface-guidelines)
