Param(
  [Parameter(Mandatory=$true)]
  [string]$AppUrl,
  [Parameter(Mandatory=$true)]
  [string]$PackageId,
  [Parameter(Mandatory=$true)]
  [string]$AppName
)

Write-Host "This script will run Bubblewrap to generate a TWA project for $AppUrl"

# Ensure bubblewrap is installed
if (-not (Get-Command bubblewrap -ErrorAction SilentlyContinue)) {
  Write-Host "Installing @bubblewrap/cli globally..."
  npm install -g @bubblewrap/cli
}

# Init bubblewrap
Write-Host "Running bubblewrap init --manifest $($AppUrl.TrimEnd('/'))/manifest.json --packageId $PackageId --applicationName '$AppName' --no-interactive"
bubblewrap init --manifest "$($AppUrl.TrimEnd('/'))/manifest.json" --packageId $PackageId --applicationName "$AppName" --no-interactive

# Move generated dir to 'twa' if it exists
$generatedDir = Join-Path (Get-Location) $PackageId
if (Test-Path $generatedDir) {
  if (-Not (Test-Path .\twa)) { New-Item -ItemType Directory -Path .\twa | Out-Null }
  Write-Host "Moving generated project $generatedDir to .\twa\"
  Move-Item -Path $generatedDir -Destination .\twa -Force
}

Write-Host "Done. Open .\twa in Android Studio and build a signed bundle. For Gradle builds on Windows use: .\twa\gradlew.bat bundleRelease"
