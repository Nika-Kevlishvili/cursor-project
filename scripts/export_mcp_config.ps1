# MCP Configuration Export Script
# ეს სკრიპტი ექსპორტირებს MCP კონფიგურაციას Cursor-ის settings-იდან
# This script exports MCP configuration from Cursor settings

param(
    [string]$OutputPath = "mcp_config_backup.json"
)

Write-Host "📤 MCP Configuration Export" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host ""

# Find Cursor settings.json
$settingsPath = "$env:APPDATA\Cursor\User\settings.json"

if (-not (Test-Path $settingsPath)) {
    Write-Host "❌ Cursor settings.json not found at: $settingsPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please check if Cursor is installed and settings.json exists." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Found Cursor settings: $settingsPath" -ForegroundColor Green
Write-Host ""

try {
    # Read settings
    $settingsContent = Get-Content $settingsPath -Raw -ErrorAction Stop
    $settings = $settingsContent | ConvertFrom-Json -ErrorAction Stop
    
    # Extract MCP configuration
    if ($settings.mcp) {
        Write-Host "📋 Found MCP configuration" -ForegroundColor Green
        Write-Host ""
        
        # Export MCP config
        $mcpConfig = @{
            mcp = $settings.mcp
            exported_at = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            cursor_version = $settings.'cursor.version' 2>$null
        }
        
        $mcpConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputPath -Encoding UTF8
        
        Write-Host "✅ MCP configuration exported to: $OutputPath" -ForegroundColor Green
        Write-Host ""
        Write-Host "📝 Configuration preview:" -ForegroundColor Cyan
        $settings.mcp | ConvertTo-Json -Depth 5
        Write-Host ""
        Write-Host "💡 To import on another computer, use:" -ForegroundColor Yellow
        Write-Host "   .\scripts\import_mcp_config.ps1 -InputPath `"$OutputPath`"" -ForegroundColor Gray
    } else {
        Write-Host "ℹ️  No MCP configuration found in settings.json" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "MCP configuration will be empty. You can add MCP servers manually in Cursor settings." -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error reading settings.json: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please check if settings.json is valid JSON." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "✨ Export complete!" -ForegroundColor Green

