# Push to GitHub Script
# ეს სკრიპტი დაგეხმარებათ GitHub-ზე კოდის ატვირთვაში

param(
    [Parameter(Mandatory=$true)]
    [string]$RepositoryName = "cursor-project"
)

$GitHubUsername = "Nika-Kevlishvili"
$repoUrl = "https://github.com/$GitHubUsername/$RepositoryName.git"

Write-Host "🚀 GitHub Push Script" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Repository: $repoUrl" -ForegroundColor Yellow
Write-Host ""

# Check if remote already exists
$remoteExists = git remote get-url origin 2>$null
if ($remoteExists) {
    Write-Host "⚠️  Remote 'origin' already exists: $remoteExists" -ForegroundColor Yellow
    $update = Read-Host "Do you want to update it? (y/n)"
    if ($update -eq 'y' -or $update -eq 'Y') {
        git remote set-url origin $repoUrl
        Write-Host "✅ Remote updated" -ForegroundColor Green
    }
} else {
    Write-Host "📡 Adding remote repository..." -ForegroundColor Cyan
    git remote add origin $repoUrl
    Write-Host "✅ Remote added" -ForegroundColor Green
}

# Rename branch to main if needed
$currentBranch = git branch --show-current
if ($currentBranch -ne "main") {
    Write-Host "🔄 Renaming branch to 'main'..." -ForegroundColor Cyan
    git branch -M main
    Write-Host "✅ Branch renamed to 'main'" -ForegroundColor Green
}

Write-Host ""
Write-Host "📤 Pushing to GitHub..." -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  IMPORTANT: When prompted for credentials:" -ForegroundColor Yellow
Write-Host "   - Username: $GitHubUsername" -ForegroundColor White
Write-Host "   - Password: Use Personal Access Token (NOT your GitHub password)" -ForegroundColor White
Write-Host ""
Write-Host "💡 If you don't have a Personal Access Token:" -ForegroundColor Cyan
Write-Host "   1. Go to: https://github.com/settings/tokens" -ForegroundColor Gray
Write-Host "   2. Generate new token (classic)" -ForegroundColor Gray
Write-Host "   3. Select scope: 'repo' (full control)" -ForegroundColor Gray
Write-Host "   4. Copy the token and use it as password" -ForegroundColor Gray
Write-Host ""
Write-Host "Press Enter to continue with push..." -ForegroundColor Yellow
Read-Host

# Push to GitHub
Write-Host ""
Write-Host "🔄 Executing: git push -u origin main" -ForegroundColor Cyan
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host "🌐 Repository URL: $repoUrl" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ Push failed. Common issues:" -ForegroundColor Red
    Write-Host "   1. Repository doesn't exist on GitHub - create it first at https://github.com/new" -ForegroundColor Yellow
    Write-Host "   2. Authentication failed - use Personal Access Token" -ForegroundColor Yellow
    Write-Host "   3. Network issues - check your connection" -ForegroundColor Yellow
}

