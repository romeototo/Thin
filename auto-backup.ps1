# Auto-backup script for OpenClaw workspace
# Created by ไอติม 🍦 - Runs every 24 hours
# Token เก็บใน environment variable: OPENCLAW_GITHUB_TOKEN

$GITHUB_USERNAME = "romeototo"
$GITHUB_TOKEN = $env:OPENCLAW_GITHUB_TOKEN
$WORKSPACE = "C:\Users\admin\.openclaw\workspace"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Check if token is set
if (-not $GITHUB_TOKEN) {
    Write-Host "❌ Error: OPENCLAW_GITHUB_TOKEN environment variable not set" -ForegroundColor Red
    Write-Host "💡 Set it with: [Environment]::SetEnvironmentVariable('OPENCLAW_GITHUB_TOKEN', 'your-token', 'User')" -ForegroundColor Yellow
    exit 1
}

try {
    Set-Location $WORKSPACE
    
    # Add all files
    git add -A 2>$null
    
    # Check if there are changes
    $status = git status --porcelain 2>$null
    
    if ($status) {
        # Commit
        git commit -m "🍦 Auto-backup: $timestamp" 2>$null
        
        # Push with token
        $AUTH_URL = "https://$GITHUB_USERNAME`:$GITHUB_TOKEN@github.com/romeototo/Thin.git"
        git remote set-url origin $AUTH_URL 2>$null
        
        $result = git push origin HEAD 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Backup successful: $timestamp" -ForegroundColor Green
        } else {
            Write-Host "❌ Push failed" -ForegroundColor Red
        }
    } else {
        Write-Host "ℹ️ No changes: $timestamp" -ForegroundColor Cyan
    }
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}
