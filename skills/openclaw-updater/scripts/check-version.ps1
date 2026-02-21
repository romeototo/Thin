# Check OpenClaw Version
# ตรวจสอบเวอร์ชันปัจจุบันของ OpenClaw

Write-Host "🔍 กำลังตรวจสอบเวอร์ชัน OpenClaw..." -ForegroundColor Cyan

# ตรวจสอบว่า openclaw ติดตั้งอยู่หรือไม่
$openclawPath = Get-Command openclaw -ErrorAction SilentlyContinue
if (-not $openclawPath) {
    Write-Host "❌ ไม่พบคำสั่ง openclaw" -ForegroundColor Red
    Write-Host "💡 ตรวจสอบว่า OpenClaw ติดตั้งอยู่หรือไม่" -ForegroundColor Yellow
    exit 1
}

# ดึงเวอร์ชันปัจจุบัน
try {
    $versionInfo = openclaw --version 2>$null
    if ($versionInfo) {
        Write-Host "✅ OpenClaw ติดตั้งแล้ว" -ForegroundColor Green
        Write-Host "📦 เวอร์ชันปัจจุบัน: $versionInfo" -ForegroundColor White
    } else {
        # ลองดูจาก package.json
        $packagePath = "$env:APPDATA\npm\node_modules\openclaw\package.json"
        if (Test-Path $packagePath) {
            $package = Get-Content $packagePath | ConvertFrom-Json
            Write-Host "✅ OpenClaw ติดตั้งแล้ว" -ForegroundColor Green
            Write-Host "📦 เวอร์ชันปัจจุบัน: $($package.version)" -ForegroundColor White
        } else {
            Write-Host "⚠️ ไม่สามารถระบุเวอร์ชันได้" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "⚠️ ไม่สามารถดึงข้อมูลเวอร์ชันได้: $_" -ForegroundColor Yellow
}

# ตรวจสอบ npm registry สำหรับเวอร์ชันล่าสุด
Write-Host "`n🌐 กำลังตรวจสอบเวอร์ชันล่าสุดจาก npm..." -ForegroundColor Cyan
try {
    $latestVersion = npm view openclaw version 2>$null
    if ($latestVersion) {
        Write-Host "📦 เวอร์ชันล่าสุด: $latestVersion" -ForegroundColor Green
        
        # เปรียบเทียบเวอร์ชัน
        $currentVersion = (openclaw --version 2>$null) -replace 'openclaw v', ''
        if ($currentVersion -and ($currentVersion -ne $latestVersion)) {
            Write-Host "⚠️ มีเวอร์ชันใหม่กว่า!" -ForegroundColor Yellow
            Write-Host "💡 รัน update-openclaw.ps1 เพื่ออัปเดต" -ForegroundColor Cyan
        } elseif ($currentVersion -eq $latestVersion) {
            Write-Host "✅ คุณกำลังใช้เวอร์ชันล่าสุดแล้ว" -ForegroundColor Green
        }
    }
} catch {
    Write-Host "⚠️ ไม่สามารถเชื่อมต่อกับ npm registry: $_" -ForegroundColor Yellow
}

Write-Host "`n✨ ตรวจสอบเสร็จสิ้น" -ForegroundColor Green
