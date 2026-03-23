import { verifyAppCheck } from "@/lib/AppCheck";
import { ConvectiveOutlookSubtype, subtypeFromString, ConvectiveOutlook, ConvectiveOutlookFactory } from "@/lib/ConvectiveOutlooks";
import { getDatabase } from "firebase-admin/database";
import { NextRequest, NextResponse } from "next/server";

async function fetchDay3CigProb(fallback: boolean): Promise<any | null> {
    try {
        let outlook = ConvectiveOutlookFactory.createOutlook(3, ConvectiveOutlookSubtype.cigProbabilistic, fallback)
        console.log(`Fetch: ${outlook.url} for convective/3/cigprob`)
        const response = await fetch(outlook.url)
        if (!response.ok) {
            console.error(`${outlook.url.toString()}: ${response.status} ${response.statusText} (fallback: ${fallback})`)
            return null
        }
        return await response.json()
    } catch {
        return null
    }
}

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
        let cigData: any | null
        if (day === 3 && subtype === ConvectiveOutlookSubtype.probabilistic)
            cigData = await fetchDay3CigProb(fallback)
        else
            cigData = null
        const json = await response.json()
        const data = { groups: processResponse(json, cigData, day, subtype)  }
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

type FeatureCollection = { type: 'FeatureCollection', features: { type: 'Feature', geometry: any, properties: Record<string, any> }[] }

function processResponse(data: any, cigData: any | null, day: number, subtype: ConvectiveOutlookSubtype): any {
    if ((day <= 2 && subtype == ConvectiveOutlookSubtype.categorical) || day >= 4)
        return { convectivePrimary: data }
    else if (cigData) {
        let response: any = { }
        if ((data as FeatureCollection).features.length > 0)
            response.convectivePrimary = data
        if ((cigData as FeatureCollection).features.length > 0)
            response.convectiveCIG = cigData
        return response
    } else {
        let convectivePrimary = data as FeatureCollection
        let [cigs, probs] = chunkArray(convectivePrimary.features, f => (f.properties.LABEL as string)?.indexOf('CIG') === 0)
        convectivePrimary.features = probs
        let convectiveCIG = {
            type: 'FeatureCollection',
            features: cigs
        }
        let response: any = { }
        if (convectivePrimary.features.length > 0)
            response.convectivePrimary = convectivePrimary
        if (convectiveCIG.features.length > 0)
            response.convectiveCIG = convectiveCIG
        return response
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
