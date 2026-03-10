#!/usr/bin/env node

// ==============================================================================
// @gimso2x/antigravity-setting CLI
//
// 사용법:
//   npx @gimso2x/antigravity-setting                  # 인터랙티브 선택
//   npx @gimso2x/antigravity-setting --cursor          # Cursor만
//   npx @gimso2x/antigravity-setting --both            # Antigravity + Cursor
//   npx @gimso2x/antigravity-setting --target ./path   # 타겟 경로 지정
//   npx @gimso2x/antigravity-setting --help            # 도움말
// ==============================================================================

import { existsSync, mkdirSync, cpSync, copyFileSync, readdirSync, rmSync, statSync } from 'node:fs';
import { join, resolve, dirname } from 'node:path';
import { homedir, platform } from 'node:os';
import { createInterface } from 'node:readline';
import { fileURLToPath } from 'node:url';

// ── 경로 설정 ──
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const PKG_ROOT = resolve(__dirname, '..');

// ── ANSI 색상 ──
const C = {
  cyan: '\x1b[36m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  magenta: '\x1b[35m',
  white: '\x1b[97m',
  dim: '\x1b[2m',
  reset: '\x1b[0m',
};

// ── 출력 헬퍼 ──
const log = (msg) => console.log(msg);
const step = (s, msg) => log(`\n${C.cyan}[${s}]${C.reset} ${msg}`);
const ok = (msg) => log(`  ${C.green}✅ ${msg}${C.reset}`);
const warn = (msg) => log(`  ${C.yellow}⚠️  ${msg}${C.reset}`);
const err = (msg) => log(`  ${C.red}❌ ${msg}${C.reset}`);

// ── 인자 파싱 ──
function parseArgs(argv) {
  const args = { agent: '', target: process.cwd() };

  for (let i = 2; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '--help' || arg === '-h') {
      printHelp();
      process.exit(0);
    } else if (arg === '--cursor') {
      args.agent = 'cursor';
    } else if (arg === '--both') {
      args.agent = 'both';
    } else if (arg === '--antigravity') {
      args.agent = 'antigravity';
    } else if (arg === '--target' || arg === '-t') {
      args.target = argv[++i] || process.cwd();
    } else if (!arg.startsWith('-')) {
      // 위치 인자는 타겟 경로로 처리
      args.target = arg;
    }
  }

  return args;
}

function printHelp() {
  log(`
${C.magenta}🚀 @gimso2x/antigravity-setting${C.reset}
${C.dim}AI 에이전트(Antigravity, Cursor) 워크스페이스 설정 CLI${C.reset}

${C.white}사용법:${C.reset}
  npx @gimso2x/antigravity-setting [옵션] [타겟경로]

${C.white}옵션:${C.reset}
  ${C.cyan}--antigravity${C.reset}   Antigravity만 배포 (.agent/ + GEMINI.md)
  ${C.cyan}--cursor${C.reset}        Cursor만 배포 (.cursor/rules/)
  ${C.cyan}--both${C.reset}          둘 다 배포
  ${C.cyan}--target, -t${C.reset}    타겟 프로젝트 경로 (기본: 현재 디렉터리)
  ${C.cyan}--help, -h${C.reset}      도움말 표시

${C.white}예시:${C.reset}
  ${C.dim}# 인터랙티브 선택${C.reset}
  npx @gimso2x/antigravity-setting

  ${C.dim}# Antigravity + Cursor 모두 배포${C.reset}
  npx @gimso2x/antigravity-setting --both

  ${C.dim}# 특정 경로에 Cursor만 배포${C.reset}
  npx @gimso2x/antigravity-setting --cursor --target ./my-project
`);
}

// ── 인터랙티브 메뉴 ──
function askAgent() {
  return new Promise((resolvePromise) => {
    const rl = createInterface({
      input: process.stdin,
      output: process.stdout,
    });

    log('');
    log(`${C.yellow}┌──────────────────────────────────────────┐${C.reset}`);
    log(`${C.yellow}│  워크스페이스 에이전트를 선택하세요       │${C.reset}`);
    log(`${C.yellow}├──────────────────────────────────────────┤${C.reset}`);
    log(`${C.yellow}│${C.reset}  ${C.white}[1] Antigravity (.agent + GEMINI.md)${C.reset}    ${C.yellow}│${C.reset}`);
    log(`${C.yellow}│${C.reset}  ${C.cyan}[2] Cursor     (.cursor/rules/)${C.reset}         ${C.yellow}│${C.reset}`);
    log(`${C.yellow}│${C.reset}  ${C.green}[3] 둘 다      (Antigravity + Cursor)${C.reset}   ${C.yellow}│${C.reset}`);
    log(`${C.yellow}└──────────────────────────────────────────┘${C.reset}`);
    log('');

    const ask = () => {
      rl.question('선택 (1/2/3): ', (answer) => {
        const choice = answer.trim();
        if (choice === '1') {
          rl.close();
          resolvePromise('antigravity');
        } else if (choice === '2') {
          rl.close();
          resolvePromise('cursor');
        } else if (choice === '3') {
          rl.close();
          resolvePromise('both');
        } else {
          warn('1, 2, 3 중에서 선택해 주세요.');
          ask();
        }
      });
    };

    ask();
  });
}

