//
//  ApplicationContextManager.swift
//  RedzoneCore
//
//  Created by Greg Whatley on 12/19/25.
//

import Combine
import OSLog
import SwiftUI
import WatchConnectivity

// MARK: - ApplicationContextManager implementation

@MainActor final class ApplicationContextManager: NSObject {
    nonisolated private static let logger: Logger = .create()
    static let shared = ApplicationContextManager()
    private let subject: CurrentValueSubject<PropertyList, Never> = .init([:])
    private var pendingContext: PropertyList?

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            Self.logger.debug("Activating WCSession...")
            WCSession.default.activate()
        } else {
            Self.logger.warning("WCSession is not supported.")
        }
    }

    // MARK: - Main interface

    /// Sets the given key/value pair in the application context and enqueues
    /// the transfer to the paired companion device.
    func updateContext<T: AtomicPropertyListValue>(key: String, value: T) {
        updateContext(plist: [key: value, "date": Date()])
    }

    // swiftlint:disable:next orphaned_doc_comment
    /// A publisher that fires values that match the given type for the given application context key.
    // periphery:ignore:parameters type - type argument is required for type inference
    func publisher<T: AtomicPropertyListValue>(for key: String, type: T.Type = T.self) -> AnyPublisher<T, Never> {
        subject.compactMap { $0[key] as? T }.eraseToAnyPublisher()
    }

    // MARK: - Private helpers

    /// Transfers the given property list context data to the paired companion device.
    /// If the Watch Connectivity session is not yet active or the transer fails,
    /// the data will be saved for a future attempt (when session is active and companion
    /// device becomes reachable).
    private func updateContext(plist: PropertyList) {
        guard WCSession.default.activationState == .activated else {
            Self.logger.warning("Application context updated before the session was activated.")
            pendingContext = merge(pendingContext ?? [:], plist)
            return
        }
        do {
            let merged = mergeWithSubject(plist: plist)
            subject.send(merged)
            try WCSession.default.updateApplicationContext(merged)
        } catch {
            Self.logger.error("Failed to send app context: \(error.localizedDescription)")
            pendingContext = merge(pendingContext ?? [:], plist)
        }
    }

    /// Merges the given property list data into the current subject's data.
    private func mergeWithSubject(plist: PropertyList) -> PropertyList {
        merge(subject.value, plist)
    }

    /// Attempts to transfer a previously failed context if needed.
    private func processPendingContextIfNeeded() {
        guard let pendingContext else { return }
        Self.logger.info("Processing pending context: \(pendingContext.debugDescription).")
        self.pendingContext = nil
        updateContext(plist: pendingContext)
    }

    /// Combines two property list dictionaries, keeping the values of the second
    /// for duplicate keys.
    nonisolated private func merge(_ first: PropertyList, _ second: PropertyList) -> PropertyList {
        first.merging(second) { _, new in new }
    }
}

// MARK: - WCSessionDelegate implementation
// The WCSessionDelegate implementation is nonisolated because delegate callbacks
// may be called on a background thread.
nonisolated extension ApplicationContextManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        Self.logger.debug("activationDidCompleteWith state: \(String(describing: activationState)).")
        if let error {
            Self.logger.error("activationDidCompleteWith error: \(error.localizedDescription)")
        }
        guard activationState == .activated else { return }

        // Send the current context to the publisher and process any pending context changes.
        let applicationContext = session.receivedApplicationContext.coercedToPropertyList()
        DispatchQueue.main.async { [weak self] in
            guard let merged = self?.mergeWithSubject(plist: applicationContext) else { return }
            self?.subject.send(merged)
            self?.processPendingContextIfNeeded()
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        Self.logger.debug("sessionReachabilityDidChange: \(session.isReachable).")
        if session.isReachable {
            // If the session is reachable now, check for and process any pending context changes.
            DispatchQueue.main.async { [weak self] in
                self?.processPendingContextIfNeeded()
            }
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        Self.logger.debug("didReceiveApplicationContext: \(applicationContext.debugDescription).")
        let context = applicationContext.coercedToPropertyList()

        // Update the publisher with the merged context.
        DispatchQueue.main.async { [weak self] in
            guard let merged = self?.mergeWithSubject(plist: context) else { return }
            self?.subject.send(merged)
        }
    }

    // MARK: - Required but unused protocol requirements

#if !os(watchOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        Self.logger.debug("sessionDidBecomeInactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        Self.logger.debug("sessionDidDeactivate")
    }
#endif
}
