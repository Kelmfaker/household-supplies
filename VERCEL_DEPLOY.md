Vercel deployment instructions
=============================

This project is a Next.js app that uses Supabase for realtime and auth.

Quick steps to deploy to Vercel
1. Sign in to Vercel and create a new project linked to this GitHub repository.
2. In Project Settings -> Environment Variables, set the following environment variables:

  - NEXT_PUBLIC_SUPABASE_URL (public) — your Supabase URL (https://xyz.supabase.co)
  - NEXT_PUBLIC_SUPABASE_ANON_KEY (public) — your Supabase anon key
  - SUPABASE_SERVICE_ROLE_KEY (secret) — Supabase service role key (server-only)
  - NEXT_STATIC_EXPORT (optional) — set to `1` only if you want to force static export (not recommended for full server behavior)

3. Provision a Node environment: Vercel uses its build system automatically. The default `next build` command and `next start` are used by Vercel.

4. Deploy. Vercel will run the build and serve API routes as serverless functions so your `app/api/*` routes will work.

Notes and security
- Keep `SUPABASE_SERVICE_ROLE_KEY` as a secret (do not expose it to client). Use Vercel's Environment Secrets.
- If you want to publish a static-only site to GitHub Pages instead, set `NEXT_STATIC_EXPORT=1` and use the included `scripts/assemble_static_export.ps1` and CI workflow. For full functionality use Vercel.

If you want, I can add a `vercel.json` with recommended settings and a GitHub Actions workflow to auto-deploy to Vercel (requires a Vercel token). Let me know.

CI-based deploy (GitHub Actions)
--------------------------------
If you prefer to deploy from GitHub Actions instead of connecting the repo in the Vercel UI, follow these steps:

1. Generate a Vercel token: go to https://vercel.com/account/tokens and create a token with `Deployments:Read and Create` scope.
2. In your GitHub repository, go to Settings → Secrets → Actions and add a secret named `VERCEL_TOKEN` with the token value.
3. The repository already contains `.github/workflows/deploy-to-vercel.yml` which will run on pushes to `main` and deploy to Vercel using the token.

Notes:
- For the GitHub Action to pick correct project automatically, the repo should be linked in Vercel or the token must have access to the team/org where the project lives.
- The workflow runs `vercel --prod --confirm`, which will perform a production deploy.

