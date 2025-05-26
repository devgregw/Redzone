// 'use client'

import Image from "next/image";
import logo from "./logo.png"

// import dynamic from "next/dynamic"

// const MapView = dynamic(() => import('./MapView'), { ssr: false })

export default function Home() {
  return (
    <div style={{ height: '100vh', display: 'flex', textAlign: 'center', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
      <Image src={logo} alt="Redzone logo" width="150" height="150" style={{ borderRadius: '2rem', marginBottom: '1rem' }}/>
      <span style={{display: 'inline-block'}}>Redzone for web under construction</span>
    </div>
  )
}
