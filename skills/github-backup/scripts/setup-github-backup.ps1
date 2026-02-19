# GitHub Backup Setup Script
# Created by ไอติม 🍦
param(
    [Parameter(Mandatory=$true)]
    [string]$Username,
    
    [Parameter(Mandatory=$true)]
    [string]$Token,
    
    [Parameter(Mandatory=$true)]
    [string]$Repo,
    
    [string]$Workspace = "C:\Users\admin\.openclaw\workspace",
    [string]$Branch = "main"
)

Write-Host "🍦 ไอติมกำลังตั้งค่า GitHub Backup..." -ForegroundColor Magenta
Write-Host "📁 Workspace: $Workspace" -ForegroundColor Cyan
Write-Host "📍 Repository: $Repo" -ForegroundColor Cyan

try {
    Set-Location $Workspace
    
    # Init git if not exists
    if (-not (Test-Path ".git")) {
        Write-Host "📂 Initializing git repository..." -ForegroundColor Yellow
        git init
    }
    
    # Git config
    git config user.email "openclaw-backup@local"
    git config user.name "OpenClaw Backup Bot"
    
    # Setup remote with token
    git remote remove origin 2>$null
    $authUrl = "https://$Username`:$Token@github.com/$Username/Thin.git"
    git remote add origin $authUrl
    
    # Save config
    $config = @{
        username = $Username
        token = $Token
        repo = $Repo
        branch = $Branch
        workspace = $Workspace
    } | ConvertTo-Json
    
    $config | Out-File -FilePath ".openclaw\backup-config.json" -Encoding UTF8
    
    # Create .gitignore
    @'
# OpenClaw Backup Ignore
*.log
logs/
*.tmp
.cache/
.DS_Store
Thumbs.db
node_modules/
'@ | Out-File -FilePath ".gitignore" -Encoding UTF8 -Force
    
    # First commit
    Write-Host "📦 Creating initial backup..." -ForegroundColor Yellow
    git add -A 2>$null
    git commit -m "🍦 Initial backup by ไอติม" 2>$null
    
    # Push
    git branch -M $Branch
    git push -u origin $Branch --force
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Setup complete! Backup successful!" -ForegroundColor Green
        Write-Host "🌐 View at: $Repo" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Push failed. Please check your credentials." -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}
