TWA (Trusted Web Activity) Project

If you prefer to generate the TWA project locally and commit it to the repository to enable CI builds, use these steps:

1. Install prerequisites
   - Java JDK (11+)
   - Android SDK (command line tools)
   - Node.js & npm
   - Bubblewrap: npm install -g @bubblewrap/cli

2. Generate the TWA locally
   - Using Bash/macOS/Linux:
     ./scripts/create_twa.sh https://your-deployed-url
   - Using PowerShell/Windows:
     .\scripts\generate_twa.ps1 -AppUrl "https://your-deployed-url" -PackageId "com.example.household" -AppName "Household Supplies"

3. Commit the `twa/` folder to the repo (optional)
   - If `twa/` is committed, the GitHub Actions workflow can skip `bubblewrap init` and use the committed project to build the AAB.

4. Build locally using Android Studio or Gradle
   - In Android Studio: File > Open > choose the `twa/` folder; Build > Generate Signed Bundle / APK
   - Using Gradle (Linux/macOS): ./gradlew bundleRelease
   - Using Gradle (Windows): .\gradlew.bat bundleRelease

Notes:
- Signing requires a keystore. Use `keytool -genkeypair` to create one if needed.
- CI builds require adding keystore (base64) and passwords as repository secrets. See PLAY_STORE_CI_README.md for details.
