import Link from 'next/link'

export default function Home() {
  // Keep this page purely static so `next export` can prerender it.
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-emerald-50 to-teal-50">
      <h1 className="text-3xl font-bold text-emerald-700 mb-4">Household Supplies Manager</h1>
      <p className="text-center max-w-xl text-muted-foreground mb-6">A simple app to share household supply lists with your partner. To use the interactive app, open the client app below (this route is client-side and will handle auth and real-time sync).</p>
      <div className="space-x-4">
        <Link href="/client" className="inline-block bg-emerald-600 text-white px-5 py-3 rounded shadow">Open Client App</Link>
        <a href="/public/placeholder.pdf" className="inline-block text-sm text-muted-foreground">View sample PDF</a>
      </div>
    </div>
  )
}
