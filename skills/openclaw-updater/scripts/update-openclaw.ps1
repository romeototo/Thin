# Update OpenClaw to Latest Version
# อัปเดต OpenClaw เป็นเวอร์ชันล่าสุดผ่าน npm

param(
    [switch]$SkipBackup,
    [switch]$SkipRestart,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 กำลังอัปเดต OpenClaw..." -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan

# 1. ตรวจสอบสิทธิ์ Admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "⚠️ แนะนำให้รันด้วยสิทธิ์ Administrator" -ForegroundColor Yellow
    Write-Host "💡 คลิกขวา → Run as Administrator" -ForegroundColor Yellow
    if (-not $Force) {
        $continue = Read-Host "ต้องการดำเนินการต่อหรือไม่? (y/N)"
        if ($continue -ne 'y') {
            exit 0
        }
    }
}

# 2. สำรอง config
if (-not $SkipBackup) {
    Write-Host "`n💾 กำลังสำรอง config..." -ForegroundColor Cyan
    $configPath = "$env:USERPROFILE\.openclaw\openclaw.json"
    $backupPath = "$env:USERPROFILE\.openclaw\openclaw.json.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    
    if (Test-Path $configPath) {
        Copy-Item $configPath $backupPath -Force
        Write-Host "✅ สำรอง config แล้ว: $backupPath" -ForegroundColor Green
    } else {
        Write-Host "⚠️ ไม่พบ config ให้สำรอง" -ForegroundColor Yellow
    }
}

# 3. ตรวจสอบเวอร์ชันปัจจุบัน
Write-Host "`n📦 เวอร์ชันปัจจุบัน:" -ForegroundColor Cyan
try {
    $currentVersion = openclaw --version 2>$null
    Write-Host "   $currentVersion" -ForegroundColor White
} catch {
    Write-Host "   ไม่สามารถระบุได้" -ForegroundColor Yellow
}

# 4. อัปเดตผ่าน npm
Write-Host "`n⬆️  กำลังอัปเดต OpenClaw ผ่าน npm..." -ForegroundColor Cyan
Write-Host "   รอสักครู่..." -ForegroundColor Gray

try {
    $npmOutput = npm update -g openclaw 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ อัปเดตสำเร็จ!" -ForegroundColor Green
    } else {
        Write-Host "⚠️ npm update มีปัญหา ลองใช้ npm install แทน..." -ForegroundColor Yellow
        npm install -g openclaw@latest 2>&1
    }
} catch {
    Write-Host "❌ อัปเดตไม่สำเร็จ: $_" -ForegroundColor Red
    Write-Host "💡 ลองรันด้วยสิทธิ์ Administrator" -ForegroundColor Yellow
    exit 1
}

# 5. ตรวจสอบเวอร์ชันใหม่
Write-Host "`n📦 เวอร์ชันหลังอัปเดต:" -ForegroundColor Cyan
try {
    $newVersion = openclaw --version 2>$null
    Write-Host "   $newVersion" -ForegroundColor White
} catch {
    Write-Host "   ไม่สามารถระบุได้" -ForegroundColor Yellow
}

# 6. รีสตาร์ต gateway
if (-not $SkipRestart) {
    Write-Host "`n🔄 กำลังรีสตาร์ต OpenClaw Gateway..." -ForegroundColor Cyan
    try {
        openclaw gateway restart
        Write-Host "✅ รีสตาร์ตสำเร็จ!" -ForegroundColor Green
        Write-Host "⏳ รอ 5 วินาทีให้ Gateway เริ่มทำงาน..." -ForegroundColor Gray
        Start-Sleep -Seconds 5
    } catch {
        Write-Host "⚠️ รีสตาร์ตไม่สำเร็จ: $_" -ForegroundColor Yellow
        Write-Host "💡 ลองรีสตาร์ตเองด้วย: openclaw gateway restart" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n⏭️  ข้ามการรีสตาร์ต (ใช้ --SkipRestart)" -ForegroundColor Yellow
}

Write-Host "`n" + ("=" * 50) -ForegroundColor Cyan
Write-Host "✨ อัปเดตเสร็จสิ้น!" -ForegroundColor Green

if (-not $SkipRestart) {
    Write-Host "`n💡 ตรวจสอบสถานะด้วย:" -ForegroundColor Cyan
    Write-Host "   openclaw status" -ForegroundColor White
}
