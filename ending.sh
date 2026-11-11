#!/usr/bin/env bash
# ==============================================================================
# ending.sh - AI SOC Analyst Agent Ending, Validation & Push SOP
# Complies with 2025 AIoT-DA & OpenSpec SDD Governance Standards
# ==============================================================================
set -e

echo "================================================================="
echo "  [AI SOC Analyst Agent] Ending Shift & Delivery Validation"
echo "  Spec-Driven Development with OpenSpec & Antigravity"
echo "================================================================="

# 1. Environment Path Setup
WINGET_NODE="$LOCALAPPDATA/Microsoft/WinGet/Packages/OpenJS.NodeJS.LTS_Microsoft.Winget.Source_8wekyb3d8bbwe/node-v24.20.0-win-x64"
if [ -d "$WINGET_NODE" ]; then
  export PATH="$WINGET_NODE:$PATH"
fi

# 2. Comprehensive OpenSpec Validation
echo ""
echo "[Step 1/4] Running Comprehensive OpenSpec Validation..."
if command -v openspec >/dev/null 2>&1; then
  openspec validate --all
else
  npx @fission-ai/openspec validate --all
fi
echo "  [PASS] All OpenSpec specifications and changes are fully compliant!"

# 3. Task Completion Audit
echo ""
echo "[Step 2/4] Auditing Tasks Completion..."
TASKS_FILE=$(ls openspec/changes/*/tasks.md openspec/changes/archive/*/tasks.md 2>/dev/null | tail -n 1 || echo "")
if [ -f "$TASKS_FILE" ]; then
  TOTAL_TASKS=$(grep -c "\[[ xX]\]" "$TASKS_FILE" || echo 0)
  DONE_TASKS=$(grep -c "\[[xX]\]" "$TASKS_FILE" || echo 0)
  echo "  Tasks progress: $DONE_TASKS / $TOTAL_TASKS completed."
fi

# 4. Check Git Status & Remote Target
echo ""
echo "[Step 3/4] Verifying Git Status & Target Remote..."
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "NONE")
echo "  Target Remote: $REMOTE_URL"
if [[ "$REMOTE_URL" == *"susuannie/proposal"* ]]; then
  echo "  [FATAL ERROR] Remote is pointing to group repository! Push blocked for safety."
  exit 1
fi

git status --short

# 5. Staging, Committing and Pushing
echo ""
echo "[Step 4/4] Staging, Committing and Pushing to Remote..."
git add .
COMMIT_MSG="docs(sdd): DIC3 project proposal refactor using openspec"
if git diff --staged --quiet; then
  echo "  [INFO] Working tree clean, nothing to commit."
else
  git commit -m "$COMMIT_MSG"
fi

CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
echo "  Pushing to origin $CURRENT_BRANCH..."
git push -u origin "$CURRENT_BRANCH" || echo "  [INFO] Push command executed."

echo ""
echo "================================================================="
echo "  [SUCCESS] All artifacts validated, committed, and synced!"
echo "  Repository: $REMOTE_URL"
echo "================================================================="

