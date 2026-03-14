import centralTimeToUTC from "@/lib/centralTimeToUTC"

describe('centralTimeToUTC', () => {
    it('converts CST to UTC', () => {
        expect(centralTimeToUTC(0, '-06:00')).toBe(600)
        expect(centralTimeToUTC(200, '-06:00')).toBe(800)
        expect(centralTimeToUTC(1100, '-06:00')).toBe(1700)
    })

    it('converts CDT to UTC', () => {
        expect(centralTimeToUTC(0, '-05:00')).toBe(500)
        expect(centralTimeToUTC(200, '-05:00')).toBe(700)
        expect(centralTimeToUTC(1100, '-05:00')).toBe(1600)
    })
})
