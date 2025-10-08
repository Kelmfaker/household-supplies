CI TWA build (GitHub Actions)

This workflow builds the Android App Bundle (AAB) for the Trusted Web Activity using Bubblewrap in GitHub Actions.

Required repository secrets (set in GitHub Settings → Secrets):
 
 Optional secret for GitHub Pages assetlinks (used by the Pages deploy workflow):
 - ASSETLINKS_JSON: Raw JSON string for `assetlinks.json`. If set, the Pages workflow will write this
   file into `out/.well-known/assetlinks.json` before publishing, so it will be available at the origin
   root as `/.well-known/assetlinks.json`.
 
 Helper (local PowerShell):
 1. Edit `play-store/assetlinks.json` with your `package_name` and `sha256_cert_fingerprints`.
 2. Run:
 ```powershell
 .\scripts\assetlinks_to_secret.ps1
 ```
 3. Copy the printed RAW JSON and paste into the repository secret `ASSETLINKS_JSON`.

Publishing options for manifest/assetlinks
- If you want to host only the PWA assets (manifest + icons + assetlinks) on GitHub Pages, use the `deploy-public-pages.yml` workflow which publishes the `public/` directory as the Pages site. This is the simplest route to expose `manifest.json` and `/.well-known/assetlinks.json` over HTTPS.

To use it:
1. Ensure `public/manifest.json` and `public/icons/*` are correct.
2. Set `ASSETLINKS_JSON` secret as described above (optional but required for TWA verification).
3. Push to `main` or run the `Publish public/ to GitHub Pages` workflow manually. Then enable GitHub Pages to serve `gh-pages` branch.

Notes about origin-root for assetlinks
- Play Store requires `/.well-known/assetlinks.json` at the origin root (e.g., `https://kelmfaker.github.io/.well-known/assetlinks.json`). If you publish a repo site at `/repo` path, the workflow will still put `/.well-known/assetlinks.json` at the origin root when you publish `public/` as the Pages site (the gh-pages branch becomes the origin root for that Pages site).


How it works
- The workflow decodes `KEYSTORE_BASE64` to `play-store/my-release-key.jks`.
- It populates `play-store/bubblewrap-config.json` with the keystore path and passwords to a temporary `play-store/bubblewrap-config.ci.json` file.
- Runs `bubblewrap build` to generate the AAB.
- Uploads the produced AAB as a workflow artifact named `twa-aab` that you can download from the Actions UI.

Trigger
- Manually via the Actions tab (Run workflow) or by pushing to `main`.

Security notes
- Keep your keystore and passwords secret. Use repository secrets and avoid committing keys or passwords.
