import centralTimeZoneOffset from "./centralTimeZoneOffset"

export abstract class ConvectiveOutlook {
    protected issuances: number[]

    constructor(issuances: number[]) {
        this.issuances = issuances
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

    constructor(subtype: ConvectiveOutlookSubtype) {
        super([2000, 1630, 1300, 1200, 100])
        this.subtype = subtype
    }

    get path(): string {
        const { timestamp, latestIssuance } = findIssuance(this.issuances)
        return `products/outlook/archive/${timestamp.year}/day1otlk_${timestamp.date}_${latestIssuance}_${this.subtype}`
    }
}

function centralTimeToUTC(time: number): number {
    return time - (centralTimeZoneOffset() / 36)
}

class Day2ConvectiveOutlook extends ConvectiveOutlook {
    subtype: ConvectiveOutlookSubtype

    constructor(subtype: ConvectiveOutlookSubtype) {
        super([1730, centralTimeToUTC(100)])
        this.subtype = subtype
    }

    get path(): string {
        const { timestamp, latestIssuance } = findIssuance(this.issuances)
        return `products/outlook/archive/${timestamp.year}/day2otlk_${timestamp.date}_${latestIssuance}_${this.subtype}`
    }
}

class Day3ConvectiveOutlook extends ConvectiveOutlook {
    subtype: ConvectiveOutlookSubtype

    constructor(subtype: ConvectiveOutlookSubtype) {
        super([1930, centralTimeToUTC(230)])
        this.subtype = subtype
    }

    get path(): string {
        const { timestamp, latestIssuance } = findIssuance(this.issuances)
        return `products/outlook/archive/${timestamp.year}/day3otlk_${timestamp.date}_${latestIssuance}_${this.subtype}`
    }
}

class FutureProbabilisticOutlook extends ConvectiveOutlook {
    day: number

    constructor(day: number) {
        super([centralTimeToUTC(400)])
        this.day = day
    }

    get path(): string {
        const { date, year } = findIssuance(this.issuances).timestamp
        return `products/exper/day4-8/archive/${year}/day${this.day}prob_${date}`
    }
}

function findIssuance(issuances: number[]): { timestamp: SPCDate, latestIssuance: string } {
    let timestamp: SPCDate
    let latestIssuance: number | undefined = issuances.find(iss => {
        const value = iss === 1200 ? 600 : iss
        return new SPCDate().time >= value
    })
    if (latestIssuance)
        timestamp = new SPCDate()
    else {
        timestamp = new SPCDate(true)
        latestIssuance = issuances[0]
    }
    return { timestamp, latestIssuance: padZeroes(latestIssuance, 4) }
}

export class ConvectiveOutlookFactory {
    static createOutlook(day: number, subtype: ConvectiveOutlookSubtype): ConvectiveOutlook {
        switch (day) {
            case 1:
                if (subtype === ConvectiveOutlookSubtype.probabilistic)
                    throw 'Invalid subtype'
                return new Day1ConvectiveOutlook(subtype)
            case 2:
                if (subtype === ConvectiveOutlookSubtype.probabilistic)
                    throw 'Invalid subtype'
                return new Day2ConvectiveOutlook(subtype)
            case 3:
                if (subtype !== ConvectiveOutlookSubtype.categorical && subtype !== ConvectiveOutlookSubtype.probabilistic)
                    throw 'Invalid subtype'
                return new Day3ConvectiveOutlook(subtype)
            case 4: case 5: case 6: case 7: case 8:
                if (subtype !== ConvectiveOutlookSubtype.probabilistic)
                    throw 'Invalid subtype'
                return new FutureProbabilisticOutlook(day)
            default: throw 'Day must be between 1-8'
        }
    }
}
