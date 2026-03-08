<#
.SYNOPSIS
    Antigravity Setting 초기화 스크립트 — 워크스페이스 타입에 따라 .agent(antigravity) 또는 .cursor(cursor)만 배포합니다.

.DESCRIPTION
    -WorkspaceAgent에 따라 타겟 프로젝트에 넣는 내용이 다릅니다.
    - antigravity: .agent/ + init.md + 글로벌 GEMINI.md
    - cursor: .cursor/rules/ 만 (이 레포의 .cursor/rules 에서 복사)

.PARAMETER TargetPath
    설정을 적용할 타겟 프로젝트 경로 (기본: 현재 디렉토리)

.PARAMETER WorkspaceAgent
    antigravity → .agent (Gemini) | cursor → .cursor (Cursor IDE)

.EXAMPLE
    # Antigravity: .agent + init.md + 글로벌 GEMINI.md
    .\scripts\setup.ps1 -TargetPath "C:\work\my-project"

    # Cursor: .cursor/rules/ 만 배포
    .\scripts\setup.ps1 -TargetPath "C:\work\my-project" -WorkspaceAgent cursor
#>
param(
    [string]$TargetPath = (Get-Location).Path,
    [ValidateSet("antigravity", "cursor")]
    [string]$WorkspaceAgent = "antigravity"
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

# ── 시작 ──
Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║   🚀 Antigravity Setting 초기화 스크립트   ║" -ForegroundColor Magenta
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""
Write-Host "소스 레포:       $ScriptDir"
Write-Host "타겟 프로젝트:   $TargetPath"
Write-Host "워크스페이스:    $WorkspaceAgent" -ForegroundColor $(if ($WorkspaceAgent -eq "cursor") { "Cyan" } else { "White" })

# ── 소스 = 타겟 감지 ──
$ResolvedSource = (Resolve-Path $ScriptDir).Path.TrimEnd('\')
$ResolvedTarget = (Resolve-Path $TargetPath).Path.TrimEnd('\')

if ($ResolvedSource -eq $ResolvedTarget) {
    Write-Err "소스 레포와 타겟 프로젝트가 동일합니다!"
    Write-Host "  → 다른 프로젝트 경로를 -TargetPath로 지정해 주세요." -ForegroundColor Yellow
    Write-Host "  예: .\scripts\setup.ps1 -TargetPath `"C:\work\my-project`"" -ForegroundColor Yellow
    exit 1
}

# ── 워크스페이스별 설정: .agent = antigravity, .cursor = cursor ──
if ($WorkspaceAgent -eq "antigravity") {
    Write-Step "1" ".agent/ 디렉토리를 타겟에 복사 (antigravity 전용)..."
    $SourceAgent = Join-Path $ScriptDir ".agent"
    $DestAgent = Join-Path $TargetPath ".agent"
    if (-not (Test-Path $SourceAgent)) {
        Write-Err "소스 .agent/ 디렉토리가 없습니다: $SourceAgent"
        exit 1
    }
    if (Test-Path $DestAgent) {
        Write-Warn "기존 .agent/ 발견 → 덮어씁니다."
        Remove-Item -Recurse -Force $DestAgent
    }
    Copy-Item -Recurse -Force $SourceAgent $DestAgent
    $fileCount = (Get-ChildItem -Recurse -File $DestAgent).Count
    Write-OK ".agent/ 복사 완료 ($fileCount 파일)"

    Write-Step "2" "init.md 복사 (Antigravity/Gemini용)..."
    $SourceInit = Join-Path $ScriptDir "init.md"
    $DestInit = Join-Path $TargetPath "init.md"
    if (Test-Path $SourceInit) {
        Copy-Item -Force $SourceInit $DestInit
        Write-OK "init.md 복사 완료 → LLM에 붙여넣어 workspace GEMINI.md를 생성하세요."
    }
    else {
        Write-Warn "init.md가 없습니다. 건너뜁니다."
    }

    Write-Step "3" "Global GEMINI.md 설정..."
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
else {
    # cursor: .cursor 만 배포 (.agent 복사 안 함)
    Write-Step "1" ".cursor/rules/ 생성 및 Cursor 규칙 템플릿 복사..."
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

    Write-Step "2" "cursor-init.md 복사 (프로젝트 컨텍스트 생성용)..."
    $SourceCursorInit = Join-Path $ScriptDir "cursor-init.md"
    $DestCursorInit = Join-Path $TargetPath "cursor-init.md"
    if (Test-Path $SourceCursorInit) {
        Copy-Item -Force $SourceCursorInit $DestCursorInit
        Write-OK "cursor-init.md 복사 완료 → Cursor 채팅에 붙여넣어 project-context.mdc를 생성하세요."
    }
    else {
        Write-Warn "cursor-init.md가 없습니다. 건너뜁니다."
    }
}

# ── 완료 ──
Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✅ 초기화 완료!                          ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
if ($WorkspaceAgent -eq "antigravity") {
    Write-Host "📁 .agent/       → $DestAgent" -ForegroundColor White
    Write-Host "📄 GEMINI.md     → $GeminiGlobalPath (글로벌)" -ForegroundColor White
    Write-Host "📝 init.md       → $DestInit" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 다음 단계: init.md를 열어 LLM 에이전트에게 붙여넣으면" -ForegroundColor Yellow
    Write-Host "   이 프로젝트에 맞는 workspace GEMINI.md를 생성하세요." -ForegroundColor Yellow
}
else {
    Write-Host "📂 .cursor/rules/ → $CursorRulesDest" -ForegroundColor White
    Write-Host "📝 cursor-init.md → $DestCursorInit" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 다음 단계:" -ForegroundColor Yellow
    Write-Host "   1. CURSOR_GLOBAL_RULES.md를 Cursor Settings → Rules에 붙여넣으세요." -ForegroundColor Yellow
    Write-Host "   2. cursor-init.md를 Cursor 채팅에 붙여넣어 project-context.mdc를 생성하세요." -ForegroundColor Yellow
}
Write-Host ""

