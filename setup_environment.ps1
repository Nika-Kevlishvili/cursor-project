# Environment Variables Setup Script
# ეს სკრიპტი დაგეხმარებათ environment variables-ის დაყენებაში

param(
    [switch]$Interactive = $false
)

Write-Host "🔧 Environment Variables Setup Script" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if .env file exists
$envFile = ".env"
# Try .env.example first, then env.example
$envExample = if (Test-Path ".env.example") { ".env.example" } else { "env.example" }

if (-not (Test-Path $envExample)) {
    Write-Host "❌ .env.example file not found!" -ForegroundColor Red
    Write-Host "   Please ensure .env.example exists in the project root." -ForegroundColor Yellow
    exit 1
}

if (Test-Path $envFile) {
    Write-Host "⚠️  .env file already exists!" -ForegroundColor Yellow
    $overwrite = Read-Host "Do you want to overwrite it? (y/n)"
    if ($overwrite -ne 'y' -and $overwrite -ne 'Y') {
        Write-Host "Cancelled. Using existing .env file." -ForegroundColor Yellow
        exit 0
    }
}

# Copy example file
Write-Host "📋 Creating .env file from template..." -ForegroundColor Cyan
Copy-Item $envExample $envFile -Force
Write-Host "✅ .env file created" -ForegroundColor Green
Write-Host ""

if ($Interactive) {
    Write-Host "📝 Interactive Setup Mode" -ForegroundColor Cyan
    Write-Host "========================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Please fill in the following values:" -ForegroundColor White
    Write-Host ""
    
    # GitLab
    Write-Host "GitLab Configuration:" -ForegroundColor Yellow
    $gitlabUrl = Read-Host "GitLab URL [https://gitlab.com]"
    if ($gitlabUrl) { (Get-Content $envFile) -replace 'GITLAB_URL=https://gitlab.com', "GITLAB_URL=$gitlabUrl" | Set-Content $envFile }
    
    $gitlabToken = Read-Host "GitLab Token (or press Enter to skip)"
    if ($gitlabToken) { (Get-Content $envFile) -replace 'GITLAB_TOKEN=your-gitlab-token-here', "GITLAB_TOKEN=$gitlabToken" | Set-Content $envFile }
    
    $gitlabProjectId = Read-Host "GitLab Project ID (or press Enter to skip)"
    if ($gitlabProjectId) { (Get-Content $envFile) -replace 'GITLAB_PROJECT_ID=your-project-id-here', "GITLAB_PROJECT_ID=$gitlabProjectId" | Set-Content $envFile }
    
    Write-Host ""
    
    # Jira
    Write-Host "Jira Configuration:" -ForegroundColor Yellow
    $jiraUrl = Read-Host "Jira URL [https://your-company.atlassian.net]"
    if ($jiraUrl) { (Get-Content $envFile) -replace 'JIRA_URL=https://your-company.atlassian.net', "JIRA_URL=$jiraUrl" | Set-Content $envFile }
    
    $jiraEmail = Read-Host "Jira Email (or press Enter to skip)"
    if ($jiraEmail) { (Get-Content $envFile) -replace 'JIRA_EMAIL=your-email@example.com', "JIRA_EMAIL=$jiraEmail" | Set-Content $envFile }
    
    $jiraToken = Read-Host "Jira API Token (or press Enter to skip)"
    if ($jiraToken) { (Get-Content $envFile) -replace 'JIRA_API_TOKEN=your-jira-api-token-here', "JIRA_API_TOKEN=$jiraToken" | Set-Content $envFile }
    
    $jiraProjectKey = Read-Host "Jira Project Key (or press Enter to skip)"
    if ($jiraProjectKey) { (Get-Content $envFile) -replace 'JIRA_PROJECT_KEY=PROJ', "JIRA_PROJECT_KEY=$jiraProjectKey" | Set-Content $envFile }
    
    Write-Host ""
    
    # Postman
    Write-Host "Postman Configuration:" -ForegroundColor Yellow
    $postmanKey = Read-Host "Postman API Key (or press Enter to skip)"
    if ($postmanKey) { (Get-Content $envFile) -replace 'POSTMAN_API_KEY=your-postman-api-key-here', "POSTMAN_API_KEY=$postmanKey" | Set-Content $envFile }
    
    $postmanWorkspace = Read-Host "Postman Workspace ID (or press Enter to skip)"
    if ($postmanWorkspace) { (Get-Content $envFile) -replace 'POSTMAN_WORKSPACE_ID=your-workspace-id-here', "POSTMAN_WORKSPACE_ID=$postmanWorkspace" | Set-Content $envFile }
    
    Write-Host ""
    
    # Confluence
    Write-Host "Confluence Configuration:" -ForegroundColor Yellow
    $confluenceUrl = Read-Host "Confluence URL [https://your-company.atlassian.net/wiki/home]"
    if ($confluenceUrl) { (Get-Content $envFile) -replace 'CONFLUENCE_URL=https://your-company.atlassian.net/wiki/home', "CONFLUENCE_URL=$confluenceUrl" | Set-Content $envFile }
    
    Write-Host ""
}

Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Next Steps:" -ForegroundColor Cyan
Write-Host "=============" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Edit .env file and fill in your actual values:" -ForegroundColor White
Write-Host "   notepad .env" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Load environment variables:" -ForegroundColor White
Write-Host "   .\load_environment.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Or set them manually in PowerShell:" -ForegroundColor White
Write-Host "   Get-Content .env | ForEach-Object {" -ForegroundColor Gray
Write-Host "     if ($_ -match '^([^#][^=]+)=(.*)$') {" -ForegroundColor Gray
Write-Host "       [Environment]::SetEnvironmentVariable(`$matches[1], `$matches[2], 'User')" -ForegroundColor Gray
Write-Host "     }" -ForegroundColor Gray
Write-Host "   }" -ForegroundColor Gray
Write-Host ""
Write-Host "⚠️  IMPORTANT: .env file is in .gitignore and will NOT be committed to Git" -ForegroundColor Yellow
Write-Host ""

