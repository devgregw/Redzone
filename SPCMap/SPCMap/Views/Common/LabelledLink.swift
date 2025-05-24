//
//  LabelledLink.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/18/25.
//

import SwiftUI

struct LabelledLink: View {
    let title: String
    let systemImage: String
    let destination: URL?
    
    init(_ title: String, destination: URL?, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
        self.destination = destination
    }
    
    init(_ title: String, destination: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
        self.destination = URL(string: destination)
    }
    
    var body: some View {
        if let destination {
            Link(destination: destination) {
                Label {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(title)
                            if let host = destination.host()?.trimmingPrefix("www.") {
                                Text(host)
                                    .font(.caption)
                            }
                        }
                        Spacer()
                        Image(systemName: "arrow.up.forward.square")
                    }
                } icon: {
                    Image(systemName: systemImage)
                }
            }
        }
        #if DEBUG
        if destination == nil {
            Text("Invalid URL!")
                .bold()
                .foregroundStyle(.red)
        }
        #endif
    }
}
