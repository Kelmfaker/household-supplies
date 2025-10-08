Building the Trusted Web Activity (TWA)

Prerequisites
- JDK 17 (64-bit) installed or allow Bubblewrap to download it.
- Android SDK (Bubblewrap can install build tools but having Android SDK/command-line tools helps).
- Node.js and npm installed.
- Valid `manifest.json` hosted at the URL in `play-store/bubblewrap-config.json`.
- A Java keystore (`.jks`) for signing the app.

Steps
1. Update `play-store/bubblewrap-config.json`:
   - Set `manifestUrl` (already set to GitHub Pages URL).
   - Update `signing.keystorePath` to the path of your `.jks` file.
   - Replace `keystorePassword` and `keyPassword` with the actual passwords (do this locally and don't commit).

2. Ensure `assetlinks.json` is published at the origin root under `/.well-known/assetlinks.json`.

3. Run Bubblewrap init (if you haven't already):
```powershell
bubblewrap init --config play-store/bubblewrap-config.json
```

4. Build the AAB:
```powershell
bubblewrap build
```

5. If Gradle fails due to memory, adjust `gradle.properties` in project root (example: `org.gradle.jvmargs=-Xmx512m`) or increase system RAM/pagefile.

6. Upload the generated AAB to the Play Console.

Notes
- Do not commit keystore passwords. Keep keystore files out of version control.
- If you need help extracting the SHA-256 fingerprint from your keystore for `assetlinks.json`, run:
```powershell
keytool -list -v -keystore path\to\your.jks -alias your_alias
```
