//
//  MKPolygon.swift
//  SPCMap
//
//  Created by Greg Whatley on 4/2/23.
//

import MapKit

extension MKPolygon: AnyPolygon {
    func contains(point: MKMapPoint) -> Bool {
        let polygonVerticies = points()
        var isInsidePolygon = false

        for i in 0 ..< pointCount {
            let vertex = polygonVerticies[i]
            let nextVertex = polygonVerticies[(i + 1) % pointCount]

            // The vertices of the edge we are checking.
            let xp0 = vertex.x
            let yp0 = vertex.y
            let xp1 = nextVertex.x
            let yp1 = nextVertex.y

            if ((yp0 <= point.y) && (yp1 > point.y) || (yp1 <= point.y) && (yp0 > point.y))
            {
                // If so, get the point where it crosses that line. This is a simple solution
                // to a linear equation. Note that we can't get a division by zero here -
                // if yp1 == yp0 then the above if be false.
                let cross = (xp1 - xp0) * (point.y - yp0) / (yp1 - yp0) + xp0

                // Finally check if it crosses to the left of our test point. You could equally
                // do right and it should give the same result.
                if cross < point.x {
                    isInsidePolygon.toggle()
                }
            }
        }

        return isInsidePolygon
    }
    
    var points: [MKMapPoint] {
        .init(unsafeMutablePointer: points(), count: pointCount)
    }
}
