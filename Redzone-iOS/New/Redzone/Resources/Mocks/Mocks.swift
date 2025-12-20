//
//  Mocks.swift
//  Redzone
//
//  Created by Greg Whatley on 10/2/25.
//

#if DEBUG
import Foundation
import OSLog
import RedzoneCore

fileprivate let logger: Logger = .create()

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
    init(contentsOf mockEntry: Mocks.Entry) {
        guard let url = Bundle.main.url(forResource: mockEntry.name, withExtension: nil) else {
            logger.error("URL for mock resource '\(mockEntry.name)' not found.")
            self = Data()
            return
        }
        do {
            self = try Data(contentsOf: url)
        } catch {
            logger.error("Failed to retrieve data for mock resource '\(mockEntry.name)': \(error.localizedDescription)")
            debugPrint(error)
            self =  Data()
        }
    }
}
#endif
