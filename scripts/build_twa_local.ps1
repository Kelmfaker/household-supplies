<#
build_twa_local.ps1

Diagnostics and build helper for TWA (Bubblewrap) Gradle bundle.

What it does:
- Dumps Java and Android SDK environment info
- Captures system memory info
- Runs Gradle clean bundleRelease with --no-daemon and full stacktrace
- Writes everything to gradle-build-diagnostic.log in project root

Run in PowerShell from the project root:
  .\scripts\build_twa_local.ps1

If the script fails, attach the generated gradle-build-diagnostic.log when asking for help.
#>

$log = Join-Path $PSScriptRoot '..\gradle-build-diagnostic.log' | Resolve-Path -Relative
if (Test-Path $log) { Remove-Item $log -Force }

"=== Diagnostic run: $(Get-Date -Format o) ===" | Out-File -FilePath $log -Encoding utf8

"--- Current Directory ---" | Out-File -FilePath $log -Append
(Get-Location).Path | Out-File -FilePath $log -Append

"--- Java version ---" | Out-File -FilePath $log -Append
& java -version 2>&1 | Out-File -FilePath $log -Append

"--- Java executable path (where) ---" | Out-File -FilePath $log -Append
where.exe java 2>&1 | Out-File -FilePath $log -Append

"--- JAVA_HOME ---" | Out-File -FilePath $log -Append
($env:JAVA_HOME) | Out-File -FilePath $log -Append

"--- ANDROID_SDK_ROOT ---" | Out-File -FilePath $log -Append
($env:ANDROID_SDK_ROOT) | Out-File -FilePath $log -Append

"--- ANDROID_HOME ---" | Out-File -FilePath $log -Append
($env:ANDROID_HOME) | Out-File -FilePath $log -Append

"--- Free/Total Memory (KB) ---" | Out-File -FilePath $log -Append
(Get-CimInstance Win32_OperatingSystem | Select-Object FreePhysicalMemory,TotalVisibleMemorySize | Format-List | Out-String) | Out-File -FilePath $log -Append

"--- Processor Count ---" | Out-File -FilePath $log -Append
$env:NUMBER_OF_PROCESSORS | Out-File -FilePath $log -Append

"--- Path contains spaces/parentheses? ---" | Out-File -FilePath $log -Append
(Get-Location).Path -match '[\s\(\)]' | Out-File -FilePath $log -Append

"--- Gradle properties (project gradle.properties) ---" | Out-File -FilePath $log -Append
if (Test-Path .\gradle.properties) { Get-Content .\gradle.properties | Out-File -FilePath $log -Append } else { 'NONE' | Out-File -FilePath $log -Append }

"--- Starting Gradle clean bundleRelease (no-daemon) ---" | Out-File -FilePath $log -Append

# Run Gradle wrapper and capture full output
try {
    $gradleCmd = 'cmd /c .\\gradlew.bat clean bundleRelease --no-daemon --stacktrace --warning-mode all'
    Write-Output "Running: $gradleCmd"
    & cmd /c ".\gradlew.bat" clean bundleRelease --no-daemon --stacktrace --warning-mode all 2>&1 | Tee-Object -FilePath $log -Append
    $exit = $LASTEXITCODE
    "--- Gradle exit code: $exit ---" | Out-File -FilePath $log -Append
} catch {
    "--- Exception while running Gradle: $_ ---" | Out-File -FilePath $log -Append
}

"--- Diagnostic finished: $(Get-Date -Format o) ---" | Out-File -FilePath $log -Append

Write-Output "Diagnostic complete. Log: $log"
Write-Output "Tail of log (last 200 lines):"
Get-Content $log -Tail 200
