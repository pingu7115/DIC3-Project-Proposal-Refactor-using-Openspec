#!/usr/bin/env bash
# ==============================================================================
# startup.sh - AI SOC Analyst Agent Development Startup & Onboarding SOP
# Complies with 2025 AIoT-DA & OpenSpec SDD Governance Standards
# ==============================================================================
set -e

echo "================================================================="
echo "  [AI SOC Analyst Agent] Development Environment Startup"
echo "  Spec-Driven Development with OpenSpec & Antigravity"
echo "================================================================="

# 1. Check Git Remote Status
echo ""
echo "[Step 1/5] Checking Git Remote..."
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "NONE")
echo "  Remote Origin: $REMOTE_URL"
if [[ "$REMOTE_URL" == *"susuannie/proposal"* ]]; then
  echo "  [ERROR] Remote is pointing to group repository! Aborting for safety."
  exit 1
fi

# 2. Pull Latest Changes
echo ""
echo "[Step 2/5] Synchronizing latest changes from remote..."
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
  echo "  Current branch: $CURRENT_BRANCH"
  git pull origin "$CURRENT_BRANCH" --rebase || echo "  [INFO] Initial repository or no remote branch yet. Continuing..."
fi

# 3. Verify Node.js and OpenSpec Tools
echo ""
echo "[Step 3/5] Verifying Node.js & OpenSpec Toolchain..."
if command -v node >/dev/null 2>&1; then
  NODE_VER=$(node -v)
  echo "  Node.js version: $NODE_VER"
else
  # Check WinGet LocalAppData Node
  WINGET_NODE="$LOCALAPPDATA/Microsoft/WinGet/Packages/OpenJS.NodeJS.LTS_Microsoft.Winget.Source_8wekyb3d8bbwe/node-v24.20.0-win-x64"
  if [ -d "$WINGET_NODE" ]; then
    export PATH="$WINGET_NODE:$PATH"
    echo "  Loaded Node.js from WinGet package: $(node -v)"
  else
    echo "  [WARN] Node.js not detected in default PATH. Please ensure Node v24+ is installed."
  fi
fi

if command -v openspec >/dev/null 2>&1; then
  echo "  OpenSpec CLI version: $(openspec --version)"
else
  echo "  [INFO] Attempting to invoke openspec via npx..."
  npx @fission-ai/openspec --version || true
fi

# 4. Validate OpenSpec Specifications
echo ""
echo "[Step 4/5] Auditing OpenSpec Governance & Specifications..."
if command -v openspec >/dev/null 2>&1; then
  openspec validate --all || true
else
  npx @fission-ai/openspec validate --all || true
fi

# 5. Handover Briefing & Next Actions
echo ""
echo "[Step 5/5] Active Sprint Handover & Next Actions:"
echo "  - Completed Change: openspec/changes/archive/2026-11-11-01-proposal-workflow-refactor"
echo "  - Core Proposals: docs/proposal.md (A-F Abstract, 5 Cores, 3 Trade-offs, 10 Details)"
echo "  - System Specifications: openspec/specs/ (evidence-fusion, triage-workflow)"
echo "  - Ready to develop! When finishing your shift, run ./ending.sh"
echo "================================================================="

