$TaskName = "OpenClawDailyBackup"
$ScriptPath = "C:\Users\admin\.openclaw\workspace\auto-backup.ps1"

# Remove existing task if exists
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false 2>$null

# Create action
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptPath`""

# Create trigger (daily at midnight)
$Trigger = New-ScheduledTaskTrigger -Daily -At "00:00"

# Create settings
$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopOnIdleEnd -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

# Register task
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings -Description "🍦 OpenClaw Auto-Backup by ไอติม" -RunLevel Highest -Force

Write-Host "✅ Scheduled task created successfully!" -ForegroundColor Green
