//
//  LabelledLink.swift
//  Redzone
//
//  Created by Greg Whatley on 4/18/25.
//

import SwiftUI

struct LabelledLink: View {
    let title: String
    let image: Image
    let destination: URL?
    
    init(_ title: String, destination: String, image: String) {
        self.title = title
        self.image = Image(image, bundle: .main).resizable()
        self.destination = URL(string: destination)
    }
    
    init(_ title: String, destination: String, systemImage: String) {
        self.title = title
        self.image = .init(systemName: systemImage)
        self.destination = URL(string: destination)
    }
    
    var body: some View {
        if let destination {
            Link(destination: destination) {
                Label {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(title)
                                .foregroundStyle(Color(.label))
                            if let host = destination.host()?.trimmingPrefix("www.") {
                                Text(host)
                                    .font(.caption)
                                    .foregroundStyle(Color(.secondaryLabel))
                            }
                        }
                        Spacer()
                        Image(systemName: "arrow.up.forward.square")
                    }
                } icon: {
                    image
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 40, maxHeight: 40)
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
