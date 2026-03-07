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

## References
- 스킬 라우팅: `../_shared/skill-routing.md`
- 컨텍스트 로딩: `../_shared/context-loading.md`
