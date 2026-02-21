param(
  [switch]$Probe
)

$ErrorActionPreference = 'Continue'

Write-Host "=== OpenClaw Model Health ===" -ForegroundColor Cyan
openclaw models status

if ($Probe) {
  Write-Host "`n=== Live Probe: kimi-coding ===" -ForegroundColor Cyan
  openclaw models status --probe --probe-provider kimi-coding --probe-timeout 12000
}
