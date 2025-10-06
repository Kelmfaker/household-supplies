<#
PowerShell helper: capture_play_console_screenshots.ps1
Usage:
  - Open the Play Console and navigate to the screen you want to capture.
  - Run this script from the repository root to save a timestamped PNG into ./screenshots/
  - Optional parameters:
      -FileName "step1-overview.png"  -Delay 3
#>
param(
  [string]$FileName = '',
  [int]$Delay = 2
)

# Wait optionally to let you arrange the window
if ($Delay -gt 0) { Write-Host "Waiting $Delay seconds to let you arrange the window..."; Start-Sleep -Seconds $Delay }

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

try {
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bmp = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($screen.X, $screen.Y, 0, 0, $bmp.Size)

    $outDir = Join-Path -Path (Get-Location) -ChildPath "screenshots"
    if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

    if ([string]::IsNullOrEmpty($FileName)) {
        $file = Join-Path $outDir ("playshot_{0:yyyyMMdd_HHmmss}.png" -f (Get-Date))
    } else {
        $file = Join-Path $outDir $FileName
        # If file exists, append timestamp
        if (Test-Path $file) {
            $file = Join-Path $outDir ((Get-Item $FileName).BaseName + "_{0:yyyyMMdd_HHmmss}.png" -f (Get-Date))
        }
    }

    $bmp.Save($file, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
    Write-Host "Saved screenshot: $file"
} catch {
    Write-Error "Failed to capture screenshot: $_"
}
