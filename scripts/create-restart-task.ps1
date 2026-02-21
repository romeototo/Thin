# Auto Restart Monitor Setup
# No Thai characters - Encoding safe

$taskName = "AutoRestartMonitor"
$scriptPath = "C:\Users\admin\.openclaw\workspace\scripts\auto-restart-monitor.ps1"

Write-Host "Creating Auto-Restart Monitor..." -ForegroundColor Green

# Remove old task if exists
schtasks /delete /tn $taskName /f 2>$null

# Create new task - check every 5 minutes
$createTask = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Description>Auto restart when RAM > 85% or uptime > 48h</Description>
  </RegistrationInfo>
  <Triggers>
    <TimeTrigger>
      <Repetition>
        <Interval>PT5M</Interval>
        <Duration>P3650D</Duration>
      </Repetition>
      <StartBoundary>$(Get-Date -Format "yyyy-MM-ddTHH:mm:ss")</StartBoundary>
      <Enabled>true</Enabled>
    </TimeTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-18</UserId>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>powershell.exe</Command>
      <Arguments>-ExecutionPolicy Bypass -WindowStyle Hidden -File "$scriptPath"</Arguments>
    </Exec>
  </Actions>
</Task>
"@

$xmlPath = "$env:TEMP\auto-restart-task.xml"
$createTask | Out-File -FilePath $xmlPath -Encoding Unicode

# Register task
schtasks /create /tn $taskName /xml $xmlPath /f

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS: Task created!" -ForegroundColor Green
    Write-Host "Checking every 5 minutes" -ForegroundColor Cyan
    schtasks /query /tn $taskName /fo table
} else {
    Write-Host "FAILED: Need Administrator rights!" -ForegroundColor Red
}

# Cleanup
Remove-Item $xmlPath -ErrorAction SilentlyContinue
