import { ConvectiveOutlookSubtype, subtypeFromString, ConvectiveOutlook, ConvectiveOutlookFactory } from "@/lib/ConvectiveOutlooks";
import { getApps, cert, initializeApp } from "firebase-admin/app";
import { getDatabase } from "firebase-admin/database";
import { NextRequest, NextResponse } from "next/server";

export async function GET(_: NextRequest, { params }: { params: Promise<{day: string, subtype: string}> }) {
    if (getApps().length === 0)
        initializeApp({
            credential: cert(JSON.parse(atob(process.env.FB_ADMIN_CONFIG_ENCODED!))),
            databaseURL: 'https://redzone-6a505-default-rtdb.firebaseio.com'
        })

    const { day, subtype } = await params
    let parsedSubtype: ConvectiveOutlookSubtype
    try {
        parsedSubtype = subtypeFromString(subtype)
    } catch (error) {
        console.error(error)
        return NextResponse.json({ error: 'Invalid subtype' }, { status: 400 })
    }

    let outlook: ConvectiveOutlook
    try {
        outlook = ConvectiveOutlookFactory.createOutlook(parseInt(day), parsedSubtype)
    } catch (error) {
        console.error(error)
        return NextResponse.json({ error: 'Invalid convective outlook' }, { status: 400 })
    }
    const path = outlook.path
    const db = getDatabase()
    const ref = db.ref(path)
    const snap = await ref.get()
    if (snap.exists())
        return NextResponse.json({
            cached: true,
            ...(snap.val())
        })
    else {
        const response = await fetch(outlook.url)
        if (!response.ok) {
            console.error(await response.text())
            return NextResponse.json({ error: 'Failed to fetch the outlook from the NWS.', url: outlook.url.toString() })
        }
        const data = await response.json()
        await ref.set(data)
        await updateManifest(path)
        return NextResponse.json(data)
    }
}

async function updateManifest(path: string) {
    const db = getDatabase()
    const ref = db.ref('manifest/' + path.replaceAll('/', '__'))
    ref.set(Date.now())
}
