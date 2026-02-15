import centralTimeToUTC from "./centralTimeToUTC"
import { findIssuance } from "./Issuance"

export abstract class FireOutlook {
    protected issuances: number[]
    protected fallback: boolean

    constructor(issuances: number[], fallback: boolean) {
        this.issuances = issuances
        this.fallback = fallback
    }
    
    abstract get path(): string
    get url(): URL {
        return new URL(`/${this.path}.lyr.geojson`, baseURL)
    }
}

class Day1FireOutlook extends FireOutlook {
    constructor(fallback: boolean) {
        super([1700, 1200], fallback)
    }

    get path(): string {
        const { timestamp, latestIssuance } = findIssuance(this.issuances, this.fallback)
        return `products/fire_wx/${timestamp.year}/day1fw_${timestamp.date}_${latestIssuance}_windrh`
    }
}

class Day2FireOutlook extends FireOutlook {
    constructor(fallback: boolean) {
        super([2000, 1200], fallback)
    }

    get path(): string {
        const { timestamp, latestIssuance } = findIssuance(this.issuances, this.fallback)
        return `products/fire_wx/${timestamp.year}/day2fw_${timestamp.date}_${latestIssuance}_windrh`
    }
}

const baseURL = new URL('https://www.spc.noaa.gov')

export class FireOutlookFactory {
    static createOutlook(day: number, fallback: boolean): FireOutlook {
        switch (day) {
            case 1: return new Day1FireOutlook(fallback)
            case 2: return new Day2FireOutlook(fallback)
            default: throw 'Day must be 1 or 2'
        }
    }
}
