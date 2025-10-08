"use client"

import * as React from 'react'
import { LoginForm } from "@/components/login-form"

export default function ClientPage() {
  return (
    <React.Suspense fallback={<div className="min-h-screen flex items-center justify-center">Loading...</div>}>
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-emerald-50 to-teal-50">
        <LoginForm />
      </div>
    </React.Suspense>
  )
}
