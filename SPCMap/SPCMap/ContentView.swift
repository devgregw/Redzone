//
//  ContentView.swift
//  SPC
//
//  Created by Greg Whatley on 3/15/23.
//

import CoreLocation
import MapKit
import SwiftUI
import SPCCommon

struct ContentView: View {
    @EnvironmentObject private var outlookService: NewOutlookService
    
    @State private var userLocation: MKUserLocation = .init()
    @State private var selectedOutlookType = "Categorical"
    @State private var timeFrame = 1
    @State private var tappedOutlook: Outlook? = nil
    @State private var mapConfig: OutlookMapView.Configuration = .standard
    
    @State private var displaySettings: Bool = false
    
    private let locationManager: CLLocationManager = .init()
    
    private var isLoading: Bool {
        outlookService.response.isNil
    }
    
    var selectedOutlooks: [Outlook]? {
        switch selectedOutlookType {
        case "Wind": return outlookService.response?.wind
        case "Hail": return outlookService.response?.hail
        case "Tornado": return outlookService.response?.tornado
        case "Probabilistic": return outlookService.response?.prob
        case "Sig. Prob.": return outlookService.response?.sigprob
        default: return outlookService.response?.categorical
        }
    }
    
    var highestRisk: Outlook? {
        selectedOutlooks?
            .filterNot(by: \.isSignificant)
            .sorted()
            .first { outlook in
                outlook
                    .polygons
                    .lazy
                    .map(MKPolygon.init(coordinates:))
                    .contains {
                        $0.contains(point: .init(userLocation.coordinate))
                    }
            }
    }
    
    var isSignificant: Bool {
        selectedOutlooks?
            .first(where: \.isSignificant)?
            .polygons
            .lazy
            .map(MKPolygon.init(coordinates:))
            .contains {
                $0.contains(point: .init(userLocation.coordinate))
            }
        ?? false
    }
    
    @ViewBuilder private var buttonBar: some View {
        if locationManager.authorizationStatus != .authorizedWhenInUse {
            Button {
                locationManager.requestWhenInUseAuthorization()
            } label: {
                Image(systemName: "location")
                    .padding(12)
                    .imageScale(.large)
            }
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    var body: some View {
        NavigationStack {
            OutlookMapView(outlooks: selectedOutlooks, userLocation: $userLocation, tappedOutlook: $tappedOutlook, selectedConfiguration: $mapConfig)
                .edgesIgnoringSafeArea(.vertical)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .loading(if: isLoading)
                .animation(.easeInOut.speed(1.25), value: isLoading)
        }
        .onChange(of: timeFrame, perform: { tf in
            self.selectedOutlookType = "Categorical"
            outlookService.loadTask(rawSelection: tf)
        })
        .task {
            await outlookService.load(rawSelection: timeFrame)
        }
        .toolbar {
            BottomToolbar(highestRisk: highestRisk, isSignificant: isSignificant, timeFrame: $timeFrame, selectedOutlookType: $selectedOutlookType)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(OutlookService())
    }
}
