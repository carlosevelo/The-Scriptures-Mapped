//
//  ViewModel.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 12/6/22.
//

import Foundation
import MapKit

class ViewModel: ObservableObject {
    @Published var displayedGeoplaces: [GeoPlace] = [
        GeoDatabase.shared.geoPlaceForId(66)!,
        GeoDatabase.shared.geoPlaceForId(166)!,
        GeoDatabase.shared.geoPlaceForId(266)!,
        GeoDatabase.shared.geoPlaceForId(366)!,
        GeoDatabase.shared.geoPlaceForId(1266)!
    ]
    
    var presentedViews: [String] = []
    
    var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35, longitude: 36),
        span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
    )
}
