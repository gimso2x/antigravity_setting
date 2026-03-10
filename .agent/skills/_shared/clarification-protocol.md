# Clarification Protocol

요구사항이 모호할 때 "추측하고 진행"하면 대부분 잘못된 방향으로 갑니다.
명확한 요구사항을 확보한 후 실행하세요.

> **핵심 원칙**: 맹목적으로 시도하기보다 도움을 요청하는 시점을 판단하라.

---

## 불확실성 레벨

| 레벨 | 상태 | 행동 | 예시 |
|------|------|------|------|
| **LOW** | 명확 | 기본값 적용 후 진행, 가정 기록 | "TODO 앱 만들어" |
| **MEDIUM** | 부분 모호 | 2-3개 옵션 제시 + 사용자 선택 요청 | "사용자 관리 시스템 만들어" |
| **HIGH** | 매우 모호 | **진행 불가**, 질문 필수 | "좋은 앱 만들어" |

---

## 불확실성 트리거

### HIGH (반드시 질문)
- 비즈니스 로직 결정 필요 (가격 정책, 승인 워크플로우 등)
- 보안/인증 결정 (OAuth 제공자, 권한 모델 등)
- 기존 코드와 충돌 가능성
- 요구사항이 주관적 ("좋은", "빠른", "예쁜")
- 범위가 무한정

### MEDIUM (옵션 제시)
- 2개 이상 기술 스택 선택 가능
- 구현 접근법에 트레이드오프 존재
- 여러 기능의 우선순위 불명확

---

## 에스컬레이션 템플릿

### LOW → 진행 (가정 기록)
```
⚠️ 적용된 가정:
- Next.js App Router (SSR)
- radix-ui 컴포넌트
- MVP 범위

이 기본값으로 진행합니다. 변경이 필요하면 알려주세요.
```

### MEDIUM → 옵션 선택 요청
```
🔍 불확실성 감지: {구체적 이슈}

Option A: {접근법} ✅ 장점 / ❌ 단점 / 💰 공수
Option B: {접근법} ✅ 장점 / ❌ 단점 / 💰 공수

어떤 접근을 선호하시나요? (A/B)
```

### HIGH → 차단
```
❌ 진행 불가: 요구사항이 너무 모호함

질문:
1. {구체적 질문}
2. {구체적 질문}
3. {구체적 질문}

Status: BLOCKED (명확화 대기)
```

---

## 검증 게이트 (Verification Gate)

BEFORE claiming any status:

1. **IDENTIFY**: What command proves this claim?
2. **RUN**: Execute the FULL command (fresh, complete)
3. **READ**: Full output, check exit code, count failures
4. **VERIFY**: Does output confirm the claim?
5. **ONLY THEN**: Make the claim

**Red Flags (STOP immediately):**
- Using "should", "probably", "seems to"
- Expressing satisfaction before verification
- About to commit/push without verification
- Trusting agent success reports

---

## 필수 확인 항목

### 공통
| 항목 | 확인 질문 | 기본값 | 불확실성 |
|------|----------|--------|---------|
| 대상 사용자 | 누가 사용하는가? | 일반 웹 사용자 | LOW |
| 핵심 기능 | 필수 기능 3가지는? | 작업 설명에서 추론 | MEDIUM |
| 기술 스택 | 프레임워크 제약 있는가? | 프로젝트 기본 스택 | LOW |
| 범위 | MVP인가 전체 기능인가? | MVP | LOW |

### Frontend 추가 확인
| 항목 | 확인 질문 | 기본값 | 불확실성 |
|------|----------|--------|---------|
| SSR/CSR | 서버사이드 렌더링 필요? | Next.js App Router (SSR) | MEDIUM |
| 다크 모드 | 지원 필요? | 지원 | LOW |
| 다국어 | 다국어 지원? | 불필요 | LOW |
| 디자인 시스템 | UI 라이브러리? | radix-ui | MEDIUM |
| 상태 관리 | Context? Zustand? | Zustand | MEDIUM |

---

## PM Agent: 요구사항 명세 프레임워크

```
=== 요구사항 명세 ===

원본 요청: "{사용자 원문}"

1. 핵심 목표: {한 문장으로 정의}
2. 사용자 스토리: (최소 3개)
- "사용자로서, {행동}을 하여 {이점}을 얻고 싶다"
3. 기능 범위:
- Must-have: {목록}
- Nice-to-have: {목록}
- Out-of-scope: {목록}
4. 기술 제약: {기존 코드 / 스택 / 호환성}
5. 성공 기준: {측정 가능한 조건}
```
