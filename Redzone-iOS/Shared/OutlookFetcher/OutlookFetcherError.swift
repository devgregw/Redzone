//
//  OutlookFetcherError.swift
//  Redzone
//
//  Created by Greg Whatley on 4/6/24.
//

import Foundation

enum OutlookFetcherError: Error {
    case noData
    case networkError(cause: Error)
    case unknown(message: String)
}
