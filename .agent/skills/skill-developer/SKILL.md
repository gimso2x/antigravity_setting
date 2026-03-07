---
name: skill-developer
description: 새 스킬 생성 및 관리를 위한 메타 스킬 — 스킬 구조, 트리거 패턴 설계, YAML frontmatter, 리소스 파일 구성을 가이드
---

# Skill Developer - 메타 스킬

## 사용 시점
- 새 스킬을 만들 때
- 기존 스킬의 구조를 수정할 때
- 스킬 트리거/라우팅 패턴을 설계할 때
- 스킬 디버깅 (활성화되지 않는 경우)
- **세션 변경 후 스킬 점검이 필요할 때** (스킬 갭 분석)

## 사용하지 않을 때
- 실제 코드 구현 → 전문 에이전트 사용
- 코드 리뷰 → qa-agent 사용

## 스킬 디렉토리 구조

```
.agent/skills/[skill-name]/
├── SKILL.md                    # [필수] 메인 스킬 문서
├── resources/                  # [선택] 상세 리소스
│   ├── execution-protocol.md   # 실행 프로토콜
│   ├── examples.md             # 입출력 예시
│   ├── checklist.md            # 완료 체크리스트
│   └── error-playbook.md       # 에러 복구 가이드
└── config/                     # [선택] 스킬 설정
```

## SKILL.md 필수 구조

```yaml
---
name: [스킬 이름 (kebab-case)]
description: [한 줄 설명 — 언제 사용하는지 명시]
---
```

### 본문 필수 섹션

| 섹션 | 설명 |
|------|------|
| `## 사용 시점` | 언제 이 스킬이 활성화되는지 |
| `## 사용하지 않을 때` | 다른 스킬로 위임해야 할 때 |
| `## Core Rules` | 핵심 규칙 (5개 이내) |
| `## How to Execute` | 실행 방법 (리소스 파일 참조) |
| `## References` | 관련 리소스 파일 목록 |

## 스킬 설계 원칙

### 1. 단일 책임
- 하나의 스킬은 하나의 도메인만 담당
- 범위가 넓으면 분리 (예: `frontend-agent` + `qa-agent`)

### 2. 트리거 명확성
- `description` 필드에 트리거 키워드를 자연스럽게 포함
- `_shared/skill-routing.md`에 키워드 매핑 추가

### 3. 리소스 패턴
| 파일 | 용도 |
|------|------|
| `execution-protocol.md` | 단계별 실행 절차 |
| `examples.md` | 입력/출력 예시 |
| `checklist.md` | 완료 전 검증 목록 |
| `error-playbook.md` | 공통 에러 해결법 |

### 4. 공유 리소스 활용
`_shared/` 디렉토리의 공통 리소스 참조:
- `context-loading.md` — 컨텍스트 로딩 전략
- `reasoning-templates.md` — 추론 템플릿
- `skill-routing.md` — 스킬 라우팅 규칙
- `clarification-protocol.md` — 명확화 프로토콜

## 새 스킬 생성 체크리스트

- [ ] `SKILL.md` 파일에 YAML frontmatter 포함
- [ ] `## 사용 시점` / `## 사용하지 않을 때` 섹션 작성
- [ ] Core Rules (5개 이내) 정의
- [ ] 실행 프로토콜이 필요하면 `resources/execution-protocol.md` 생성
- [ ] `_shared/skill-routing.md`에 키워드 매핑 추가
- [ ] 스킬 설명에 트리거 키워드가 자연스럽게 포함되는지 확인

## 스킬 트러블슈팅

### 스킬이 활성화되지 않을 때
1. `SKILL.md`의 `description` 필드에 사용자가 쓸 법한 키워드가 있는지 확인
2. `_shared/skill-routing.md`에 매핑이 있는지 확인
3. `name` 필드가 고유한지 확인

### 스킬이 너무 자주 활성화될 때
1. `description`의 키워드를 더 구체적으로 변경
2. `## 사용하지 않을 때` 섹션을 강화
3. 다른 스킬과 중복되는 키워드 제거

### 스킬 간 충돌
1. `_shared/skill-routing.md`의 라우팅 규칙에 우선순위 명시
2. 실행 순서 규칙 (pm → frontend → qa) 참고
3. 가드레일 스킬은 항상 우선

## 세션 기반 스킬 점검 (핵심 로직)

세션에서 변경된 파일을 분석하여 기존 스킬이 커버하지 못하는 갭을 감지합니다.

### 실행 절차

1. **변경 파일 수집**
   ```bash
   git diff HEAD --name-only
   git diff main...HEAD --name-only 2>/dev/null
   ```

2. **기존 스킬 매핑 확인**
   - 변경된 파일이 기존 스킬(frontend-agent, debug-agent 등)의 커버리지에 포함되는지 확인
   - 매핑되지 않는 파일 목록 식별

3. **스킬 생성 판단 기준** (중요한 것만)
   - ✅ **생성 대상**: 3개 이상의 관련 파일이 공통 규칙/패턴을 공유하는 경우
   - ❌ **면제 대상**: lock 파일, 문서(README/CHANGELOG), 설정 파일(단순 변경), 테스트 픽스처, CI/CD, vendor 코드

4. **결정 트리**
   ```
   미커버 파일에 대해:
     IF 기존 스킬이 확장되면 커버 가능 → UPDATE 제안
     ELSE IF 3개+ 관련 파일이 공통 패턴 공유 → CREATE 제안
     ELSE → 면제 (스킬 불필요)
   ```

5. **사용자에게 제안** — 변경 사항을 요약하고 UPDATE/CREATE를 제안 (자동 실행 금지)

### 주의사항
- 사용자 확인 없이 스킬을 자동 생성하지 않음
- 기존 스킬의 작동하는 검사는 절대 제거하지 않음 (추가만 가능)
- 새 스킬 이름은 반드시 사용자에게 확인 후 결정

## References
- 스킬 라우팅: `../_shared/skill-routing.md`
- 컨텍스트 로딩: `../_shared/context-loading.md`
