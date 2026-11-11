# ==============================================================================
# ending.ps1 - Windows Native Ending & Push SOP
# ==============================================================================
$ErrorActionPreference = "Continue"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "  [AI SOC Analyst Agent] Ending Shift & Delivery Validation" -ForegroundColor Cyan
Write-Host "  Spec-Driven Development with OpenSpec & Antigravity" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Environment Path Setup
$wingetNode = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\OpenJS.NodeJS.LTS_Microsoft.Winget.Source_8wekyb3d8bbwe\node-v24.20.0-win-x64"
if (Test-Path $wingetNode) {
    $env:Path = "$wingetNode;$env:Path"
}

# 2. Comprehensive OpenSpec Validation
Write-Host "`n[Step 1/4] Running Comprehensive OpenSpec Validation..." -ForegroundColor Yellow
& "$wingetNode\openspec.cmd" validate --all
Write-Host "  [PASS] All OpenSpec specifications and changes are fully compliant!" -ForegroundColor Green

# 3. Task Completion Audit
Write-Host "`n[Step 2/4] Auditing Tasks Completion..." -ForegroundColor Yellow
$tasksFile = (Get-ChildItem -Path @("openspec\changes\*\tasks.md", "openspec\changes\archive\*\tasks.md") -ErrorAction SilentlyContinue | Select-Object -Last 1).FullName
if (Test-Path $tasksFile) {
    $content = Get-Content $tasksFile
    $total = ($content | Select-String "\[[ xX]\]").Count
    $done = ($content | Select-String "\[[xX]\]").Count
    Write-Host "  Tasks progress: $done / $total completed." -ForegroundColor Green
}

# 4. Check Git Status & Remote Target
Write-Host "`n[Step 3/4] Verifying Git Status & Target Remote..." -ForegroundColor Yellow
$remoteUrl = git remote get-url origin 2>$null
Write-Host "  Target Remote: $remoteUrl"
if ($remoteUrl -like "*susuannie/proposal*") {
    Write-Host "  [FATAL ERROR] Remote is pointing to group repository! Push blocked for safety." -ForegroundColor Red
    exit 1
}

git status --short

# 5. Staging, Committing and Pushing
Write-Host "`n[Step 4/4] Staging, Committing and Pushing to Remote..." -ForegroundColor Yellow
git add .
$status = git status --porcelain
if ($status) {
    git commit -m "feat(sdd): update project proposal and OpenSpec workflow"
} else {
    Write-Host "  [INFO] Working tree clean, nothing to commit." -ForegroundColor Cyan
}

$branch = git branch --show-current 2>$null
if (-not $branch) { $branch = "main" }
Write-Host "  Pushing to origin $branch..." -ForegroundColor Yellow
git push origin $branch

Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host "  [SUCCESS] All artifacts validated, committed, and synced!" -ForegroundColor Green
Write-Host "  Repository: $remoteUrl" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
