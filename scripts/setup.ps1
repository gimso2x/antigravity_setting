<#
.SYNOPSIS
    Antigravity Setting 초기화 스크립트 — 워크스페이스 타입에 따라 .agent(antigravity) 또는 .cursor(cursor) 또는 둘 다 배포합니다.

.DESCRIPTION
    -WorkspaceAgent에 따라 타겟 프로젝트에 넣는 내용이 다릅니다.
    - antigravity: .agent/ + init.md + 글로벌 GEMINI.md
    - cursor: .cursor/rules/ 만 (이 레포의 .cursor/rules 에서 복사)
    - both: antigravity + cursor 모두 배포

.PARAMETER TargetPath
    설정을 적용할 타겟 프로젝트 경로 (기본: 현재 디렉토리)

.PARAMETER WorkspaceAgent
    antigravity → .agent (Gemini) | cursor → .cursor (Cursor IDE) | both → 둘 다
    생략하면 인터랙티브 선택 메뉴가 표시됩니다.

.EXAMPLE
    # 인터랙티브 선택
    .\scripts\setup.ps1 -TargetPath "C:\work\my-project"

    # 직접 지정
    .\scripts\setup.ps1 -TargetPath "C:\work\my-project" -WorkspaceAgent both
#>
param(
    [string]$TargetPath = (Get-Location).Path,
    [ValidateSet("antigravity", "cursor", "both", "")]
    [string]$WorkspaceAgent = ""
)

# ── 설정 ──
$ScriptDir = Split-Path -Parent $PSScriptRoot  # 레포 루트 (scripts/의 상위)
$GeminiGlobalDir = Join-Path $env:USERPROFILE ".gemini"
$GeminiGlobalPath = Join-Path $GeminiGlobalDir "GEMINI.md"
$CursorRulesSource = Join-Path $ScriptDir ".cursor\rules"
$CursorRulesDest = Join-Path $TargetPath ".cursor\rules"

# ── 색상 헬퍼 ──
function Write-Step($step, $msg) {
    Write-Host "`n[$step] " -ForegroundColor Cyan -NoNewline
    Write-Host $msg
}
function Write-OK($msg) {
    Write-Host "  ✅ $msg" -ForegroundColor Green
}
function Write-Warn($msg) {
    Write-Host "  ⚠️  $msg" -ForegroundColor Yellow
}
function Write-Err($msg) {
    Write-Host "  ❌ $msg" -ForegroundColor Red
}

# ── 시작 배너 ──
Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║   🚀 Antigravity Setting 초기화 스크립트   ║" -ForegroundColor Magenta
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""
Write-Host "소스 레포:       $ScriptDir"
Write-Host "타겟 프로젝트:   $TargetPath"

# ── 인터랙티브 선택 (파라미터가 없을 때) ──
if ([string]::IsNullOrEmpty($WorkspaceAgent)) {
    Write-Host ""
    Write-Host "┌──────────────────────────────────────────┐" -ForegroundColor Yellow
    Write-Host "│  워크스페이스 에이전트를 선택하세요       │" -ForegroundColor Yellow
    Write-Host "├──────────────────────────────────────────┤" -ForegroundColor Yellow
    Write-Host "│  [1] Antigravity (.agent + GEMINI.md)    │" -ForegroundColor White
    Write-Host "│  [2] Cursor     (.cursor/rules/)         │" -ForegroundColor Cyan
    Write-Host "│  [3] 둘 다      (Antigravity + Cursor)   │" -ForegroundColor Green
    Write-Host "└──────────────────────────────────────────┘" -ForegroundColor Yellow
    Write-Host ""

    do {
        $choice = Read-Host "선택 (1/2/3)"
        switch ($choice) {
            "1" { $WorkspaceAgent = "antigravity"; break }
            "2" { $WorkspaceAgent = "cursor"; break }
            "3" { $WorkspaceAgent = "both"; break }
            default { Write-Warn "1, 2, 3 중에서 선택해 주세요." }
        }
    } while ([string]::IsNullOrEmpty($WorkspaceAgent))

    Write-Host ""
}