// ── 파일 개수 세기 (재귀) ──
function countFiles(dir) {
  let count = 0;
  if (!existsSync(dir)) return 0;
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.isDirectory()) {
      count += countFiles(join(dir, entry.name));
    } else {
      count++;
    }
  }
  return count;
}

// ── 배포 함수: Antigravity ──
function deployAntigravity(targetPath, prefix = '') {
  const sourceAgent = join(PKG_ROOT, '.agent');
  const destAgent = join(targetPath, '.agent');

  step(`${prefix}1`, '.agent/ 디렉토리를 타겟에 복사 (Antigravity 전용)...');

  if (!existsSync(sourceAgent)) {
    err(`소스 .agent/ 디렉토리가 없습니다: ${sourceAgent}`);
    process.exit(1);
  }

  if (existsSync(destAgent)) {
    warn('기존 .agent/ 발견 → 덮어씁니다.');
    rmSync(destAgent, { recursive: true, force: true });
  }

  cpSync(sourceAgent, destAgent, { recursive: true });
  const fileCount = countFiles(destAgent);
  ok(`.agent/ 복사 완료 (${fileCount} 파일)`);

  // Global GEMINI.md
  step(`${prefix}2`, 'Global GEMINI.md 설정...');
  const sourceGemini = join(PKG_ROOT, 'GEMINI.md');

  if (!existsSync(sourceGemini)) {
    err(`소스 GEMINI.md가 없습니다: ${sourceGemini}`);
    process.exit(1);
  }

  const geminiGlobalDir = join(homedir(), '.gemini');
  const geminiGlobalPath = join(geminiGlobalDir, 'GEMINI.md');

  if (!existsSync(geminiGlobalDir)) {
    mkdirSync(geminiGlobalDir, { recursive: true });
  }

  if (existsSync(geminiGlobalPath)) {
    const backupPath = `${geminiGlobalPath}.bak`;
    copyFileSync(geminiGlobalPath, backupPath);
    warn(`기존 GEMINI.md 백업: ${backupPath}`);
  }

  copyFileSync(sourceGemini, geminiGlobalPath);
  ok(`Global GEMINI.md 설정 완료: ${geminiGlobalPath}`);

  return destAgent;
}

// ── 배포 함수: Cursor ──
function deployCursor(targetPath, prefix = '') {
  const cursorRulesSource = join(PKG_ROOT, '.cursor', 'rules');
  const cursorRulesDest = join(targetPath, '.cursor', 'rules');

  step(`${prefix}1`, '.cursor/rules/ 생성 및 Cursor 규칙 복사...');

  if (!existsSync(cursorRulesSource)) {
    err(`Cursor 규칙 소스가 없습니다: ${cursorRulesSource}`);
    process.exit(1);
  }

  if (existsSync(cursorRulesDest)) {
    warn('기존 .cursor/rules/ 발견 → 덮어씁니다.');
    rmSync(cursorRulesDest, { recursive: true, force: true });
  }

  mkdirSync(cursorRulesDest, { recursive: true });

  // .mdc 파일만 복사
  const mdcFiles = readdirSync(cursorRulesSource).filter((f) => f.endsWith('.mdc'));
  for (const file of mdcFiles) {
    copyFileSync(join(cursorRulesSource, file), join(cursorRulesDest, file));
  }
  ok(`.cursor/rules/ 복사 완료 (${mdcFiles.length} 파일)`);

  // CURSOR_GLOBAL_RULES.md 복사
  step(`${prefix}2`, 'CURSOR_GLOBAL_RULES.md 복사...');
  const sourceGlobalRules = join(PKG_ROOT, 'CURSOR_GLOBAL_RULES.md');

  if (existsSync(sourceGlobalRules)) {
    const destGlobalRules = join(targetPath, 'CURSOR_GLOBAL_RULES.md');
    copyFileSync(sourceGlobalRules, destGlobalRules);
    ok(`CURSOR_GLOBAL_RULES.md 복사 완료: ${destGlobalRules}`);
  } else {
    warn(`소스 CURSOR_GLOBAL_RULES.md가 없습니다: ${sourceGlobalRules}`);
  }

  return cursorRulesDest;
}

