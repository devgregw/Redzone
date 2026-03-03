import { verifyAppCheck } from "@/lib/AppCheck";
import { ConvectiveOutlookSubtype, subtypeFromString, ConvectiveOutlook, ConvectiveOutlookFactory } from "@/lib/ConvectiveOutlooks";
import { getDatabase } from "firebase-admin/database";
import { NextRequest, NextResponse } from "next/server";

async function fetchOutlook(day: number, subtype: ConvectiveOutlookSubtype, fallback: boolean): Promise<NextResponse> {
    let outlook: ConvectiveOutlook
    try {
        outlook = ConvectiveOutlookFactory.createOutlook(day, subtype, fallback)
    } catch (error) {
        console.error(error)
        return NextResponse.json({ error: 'Invalid convective outlook' }, { status: 400 })
    }
    const path = 'v2/' + outlook.path
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
        console.log(`Fetch: ${outlook.url} for convective/${day}/${subtype}`)
        const response = await fetch(outlook.url)
        if (!response.ok) {
            console.error(`${outlook.url.toString()}: ${response.status} ${response.statusText} (fallback: ${fallback})`)
            if (fallback)
                return NextResponse.json({ error: 'Failed to fetch the outlook from the NWS after a second attempt.', url: outlook.url.toString() })
            else
                return await fetchOutlook(day, subtype, true)
        }
        const json = await response.json()
        const data = { groups: processResponse(json, subtype)  }
        await ref.set(data)
        await updateManifest(path)
        return NextResponse.json(
            { ...data, fallback },
            { headers: { 'Cache-Control': 'public, s-maxage=60, stale-while-revalidate=120' } }
        )
    }
}

function chunkArray<T>(array: T[], predicate: (element: T) => boolean): [T[], T[]] {
    let trueElements: T[] = []
    let falseElements: T[] = []

    for (let element of array)
        (predicate(element) ? trueElements : falseElements).push(element)

    return [trueElements, falseElements]
}

function processResponse(data: any, subtype: ConvectiveOutlookSubtype): any {
    if (subtype == ConvectiveOutlookSubtype.categorical || subtype == ConvectiveOutlookSubtype.probabilistic)
        return { convectivePrimary: data }
    else {
        let convectivePrimary = data as { type: 'FeatureCollection', features: { type: 'Feature', geometry: any, properties: Record<string, any> }[] }
        let [cigs, probs] = chunkArray(convectivePrimary.features, f => (f.properties.LABEL as string)?.indexOf('CIG') === 0)
        convectivePrimary.features = probs
        let convectiveCIG = {
            type: 'FeatureCollection',
            features: cigs
        }
        return {
            convectivePrimary: convectivePrimary.features.length === 0 ? null : convectivePrimary,
            convectiveCIG: convectiveCIG.features.length === 0 ? null : convectiveCIG
        }
    }
}

export async function GET(req: NextRequest, { params }: { params: Promise<{day: string, subtype: string}> }) {
    if (!(await verifyAppCheck(req)))
        return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    const { day, subtype } = await params
    let parsedSubtype: ConvectiveOutlookSubtype
    try {
        parsedSubtype = subtypeFromString(subtype)
    } catch (error) {
        console.error(error)
        return NextResponse.json({ error: 'Invalid subtype' }, { status: 400 })
    }
    return await fetchOutlook(parseInt(day), parsedSubtype, false)
}

async function updateManifest(path: string) {
    const db = getDatabase()
    const ref = db.ref('manifest/' + path.replaceAll('/', '__'))
    ref.set(Date.now())
}
