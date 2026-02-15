import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Redzone",
  description: "SPC outlooks at a glance.",
  icons: {
    shortcut: '/favicon.ico',
    apple: { sizes: "180x180", url: "/apple-touch-icon.png" },
    other: [
      { sizes: "32x32", url: "/favicon-32x32.png" },
      { sizes: "16x16", url: "/favicon-16x16.png" }
    ]
  },
  manifest: '/manifest.json'
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
