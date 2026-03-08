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
    const cachePath = 'v2/' + outlook.cachePath
    const db = getDatabase()
    const ref = db.ref(cachePath)
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

        const [responseWindRH, responseDryT] = await Promise.all(outlook.urls.map(url => {
            console.log(`Fetch: ${url} for fire/${day}`)
            return fetch(url)
        }))

        if (!responseWindRH.ok) {
            console.error(`${outlook.urls[0].toString()}: ${responseWindRH.status} ${responseWindRH.statusText} (fallback: ${fallback})`)
            if (fallback)
                return NextResponse.json({ error: 'Failed to fetch the windrh outlook from the NWS after a second attempt.', url: outlook.urls[0].toString() })
            else
                return await fetchOutlook(day, true)
        } else if (!responseDryT.ok) {
            console.error(`${outlook.urls[0].toString()}: ${responseDryT.status} ${responseDryT.statusText} (fallback: ${fallback})`)
            if (fallback)
                return NextResponse.json({ error: 'Failed to fetch the dryt outlook from the NWS after a second attempt.', url: outlook.urls[1].toString() })
            else
                return await fetchOutlook(day, true)
        }

        const [windRH, dryT] = await Promise.all([responseWindRH, responseDryT].map(r => r.json()))
        
        let data: any = { groups: { } }
        if (windRH.features.length > 0)
            data.groups.fireWindRH = windRH
        if (dryT.features.length > 0)
            data.groups.fireDryTs = dryT
        await ref.set(data)
        await updateManifest(cachePath)
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
