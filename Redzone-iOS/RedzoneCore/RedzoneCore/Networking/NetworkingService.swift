//
//  NetworkingService.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 9/19/25.
//

public protocol NetworkingService: Sendable {
    var adapter: RequestAdapter { get }
}
