//
//  GeoJSONPolygon.swift
//  SPCMap
//
//  Created by Greg Whatley on 8/25/24.
//

import CoreLocation
import GeoJSON
import MapKit

extension GeoJSONPolygon {
    func contains(point: CLLocationCoordinate2D) -> Bool {
        let vertices = exterior
        let count = exterior.count
        var isInsidePolygon = false

        vertices.enumerated().forEach { (idx, vertex) in
            let nextVertex = vertices[(idx + 1) % count]

            // The vertices of the edge we are checking.
            let xp0 = vertex.latitude
            let yp0 = vertex.longitude
            let xp1 = nextVertex.latitude
            let yp1 = nextVertex.longitude

            if ((yp0 <= point.longitude) && (yp1 > point.longitude) || (yp1 <= point.longitude) && (yp0 > point.longitude))
            {
                // If so, get the point where it crosses that line. This is a simple solution
                // to a linear equation. Note that we can't get a division by zero here -
                // if yp1 == yp0 then the above if be false.
                let cross = (xp1 - xp0) * (point.longitude - yp0) / (yp1 - yp0) + xp0

                // Finally check if it crosses to the left of our test point. You could equally
                // do right and it should give the same result.
                if cross < point.longitude {
                    isInsidePolygon.toggle()
                }
            }
        }

        return isInsidePolygon
    }
}

extension Sequence where Element == GeoJSONPolygon {
    func contains(point: CLLocationCoordinate2D) -> Bool {
        contains {
            $0.contains(point: point)
        }
    }
    
    var boundingBox: MKMapRect? {
        let exteriorPolygons = flatMap(\.exterior)
        let latitudes = exteriorPolygons.map(\.latitude)
        let longitudes = exteriorPolygons.map(\.longitude)
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
