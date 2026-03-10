#!/bin/bash

# ==============================================================================
# SYNOPSIS
#     Antigravity Setting 초기화 스크립트 — 워크스페이스 타입에 따라 .agent(antigravity) 또는 .cursor(cursor) 또는 둘 다 배포합니다.
#
# DESCRIPTION
#     -WorkspaceAgent에 따라 타겟 프로젝트에 넣는 내용이 다릅니다.
#     - antigravity: .agent/ + init.md + 글로벌 GEMINI.md
#     - cursor: .cursor/rules/ 만 (이 레포의 .cursor/rules 에서 복사)
#     - both: antigravity + cursor 모두 배포
#
# PARAMETER 1 (TargetPath)
#     설정을 적용할 타겟 프로젝트 경로 (기본: 현재 디렉토리)
#
# PARAMETER 2 (WorkspaceAgent)
#     antigravity → .agent (Gemini) | cursor → .cursor (Cursor IDE) | both → 둘 다
#     생략하면 인터랙티브 선택 메뉴가 표시됩니다.
#
# EXAMPLE
#     # 인터랙티브 선택
#     ./scripts/setup.sh /path/to/my-project
#
#     # 직접 지정
#     ./scripts/setup.sh /path/to/my-project both
# ==============================================================================

# 기본값 설정
TARGET_PATH="${1:-$(pwd)}"
WORKSPACE_AGENT="$2"

# ── 설정 ──
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &> /dev/null && pwd)"
GEMINI_GLOBAL_DIR="$HOME/.gemini"
GEMINI_GLOBAL_PATH="$GEMINI_GLOBAL_DIR/GEMINI.md"
CURSOR_RULES_SOURCE="$SCRIPT_DIR/.cursor/rules"
CURSOR_RULES_DEST="$TARGET_PATH/.cursor/rules"
TEMPLATE_DIR="$SCRIPT_DIR/templates"

# ── 색상 헬퍼 ──
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

write_step() {
    printf "\n${CYAN}[$1] %s${NC}\n" "$2"
}
write_ok() {
    printf "  ✅ ${GREEN}%s${NC}\n" "$1"
}
write_warn() {
    printf "  ⚠️  ${YELLOW}%s${NC}\n" "$1"
}
write_err() {
    printf "  ❌ ${RED}%s${NC}\n" "$1"
}

# ── 시작 배너 ──
echo ""
printf "${MAGENTA}╔══════════════════════════════════════════╗${NC}\n"
printf "${MAGENTA}║   🚀 Antigravity Setting 초기화 스크립트   ║${NC}\n"
printf "${MAGENTA}╚══════════════════════════════════════════╝${NC}\n"
echo ""
echo "소스 레포:       $SCRIPT_DIR"
echo "타겟 프로젝트:   $TARGET_PATH"

# ── 인터랙티브 선택 (파라미터가 없을 때) ──
if [ -z "$WORKSPACE_AGENT" ]; then
    echo ""
    printf "${YELLOW}┌──────────────────────────────────────────┐${NC}\n"
    printf "${YELLOW}│  워크스페이스 에이전트를 선택하세요       │${NC}\n"
    printf "${YELLOW}├──────────────────────────────────────────┤${NC}\n"
    printf "${YELLOW}│${NC}  ${WHITE}[1] Antigravity (.agent + GEMINI.md)${NC}    ${YELLOW}│${NC}\n"
    printf "${YELLOW}│${NC}  ${CYAN}[2] Cursor     (.cursor/rules/)${NC}         ${YELLOW}│${NC}\n"
    printf "${YELLOW}│${NC}  ${GREEN}[3] 둘 다      (Antigravity + Cursor)${NC}   ${YELLOW}│${NC}\n"
    printf "${YELLOW}└──────────────────────────────────────────┘${NC}\n"
    echo ""

    while [ -z "$WORKSPACE_AGENT" ]; do
        read -p "선택 (1/2/3): " choice
        case "$choice" in
            1) WORKSPACE_AGENT="antigravity" ;;
            2) WORKSPACE_AGENT="cursor" ;;
            3) WORKSPACE_AGENT="both" ;;
            *) write_warn "1, 2, 3 중에서 선택해 주세요." ;;
        esac
    done
    echo ""
fi

# 라벨 및 색상 설정
if [ "$WORKSPACE_AGENT" = "antigravity" ]; then
    AGENT_LABEL="Antigravity"
    LABEL_COLOR=$WHITE
elif [ "$WORKSPACE_AGENT" = "cursor" ]; then
    AGENT_LABEL="Cursor"
    LABEL_COLOR=$CYAN
