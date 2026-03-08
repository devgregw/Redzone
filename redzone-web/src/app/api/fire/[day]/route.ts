import { verifyAppCheck } from "@/lib/AppCheck";
import { FireOutlook, FireOutlookFactory } from "@/lib/FireOutlooks";
import { getDatabase } from "firebase-admin/database";
import { NextRequest, NextResponse } from "next/server";

async function fetchOutlook(day: number, fallback: boolean): Promise<NextResponse> {
    let outlook: FireOutlook
    try {
        outlook = FireOutlookFactory.createOutlook(day, fallback)
    } catch (error) {
        console.error(error)
        return NextResponse.json({ error: 'Invalid fire outlook' }, { status: 400 })
    }
    const path = outlook.paths[0]
    const db = getDatabase()
    const ref = db.ref(path)
    const snap = await ref.get()
    if (snap.exists())
        return NextResponse.json({
            cached: true,
            fallback,
            ...(snap.val())
        }, {
            headers: { 'Cache-Control': 'public, s-maxage=60, stale-while-revalidate=120' }
        })
    else {
        const response = await fetch(outlook.urls[0])
        if (!response.ok) {
            console.error(`${outlook.urls[0].toString()}: ${response.status} ${response.statusText} (fallback: ${fallback})`)
            if (fallback)
                return NextResponse.json({ error: 'Failed to fetch the outlook from the NWS after a second attempt.', url: outlook.urls[0].toString() })
            else
                return await fetchOutlook(day, true)
        }
        const data = await response.json()
        await ref.set(data)
        await updateManifest(path)
        return NextResponse.json(
            { ...data, fallback },
            { headers: { 'Cache-Control': 'public, s-maxage=60, stale-while-revalidate=120' } }
        )
    }
}

export async function GET(req: NextRequest, { params }: { params: Promise<{day: string}> }) {
    if (!(await verifyAppCheck(req)))
        return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    const { day } = await params
    return await fetchOutlook(parseInt(day), false)
}

async function updateManifest(path: string) {
    const db = getDatabase()
    const ref = db.ref('manifest/' + path.replaceAll('/', '__'))
    ref.set(Date.now())
}
