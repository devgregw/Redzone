//
//  OutlookService.swift
//  SPC
//
//  Created by Greg Whatley on 4/2/23.
//

import CoreLocation
import SwiftUI
import SPCCommon

class OutlookService: ObservableObject {
    private let hostname = "http://192.168.100.9:3000"
    
    @Published var response: OutlookResponse?
    
    private func load(url: URL) async {
        do {
            let response: OutlookResponse? = try await URLSession(configuration: .default).decodingJSON(from: url)
            
            await MainActor.run {
                self.response = response
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load(rawSelection: Int) async {
        if let url = URL(string: "\(hostname)/day\(rawSelection)") {
            await MainActor.run {
                self.response = nil
            }
            await self.load(url: url)
        } else {
            print("Invalid selection specified")
        }
    }
    
    func loadTask(rawSelection: Int) {
        Task {
            await load(rawSelection: rawSelection)
        }
    }
}
