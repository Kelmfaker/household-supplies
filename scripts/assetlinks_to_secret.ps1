<#
assetlinks_to_secret.ps1

Helpers to prepare ASSETLINKS_JSON repository secret.
Usage:
  1. Edit play-store/assetlinks.json with your actual SHA256 fingerprint and package name.
  2. Run: .\scripts\assetlinks_to_secret.ps1
  3. Copy the printed JSON to GitHub secret named ASSETLINKS_JSON (or copy the base64 line if you prefer).
#>

$path = Resolve-Path "play-store/assetlinks.json" -ErrorAction SilentlyContinue
if (-not $path) { Write-Error "play-store/assetlinks.json not found. Create it first."; exit 1 }

$json = Get-Content $path -Raw
Write-Output "--- RAW JSON (copy this into the ASSETLINKS_JSON secret) ---"
Write-Output $json

$b64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($json))
Write-Output "--- BASE64 (optional) ---"
Write-Output $b64
