# Auto-backup script for OpenClaw workspace
# Created by ไอติม 🍦

$workspace = "C:\Users\admin\.openclaw\workspace"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

try {
    Set-Location $workspace
    
    # Add all files
    git add -A 2>$null
    
    # Check if there are changes to commit
    $status = git status --porcelain
    
    if ($status) {
        # Commit with timestamp
        git commit -m "Auto-backup: $timestamp" 2>$null
        
        # Push to GitHub
        $result = git push origin master 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Backup successful: $timestamp" -ForegroundColor Green
        } else {
            # Try main branch if master fails
            $result = git push origin main 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Backup successful (main branch): $timestamp" -ForegroundColor Green
            } else {
                Write-Host "❌ Push failed: $result" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "ℹ️ No changes to backup: $timestamp" -ForegroundColor Cyan
    }
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}
