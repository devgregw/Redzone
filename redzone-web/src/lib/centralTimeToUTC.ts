import centralTimeZoneOffset from "./centralTimeZoneOffset";

export default function centralTimeToUTC(time: number, tz?: string): number {
    return time - (centralTimeZoneOffset(tz) / 36)
}
