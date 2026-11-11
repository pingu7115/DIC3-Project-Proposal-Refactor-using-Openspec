# ==============================================================================
# startup.ps1 - Windows Native Startup SOP
# ==============================================================================
$ErrorActionPreference = "Continue"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "  [AI SOC Analyst Agent] Development Environment Startup" -ForegroundColor Cyan
Write-Host "  Spec-Driven Development with OpenSpec & Antigravity" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Check Git Remote
Write-Host "`n[Step 1/5] Checking Git Remote..." -ForegroundColor Yellow
$remoteUrl = git remote get-url origin 2>$null
Write-Host "  Remote Origin: $remoteUrl"
if ($remoteUrl -like "*susuannie/proposal*") {
    Write-Host "  [ERROR] Remote is pointing to group repository! Aborting for safety." -ForegroundColor Red
    exit 1
}

# 2. Pull Latest Changes
Write-Host "`n[Step 2/5] Synchronizing latest changes from remote..." -ForegroundColor Yellow
$branch = git branch --show-current 2>$null
if (-not $branch) { $branch = "main" }
Write-Host "  Current branch: $branch"
git pull origin $branch --rebase 2>$null

# 3. Verify Node.js & OpenSpec
Write-Host "`n[Step 3/5] Verifying Node.js & OpenSpec Toolchain..." -ForegroundColor Yellow
$wingetNode = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\OpenJS.NodeJS.LTS_Microsoft.Winget.Source_8wekyb3d8bbwe\node-v24.20.0-win-x64"
if (Test-Path $wingetNode) {
    $env:Path = "$wingetNode;$env:Path"
}
$nodeVer = & node -v
Write-Host "  Node.js version: $nodeVer"
$openspecVer = & "$wingetNode\openspec.cmd" --version
Write-Host "  OpenSpec CLI version: $openspecVer"

# 4. Audit OpenSpec Specs
Write-Host "`n[Step 4/5] Auditing OpenSpec Governance & Specifications..." -ForegroundColor Yellow
& "$wingetNode\openspec.cmd" validate --all

# 5. Handover Briefing
Write-Host "`n[Step 5/5] Active Sprint Handover & Next Actions:" -ForegroundColor Yellow
Write-Host "  - Completed Change: openspec/changes/archive/2026-11-11-01-proposal-workflow-refactor" -ForegroundColor Green
Write-Host "  - Core Proposals: docs/proposal.md (A-F Abstract, 5 Cores, 3 Trade-offs, 10 Details)" -ForegroundColor Green
Write-Host "  - System Specifications: openspec/specs/ (evidence-fusion, triage-workflow)" -ForegroundColor Green
Write-Host "  - Ready to develop! When finishing your shift, run ./ending.ps1" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
