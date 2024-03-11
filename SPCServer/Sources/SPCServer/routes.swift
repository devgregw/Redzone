import Foundation
import Vapor

fileprivate func buildRequestHandler(_ outlook: OutlookType) -> (Request) async throws -> AnyResponse {
    { req async throws in
        let data: Data
        if let cached = await OutlookCache.shared.data(for: outlook) {
            req.logger.info("Cache hit: \(cached.count) bytes")
            data = cached
        } else {
            req.logger.info("Cache miss: scraping...")
            let geojson = try await Scraper.scrapeGeoJSONURL(outlook: outlook)
            req.logger.info("Scraped GeoJSON URL: \(geojson)")
            data = try await URLSessionAdapter.shared.data(from: geojson).0
            req.logger.info("Received \(data.count) bytes")
            await OutlookCache.shared.set(data: data, for: outlook)
        }
        
        return AnyResponse(data: data, contentType: "application/geo+json")
    }
}

func routes(_ app: Application) throws {
    app.get("convective", "1", "cat", use: buildRequestHandler(.convective1(.categorical)))
    app.get("convective", "1", "wind", use: buildRequestHandler(.convective1(.wind)))
    app.get("convective", "1", "hail", use: buildRequestHandler(.convective1(.hail)))
    app.get("convective", "1", "torn", use: buildRequestHandler(.convective1(.tornado)))
    
    app.get("convective", "2", "cat", use: buildRequestHandler(.convective2(.categorical)))
    app.get("convective", "2", "wind", use: buildRequestHandler(.convective2(.wind)))
    app.get("convective", "2", "hail", use: buildRequestHandler(.convective2(.hail)))
    app.get("convective", "2", "torn", use: buildRequestHandler(.convective2(.tornado)))
    
    app.get("convective", "3", "cat", use: buildRequestHandler(.convective3(probabilistic: false)))
    app.get("convective", "3", "prob", use: buildRequestHandler(.convective3(probabilistic: true)))
    
    app.get("convective", "4", use: buildRequestHandler(.convective4))
    app.get("convective", "5", use: buildRequestHandler(.convective5))
    app.get("convective", "6", use: buildRequestHandler(.convective6))
    app.get("convective", "7", use: buildRequestHandler(.convective7))
    app.get("convective", "8", use: buildRequestHandler(.convective8))
}
