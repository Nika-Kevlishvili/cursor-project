# MCP Configuration Import Script
# ეს სკრიპტი იმპორტირებს MCP კონფიგურაციას Cursor-ის settings-ში
# This script imports MCP configuration into Cursor settings

param(
    [Parameter(Mandatory=$true)]
    [string]$InputPath
)

Write-Host "📥 MCP Configuration Import" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host ""

# Check if input file exists
if (-not (Test-Path $InputPath)) {
    Write-Host "❌ Input file not found: $InputPath" -ForegroundColor Red
    exit 1
}

# Find Cursor settings.json
$settingsPath = "$env:APPDATA\Cursor\User\settings.json"

if (-not (Test-Path $settingsPath)) {
    Write-Host "❌ Cursor settings.json not found at: $settingsPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please check if Cursor is installed." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Found Cursor settings: $settingsPath" -ForegroundColor Green
Write-Host "✅ Found backup file: $InputPath" -ForegroundColor Green
Write-Host ""

# Backup current settings
$backupPath = "$settingsPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Write-Host "💾 Creating backup: $backupPath" -ForegroundColor Cyan
Copy-Item $settingsPath $backupPath
Write-Host "✅ Backup created" -ForegroundColor Green
Write-Host ""

try {
    # Read backup file
    Write-Host "📖 Reading MCP configuration from: $InputPath" -ForegroundColor Cyan
    $backupContent = Get-Content $InputPath -Raw -ErrorAction Stop
    $backupConfig = $backupContent | ConvertFrom-Json -ErrorAction Stop
    
    if (-not $backupConfig.mcp) {
        Write-Host "❌ No MCP configuration found in backup file" -ForegroundColor Red
        exit 1
    }
    
    # Read current settings
    Write-Host "📖 Reading current Cursor settings..." -ForegroundColor Cyan
    $settingsContent = Get-Content $settingsPath -Raw -ErrorAction Stop
    $settings = $settingsContent | ConvertFrom-Json -ErrorAction Stop
    
    # Merge MCP configuration
    Write-Host "🔧 Merging MCP configuration..." -ForegroundColor Cyan
    $settings.mcp = $backupConfig.mcp
    
    # Write updated settings
    Write-Host "💾 Writing updated settings..." -ForegroundColor Cyan
    $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
    
    Write-Host ""
    Write-Host "✅ MCP configuration imported successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Please restart Cursor for changes to take effect." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📝 Imported MCP servers:" -ForegroundColor Cyan
    $backupConfig.mcp.servers.PSObject.Properties.Name | ForEach-Object {
        Write-Host "   - $_" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "❌ Error importing MCP configuration: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔄 Restoring backup..." -ForegroundColor Yellow
    Copy-Item $backupPath $settingsPath -Force
    Write-Host "✅ Settings restored from backup" -ForegroundColor Green
    exit 1
}

Write-Host ""
Write-Host "✨ Import complete!" -ForegroundColor Green

