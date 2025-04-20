import Vapor
import Dispatch
import Logging

/// This extension is temporary and can be removed once Vapor gets this support.
private extension Vapor.Application {
    static let baseExecutionQueue = DispatchQueue(label: "az101d-spc.cloud.gregwhatley.dev")
    
    func runFromAsyncMainEntrypoint() async throws {
        try await withCheckedThrowingContinuation { continuation in
            Vapor.Application.baseExecutionQueue.async { [self] in
                do {
                    try self.run()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

@main
enum Entrypoint {
    static func main() async throws {
        let env = try Environment.detect()
        let terminal = Terminal()
        LoggingSystem.bootstrap(console: terminal)
        
        let app = try await Application.make(env)
        
        try await configure(app)
        try await app.runFromAsyncMainEntrypoint()
        try await app.asyncShutdown()
    }
}
