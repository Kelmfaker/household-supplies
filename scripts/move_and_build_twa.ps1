<#
move_and_build_twa.ps1

Copies this project to C:\Projects\household-supplies (safe path without spaces/parentheses)
and runs the diagnostic build script there. Useful for avoiding path/quoting issues with Gradle/Android tooling.

Run from project root (PowerShell):
  .\scripts\move_and_build_twa.ps1

It will create C:\Projects\household-supplies if missing, copy files with robocopy, then run the diagnostic build script and print the log path.
#>

try {
    $src = (Get-Location).Path
    $destRoot = 'C:\Projects'
    $dest = Join-Path $destRoot 'household-supplies'

    Write-Output "Source: $src"
    Write-Output "Destination: $dest"

    if (-not (Test-Path $destRoot)) {
        New-Item -ItemType Directory -Path $destRoot -Force | Out-Null
    }

    # Use robocopy to mirror project (preserve files). Exclude node_modules for speed.
    $robocopyArgs = @(
        ('"{0}"' -f $src),
        ('"{0}"' -f $dest),
        '/MIR',
        '/XD', 'node_modules', '.next', 'build', 'out', '.git', '.vercel', 'play-store/*.jks'
    )

    Write-Output "Copying files (this may take a moment)..."
    $rc = Start-Process -FilePath robocopy -ArgumentList $robocopyArgs -NoNewWindow -Wait -PassThru
    if ($rc.ExitCode -ge 8) {
        Write-Warning "Robocopy reported a failure exit code: $($rc.ExitCode). Check permissions and try again.";
    }

    Write-Output "Copy complete. Changing directory to destination..."
    Set-Location $dest

    # Ensure scripts are executable and run the diagnostic build script
    if (-not (Test-Path '.\scripts\build_twa_local.ps1')) {
        Write-Error 'Missing scripts\build_twa_local.ps1 in destination. Aborting.'; exit 1
    }

    Write-Output "Running diagnostic build script at $dest\scripts\build_twa_local.ps1"
    & .\scripts\build_twa_local.ps1

    Write-Output "If the build failed, attach gradle-build-diagnostic.log from $dest"
} catch {
    Write-Error "Exception: $_"
    exit 1
}
