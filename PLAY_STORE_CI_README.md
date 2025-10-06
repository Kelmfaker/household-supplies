GitHub Actions: Build TWA AAB

This repository includes a GitHub Actions workflow to generate a Trusted Web Activity (TWA) Android project using Bubblewrap and build a signed Android App Bundle (AAB).

Workflow: .github/workflows/build-aab.yml

How it works
- The workflow is manually triggered (`workflow_dispatch`) and requires three inputs: `app_url`, `package_id`, and `app_name`.
- It installs `@bubblewrap/cli`, sets up Android command line tools, runs `bubblewrap init` against `APP_URL/manifest.json`, and builds the generated Gradle project.
- If you provide a keystore via repository secrets (base64-encoded), the workflow will write the keystore and a `keystore.properties` file inside the `twa/` directory, allowing Gradle to sign the AAB during `./gradlew bundleRelease`.

Required Repository Secrets
- KEYSTORE_BASE64: base64-encoded keystore file (JKS or PKCS12) contents
- KEYSTORE_PASSWORD: password for the keystore
- KEY_ALIAS: key alias inside the keystore
- KEY_PASSWORD: password for the key (can be same as keystore password)
 - PLAY_SERVICE_ACCOUNT_JSON: (optional) Google Play service account JSON content (for automated uploads). Add this as a GitHub secret to enable Play Console upload in CI.

Triggering the workflow
1. Deploy your PWA to a public HTTPS URL where `manifest.json` is available (e.g., https://example.com/manifest.json).
2. Add the required secrets to your GitHub repository (Settings -> Secrets -> Actions).
3. Open Actions -> Build TWA AAB -> Run workflow. Provide the `app_url`, `package_id`, and `app_name` inputs.

Artifacts
- The workflow uploads any generated `.aab` files as artifacts named `app-bundle`. Download them from the workflow run.

Notes and limitations
- The workflow runs on GitHub-hosted Ubuntu runners. It installs Android command line tools and API 33 build tools. For differing Android SDK requirements you can edit the workflow.
- Bubblewrap may prompt for input during `bubblewrap init`; the workflow uses `--no-interactive` where possible but some edge-cases may still need manual intervention. If `bubblewrap init` can't generate the project, create it locally and commit the `twa/` directory to the repo before running the workflow.
- Signing in CI requires uploading a keystore as base64 to `KEYSTORE_BASE64`. Keep this secret safe.
- You still need to upload the signed `.aab` to the Play Console; this workflow doesn't automate the Play Console upload step.

If you'd like, I can also:
- Add a release workflow that uploads the generated AAB to Google Play via `r0adkll/upload-google-play` (requires Play Console service account JSON and extra secrets).
- Add more validation steps (validate manifest URL, inspect generated project files, etc.).
