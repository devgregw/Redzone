import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.http.server.configuration.address = .hostname(nil, port: 8081)
    app.http.server.configuration.responseCompression = .enabled
    
    do {
        app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
            certificateChain: try NIOSSLCertificate.fromPEMFile("/cert/chain.pem").map { .certificate($0) },
            privateKey: .file("/cert/privkey.pem")
        )
        app.logger.info("SSL configuration successful")
    } catch {
        app.logger.error("SSL configuration failed: \(error.localizedDescription)")
    }
    
    // register routes
    try routes(app)
}