// ── 메인 ──
async function main() {
  const args = parseArgs(process.argv);
  const targetPath = resolve(args.target);

  // 에이전트 선택
  let agent = args.agent;
  if (!agent) {
    agent = await askAgent();
  }

  // 라벨 설정
  const labels = {
    antigravity: 'Antigravity',
    cursor: 'Cursor',
    both: 'Antigravity + Cursor',
  };
  const labelColors = {
    antigravity: C.white,
    cursor: C.cyan,
    both: C.green,
  };

  const label = labels[agent];
  const labelColor = labelColors[agent];

  if (!label) {
    err('잘못된 에이전트 타입입니다.');
    process.exit(1);
  }

  // 시작 배너
  log('');
  log(`${C.magenta}╔══════════════════════════════════════════╗${C.reset}`);
  log(`${C.magenta}║   🚀 Antigravity Setting 초기화           ║${C.reset}`);
  log(`${C.magenta}╚══════════════════════════════════════════╝${C.reset}`);
  log('');
  log(`타겟 프로젝트:   ${targetPath}`);
  log(`워크스페이스:    ${labelColor}${label}${C.reset}`);

  // 소스 = 타겟 감지
  const resolvedSource = resolve(PKG_ROOT);
  const resolvedTarget = resolve(targetPath);

  if (resolvedSource === resolvedTarget) {
    err('소스 패키지와 타겟 프로젝트가 동일합니다!');
    log(`  → 다른 프로젝트 경로를 --target으로 지정해 주세요.`);
    process.exit(1);
  }

  // 타겟 디렉토리 생성
  if (!existsSync(targetPath)) {
    mkdirSync(targetPath, { recursive: true });
  }

  // 배포 실행
  let destAgent = '';

  if (agent === 'antigravity') {
    log(`\n${C.magenta}── Antigravity 배포 ──${C.reset}`);
    destAgent = deployAntigravity(targetPath);
  } else if (agent === 'cursor') {
    log(`\n${C.cyan}── Cursor 배포 ──${C.reset}`);
    deployCursor(targetPath);
  } else if (agent === 'both') {
    log(`\n${C.magenta}── [A] Antigravity 배포 ──${C.reset}`);
    destAgent = deployAntigravity(targetPath, 'A-');
    log(`\n${C.cyan}── [B] Cursor 배포 ──${C.reset}`);
    deployCursor(targetPath, 'B-');
  }

  // init.md 복사
  const templateName = `init-${agent}.md`;
  const sourceInit = join(PKG_ROOT, 'templates', templateName);
  const destInit = join(targetPath, 'init.md');

  step('★', `init.md 복사 (${label} 템플릿)...`);
  if (existsSync(sourceInit)) {
    copyFileSync(sourceInit, destInit);
    ok('init.md 복사 완료 → LLM에 붙여넣으면 프로젝트 설정이 자동 생성됩니다.');
  } else {
    err(`init 템플릿이 없습니다: ${sourceInit}`);
  }

  // 완료 배너
  log('');
  log(`${C.green}╔══════════════════════════════════════════╗${C.reset}`);
  log(`${C.green}║   ✅ 초기화 완료!                          ║${C.reset}`);
  log(`${C.green}╚══════════════════════════════════════════╝${C.reset}`);
  log('');

  if (agent === 'antigravity' || agent === 'both') {
    log(`${C.white}📁 .agent/       → ${join(targetPath, '.agent')}${C.reset}`);
    log(`${C.white}📄 GEMINI.md     → ${join(homedir(), '.gemini', 'GEMINI.md')} (글로벌)${C.reset}`);
  }
  if (agent === 'cursor' || agent === 'both') {
    log(`${C.white}📂 .cursor/rules/ → ${join(targetPath, '.cursor', 'rules')}${C.reset}`);
    log(`${C.white}📄 CURSOR_GLOBAL_RULES.md → ${join(targetPath, 'CURSOR_GLOBAL_RULES.md')}${C.reset}`);
  }
  log(`${C.white}📝 init.md       → ${destInit}${C.reset}`);

  log('');
  log(`${C.yellow}💡 다음 단계:${C.reset}`);
  if (agent === 'cursor' || agent === 'both') {
    log(`${C.yellow}   1. 프로젝트 루트에 복사된 CURSOR_GLOBAL_RULES.md 내용을 Cursor Settings → Rules에 붙여넣으세요.${C.reset}`);
  }
  log(`${C.yellow}   → init.md를 열어 LLM 에이전트에게 붙여넣으면 프로젝트(Workspace) 설정이 자동 생성됩니다.${C.reset}`);
  log('');
}

main().catch((error) => {
  err(`실행 중 오류: ${error.message}`);
  process.exit(1);
});
