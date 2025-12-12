//
//  GeoJSONPolygon.swift
//  Redzone
//
//  Created by Greg Whatley on 8/25/24.
//

import CoreLocation
import GeoJSON
import MapKit

extension GeoJSONPolygon {
    func contains(point: CLLocationCoordinate2D) -> Bool {
        exterior.positions.dropLast().enumerated().reduce(into: false) { isInside, item in
            let nextVertex = exterior.positions[item.offset + 1]
            let x1 = item.element.latitude
            let y1 = item.element.longitude
            let x2 = nextVertex.latitude
            let y2 = nextVertex.longitude
            
            if ((y1 > point.longitude) != (y2 > point.longitude)),
               (point.latitude < (x2 - x1) * (point.longitude - y1) / (y2 - y1) + x1) {
                isInside.toggle()
            }
        }
    }
}

extension Sequence where Element == GeoJSONPolygon {
    func contains(point: CLLocationCoordinate2D) -> Bool {
        contains {
            $0.contains(point: point)
        }
    }
    
    var boundingBox: MKMapRect? {
        let exteriorPolygons = compactMap(\.exterior)
        let latitudes = exteriorPolygons.flatMap { $0.positions.map(\.latitude) }
        let longitudes = exteriorPolygons.flatMap { $0.positions.map(\.longitude) }
        guard let minX = latitudes.min(),
              let maxX = latitudes.max(),
              let minY = longitudes.min(),
              let maxY = longitudes.max() else {
            return nil
        }
        let maxPoint = MKMapPoint(.init(latitude: maxX, longitude: maxY))
        let minPoint = MKMapPoint(.init(latitude: minX, longitude: minY))
        let width = abs(minPoint.x - maxPoint.x)
        let height = abs(minPoint.y - maxPoint.y)
        return MKMapRect(origin: .init(x: minPoint.x, y: maxPoint.y), size: .init(width: width, height: height))
    }
}
