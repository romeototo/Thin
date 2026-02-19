# Token Saver Helper Script
# Created by ไอติม 🍦

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("status", "reset", "new-session", "spawn-task", "compact")]
    [string]$Action = "status"
)

$Workspace = "C:\Users\admin\.openclaw\workspace"

function Get-TokenStatus {
    Write-Host "🍦 สถานะ Token ปัจจุบัน" -ForegroundColor Magenta
    Write-Host "========================" -ForegroundColor Cyan
    
    # แสดง config ที่ตั้งค่าไว้
    $configPath = "$Workspace\..\openclaw.json"
    if (Test-Path $configPath) {
        Write-Host "✅ Config: Token Optimization Enabled" -ForegroundColor Green
        Write-Host "   - Context Tokens: 128,000" -ForegroundColor Gray
        Write-Host "   - Compaction: safeguard mode" -ForegroundColor Gray
        Write-Host "   - Auto-prune: 2h TTL" -ForegroundColor Gray
        Write-Host "   - Sub-agents: max 8 concurrent" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "💡 Tips ประหยัด Token:" -ForegroundColor Yellow
    Write-Host "   1. ใช้ /new ทุก 50-100 ข้อความ" -ForegroundColor White
    Write-Host "   2. Spawn sub-agents สำหรับงานย่อย" -ForegroundColor White
    Write-Host "   3. สร้าง skill สำหรับงานที่ทำบ่อย" -ForegroundColor White
    Write-Host "   4. เขียน memory กระชับ" -ForegroundColor White
}

function Reset-Session {
    Write-Host "🍦 กำลัง reset session..." -ForegroundColor Magenta
    Write-Host "⚠️  ใช้คำสั่ง /reset ในแชทเพื่อล้าง context" -ForegroundColor Yellow
    Write-Host "💡 หรือใช้ /new เพื่อเริ่ม session ใหม่ (เก็บ memory)" -ForegroundColor Cyan
}

function Show-SpawnExample {
    Write-Host "🍦 ตัวอย่างการใช้ Sub-agents" -ForegroundColor Magenta
    Write-Host "==========================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "# แยกงานใหญ่ออกเป็นส่วนย่อย:" -ForegroundColor Yellow
    Write-Host 'sessions_spawn({' -ForegroundColor White
    Write-Host '  task: "วิเคราะห์ไฟล์ A",' -ForegroundColor Gray
    Write-Host '  label: "task-a",' -ForegroundColor Gray
    Write-Host '  cleanup: "delete",' -ForegroundColor Gray
    Write-Host '  runTimeoutSeconds: 120' -ForegroundColor Gray
    Write-Host '})' -ForegroundColor White
    Write-Host ""
    Write-Host "# ข้อดี:" -ForegroundColor Yellow
    Write-Host "   - แต่ละ task ใช้ context แยก" -ForegroundColor White
    Write-Host "   - ทำงานพร้อมกันได้" -ForegroundColor White
    Write-Host "   - ลบอัตโนมัติเมื่อเสร็จ" -ForegroundColor White
}

function Show-CompactInfo {
    Write-Host "🍦 Compaction Settings" -ForegroundColor Magenta
    Write-Host "=====================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "โหมด: safeguard" -ForegroundColor Yellow
    Write-Host "  - เก็บ history ไว้ทั้งหมด" -ForegroundColor White
    Write-Host "  - ลบเฉพาะตอน context เต็มจริงๆ" -ForegroundColor White
    Write-Host "  - reserveTokensFloor: 40,000" -ForegroundColor White
    Write-Host ""
    Write-Host "Context Pruning:" -ForegroundColor Yellow
    Write-Host "  - ลบข้อความเก่ากว่า 2 ชั่วโมง" -ForegroundColor White
    Write-Host "  - เก็บ assistant messages ล่าสุด 3" -ForegroundColor White
    Write-Host "  - ลบแค่ 30% ต่อครั้ง" -ForegroundColor White
}

# Main
switch ($Action) {
    "status" { Get-TokenStatus }
    "reset" { Reset-Session }
    "new-session" { Reset-Session }
    "spawn-task" { Show-SpawnExample }
    "compact" { Show-CompactInfo }
}
