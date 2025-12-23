//
//  DisclaimerView.swift
//  Redzone
//
//  Created by Greg Whatley on 10/25/25.
//

import RedzoneMacros
import RedzoneUI
import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    Text(.Disclaimer.affiliation)
                    Text(.Disclaimer.use)
                    Text(.Disclaimer.liability)
                    Text(.Disclaimer.copyright)
                }

                ExternalLink(#URL("https://www.weather.gov/disclaimer"), label: "NWS Disclaimer", icon: Image(.nwsLogo))
            }

            Section("Safety") {
                Text(.Disclaimer.safety)

                ExternalLink(#URL("https://www.weather.gov/safety"), label: "Safety for All Hazards", icon: Image(.nwsLogo))
                ExternalLink(#URL("https://www.ready.gov/plan"), label: "Make a Plan", icon: Image(.readyLogo))
                ExternalLink(#URL("https://www.spc.noaa.gov/misc/about.html"), label: "SPC Products", icon: Image(.noaaLogo))
            }

            Section("Privacy") {
                VStack(alignment: .leading, spacing: 16) {
                    Text(.Disclaimer.privacy)
                    Text(.Disclaimer.privacyExternal)
                }

                ExternalLink(#URL("https://www.weather.gov/privacy"), label: "NWS Privacy Policy", icon: Image(.nwsLogo))
                ExternalLink(#URL("https://www.noaa.gov/protecting-your-privacy"), label: "Protecting Your Privacy", icon: Image(.noaaLogo))
            }
        }
        .navigationTitle("Disclaimer")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
//    DisclaimerView()
//        .toolbar {
//            ToolbarItem(placement: .bottomBar) {
//                Button("I Understand") {
//
//                }
//                .buttonStyle(.borderedProminent)
//            }
//        }

    NavigationStack {
        VStack(spacing: 16) {
            Image(.appIconGlass)
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.bottom)
                .shadow(radius: 4)
                .accessibilityHidden(true)

            Text("Welcome to Redzone")
                .font(.largeTitle.weight(.medium))

            Text("Before using Redzone, please read the following disclaimer.")
        }
        .multilineTextAlignment(.center)
        .padding()
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                NavigationLink {
                    DisclaimerView()
                        .toolbar {
                            ToolbarItem(placement: .bottomBar) {
                                Button {

                                } label: {
                                    HStack {
                                        Image(systemName: "signature")
                                        Text("I Understand")
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                } label: {
                    HStack {
                        Text("Continue")
                        Image(systemName: "arrow.forward")
                    }
                    .bold()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct FirstLaunchView: View {
    @Binding var didAcknowledgeDisclaimer: Bool
    @State private var confirmationAlert: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(.appIconGlass)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .padding(.bottom)
                    .shadow(radius: 4)
                    .accessibilityHidden(true)

                Text("Welcome to Redzone")
                    .font(.largeTitle.weight(.medium))

                Text("Before using Redzone, please read the following disclaimer.")
            }
            .multilineTextAlignment(.center)
            .padding()
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        DisclaimerView()
                            .toolbar {
                                ToolbarItem(placement: .bottomBar) {
                                    Button {
                                        confirmationAlert.toggle()
                                    } label: {
                                        HStack {
                                            Image(systemName: "signature")
                                            Text("I Understand")
                                        }
                                        .bold()
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                            .alert("Thank You", isPresented: $confirmationAlert) {
                                Button("Got it") {
                                    didAcknowledgeDisclaimer = true
                                }
                            } message: {
                                Text("Feel free to return to this screen anytime through Redzone → About → Disclaimer.")
                            }
                    } label: {
                        HStack {
                            Text("Continue")
                            Image(systemName: "arrow.forward")
                        }
                        .bold()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