$agentLabel = switch ($WorkspaceAgent) {
    "antigravity" { "Antigravity" }
    "cursor" { "Cursor" }
    "both" { "Antigravity + Cursor" }
}
Write-Host "워크스페이스:    $agentLabel" -ForegroundColor $(if ($WorkspaceAgent -eq "cursor") { "Cyan" } elseif ($WorkspaceAgent -eq "both") { "Green" } else { "White" })

# ── 소스 = 타겟 감지 ──
$ResolvedSource = (Resolve-Path $ScriptDir).Path.TrimEnd('\')
$ResolvedTarget = (Resolve-Path $TargetPath).Path.TrimEnd('\')

if ($ResolvedSource -eq $ResolvedTarget) {
    Write-Err "소스 레포와 타겟 프로젝트가 동일합니다!"
    Write-Host "  → 다른 프로젝트 경로를 -TargetPath로 지정해 주세요." -ForegroundColor Yellow
    Write-Host "  예: .\scripts\setup.ps1 -TargetPath `"C:\work\my-project`"" -ForegroundColor Yellow
    exit 1
}

# ══════════════════════════════════════════
# 배포 함수 정의
# ══════════════════════════════════════════

function Deploy-Antigravity {
    param([string]$StepPrefix = "")

    Write-Step "${StepPrefix}1" ".agent/ 디렉토리를 타겟에 복사 (antigravity 전용)..."
    $SourceAgent = Join-Path $ScriptDir ".agent"
    $script:DestAgent = Join-Path $TargetPath ".agent"
    if (-not (Test-Path $SourceAgent)) {
        Write-Err "소스 .agent/ 디렉토리가 없습니다: $SourceAgent"
        exit 1
    }
    if (Test-Path $script:DestAgent) {
        Write-Warn "기존 .agent/ 발견 → 덮어씁니다."
        Remove-Item -Recurse -Force $script:DestAgent
    }
    Copy-Item -Recurse -Force $SourceAgent $script:DestAgent
    $fileCount = (Get-ChildItem -Recurse -File $script:DestAgent).Count
    Write-OK ".agent/ 복사 완료 ($fileCount 파일)"



    Write-Step "${StepPrefix}2" "Global GEMINI.md 설정..."
    $SourceGemini = Join-Path $ScriptDir "GEMINI.md"
    if (-not (Test-Path $SourceGemini)) {
        Write-Err "소스 GEMINI.md가 없습니다: $SourceGemini"
        exit 1
    }
    if (-not (Test-Path $GeminiGlobalDir)) {
        New-Item -ItemType Directory -Path $GeminiGlobalDir -Force | Out-Null
    }
    if (Test-Path $GeminiGlobalPath) {
        $backupPath = "$GeminiGlobalPath.bak"
        Copy-Item -Force $GeminiGlobalPath $backupPath
        Write-Warn "기존 GEMINI.md 백업: $backupPath"
    }
    Copy-Item -Force $SourceGemini $GeminiGlobalPath
    Write-OK "Global GEMINI.md 설정 완료: $GeminiGlobalPath"
}

function Deploy-Cursor {
    param([string]$StepPrefix = "")

    Write-Step "${StepPrefix}1" ".cursor/rules/ 생성 및 Cursor 규칙 템플릿 복사..."
    if (-not (Test-Path $CursorRulesSource)) {
        Write-Err "Cursor 규칙 템플릿이 없습니다: $CursorRulesSource"
        exit 1
    }
    if (Test-Path $CursorRulesDest) {
        Write-Warn "기존 .cursor/rules/ 발견 → 덮어씁니다."
        Remove-Item -Recurse -Force $CursorRulesDest
    }
    New-Item -ItemType Directory -Path $CursorRulesDest -Force | Out-Null
    Get-ChildItem -Path $CursorRulesSource -Filter "*.mdc" | ForEach-Object { Copy-Item -Path $_.FullName -Destination $CursorRulesDest -Force }
    $rulesCount = (Get-ChildItem -Path $CursorRulesDest -File).Count
    Write-OK ".cursor/rules/ 복사 완료 ($rulesCount 파일)"

    Write-Step "${StepPrefix}2" "CURSOR_GLOBAL_RULES.md 복사..."
    $SourceGlobalRules = Join-Path $ScriptDir "CURSOR_GLOBAL_RULES.md"
    if (Test-Path $SourceGlobalRules) {
        $DestGlobalRules = Join-Path $TargetPath "CURSOR_GLOBAL_RULES.md"
        Copy-Item -Force $SourceGlobalRules $DestGlobalRules
        Write-OK "CURSOR_GLOBAL_RULES.md 복사 완료: $DestGlobalRules"
    } else {
        Write-Warn "소스 CURSOR_GLOBAL_RULES.md가 없습니다: $SourceGlobalRules"
    }


}

# ══════════════════════════════════════════
# 실행
# ══════════════════════════════════════════

switch ($WorkspaceAgent) {
    "antigravity" {
        Write-Host "`n── Antigravity 배포 ──" -ForegroundColor Magenta
        Deploy-Antigravity
    }
    "cursor" {
        Write-Host "`n── Cursor 배포 ──" -ForegroundColor Cyan
        Deploy-Cursor
    }
    "both" {
        Write-Host "`n── [A] Antigravity 배포 ──" -ForegroundColor Magenta
        Deploy-Antigravity -StepPrefix "A-"
        Write-Host "`n── [B] Cursor 배포 ──" -ForegroundColor Cyan
        Deploy-Cursor -StepPrefix "B-"
    }
}

# ── 통합 init.md 복사 (선택에 따라 적절한 템플릿 사용) ──
$TemplateDir = Join-Path $ScriptDir "templates"
$InitTemplateName = "init-$WorkspaceAgent.md"
$SourceInitTemplate = Join-Path $TemplateDir $InitTemplateName
$script:DestInit = Join-Path $TargetPath "init.md"

Write-Step "★" "init.md 복사 ($agentLabel 템플릿)..."
if (Test-Path $SourceInitTemplate) {
    Copy-Item -Force $SourceInitTemplate $script:DestInit
    Write-OK "init.md 복사 완료 → LLM에 붙여넣으면 프로젝트 설정이 자동 생성됩니다."
}
else {
    Write-Err "init 템플릿이 없습니다: $SourceInitTemplate"
}

# ── 완료 ──
Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✅ 초기화 완료!                          ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

if ($WorkspaceAgent -eq "antigravity" -or $WorkspaceAgent -eq "both") {
    Write-Host "📁 .agent/       → $($script:DestAgent)" -ForegroundColor White
    Write-Host "📄 GEMINI.md     → $GeminiGlobalPath (글로벌)" -ForegroundColor White
}
if ($WorkspaceAgent -eq "cursor" -or $WorkspaceAgent -eq "both") {
    Write-Host "📂 .cursor/rules/ → $CursorRulesDest" -ForegroundColor White
    $DestGlobalRules = Join-Path $TargetPath "CURSOR_GLOBAL_RULES.md"
    Write-Host "📄 CURSOR_GLOBAL_RULES.md → $DestGlobalRules" -ForegroundColor White
}
Write-Host "📝 init.md       → $($script:DestInit)" -ForegroundColor White

Write-Host ""
Write-Host "💡 다음 단계:" -ForegroundColor Yellow
if ($WorkspaceAgent -eq "cursor" -or $WorkspaceAgent -eq "both") {
    Write-Host "   1. 프로젝트 루트에 복사된 CURSOR_GLOBAL_RULES.md 내용을 Cursor Settings → Rules에 붙여넣으세요." -ForegroundColor Yellow
}
Write-Host "   → init.md를 열어 LLM 에이전트에게 붙여넣으면 프로젝트(Workspace) 설정이 자동 생성됩니다." -ForegroundColor Yellow
Write-Host ""
