import { NextResponse } from "next/server";

export function GET() {
    return NextResponse.redirect('https://github.com/devgregw/Redzone/blob/main/README.md')
}