elif [ "$WORKSPACE_AGENT" = "both" ]; then
    AGENT_LABEL="Antigravity + Cursor"
    LABEL_COLOR=$GREEN
else
    write_err "잘못된 워크스페이스 에이전트입니다. (antigravity, cursor, both 중 하나여야 합니다.)"
    exit 1
fi

printf "워크스페이스:    ${LABEL_COLOR}%s${NC}\n" "$AGENT_LABEL"

# ── 디렉토리 확장 및 절대 경로 계산 ──
# "realpath" 명령이 없는 플랫폼 대비 간이 해결 함수
get_abs_path() {
    local target="$1"
    if [ -d "$target" ]; then
        cd "$target" && pwd
    elif [ -e "$target" ]; then
        echo "$(cd "$(dirname "$target")" && pwd)/$(basename "$target")"
    else
        echo "$target" # 존재하지 않으면 원본 반환
    fi
}

RESOLVED_SOURCE=$(get_abs_path "$SCRIPT_DIR")
RESOLVED_TARGET=$(get_abs_path "$TARGET_PATH")

if [ "$RESOLVED_SOURCE" = "$RESOLVED_TARGET" ]; then
    write_err "소스 레포와 타겟 프로젝트가 동일합니다!"
    printf "  → 다른 프로젝트 경로를 첫 번째 인수로 지정해 주세요.\n"
    printf "  예: ./scripts/setup.sh /path/to/my-project\n"
    exit 1
fi

# 타겟 경로 생성
if [ ! -d "$TARGET_PATH" ]; then
    mkdir -p "$TARGET_PATH"
fi

# ==============================================================================
# 배포 함수 정의
# ==============================================================================

deploy_antigravity() {
    local step_prefix="$1"

    write_step "${step_prefix}1" ".agent/ 디렉토리를 타겟에 복사 (antigravity 전용)..."
    SOURCE_AGENT="$SCRIPT_DIR/.agent"
    DEST_AGENT="$TARGET_PATH/.agent"
    
    if [ ! -d "$SOURCE_AGENT" ]; then
        write_err "소스 .agent/ 디렉토리가 없습니다: $SOURCE_AGENT"
        exit 1
    fi
    
    if [ -d "$DEST_AGENT" ]; then
        write_warn "기존 .agent/ 발견 → 덮어씁니다."
        rm -rf "$DEST_AGENT"
    fi
    
    cp -R "$SOURCE_AGENT" "$DEST_AGENT"
    FILE_COUNT=$(find "$DEST_AGENT" -type f | wc -l | tr -d ' ')
    write_ok ".agent/ 복사 완료 ($FILE_COUNT 파일)"

    write_step "${step_prefix}2" "Global GEMINI.md 설정..."
    SOURCE_GEMINI="$SCRIPT_DIR/GEMINI.md"
    
    if [ ! -f "$SOURCE_GEMINI" ]; then
        write_err "소스 GEMINI.md가 없습니다: $SOURCE_GEMINI"
        exit 1
    fi
    
    if [ ! -d "$GEMINI_GLOBAL_DIR" ]; then
        mkdir -p "$GEMINI_GLOBAL_DIR"
    fi
    
    if [ -f "$GEMINI_GLOBAL_PATH" ]; then
        BACKUP_PATH="${GEMINI_GLOBAL_PATH}.bak"
        cp "$GEMINI_GLOBAL_PATH" "$BACKUP_PATH"
        write_warn "기존 GEMINI.md 백업: $BACKUP_PATH"
    fi
    
    cp "$SOURCE_GEMINI" "$GEMINI_GLOBAL_PATH"
    write_ok "Global GEMINI.md 설정 완료: $GEMINI_GLOBAL_PATH"
}

