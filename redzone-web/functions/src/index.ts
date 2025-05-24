// import { onSchedule } from "firebase-functions/v2/scheduler";
import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import { getDatabase } from "firebase-admin/database";
import { initializeApp } from "firebase-admin/app";

initializeApp()

// exports.cleanup = onSchedule('every day 00:00', async () => {
exports.cleanup = onRequest(async (_, res) => {
    logger.debug('Running database cleanup')
    const db = getDatabase()
    const manifestRef = db.ref('manifest')
    const manifest: Record<string, number> = (await manifestRef.get()).val()
    logger.info('Manifest', manifest)
    const keysToDelete: string[] = []

    const now = Date.now()
    for (const key in manifest) {
        const timestamp = new Date(manifest[key]).getTime()
        if (Math.abs(now - timestamp) >= 86_400_000) {
            delete manifest[key]
            keysToDelete.push(key.replaceAll('__', '/'))
        }
    }

    logger.info('Deleting stale entries', keysToDelete)

    try {
        await Promise.all(keysToDelete.map(k => db.ref(k).remove()))
    } catch (error) {
        logger.error('Failed to delete one or more items', error)
    }

    try {
        await manifestRef.set(manifest)
    } catch (error) {
        logger.error('Failed to update the manifest', error)
    }

    logger.debug('Done')
    res.status(200).send({
        manifest,
        keysToDelete
    })
})
