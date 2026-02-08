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

export function findIssuance(issuances: number[], fallback: boolean): { timestamp: SPCDate, latestIssuance: string } {
    let timestamp: SPCDate
    let latestIssuance: number | undefined = issuances.find(iss => {
        const value = iss === 1200 ? 600 : iss
        return new SPCDate().time >= value
    })
    if (latestIssuance)
        if (fallback)
            return findIssuance(issuances.filter(i => i !== latestIssuance), false)
        else
            timestamp = new SPCDate()
    else {
        timestamp = new SPCDate(true)
        latestIssuance = issuances[0]
    }
    return { timestamp, latestIssuance: padZeroes(latestIssuance, 4) }
}
