# Google Gemini Setup Script
# Created by ไอติม 🍦
# ตั้งค่า Gemini Pro ให้ใช้งานได้จริง

param(
    [Parameter(Mandatory=$false)]
    [string]$ApiKey = ""
)

$ConfigPath = "C:\Users\admin\.openclaw\openclaw.json"
$BackupPath = "C:\Users\admin\.openclaw\openclaw.json.backup"

Write-Host "🍦 ไอติมกำลังตั้งค่า Gemini Pro..." -ForegroundColor Magenta
Write-Host "==================================" -ForegroundColor Cyan

# Backup config
if (Test-Path $ConfigPath) {
    Copy-Item $ConfigPath $BackupPath -Force
    Write-Host "✅ Backup config แล้ว" -ForegroundColor Green
}

# Read current config
$config = Get-Content $ConfigPath | ConvertFrom-Json

# Update auth profile
if (-not $config.auth.profiles."google:default") {
    $config.auth.profiles | Add-Member -NotePropertyName "google:default" -NotePropertyValue @{
        provider = "google"
        mode = "api_key"
    }
    Write-Host "✅ เพิ่ม Google auth profile" -ForegroundColor Green
}

# Update models provider
$config.models = @{
    providers = @{
        google = @{
            baseUrl = "https://generativelanguage.googleapis.com/v1"
            apiKey = if ($ApiKey) { $ApiKey } else { "YOUR_API_KEY_HERE" }
            auth = "api-key"
            api = "google-generative-ai"
            models = @(
                @{
                    id = "gemini-pro"
                    name = "Gemini Pro"
                    input = @("text", "image")
                    contextWindow = 30720
                }
            )
        }
    }
}
Write-Host "✅ ตั้งค่า Gemini Pro model" -ForegroundColor Green

# Update agent defaults
$config.agents.defaults.model.fallbacks = @("gemini-pro")

# Add gemini-pro to models list
if (-not $config.agents.defaults.models."gemini-pro") {
    $config.agents.defaults.models | Add-Member -NotePropertyName "gemini-pro" -NotePropertyValue @{
        alias = "Gemini Pro"
    }
    Write-Host "✅ เพิ่ม Gemini Pro ใน fallback chain" -ForegroundColor Green
}

# Save config
$config | ConvertTo-Json -Depth 10 | Out-File $ConfigPath -Encoding UTF8
Write-Host "✅ บันทึก config แล้ว" -ForegroundColor Green

Write-Host ""
Write-Host "📝 ขั้นตอนต่อไป:" -ForegroundColor Yellow
if (-not $ApiKey) {
    Write-Host "1. แก้ไข API Key ใน $ConfigPath" -ForegroundColor White
    Write-Host "   หา 'YOUR_API_KEY_HERE' แล้วแทนที่ด้วย Key จริง" -ForegroundColor Gray
}
Write-Host "2. Restart OpenClaw: openclaw gateway restart" -ForegroundColor White
Write-Host "3. ทดสอบด้วย: sessions_spawn({task: 'test', model: 'gemini-pro'})" -ForegroundColor White

Write-Host ""
Write-Host "⚠️  อย่าลืม:" -ForegroundColor Red
Write-Host "   - API Key ต้องถูกต้องและ Active" -ForegroundColor Yellow
Write-Host "   - เปิด Billing ใน Google AI Studio ถ้าจำเป็น" -ForegroundColor Yellow
