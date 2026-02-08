import centralTimeZoneOffset from "./centralTimeZoneOffset";

export default function centralTimeToUTC(time: number): number {
    return time - (centralTimeZoneOffset() / 36)
}
