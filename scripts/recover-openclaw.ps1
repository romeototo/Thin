param(
    [switch]$FollowLogs,
    [switch]$ForceInstall
)

$ErrorActionPreference = 'Continue'
$OpenClawBin = 'C:\Users\admin\AppData\Roaming\npm\openclaw.cmd'

function Step($msg) {
    Write-Host "`n=== $msg ===" -ForegroundColor Cyan
}

function Run($cmd) {
    if ($cmd -like 'openclaw*' -and (Test-Path $OpenClawBin)) {
        $cmd = 'cmd /c ""' + $OpenClawBin + '" ' + ($cmd -replace '^openclaw\s*','') + '"'
    }
    Write-Host "> $cmd" -ForegroundColor Yellow
    try {
        Invoke-Expression $cmd
        if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) {
            Write-Host "! exit code: $LASTEXITCODE" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "! failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Step "OpenClaw quick recovery"
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor DarkGray

Step "1) Gateway status"
Run "openclaw gateway status"

Step "2) Ensure gateway is started (only if port is down)"
$needStart = $true
try {
    $probeBefore = Test-NetConnection 127.0.0.1 -Port 18789 -WarningAction SilentlyContinue
    if ($probeBefore.TcpTestSucceeded) {
        $needStart = $false
        Write-Host "Gateway already reachable, skip start." -ForegroundColor DarkGray
    }
}
catch {}

if ($needStart) {
    Run "openclaw gateway start"
}

if ($ForceInstall) {
    Step "3) Force install service (sync token/config)"
    Run "openclaw gateway install --force"
} else {
    Step "3) Optional token/config sync"
    Write-Host "Skip install --force (use -ForceInstall when you changed gateway token/config)." -ForegroundColor DarkGray
}

Step "4) Restart gateway"
Run "openclaw gateway restart"

Step "5) Check status"
Run "openclaw status"

Step "6) Probe local gateway port"
try {
    $probe = Test-NetConnection 127.0.0.1 -Port 18789 -WarningAction SilentlyContinue
    $ok = $probe.TcpTestSucceeded
    if ($ok) {
        Write-Host "Gateway reachable on 127.0.0.1:18789" -ForegroundColor Green
    } else {
        Write-Host "Gateway NOT reachable on 127.0.0.1:18789" -ForegroundColor Red
    }
}
catch {
    Write-Host "Port probe failed: $($_.Exception.Message)" -ForegroundColor Red
}

if ($FollowLogs) {
    Step "7) Follow logs"
    Run "openclaw logs --follow"
} else {
    Step "Done"
    Write-Host "Tip: add -FollowLogs to tail logs after recovery." -ForegroundColor DarkGray
}
