import { getApps, cert, initializeApp } from "firebase-admin/app";
import { getAppCheck } from "firebase-admin/app-check";
import { NextRequest } from "next/server";

export async function verifyAppCheck(req: NextRequest): Promise<boolean> {
    if (getApps().length === 0)
        initializeApp({
            credential: cert(JSON.parse(atob(process.env.FB_ADMIN_CONFIG_ENCODED!))),
            databaseURL: 'https://redzone-6a505-default-rtdb.firebaseio.com'
        })

    const token = req.headers.get('X-Firebase-AppCheck')
    if (!token) {
        console.warn('App Check verification failed: token not provided')
        return false
    }

    try {
        const claims = await getAppCheck().verifyToken(token)
        return true
    } catch (err) {
        console.warn('App Check verification failed: verification failed')
        return false
    }
}
