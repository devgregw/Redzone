import { Issuance, findIssuance } from "@/lib/Issuance";

describe('Issuance', () => {
    it('finds the latest issuance today', () => {
        // Reference date: 2024-06-01T18:00:00Z
        const referenceDate = new Date(Date.UTC(2024, 5, 1, 18, 0))
        const issuances: Issuance[] = [800, 1200, 1600, 2000]
        const result = findIssuance(issuances, false, referenceDate)
        // The latest issuance as of 18:00 UTC should be 1600.
        expect(result).toStrictEqual({
            year: 2024,
            date: '20240601',
            issuance: "1600"
        })
    })

    it('finds the latest issuance today (fallback)', () => {
        // Reference date: 2024-06-01T18:00:00Z
        const referenceDate = new Date(Date.UTC(2024, 5, 1, 18, 0))
        const issuances: Issuance[] = [800, 1200, 1600, 2000]
        const result = findIssuance(issuances, true, referenceDate)
        // Falling back should return the next latest issuance.
        expect(result).toStrictEqual({
            year: 2024,
            date: '20240601',
            issuance: "1200"
        })
    })

    it('finds the latest issuance yesterday', () => {
        // Reference date: 2024-06-01T00:00:00Z
        const referenceDate = new Date(Date.UTC(2024, 5, 1, 0, 0))
        const issuances: Issuance[] = [800, 1200, 1600, 2000]
        const result = findIssuance(issuances, false, referenceDate)
        // If no issuance has occurred today, it should return the latest
        // issuance from yesterday.
        expect(result).toStrictEqual({
            year: 2024,
            date: '20240531',
            issuance: "2000"
        })
    })

    it('finds the latest issuance yesterday (fallback)', () => {
        // Reference date: 2024-06-01T08:00:00Z
        const referenceDate = new Date(Date.UTC(2024, 5, 1, 8, 0))
        const issuances: Issuance[] = [800, 1200, 1600, 2000]
        const result = findIssuance(issuances, true, referenceDate)
        // If no issuance has occurred today, it should return the latest
        // issuance from yesterday.
        expect(result).toStrictEqual({
            year: 2024,
            date: '20240531',
            issuance: "2000"
        })
    })
})
