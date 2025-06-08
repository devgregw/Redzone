import centralTimeZoneOffset from "./centralTimeZoneOffset"

export abstract class ConvectiveOutlook {
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

function padZeroes(input: { toString(): string }, maxLength: number): string {
    return input.toString().padStart(maxLength, "0")
}

class SPCDate {
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

const baseURL = new URL('https://www.spc.noaa.gov')

class Day1ConvectiveOutlook extends ConvectiveOutlook {
    subtype: ConvectiveOutlookSubtype

    constructor(subtype: ConvectiveOutlookSubtype, fallback: boolean) {
        super([2000, 1630, 1300, 1200, 100], fallback)
        this.subtype = subtype
    }

    get path(): string {
        const { timestamp, latestIssuance } = findIssuance(this.issuances, this.fallback)
        return `products/outlook/archive/${timestamp.year}/day1otlk_${timestamp.date}_${latestIssuance}_${this.subtype}`
    }
}

function centralTimeToUTC(time: number): number {
    return time - (centralTimeZoneOffset() / 36)
}

class Day2ConvectiveOutlook extends ConvectiveOutlook {
    subtype: ConvectiveOutlookSubtype

    constructor(subtype: ConvectiveOutlookSubtype, fallback: boolean) {
        super([1730, centralTimeToUTC(100)], fallback)
        this.subtype = subtype
    }

    get path(): string {
        const { timestamp, latestIssuance } = findIssuance(this.issuances, this.fallback)
        return `products/outlook/archive/${timestamp.year}/day2otlk_${timestamp.date}_${latestIssuance}_${this.subtype}`
    }
}

class Day3ConvectiveOutlook extends ConvectiveOutlook {
    subtype: ConvectiveOutlookSubtype

    constructor(subtype: ConvectiveOutlookSubtype, fallback: boolean) {
        super([1930, centralTimeToUTC(230)], fallback)
        this.subtype = subtype
    }

    get path(): string {
        const { timestamp, latestIssuance } = findIssuance(this.issuances, this.fallback)
        return `products/outlook/archive/${timestamp.year}/day3otlk_${timestamp.date}_${latestIssuance}_${this.subtype}`
    }
}

class FutureProbabilisticOutlook extends ConvectiveOutlook {
    day: number

    constructor(day: number, fallback: boolean) {
        super([centralTimeToUTC(400)], fallback)
        this.day = day
    }

    get path(): string {
        const { date, year } = findIssuance(this.issuances, this.fallback).timestamp
        return `products/exper/day4-8/archive/${year}/day${this.day}prob_${date}`
    }
}

function findIssuance(issuances: number[], fallback: boolean): { timestamp: SPCDate, latestIssuance: string } {
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
