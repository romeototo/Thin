# Auto-Restart Monitor for Low-Spec PC
# Created by ไอติม 🍦
# Restart เมื่อ: RAM>85%, CPU 100% 5นาที, อืด, หรือเปิดนาน48ชม.

param(
    [switch]$TestMode
)

$LogFile = "C:\Users\admin\.openclaw\workspace\logs\auto-restart.log"
$AlertFile = "C:\Users\admin\.openclaw\workspace\auto-restart-pending.txt"

# สร้างโฟลเดอร์ logs ถ้ายังไม่มี
$LogDir = Split-Path $LogFile -Parent
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $LogFile -Append -Encoding UTF8
    Write-Host "$timestamp - $Message"
}

# ดึงข้อมูลระบบ
$OS = Get-CimInstance Win32_OperatingSystem
$TotalRAM = $OS.TotalVisibleMemorySize / 1MB
$FreeRAM = $OS.FreePhysicalMemory / 1MB
$UsedRAM = $TotalRAM - $FreeRAM
$UsedRAMPercent = ($UsedRAM / $TotalRAM) * 100

# CPU Usage (average 5 seconds)
$CPU = (Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 5 | 
        Select-Object -ExpandProperty CounterSamples | 
        Measure-Object CookedValue -Average).Average

# Uptime
$Uptime = (Get-Date) - $OS.LastBootUpTime
$UptimeHours = $Uptime.TotalHours

Write-Log "=== System Check ==="
Write-Log "RAM Total: $([math]::Round($TotalRAM,2)) GB"
Write-Log "RAM Used: $([math]::Round($UsedRAMPercent,1))%"
Write-Log "CPU: $([math]::Round($CPU,1))%"
Write-Log "Uptime: $([math]::Round($UptimeHours,1)) hours"

# ตรวจสอบเงื่อนไข
$ShouldRestart = $false
$Reason = ""

# 1. RAM > 85%
if ($UsedRAMPercent -gt 85) {
    $ShouldRestart = $true
    $Reason = "RAM usage critical: $([math]::Round($UsedRAMPercent,1))%"
    Write-Log "⚠️ ALERT: $Reason"
}

# 2. CPU > 95% ต่อเนื่อง (เช็คครั้งนี้)
if ($CPU -gt 95) {
    $ShouldRestart = $true
    $Reason = "CPU overloaded: $([math]::Round($CPU,1))%"
    Write-Log "⚠️ ALERT: $Reason"
}

# 3. Uptime > 48 ชั่วโมง
if ($UptimeHours -gt 48) {
    $ShouldRestart = $true
    $Reason = "System uptime exceeded 48 hours"
    Write-Log "⚠️ ALERT: $Reason"
}

# 4. Disk space < 5%
$Disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$FreeSpacePercent = ($Disk.FreeSpace / $Disk.Size) * 100
if ($FreeSpacePercent -lt 5) {
    $ShouldRestart = $true
    $Reason = "Disk space critical: $([math]::Round($FreeSpacePercent,1))% free"
    Write-Log "⚠️ ALERT: $Reason"
}

# ตัดสินใจ
if ($TestMode) {
    Write-Log "TEST MODE - Would restart: $ShouldRestart"
    Write-Log "Reason: $Reason"
    exit 0
}

if ($ShouldRestart) {
    Write-Log "🔄 Initiating restart in 60 seconds..."
    Write-Log "Reason: $Reason"
    
    # บันทึกสาเหตุไว้
    $Reason | Out-File -FilePath $AlertFile -Force -Encoding UTF8
    
    # แจ้งเตือน (ถ้ามี)
    try {
        msg * "คอมพิวเตอร์จะ restart ใน 60 วินาที ($Reason)" 2>$null
    } catch {}
    
    # รอ 60 วินาทีแล้ว restart
    Start-Sleep -Seconds 60
    Write-Log "🔄 Restarting now..."
    Restart-Computer -Force
} else {
    Write-Log "✅ System healthy - no restart needed"
}
