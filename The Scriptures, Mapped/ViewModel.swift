//
//  ViewModel.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 12/6/22.
//

import Foundation
import MapKit

class ViewModel: ObservableObject {
    @Published var displayedGeoplaces: [GeoPlace] = []
    
    var presentedViews: [String] = []
    
    var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35, longitude: 36),
        span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
    )
}
