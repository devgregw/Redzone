//
//  AnyResponse.swift
//
//
//  Created by Greg Whatley on 6/29/23.
//

import Foundation
import Vapor

struct AnyResponse: AsyncResponseEncodable {
    func encodeResponse(for request: Request) async throws -> Response {
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: contentType)
        return .init(status: .ok, headers: headers, body: .init(data: data))
    }
    
    let data: Data
    let contentType: String
}
