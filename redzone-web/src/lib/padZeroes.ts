export default function padZeroes(input: { toString(): string }, maxLength: number): string {
    return input.toString().padStart(maxLength, "0")
}
