# GitHub Backup Script
# Created by ไอติม 🍦 - Backup OpenClaw workspace to GitHub

$Workspace = "C:\Users\admin\.openclaw\workspace"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "🍦 ไอติมกำลัง backup..." -ForegroundColor Magenta

try {
    Set-Location $Workspace
    
    # Load config
    $configPath = ".openclaw\backup-config.json"
    if (Test-Path $configPath) {
        $config = Get-Content $configPath | ConvertFrom-Json
        $authUrl = "https://$($config.username):$($config.token)@github.com/$($config.username)/Thin.git"
        git remote set-url origin $authUrl 2>$null
    }
    
    # Add all changes
    git add -A 2>$null
    
    # Check for changes
    $status = git status --porcelain 2>$null
    
    if ($status) {
        # Commit
        git commit -m "🍦 Auto-backup: $timestamp" 2>$null
        
        # Push
        $result = git push origin HEAD 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Backup successful: $timestamp" -ForegroundColor Green
        } else {
            Write-Host "❌ Push failed" -ForegroundColor Red
        }
    } else {
        Write-Host "ℹ️ No changes to backup: $timestamp" -ForegroundColor Cyan
    }
    
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}
