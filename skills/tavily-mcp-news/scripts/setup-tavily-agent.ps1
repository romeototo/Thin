param(
  [string]$RepoUrl = "https://github.com/spped2000/tavily-mcp-agent.git",
  [string]$TargetDir = "$PSScriptRoot\..\..\..\external\tavily-mcp-agent"
)

$ErrorActionPreference = "Stop"

Write-Host "[1/6] Check prerequisites..."
$py = Get-Command python -ErrorAction SilentlyContinue
if (-not $py) {
  throw "Python not found. Please install Python 3.10+ แล้วรันสคริปต์อีกครั้ง"
}
python --version
node --version
npm --version
git --version

if (!(Test-Path $TargetDir)) {
  Write-Host "[2/6] Cloning repo..."
  git clone $RepoUrl $TargetDir
} else {
  Write-Host "[2/6] Repo already exists, skip clone."
}

Set-Location $TargetDir

Write-Host "[3/6] Create venv..."
if (!(Test-Path ".venv")) {
  python -m venv .venv
}

Write-Host "[4/6] Install dependencies..."
& .\.venv\Scripts\python.exe -m pip install --upgrade pip
& .\.venv\Scripts\python.exe -m pip install google-adk

Write-Host "[5/6] Prepare .env..."
if (!(Test-Path ".env")) {
@"
TAVILY_API_KEY=
"@ | Set-Content -Path ".env" -Encoding UTF8
  Write-Host "Created .env (please fill TAVILY_API_KEY)"
} else {
  Write-Host ".env already exists"
}

Write-Host "[6/6] Done. Run with:"
Write-Host "  cd $TargetDir"
Write-Host "  .\.venv\Scripts\activate"
Write-Host "  adk web"
