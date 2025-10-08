import { readFileSync } from 'fs'
import { dirname } from 'path'
import { fileURLToPath } from 'url'

const __dirname = dirname(fileURLToPath(import.meta.url))

let withPWA = (config) => config
try {
  // Try to require next-pwa if installed; if not present, fall back gracefully.
  // The dev machine should run `npm install next-pwa` (install step will be suggested below).
  // Using dynamic import to avoid hard dependency at runtime when package is missing.
  const nextPwa = await import('next-pwa')
  withPWA = nextPwa.default({ dest: 'public', register: true, skipWaiting: true })
} catch (e) {
  // next-pwa not installed; proceed without PWA wrapping.
  console.warn('[v0] next-pwa is not installed; PWA will be disabled until next-pwa is added.')
}

/** @type {import('next').NextConfig} */
const nextConfig = withPWA({
  // Allow selecting static export when needed (e.g. GitHub Pages).
  // For Vercel or serverful deployments leave unset so API routes and SSR work.
  ...(process.env.NEXT_STATIC_EXPORT === '1' ? { output: 'export' } : {}),
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  images: {
    unoptimized: true,
  },
})

export default nextConfig
