import { FireOutlook, FireOutlookFactory } from "@/lib/FireOutlooks";
import { getApps, cert, initializeApp } from "firebase-admin/app";
import { getDatabase } from "firebase-admin/database";
import { NextRequest, NextResponse } from "next/server";

async function fetchOutlook(day: number, fallback: boolean): Promise<NextResponse> {
    if (getApps().length === 0)
        initializeApp({
            credential: cert(JSON.parse(atob(process.env.FB_ADMIN_CONFIG_ENCODED!))),
            databaseURL: 'https://redzone-6a505-default-rtdb.firebaseio.com'
        })

    let outlook: FireOutlook
    try {
        outlook = FireOutlookFactory.createOutlook(day, fallback)
    } catch (error) {
        console.error(error)
        return NextResponse.json({ error: 'Invalid fire outlook' }, { status: 400 })
    }
    const path = outlook.path
    const db = getDatabase()
    const ref = db.ref(path)
    const snap = await ref.get()
    if (snap.exists())
        return NextResponse.json({
            cached: true,
            fallback,
            ...(snap.val())
        })
    else {
        const response = await fetch(outlook.url)
        if (!response.ok) {
            console.error(`${outlook.url.toString()}: ${response.status} ${response.statusText} (fallback: ${fallback})`)
            if (fallback)
                return NextResponse.json({ error: 'Failed to fetch the outlook from the NWS after a second attempt.', url: outlook.url.toString() })
            else
                return await fetchOutlook(day, true)
        }
        const data = await response.json()
        await ref.set(data)
        await updateManifest(path)
        return NextResponse.json({ ...data, fallback })
    }
}

export async function GET(req: NextRequest, { params }: { params: Promise<{day: string}> }) {
    const { day } = await params
    return await fetchOutlook(parseInt(day), false)
}

async function updateManifest(path: string) {
    const db = getDatabase()
    const ref = db.ref('manifest/' + path.replaceAll('/', '__'))
    ref.set(Date.now())
}
