<#
.SYNOPSIS
    Antigravity Setting 초기화 스크립트
    .agent/ 복사 + Global GEMINI.md 설정을 자동화합니다.

.DESCRIPTION
    이 레포를 clone한 후 실행하면:
    1. .agent/ 디렉토리를 타겟 프로젝트에 복사 (덮어쓰기)
    2. GEMINI.md를 ~/.gemini/GEMINI.md에 글로벌 설정으로 복사

.PARAMETER TargetPath
    .agent/를 복사할 프로젝트 경로 (기본: 현재 디렉토리)

.EXAMPLE
    # 현재 프로젝트에 설정 적용
    .\scripts\setup.ps1

    # 특정 프로젝트에 설정 적용
    .\scripts\setup.ps1 -TargetPath "C:\work\my-project"
#>
param(
    [string]$TargetPath = (Get-Location).Path
)

# ── 설정 ──
$ScriptDir = Split-Path -Parent $PSScriptRoot  # 레포 루트 (scripts/의 상위)
$GeminiGlobalDir = Join-Path $env:USERPROFILE ".gemini"
$GeminiGlobalPath = Join-Path $GeminiGlobalDir "GEMINI.md"

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
Write-Host "소스 레포:     $ScriptDir"
Write-Host "타겟 프로젝트: $TargetPath"

# ── 소스 = 타겟 감지 ──
$ResolvedSource = (Resolve-Path $ScriptDir).Path.TrimEnd('\')
$ResolvedTarget = (Resolve-Path $TargetPath).Path.TrimEnd('\')

if ($ResolvedSource -eq $ResolvedTarget) {
    Write-Err "소스 레포와 타겟 프로젝트가 동일합니다!"
    Write-Host "  → 다른 프로젝트 경로를 -TargetPath로 지정해 주세요." -ForegroundColor Yellow
    Write-Host "  예: .\scripts\setup.ps1 -TargetPath `"C:\work\my-project`"" -ForegroundColor Yellow
    exit 1
}

# ── Step 1: .agent/ 복사 ──
Write-Step "1/3" ".agent/ 디렉토리를 프로젝트에 복사..."

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

# ── Step 2: Global GEMINI.md 복사 ──
# ── Step 2: init.md 복사 ──
Write-Step "2/3" "init.md를 프로젝트에 복사..."

$SourceInit = Join-Path $ScriptDir "init.md"
$DestInit = Join-Path $TargetPath "init.md"

if (Test-Path $SourceInit) {
    Copy-Item -Force $SourceInit $DestInit
    Write-OK "init.md 복사 완료 → LLM에 붙여넣어 workspace GEMINI.md를 생성하세요."
} else {
    Write-Warn "init.md가 없습니다. 건너뜁니다."
}

# ── Step 3: Global GEMINI.md 복사 ──
Write-Step "3/3" "Global GEMINI.md 설정..."

$SourceGemini = Join-Path $ScriptDir "GEMINI.md"

if (-not (Test-Path $SourceGemini)) {
    Write-Err "소스 GEMINI.md가 없습니다: $SourceGemini"
    exit 1
}

# ~/.gemini/ 디렉토리 생성
if (-not (Test-Path $GeminiGlobalDir)) {
    New-Item -ItemType Directory -Path $GeminiGlobalDir -Force | Out-Null
}

# 기존 파일 백업
if (Test-Path $GeminiGlobalPath) {
    $backupPath = "$GeminiGlobalPath.bak"
    Copy-Item -Force $GeminiGlobalPath $backupPath
    Write-Warn "기존 GEMINI.md 백업: $backupPath"
}

Copy-Item -Force $SourceGemini $GeminiGlobalPath
Write-OK "Global GEMINI.md 설정 완료: $GeminiGlobalPath"

# ── 완료 ──
Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✅ 초기화 완료!                          ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "📁 .agent/       → $DestAgent" -ForegroundColor White
Write-Host "📄 GEMINI.md     → $GeminiGlobalPath (글로벌)" -ForegroundColor White
Write-Host "📝 init.md       → $DestInit" -ForegroundColor White
Write-Host ""
Write-Host "💡 다음 단계: init.md를 열어 LLM 에이전트에게 붙여넣으면" -ForegroundColor Yellow
Write-Host "   이 프로젝트에 맞는 workspace GEMINI.md를 생성하세요." -ForegroundColor Yellow
Write-Host ""
