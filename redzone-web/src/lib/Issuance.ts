import padZeroes from "./padZeroes"

export class SPCDate {
    private referenceDate: Date

    get date(): string {
        return `${padZeroes(this.referenceDate.getUTCFullYear(), 4)}${padZeroes(this.referenceDate.getUTCMonth() + 1, 2)}${padZeroes(this.referenceDate.getUTCDate(), 2)}`
    }

    get time(): number {
        return parseInt(`${this.referenceDate.getUTCHours()}${padZeroes(this.referenceDate.getUTCMinutes(), 2)}`)
    }

    get year(): number {
        return this.referenceDate.getUTCFullYear()
    }


    constructor(yesterday?: boolean) {
        this.referenceDate = new Date()
        if (yesterday) {
            this.referenceDate.setUTCDate(this.referenceDate.getUTCDate() - 1)
        }
    }
}

export type Issuance = number | { iss: number, comparison: number }
export type ResolvedIssuance = { year: number, date: string, issuance: number }

function issProp(iss: Issuance, value: 'iss' | 'comparison'): number {
    if (typeof iss === 'number')
        return iss
    else
        return iss[value]
}

export function findIssuance(issuances: Issuance[], fallback: boolean, referenceDate: Date = new Date()): ResolvedIssuance {
    const sortedIssuances = issuances.toSorted((a, b) => {
        return issProp(a, 'comparison') - issProp(b, 'comparison')
    })
    const year = referenceDate.getUTCFullYear()
    const month = referenceDate.getUTCMonth()
    const day = referenceDate.getUTCDate()
    
    const latest = sortedIssuances.toReversed().find(iss => {
        const hhmm = issProp(iss, 'comparison')
        const date = Date.UTC(year, month, day, Math.floor(hhmm / 100), hhmm % 100)
        return date <= referenceDate.getTime()
    })

    if (latest) {
        if (fallback) {
            let filteredIssuances = sortedIssuances.filter(iss => issProp(iss, 'comparison') < issProp(latest, 'comparison'))
            return findIssuance(filteredIssuances, false, referenceDate)
        } else {
            return {
                year,
                date: `${padZeroes(year, 4)}${padZeroes(month + 1, 2)}${padZeroes(day, 2)}`,
                issuance: typeof latest === 'number' ? latest : latest.iss
            }
        }
    } else {
        let dayBefore = new Date(referenceDate.getTime() - 24 * 60 * 60 * 1000)
        dayBefore.setUTCHours(23, 59, 0, 0)
        return findIssuance(issuances, fallback, new Date(dayBefore))
    }
}

// export function findIssuance(issuances: number[], fallback: boolean): { timestamp: SPCDate, latestIssuance: string } {
//     let timestamp: SPCDate
//     let latestIssuance: number | undefined = issuances.find(iss => {
//         const value = iss === 1200 ? 600 : iss
//         return new SPCDate().time >= value
//     })
//     if (latestIssuance)
//         if (fallback)
//             return findIssuance(issuances.filter(i => i !== latestIssuance), false)
//         else
//             timestamp = new SPCDate()
//     else {
//         timestamp = new SPCDate(true)
//         latestIssuance = issuances[0]
//     }
//     console.log(`Next issuance in ${issuances.join(',')} (fallback: ${fallback}): ${latestIssuance} (${timestamp.date} ${timestamp.time})`)
//     return { timestamp, latestIssuance: padZeroes(latestIssuance, 4) }
// }
