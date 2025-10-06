#!/usr/bin/env bash
# Script: create_twa.sh
# Purpose: Guide to create a Trusted Web Activity (TWA) Android project using Bubblewrap.
# Note: This script requires Node.js, npm, Java JDK, Android SDK, and bubblewrap installed globally.

set -e
if [ -z "$1" ]; then
  echo "Usage: $0 <https://your-deployed-app-url>"
  exit 2
fi
APP_URL="$1"

echo "1) Ensure you have bubblewrap installed globally:"
echo "   npm install -g @bubblewrap/cli"

echo "2) Initialize a Bubblewrap project (interactive):"
echo "   bubblewrap init --manifest ${APP_URL}/manifest.json"

echo "3) Open the generated Android project in Android Studio and build a signed bundle (AAB):"
echo "   - File > Open > select the generated project folder"
echo "   - Build > Generate Signed Bundle / APK > Android App Bundle"

echo "4) Or build via Gradle (from generated project dir):"
echo "   ./gradlew bundleRelease    # (on Windows use .\\gradlew.bat bundleRelease)"

echo "5) Use keytool to generate a keystore if you don't have one:"
echo "   keytool -genkeypair -v -keystore my-release-key.jks -alias your_alias_name -keyalg RSA -keysize 2048 -validity 10000"

echo "6) Upload the AAB to Google Play Console."

echo "This script only prints instructions; run the interactive commands locally where Android SDK is available."
