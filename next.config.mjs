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
  // Build a static export output (replaces `next export` in newer Next.js)
  output: 'export',
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
