export default function centralTimeZoneOffset(): number {
    const str = new Date().toLocaleString('en', { timeZone: 'America/Chicago', timeZoneName: 'longOffset' })
    const match = str.match(/([+-]\d+):(\d+)$/)

    if (match) {
        const [, h, m] = match;
        return (parseInt(h, 10) * 60 + (h[0] === '+' ? parseInt(m, 10) : -parseInt(m, 10))) * 60
    } else {
        return 0 // Default to 0 if no offset is found
    }
}
