import centralTimeToUTC from "./centralTimeToUTC"
import { findIssuance, Issuance } from "./Issuance"

export abstract class ConvectiveOutlook {
    protected issuances: Issuance[]
    protected fallback: boolean

    constructor(issuances: Issuance[], fallback: boolean) {
        this.issuances = issuances
        this.fallback = fallback
    }
    
    abstract get path(): string
    get url(): URL {
        return new URL(`/${this.path}.lyr.geojson`, baseURL)
    }
}

export enum ConvectiveOutlookSubtype {
    categorical = "cat",
    wind = "wind",
    hail = "hail",
    tornado = "torn",
    probabilistic = "prob"
}

export function subtypeFromString(str: string): ConvectiveOutlookSubtype {
    const value: ConvectiveOutlookSubtype | undefined = ({
        'cat': ConvectiveOutlookSubtype.categorical,
        'wind': ConvectiveOutlookSubtype.wind,
        'hail': ConvectiveOutlookSubtype.hail,
        'torn': ConvectiveOutlookSubtype.tornado,
        'prob': ConvectiveOutlookSubtype.probabilistic
    } as Record<string, ConvectiveOutlookSubtype>)[str]
    if (value) return value
    else throw 'Invalid sub type ' + str
}

const baseURL = new URL('https://www.spc.noaa.gov')

class Day1ConvectiveOutlook extends ConvectiveOutlook {
    subtype: ConvectiveOutlookSubtype

    constructor(subtype: ConvectiveOutlookSubtype, fallback: boolean) {
        super([2000, 1630, 1300, {iss: 1200, comparison: 600}, 100], fallback)
        this.subtype = subtype
    }

    get path(): string {
        const { year, date, issuance } = findIssuance(this.issuances, this.fallback)
        return `products/outlook/archive/${year}/day1otlk_${date}_${issuance}_${this.subtype}`
    }
}

class Day2ConvectiveOutlook extends ConvectiveOutlook {
    subtype: ConvectiveOutlookSubtype

    constructor(subtype: ConvectiveOutlookSubtype, fallback: boolean) {
        super([1730, centralTimeToUTC(100)], fallback)
        this.subtype = subtype
    }

    get path(): string {
        const { year, date, issuance } = findIssuance(this.issuances, this.fallback)
        return `products/outlook/archive/${year}/day2otlk_${date}_${issuance}_${this.subtype}`
    }
}

class Day3ConvectiveOutlook extends ConvectiveOutlook {
    subtype: ConvectiveOutlookSubtype

    constructor(subtype: ConvectiveOutlookSubtype, fallback: boolean) {
        super([1930, centralTimeToUTC(230)], fallback)
        this.subtype = subtype
    }

    get path(): string {
        const { year, date, issuance } = findIssuance(this.issuances, this.fallback)
        return `products/outlook/archive/${year}/day3otlk_${date}_${issuance}_${this.subtype}`
    }
}

class FutureProbabilisticOutlook extends ConvectiveOutlook {
    day: number

    constructor(day: number, fallback: boolean) {
        super([centralTimeToUTC(400)], fallback)
        this.day = day
    }

    get path(): string {
        const { year, date } = findIssuance(this.issuances, this.fallback)
        return `products/exper/day4-8/archive/${year}/day${this.day}prob_${date}`
    }
}

export class ConvectiveOutlookFactory {
    static createOutlook(day: number, subtype: ConvectiveOutlookSubtype, fallback: boolean): ConvectiveOutlook {
        switch (day) {
            case 1:
                if (subtype === ConvectiveOutlookSubtype.probabilistic)
                    throw 'Invalid subtype'
                return new Day1ConvectiveOutlook(subtype, fallback)
            case 2:
                if (subtype === ConvectiveOutlookSubtype.probabilistic)
                    throw 'Invalid subtype'
                return new Day2ConvectiveOutlook(subtype, fallback)
            case 3:
                if (subtype !== ConvectiveOutlookSubtype.categorical && subtype !== ConvectiveOutlookSubtype.probabilistic)
                    throw 'Invalid subtype'
                return new Day3ConvectiveOutlook(subtype, fallback)
            case 4: case 5: case 6: case 7: case 8:
                if (subtype !== ConvectiveOutlookSubtype.probabilistic)
                    throw 'Invalid subtype'
                return new FutureProbabilisticOutlook(day, fallback)
            default: throw 'Day must be between 1-8'
        }
    }
}
