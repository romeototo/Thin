# OpenClaw Auto-Backup Setup Script
# Created by ไอติม 🍦
# Token เก็บใน environment variable: OPENCLAW_GITHUB_TOKEN

$GITHUB_USERNAME = "romeototo"
$GITHUB_TOKEN = $env:OPENCLAW_GITHUB_TOKEN
$REPO_URL = "https://github.com/romeototo/Thin.git"
$WORKSPACE = "C:\Users\admin\.openclaw\workspace"

# Check if token is set
if (-not $GITHUB_TOKEN) {
    Write-Host "❌ Error: OPENCLAW_GITHUB_TOKEN environment variable not set" -ForegroundColor Red
    Write-Host "💡 Set it first with:" -ForegroundColor Yellow
    Write-Host "   [Environment]::SetEnvironmentVariable('OPENCLAW_GITHUB_TOKEN', 'your-token', 'User')" -ForegroundColor Cyan
    exit 1
}

Write-Host "🍦 ไอติมกำลังตั้งค่า Auto-Backup..." -ForegroundColor Magenta

try {
    Set-Location $WORKSPACE
    
    # Check if git is initialized
    if (-not (Test-Path ".git")) {
        Write-Host "📁 Initializing git repository..." -ForegroundColor Cyan
        git init
    }
    
    # Set git config
    git config user.email "backup@openclaw.local"
    git config user.name "OpenClaw Backup"
    
    # Remove old remote if exists
    git remote remove origin 2>$null
    
    # Add remote with token
    $AUTH_URL = "https://$GITHUB_USERNAME`:$GITHUB_TOKEN@github.com/romeototo/Thin.git"
    git remote add origin $AUTH_URL
    
    # Add all files
    Write-Host "📦 Adding files..." -ForegroundColor Cyan
    git add -A
    
    # Commit
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "🍦 Auto-backup: $timestamp" 2>$null
    
    # Push
    Write-Host "🚀 Pushing to GitHub..." -ForegroundColor Cyan
    git branch -M main
    git push -u origin main --force
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Backup setup complete!" -ForegroundColor Green
        Write-Host "📍 Repository: $REPO_URL" -ForegroundColor Green
    } else {
        # Try master branch
        git branch -M master
        git push -u origin master --force
        Write-Host "✅ Backup setup complete! (master branch)" -ForegroundColor Green
    }
    
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}

Read-Host "Press Enter to exit..."
