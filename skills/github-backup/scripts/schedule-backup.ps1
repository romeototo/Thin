# Schedule Backup Task
# Created by ไอติม 🍦
param(
    [int]$IntervalHours = 24,
    [string]$TaskName = "OpenClawGitHubBackup"
)

Write-Host "🍦 ไอติมกำลังตั้งค่า Scheduled Backup (ทุก $IntervalHours ชั่วโมง)..." -ForegroundColor Magenta

$ScriptPath = "C:\Users\admin\.openclaw\workspace\skills\github-backup\scripts\backup-to-github.ps1"

# Remove old task
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false 2>$null

# Create action
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptPath`""

# Create trigger
if ($IntervalHours -eq 24) {
    # Daily at midnight
    $Trigger = New-ScheduledTaskTrigger -Daily -At "00:00"
} else {
    # Every N hours
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours $IntervalHours) -RepetitionDuration (New-TimeSpan -Days 3650)
}

# Settings
$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopOnIdleEnd -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

try {
    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings -Description "🍦 OpenClaw Auto-Backup to GitHub by ไอติม" -RunLevel Highest
    Write-Host "✅ Scheduled Task created successfully!" -ForegroundColor Green
    Write-Host "📅 จะ backup ทุก $IntervalHours ชั่วโมง" -ForegroundColor Cyan
    
    # Show task info
    Get-ScheduledTask -TaskName $TaskName | Select-Object TaskName, State, NextRunTime
} catch {
    Write-Host "❌ Failed to create task: $_" -ForegroundColor Red
}
