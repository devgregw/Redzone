import { onSchedule } from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";
import { getDatabase } from "firebase-admin/database";
import { initializeApp } from "firebase-admin/app";

initializeApp()

// exports.cleanup = onSchedule('every day 00:00', async () => {
export const cleanup = onSchedule('every day 00:00', async () => {
    const now = new Date()
    logger.debug(`Running database cleanup at ${now.toLocaleString()}`)
    const db = getDatabase()
    const manifestRef = db.ref('manifest')
    const manifest: Record<string, number> = (await manifestRef.get()).val()
    logger.info('Manifest', manifest)
    const keysToDelete: string[] = []

    
    for (const key in manifest) {
        const timestamp = new Date(manifest[key]).getTime()
        if (Math.abs(now.getTime() - timestamp) >= 86_400_000) {
            delete manifest[key]
            keysToDelete.push(key.replaceAll('__', '/'))
        }
    }

    logger.info(`Deleting ${keysToDelete.length} stale entries`, keysToDelete)

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

    logger.debug(`Completed at ${new Date().toLocaleString()}`)
})
