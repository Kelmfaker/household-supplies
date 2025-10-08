Play Store Deployment Checklist

1) Prepare PWA and host it on HTTPS
   - Ensure your site is deployed on HTTPS (Vercel recommended).
   - Manifest available at: https://your-domain/manifest.json
   - Service worker registered and app installable.

2) Required assets for Play Console
   - High-res icon: 512x512 PNG (used in Play Store listing)
   - Feature graphic: 1024x500 (optional but recommended)
   - Screenshots: phone (at least 2) and tablet (optional)
   - Privacy policy URL

3) Generate TWA (Bubblewrap)
   - npm i -g @bubblewrap/cli
   - bubblewrap init --manifest https://your-domain/manifest.json
   - Configure package name (e.g., com.yourcompany.households)
   - Build signed AAB in Android Studio or via Gradle

4) Keystore and signing
   - Generate keystore: keytool -genkeypair -v -keystore my-release-key.jks -alias your_alias -keyalg RSA -keysize 2048 -validity 10000
   - Keep keystore and password secure

5) Play Console steps
   - Create app, fill store listing, upload AAB, provide content rating, privacy policy, and submit to internal testing

6) Notes
   - Target latest Android API level as required by Play
   - If you collect user data, include privacy policy URL and disclose data handling

If you'd like, I can:
- Add these changes directly into the repo (I already added manifest and placeholder icons and next.config.mjs modifications).
- Generate a CI workflow to automatically build and sign an AAB (requires secrets for keystore).
- Provide step-by-step help running Bubblewrap locally.

Tell me which next step you want me to perform.
