//
//  OutlookCache.swift
//
//
//  Created by Greg Whatley on 4/6/24.
//

import Foundation
import Vapor

protocol OutlookCaching: Actor {
    func get(path: String) async -> Data?
    func set(_ data: Data?, path: String) async
    func cleanup() async
}

extension OutlookCaching {
    func cleanup() async { }
}

actor OutlookCacheSwizzler: OutlookCaching {
    private static let storage: StorageCache? = .init()
    private static let memory: MemoryCache = .init()
    
    func get(path: String) async -> Data? {
        if let data = await Self.storage?.get(path: path) {
            return data
        } else {
            return await Self.memory.get(path: path)
        }
    }
    
    func set(_ data: Data?, path: String) async {
        if let storage = Self.storage {
            await storage.set(data, path: path)
        } else {
            await Self.memory.set(data, path: path)
        }
    }
}

fileprivate actor StorageCache: OutlookCaching {
    private enum StorageError: Error {
        case cacheDirectoryVerificationFailed
    }
    
    private static let path: String = "/outlook-cache"
    private let logger: Logger
    
    init?() {
        var logger = Logger(label: "StorageCache")
        #if DEBUG
        logger.logLevel = .trace
        #endif
        self.logger = logger
        do {
            var isDirectory: ObjCBool = false
            guard FileManager.default.fileExists(atPath: Self.path, isDirectory: &isDirectory),
                  isDirectory.boolValue,
                  FileManager.default.isWritableFile(atPath: Self.path) else {
                logger.warning("Failed to verify the cache directory.")
                throw StorageError.cacheDirectoryVerificationFailed
            }
            logger.debug("Storage cache verified successfully.")
        } catch {
            logger.report(error: error)
            return nil
        }
    }
    
    private func fullPath(_ relative: String) -> String {
        "\(Self.path)/\(relative)"
    }
    
    func get(path: String) -> Data? {
        do {
            let path: String = fullPath(path)
            guard FileManager.default.fileExists(atPath: path) else {
                logger.info("Storage: Cache miss for GeoJSON: \(path)")
                return nil
            }
            logger.info("Storage: Cache hit for GeoJSON: \(path)")
            return try Data(contentsOf: URL(filePath: path, directoryHint: .notDirectory))
        } catch {
            logger.report(error: error)
            return nil
        }
    }
    
    func set(_ data: Data?, path: String) {
        do {
            let path: String = fullPath(path)
            guard let data else {
                try FileManager.default.removeItem(at: URL(filePath: path, directoryHint: .notDirectory))
                return
            }
            cleanup()
            logger.info("Storage: Caching GeoJSON (\(data.count) bytes): \(path)")
            let fileURL = URL(filePath: path, directoryHint: .notDirectory)
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: fileURL)
        } catch {
            logger.report(error: error)
        }
    }
    
    private func deleteFileIfNeeded(path: String) throws {
        if let date = try FileManager.default.attributesOfItem(atPath: path)[.creationDate] as? Date,
           abs(date.timeIntervalSinceNow) >= 60 * 60 * 24 * 2 {
            logger.info("Deleting stale cache file \(path)")
            try FileManager.default.removeItem(atPath: path)
        }
    }
    
    private func cleanup(path: String) throws {
        try FileManager.default.contentsOfDirectory(atPath: path).forEach {
            let path = "\(path)/\($0)"
            if try FileManager.default.attributesOfItem(atPath: path)[.type] as? FileAttributeType == .typeDirectory {
                try cleanup(path: path)
            } else {
                try deleteFileIfNeeded(path: path)
            }
        }
    }
    
    func cleanup() {
        do {
            logger.info("Scanning for stale cache files")
            try cleanup(path: Self.path)
        } catch {
            logger.report(error: error)
        }
    }
}

fileprivate actor MemoryCache: OutlookCaching {
    init() { }
    
    private var cache: [String: (Data, Date)] = [:]
    
    private let logger: Logger = {
        var logger = Logger(label: "MemoryCache")
        #if DEBUG
        logger.logLevel = .trace
        #endif
        return logger
    }()
    
    func get(path: String) -> Data? {
        let value = cache[path]
        if value != nil {
            logger.info("Memory: Cache hit for GeoJSON: \(path)")
        }
        return value?.0
    }
    
    func set(_ data: Data?, path: String) {
        if let data {
            cleanup()
            logger.info("Memory: Caching GeoJSON (\(data.count) bytes): \(path)")
            cache[path] = (data, .now)
        } else {
            cache.removeValue(forKey: path)
        }
    }
    
    func cleanup() {
        cache
            .filter { abs($0.value.1.timeIntervalSinceNow) >= 60 * 60 * 24 * 2 }
            .forEach {
                logger.info("Memory: Removing stale cache item: \($0.key)")
                cache.removeValue(forKey: $0.key)
            }
    }
}
