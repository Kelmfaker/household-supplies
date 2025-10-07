Param()

# Assemble static export for GitHub Pages
# Copies next static export output and public/ into out/
Set-StrictMode -Version Latest

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# Project root is parent of scripts folder
$root = Join-Path $scriptDir ".."
Push-Location $root

Write-Host "Assembling static export into out/"

if (-Not (Test-Path -Path ".next")) {
  Write-Error ".next does not exist. Run 'npm run export' (which now runs 'next build') first."
  Exit 1
}

# Create out dir
if (Test-Path -Path "out") { Remove-Item -Recurse -Force out }
New-Item -ItemType Directory -Path out | Out-Null

# Copy public content
if (Test-Path -Path "public") {
  Write-Host "Copying public/ to out/"
  Copy-Item -Recurse -Force public\* out\
}

# Copy exported pages from .next if present
# Next places exported HTML under .next/server/pages or .next/static depending on build
Write-Host "Copying .next static files"
Copy-Item -Recurse -Force .next\static out\.next-static -ErrorAction SilentlyContinue
Copy-Item -Recurse -Force .next\server out\.next-server -ErrorAction SilentlyContinue

Write-Host "Static export assembled in out/. Verify contents and push to GitHub Pages or another static host."

Pop-Location
