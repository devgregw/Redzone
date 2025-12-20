//
//  Mocks.swift
//  RedzoneCoreTests
//
//  Created by Greg Whatley on 10/2/25.
//

import Foundation
import Testing

@dynamicMemberLookup enum Mocks {
    @dynamicMemberLookup struct Entry {
        fileprivate let name: String

        subscript(dynamicMember member: String) -> Self {
            .init(name: name + "." + member)
        }
    }

    static subscript(dynamicMember member: String) -> Entry {
        .init(name: member)
    }
}

extension Data {
    init(contentsOf mockEntry: Mocks.Entry) throws {
        let bundle = try #require(Bundle(identifier: "dev.gregwhatley.redzone.RedzoneCoreTests"))
        let url = try #require(bundle.url(forResource: mockEntry.name, withExtension: nil))
        self = try Data(contentsOf: url)
    }
}
