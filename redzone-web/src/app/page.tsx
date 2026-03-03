// 'use client'

import Image from "next/image";
import logo from "./logo.png"
import tf from "./tf.png"
import Link from "next/link";

// import dynamic from "next/dynamic"

// const MapView = dynamic(() => import('./MapView'), { ssr: false })

export default function Home() {
  return (
    <div style={{ height: '100vh', display: 'flex', textAlign: 'center', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
      <Image src={logo} alt="Redzone logo" width="150" height="150" style={{ borderRadius: '2rem', marginBottom: '1rem' }}/>
      <span style={{display: 'inline-block'}}>Redzone for web under construction</span>

      <Link href='/testflight' style={{ marginTop: '3rem' }}>
        <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'center', border: '2px solid white', padding: '0.5rem', borderRadius: '1rem', background: 'black' }}>
          <Image src={tf} alt='TestFlight logo' width={75} height={75} />
          <span style={{ margin: '0.5rem', display: 'inline-block', fontSize: 'large' }}>Try Redzone on TestFlight</span>
        </div>
      </Link>
    </div>
  )
}
