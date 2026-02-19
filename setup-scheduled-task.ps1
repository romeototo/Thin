# Setup Daily Backup Task
# Created by ไอติม 🍦

Write-Host "🍦 ไอติมกำลังตั้งค่า Scheduled Task สำหรับ Daily Backup..." -ForegroundColor Magenta

$TaskName = "OpenClawDailyBackup"
$ScriptPath = "C:\Users\admin\.openclaw\workspace\auto-backup.ps1"

# Remove old task if exists
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false 2>$null

# Create action
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptPath`""

# Create trigger - Run daily at midnight
$Trigger = New-ScheduledTaskTrigger -Daily -At "00:00"

# Create settings
$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopOnIdleEnd -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

# Register task
try {
    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings -Description "🍦 OpenClaw Auto-Backup to GitHub every 24 hours by ไอติม" -RunLevel Highest
    Write-Host "✅ Scheduled Task created successfully!" -ForegroundColor Green
    Write-Host "📅 Backup will run every day at midnight" -ForegroundColor Cyan
    Write-Host "📝 Task Name: $TaskName" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Failed to create task: $_" -ForegroundColor Red
}

# Show task info
Get-ScheduledTask -TaskName $TaskName | Select-Object TaskName, State, NextRunTime | Format-Table

Read-Host "Press Enter to exit..."
