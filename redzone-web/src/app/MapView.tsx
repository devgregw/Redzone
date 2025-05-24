'use client'

import { FeatureVisibility, Map } from "mapkit-react";

export default function MapView() {
    return (
        <Map
            isRotationEnabled
            isScrollEnabled
            isZoomEnabled
            showsUserLocation
            tracksUserLocation
            showsUserLocationControl
            showsMapTypeControl
            showsZoomControl
            showsCompass={FeatureVisibility.Adaptive}
            showsScale={FeatureVisibility.Adaptive}
            showsPointsOfInterest
            token={process.env.NEXT_PUBLIC_MAPKIT_TOKEN!}
        >
            
        </Map>
    )
}
