@echo off
:: Auto-Restart Monitor Setup
:: Double-click to run as Admin

:: Check if running as Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ==========================================
echo  Auto-Restart Monitor Setup
echo ==========================================
echo.

:: Remove old task if exists
schtasks /delete /tn "AutoRestartMonitor" /f >nul 2>&1

:: Create new task
echo Creating scheduled task...
schtasks /create /tn "AutoRestartMonitor" /tr "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\Users\admin\.openclaw\workspace\scripts\auto-restart-monitor.ps1" /sc minute /mo 5 /ru SYSTEM /rl HIGHEST /f

if %errorLevel% equ 0 (
    echo.
    echo SUCCESS! Task created.
    echo.
    echo Settings:
    echo - Check every: 5 minutes
    echo - Restart if: RAM ^> 85%% or uptime ^> 48 hours
    echo - Log file: C:\Users\admin\.openclaw\workspace\logs\auto-restart.log
    echo.
    schtasks /query /tn "AutoRestartMonitor" /fo table
) else (
    echo.
    echo FAILED! Error code: %errorLevel%
)

echo.
pause
