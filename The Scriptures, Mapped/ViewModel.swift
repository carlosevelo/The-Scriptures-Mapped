//
//  ViewModel.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 12/6/22.
//

import SwiftUI
import MapKit

class ViewModel: ObservableObject, GeoPlaceCollector {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Published var focusedGeoPlaceId: Int?
    @Published var displayedGeoplaces: [GeoPlace] = []
    @Published var coordinateRegion = Map.defaultRegion
    
    @Published var presentedViews: [String] = []
    
    // MARK: - Init
    
    init() {
        ScriptureRenderer.shared.injectGeoPlaceCollector(self)
    }
    
    // MARK: - User Intents
    func clearMapView() {
        displayedGeoplaces = []
        coordinateRegion = Map.defaultRegion
        //lastGeocodedPlaces = []
        //focusedGeoPlaceId = nil
    }
    func focusOnGeoPlace(geoPlaceId: Int) {
        focusedGeoPlaceId = geoPlaceId
        if let geoPlace = GeoDatabase.shared.geoPlaceForId(geoPlaceId) {
            let latLonDelta = (geoPlace.viewAltitude ?? 5000) / 50000
            
            coordinateRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: geoPlace.latitude,
                    longitude: geoPlace.longitude),
                span: MKCoordinateSpan(
                    latitudeDelta: latLonDelta,
                    longitudeDelta: latLonDelta))
        }
        
    }
    func resetMapView() {
        self.coordinateRegion = self.coordinateRegionForGeoPlaces
    }
    
    // MARK: - Computed Properties
    
    private var coordinateRegionForGeoPlaces: MKCoordinateRegion {
        if displayedGeoplaces.isEmpty {
            coordinateRegion = Map.defaultRegion
        }
        
        var maxLat: Double = -90
        var minLat: Double = 90
        var maxLong: Double = -180
        var minLong: Double = 180
        
        for geoPlace in displayedGeoplaces {
            if geoPlace.latitude > maxLat {
                maxLat = geoPlace.latitude
            }
            if geoPlace.latitude < minLat {
                minLat = geoPlace.latitude
            }
            if geoPlace.longitude > maxLong {
                maxLong = geoPlace.longitude
            }
            if geoPlace.longitude < minLong {
                minLong = geoPlace.longitude
            }
        }
        
        let center = CLLocationCoordinate2D(
            latitude: minLat + abs(maxLat - minLat) / 2,
            longitude: minLong + abs(maxLong - minLong) / 2)
        
        let span = MKCoordinateSpan(
            latitudeDelta: displayedGeoplaces.count > 1 ? abs(maxLat - minLat) * 1.2 : maxLat * 0.02,
            longitudeDelta: displayedGeoplaces.count > 1 ? abs(maxLong - minLong) * 1.2 : maxLong * 0.02)
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    // MARK: - GeoPlaceCollector
    
    private var lastGeocodedPlaces: [GeoPlace] = []
    func setGeocodedPlaces(_ places: [GeoPlace]?) {
        var singlePlaces: [GeoPlace] = []
        places?.forEach({ place in
            if !singlePlaces.contains(where: {$0.placename == place.placename}) {
                singlePlaces.append(place)
            }
        })
        
        if singlePlaces.isEmpty && lastGeocodedPlaces.isEmpty {
            return
        }
        
        if singlePlaces == lastGeocodedPlaces {
            return
        } else {
            lastGeocodedPlaces = singlePlaces
        }
        
        DispatchQueue.main.async {
            self.displayedGeoplaces = self.lastGeocodedPlaces
            self.coordinateRegion = self.coordinateRegionForGeoPlaces
        }
    }
    
    // MARK: - Constants
    
    private struct Map {
        static let defaultRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 31.7683,
                longitude: 35.2137),
            span: MKCoordinateSpan(
                latitudeDelta: 3,
                longitudeDelta: 3))
    }
}