deploy_cursor() {
    local step_prefix="$1"

    write_step "${step_prefix}1" ".cursor/rules/ 생성 및 Cursor 규칙 템플릿 복사..."
    
    if [ ! -d "$CURSOR_RULES_SOURCE" ]; then
        write_err "Cursor 규칙 템플릿이 없습니다: $CURSOR_RULES_SOURCE"
        exit 1
    fi
    
    if [ -d "$CURSOR_RULES_DEST" ]; then
        write_warn "기존 .cursor/rules/ 발견 → 덮어씁니다."
        rm -rf "$CURSOR_RULES_DEST"
    fi
    
    mkdir -p "$CURSOR_RULES_DEST"
    cp -R "$CURSOR_RULES_SOURCE/"*.mdc "$CURSOR_RULES_DEST/" 2>/dev/null || true
    RULES_COUNT=$(find "$CURSOR_RULES_DEST" -type f -name "*.mdc" | wc -l | tr -d ' ')
    write_ok ".cursor/rules/ 복사 완료 ($RULES_COUNT 파일)"

    write_step "${step_prefix}2" "CURSOR_GLOBAL_RULES.md 복사..."
    SOURCE_GLOBAL_RULES="$SCRIPT_DIR/CURSOR_GLOBAL_RULES.md"
    
    if [ -f "$SOURCE_GLOBAL_RULES" ]; then
        DEST_GLOBAL_RULES="$TARGET_PATH/CURSOR_GLOBAL_RULES.md"
        cp "$SOURCE_GLOBAL_RULES" "$DEST_GLOBAL_RULES"
        write_ok "CURSOR_GLOBAL_RULES.md 복사 완료: $DEST_GLOBAL_RULES"
    else
        write_warn "소스 CURSOR_GLOBAL_RULES.md가 없습니다: $SOURCE_GLOBAL_RULES"
    fi
}

# ==============================================================================
# 실행
# ==============================================================================

case "$WORKSPACE_AGENT" in
    "antigravity")
        printf "\n${MAGENTA}── Antigravity 배포 ──${NC}\n"
        deploy_antigravity ""
        ;;
    "cursor")
        printf "\n${CYAN}── Cursor 배포 ──${NC}\n"
        deploy_cursor ""
        ;;
    "both")
        printf "\n${MAGENTA}── [A] Antigravity 배포 ──${NC}\n"
        deploy_antigravity "A-"
        printf "\n${CYAN}── [B] Cursor 배포 ──${NC}\n"
        deploy_cursor "B-"
        ;;
esac

# ── 통합 init.md 복사 (선택에 따라 적절한 템플릿 사용) ──
INIT_TEMPLATE_NAME="init-${WORKSPACE_AGENT}.md"
SOURCE_INIT_TEMPLATE="$TEMPLATE_DIR/$INIT_TEMPLATE_NAME"
DEST_INIT="$TARGET_PATH/init.md"

write_step "★" "init.md 복사 ($AGENT_LABEL 템플릿)..."
if [ -f "$SOURCE_INIT_TEMPLATE" ]; then
    cp "$SOURCE_INIT_TEMPLATE" "$DEST_INIT"
    write_ok "init.md 복사 완료 → LLM에 붙여넣으면 프로젝트 설정이 자동 생성됩니다."
else
    write_err "init 템플릿이 없습니다: $SOURCE_INIT_TEMPLATE"
fi

# ── 완료 ──
echo ""
printf "${GREEN}╔══════════════════════════════════════════╗${NC}\n"
printf "${GREEN}║   ✅ 초기화 완료!                          ║${NC}\n"
printf "${GREEN}╚══════════════════════════════════════════╝${NC}\n"
echo ""

if [ "$WORKSPACE_AGENT" = "antigravity" ] || [ "$WORKSPACE_AGENT" = "both" ]; then
    printf "${WHITE}📁 .agent/       → %s${NC}\n" "$DEST_AGENT"
    printf "${WHITE}📄 GEMINI.md     → %s (글로벌)${NC}\n" "$GEMINI_GLOBAL_PATH"
fi

if [ "$WORKSPACE_AGENT" = "cursor" ] || [ "$WORKSPACE_AGENT" = "both" ]; then
    printf "${WHITE}📂 .cursor/rules/ → %s${NC}\n" "$CURSOR_RULES_DEST"
    DEST_GLOBAL_RULES="$TARGET_PATH/CURSOR_GLOBAL_RULES.md"
    printf "${WHITE}📄 CURSOR_GLOBAL_RULES.md → %s${NC}\n" "$DEST_GLOBAL_RULES"
fi

printf "${WHITE}📝 init.md       → %s${NC}\n" "$DEST_INIT"

echo ""
printf "${YELLOW}💡 다음 단계:${NC}\n"
if [ "$WORKSPACE_AGENT" = "cursor" ] || [ "$WORKSPACE_AGENT" = "both" ]; then
    printf "${YELLOW}   1. 프로젝트 루트에 복사된 CURSOR_GLOBAL_RULES.md 내용을 Cursor Settings → Rules에 붙여넣으세요.${NC}\n"
fi
printf "${YELLOW}   → init.md를 열어 LLM 에이전트에게 붙여넣으면 프로젝트(Workspace) 설정이 자동 생성됩니다.${NC}\n"
echo ""
