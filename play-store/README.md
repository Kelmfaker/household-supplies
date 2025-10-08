Play Store / TWA setup notes

This folder contains templates and instructions for preparing a Trusted Web Activity (TWA) for the Play Store.

1) Update `manifest.json` and deploy your site
   - Ensure the site is reachable on HTTPS and the manifest is available at `https://<your-domain>/manifest.json`.
   - The `manifest.json` in the repo was adjusted to use root-relative `start_url` and includes a 512×512 icon entry pointing to `public/placeholder-logo.png`. Replace the placeholder icons with your real assets (512x512 PNG and 192x192).

2) Configure Android package name and keystore
   - Choose an Android package name (example: `com.yourcompany.households`) and keep it consistent in Bubblewrap and Play Console.
   - Generate or reuse a keystore. Example command to generate a keystore:

     keytool -genkeypair -v -keystore my-release-key.jks -alias my_alias -keyalg RSA -keysize 2048 -validity 10000

   - Get the SHA-256 fingerprint from the keystore (used below):

     keytool -list -v -keystore my-release-key.jks -alias my_alias

3) Update and host Digital Asset Links
   - Copy `assetlinks.json.template` to `assetlinks.json`, replace `package_name` and the `sha256_cert_fingerprints` with the value from your keystore.
   - Host the resulting file at `https://<your-domain>/.well-known/assetlinks.json`.

4) Bubblewrap
   - Install Bubblewrap: `npm i -g @bubblewrap/cli`
   - Initialize using the deployed manifest (recommended to use an HTTPS URL):

     bubblewrap init --manifest https://<your-domain>/manifest.json

   - Follow prompts, set package name and other metadata.
   - Build signed AAB via Android Studio or Gradle and sign with your keystore.

5) Play Console
   - Create app, upload AAB, fill store listing, add privacy policy, screenshots, and submit to testing.

Notes and tips
- Ensure the manifest and all icons are served over HTTPS and that the start_url / scope match the deployed origin. Using relative `start_url` and `scope: /` simplifies packaging across environments.
- Do not commit keystore files or credentials. Keep them in your secure secret storage (Play Console or CI secrets).

If you want, I can update `manifest.json` further, add real icon files (if you supply them), or run a `bubblewrap init` attempt and report errors. Let me know which next step to take.

Non-interactive Bubblewrap usage
--------------------------------

You can use the provided `bubblewrap-config.json.template` to run Bubblewrap non-interactively. Copy it to `bubblewrap-config.json`, fill the fields (`manifestUrl` and `applicationId` at minimum), and run:

```powershell
# make a local copy and edit the values
cp play-store\bubblewrap-config.json.template play-store\bubblewrap-config.json
# edit play-store\bubblewrap-config.json and set applicationId and manifestUrl

# Run bubblewrap using the config (example):
bubblewrap init --manifest "$(cat play-store/bubblewrap-config.json | jq -r .manifestUrl)" --applicationId "$(cat play-store/bubblewrap-config.json | jq -r .applicationId)"
```

Note: The PowerShell snippet above uses `jq` for convenience. If you don't have `jq`, just read the values manually and pass them to `bubblewrap init`.