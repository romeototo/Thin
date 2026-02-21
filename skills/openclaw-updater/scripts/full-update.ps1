# Full Update OpenClaw
# อัปเดต OpenClaw แบบเต็มรูปแบบ: update → restart → verify

$ErrorActionPreference = "Stop"

Write-Host "🚀 OpenClaw Full Update" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

# Step 1: Check current version
Write-Host "`n📋 STEP 1/4: ตรวจสอบเวอร์ชันปัจจุบัน" -ForegroundColor Yellow
& "$PSScriptRoot\check-version.ps1"

# Step 2: Backup
Write-Host "`n📋 STEP 2/4: สำรองข้อมูล" -ForegroundColor Yellow
$configPath = "$env:USERPROFILE\.openclaw\openclaw.json"
$backupDir = "$env:USERPROFILE\.openclaw\backups"

if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
}

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupFiles = @(
    @{Source="$env:USERPROFILE\.openclaw\openclaw.json"; Target="$backupDir\openclaw-$timestamp.json"},
    @{Source="$env:USERPROFILE\.openclaw\workspace"; Target="$backupDir\workspace-$timestamp"}
)

foreach ($file in $backupFiles) {
    if (Test-Path $file.Source) {
        if (Test-Path $file.Source -PathType Container) {
            Copy-Item $file.Source $file.Target -Recurse -Force
        } else {
            Copy-Item $file.Source $file.Target -Force
        }
        Write-Host "✅ สำรอง: $($file.Source)" -ForegroundColor Green
    }
}

# Step 3: Update
Write-Host "`n📋 STEP 3/4: อัปเดต OpenClaw" -ForegroundColor Yellow

# ตรวจสอบสิทธิ์
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "⚠️ ไม่มีสิทธิ์ Administrator - อาจอัปเดตไม่สำเร็จ" -ForegroundColor Yellow
}

# อัปเดต
Write-Host "⬆️  กำลังรัน npm update..." -ForegroundColor Cyan
try {
    npm update -g openclaw 2>&1 | ForEach-Object {
        if ($_ -match 'error|ERR|failed') {
            Write-Host "   ❌ $_" -ForegroundColor Red
        } else {
            Write-Host "   $_" -ForegroundColor Gray
        }
    }
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️ npm update ล้มเหลว ลอง npm install..." -ForegroundColor Yellow
        npm install -g openclaw@latest 2>&1
    }
    
    Write-Host "✅ อัปเดตเสร็จสิ้น" -ForegroundColor Green
} catch {
    Write-Host "❌ อัปเดตไม่สำเร็จ: $_" -ForegroundColor Red
    exit 1
}

# Step 4: Restart
Write-Host "`n📋 STEP 4/4: รีสตาร์ต Gateway" -ForegroundColor Yellow
try {
    Write-Host "🔄 กำลังรีสตาร์ต..." -ForegroundColor Cyan
    openclaw gateway restart
    Write-Host "⏳ รอ 5 วินาที..." -ForegroundColor Gray
    Start-Sleep -Seconds 5
} catch {
    Write-Host "⚠️ รีสตาร์ตไม่สำเร็จ: $_" -ForegroundColor Yellow
}

# Verify
Write-Host "`n✅ ตรวจสอบผลลัพธ์:" -ForegroundColor Green
try {
    $newVersion = openclaw --version 2>$null
    Write-Host "📦 OpenClaw เวอร์ชัน: $newVersion" -ForegroundColor White
    
    $gatewayStatus = openclaw gateway status 2>$null
    if ($gatewayStatus -match 'running|active') {
        Write-Host "🟢 Gateway: กำลังทำงาน" -ForegroundColor Green
    } else {
        Write-Host "🟡 Gateway: ไม่แน่ใจสถานะ" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️ ไม่สามารถตรวจสอบสถานะได้" -ForegroundColor Yellow
}

Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan
Write-Host "✨ Full Update เสร็จสิ้น!" -ForegroundColor Green
Write-Host "`n💡 คำสั่งที่ใช้ได้:" -ForegroundColor Cyan
Write-Host "   openclaw status       - ตรวจสอบสถานะ" -ForegroundColor White
Write-Host "   openclaw gateway logs - ดู logs" -ForegroundColor White
