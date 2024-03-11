import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.http.server.configuration.address = .hostname(nil, port: 8081)
    app.http.server.configuration.responseCompression = .enabled
    
    // register routes
    try routes(app)
}
