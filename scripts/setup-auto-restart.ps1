# Create Auto-Restart Scheduled Task
# Created by ไอติม 🍦

$TaskName = "AutoRestartMonitor"
$ScriptPath = "C:\Users\admin\.openclaw\workspace\scripts\auto-restart-monitor.ps1"

Write-Host "🍦 กำลังตั้งค่า Auto-Restart Monitor..." -ForegroundColor Magenta

# ลบ task เก่าถ้ามี
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false 2>$null

# สร้าง Action
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptPath`""

# สร้าง Trigger - รันทุก 5 นาที
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration (New-TimeSpan -Days 3650)

# ตั้งค่า
$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopOnIdleEnd -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -RunOnlyIfNetworkAvailable $false

# สร้าง Task (ต้อง Run as Administrator)
try {
    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings -Description "🍦 Auto-restart when RAM>85%, CPU>95%, or uptime>48h" -RunLevel Highest -User "SYSTEM"
    
    Write-Host "✅ Task '$TaskName' สร้างสำเร็จ!" -ForegroundColor Green
    Write-Host "📅 จะตรวจสอบทุก 5 นาที" -ForegroundColor Cyan
    Write-Host "📝 Log อยู่ที่: C:\Users\admin\.openclaw\workspace\logs\auto-restart.log" -ForegroundColor Gray
    
    # แสดงข้อมูล task
    Get-ScheduledTask -TaskName $TaskName | Select-Object TaskName, State, NextRunTime | Format-Table
    
} catch {
    Write-Host "❌ ไม่สามารถสร้าง Task ได้: $_" -ForegroundColor Red
    Write-Host "💡 ต้อง Run as Administrator!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🧪 ทดสอบการทำงาน:" -ForegroundColor Yellow
Write-Host "   powershell -File `"$ScriptPath`" -TestMode" -ForegroundColor White
