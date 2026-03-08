import centralTimeToUTC from "./centralTimeToUTC"
import { findIssuance, Issuance } from "./Issuance"

export abstract class FireOutlook {
    protected issuances: Issuance[]
    protected fallback: boolean

    constructor(issuances: Issuance[], fallback: boolean) {
        this.issuances = issuances
        this.fallback = fallback
    }
    
    abstract get paths(): [string, string]
    get urls(): [URL, URL] {
        return this.paths.map(p => new URL(`/${p}.lyr.geojson`, baseURL)) as [URL, URL]
    }

    get cachePath(): string {
        const { year, date, issuance } = findIssuance(this.issuances, this.fallback)
        return `products/fire_wx/${year}/day1fw_${date}_${issuance}`
    }
}

class Day1FireOutlook extends FireOutlook {
    constructor(fallback: boolean) {
        super([1700, 1200], fallback)
    }

    get paths(): [string, string] {
        const { year, date, issuance } = findIssuance(this.issuances, this.fallback)
        return [
            `products/fire_wx/${year}/day1fw_${date}_${issuance}_windrh`,
            `products/fire_wx/${year}/day1fw_${date}_${issuance}_dryt`
        ]
    }
}

class Day2FireOutlook extends FireOutlook {
    constructor(fallback: boolean) {
        super([2000, 1200], fallback)
    }

    get paths(): [string, string] {
        const { year, date, issuance } = findIssuance(this.issuances, this.fallback)
        return [
            `products/fire_wx/${year}/day2fw_${date}_${issuance}_windrh`,
            `products/fire_wx/${year}/day2fw_${date}_${issuance}_dryt`
        ]
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
