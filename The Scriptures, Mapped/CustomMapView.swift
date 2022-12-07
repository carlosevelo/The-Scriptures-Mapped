//
//  CustomMapView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 12/6/22.
//

import SwiftUI
import MapKit

// The structure of CustomMapView is similar to WebView.  We have a
// UIViewRepresentable that also uses a coordinator class to help with
// things like handling annotations.  See CustomAnnotationView for how
// we define a view in UIKit that has a pin image and a label.
//
struct CustomMapView: UIViewRepresentable {
    var coordinateRegion: Binding<MKCoordinateRegion>
    var annotationItems: [GeoPlace]
    
    private let coordinator = Coordinator()
    
    func makeCoordinator() -> Coordinator {
        coordinator
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        // Configure the map for the settings we want
        mapView.mapType = .hybridFlyover
        mapView.showsScale = true
        mapView.showsCompass = true
        
        // Use our coordinator as the map delegate
        mapView.delegate = coordinator
        
        // This tells the MKMapView what type of view to build for its annotations
        mapView.register(CustomAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: Constant.pinIdentifier)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let mapView = uiView

        // The wrapped value of a binding is the value that is bound
        // (a CLLocationCoordinate2D in our case here)
        mapView.setRegion(coordinateRegion.wrappedValue, animated: true)

        // The algorithm for updating annotations is:
        //
        // 1. Remove any annotations that aren't in the list anymore.
        // 2. Add any annotations that aren't already in the list.
        //
        // Because individual annotations can't change, we don't need to
        // worry about updating properties of existing annotations.

        // 1. Remove
        mapView.removeAnnotations(extraAnnotations(for: mapView))

        // 2. Add
        for geoplace in newAnnotations(for: mapView) {
            let annotation = MKPointAnnotation()

            annotation.coordinate = CLLocationCoordinate2DMake(geoplace.latitude,
                                                               geoplace.longitude)
            annotation.title = geoplace.placename
            annotation.subtitle = "\(geoplace.latitude), \(geoplace.longitude)"

            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - Private helpers

    // Given a map annotation view (MKAnnotationView), find the corresponding GeoPlace
    // in our array of annotations.  Because we don't have ID's, we can use the subtitle
    // which consists of "latitude, longitude".  These strings will be unique within a
    // chapter, so we're safe using this as an ID.  You may recognize this pattern as
    // similar to what we did with cards in our concentration game.
    private func annotationItem(for annotationView: MKAnnotationView) -> GeoPlace? {
        if let subtitle = annotationView.annotation?.subtitle, let geoPlace = annotationItems.first(where: {
            "\($0.latitude), \($0.longitude)" == subtitle
        }) {
            return geoPlace
        }

        return nil
    }

    // Find the annotations on the map that aren't in our array.
    private func extraAnnotations(for mapView: MKMapView) -> [MKAnnotation] {
        var annotations = [MKAnnotation]()

        mapView.annotations.forEach { annotation in
            if !annotationItems.contains(where: { "\($0.latitude), \($0.longitude)" == annotation.subtitle }) {
                annotations.append(annotation)
            }
        }

        return annotations
    }
    
    // Find the annotations in our array that aren't on the map.
    private func newAnnotations(for mapView: MKMapView) -> [GeoPlace] {
        var annotations = [GeoPlace]()

        annotationItems.forEach { geoPlace in
            if !mapView.annotations.contains(where: { $0.subtitle == "\(geoPlace.latitude), \(geoPlace.longitude)" }) {
                annotations.append(geoPlace)
            }
        }

        return annotations
    }

    // MARK: - Coordinator for map view delegate

    class Coordinator: NSObject, MKMapViewDelegate {
        var updateCoordinateRegion: ((MKCoordinateRegion) -> Void)? = nil

        // Because UIKit views are heavyweight, it's helpful to reuse annotation views when
        // possible.  So rather than making a new annotation view, we see if we can reuse one.
        // If there isn't an unused view in the queue, UIKit will create a new one automatically.
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constant.pinIdentifier,
                                                             for: annotation)

            view.canShowCallout = false

            return view
        }
    }
    
    private struct Constant {
        // MKMapView can have many different types of annotation.  An identifier is used
        // to indicate which kind of annotation we're working with at any time.  In our
        // case, we use a single annotation type, identified as "pin".
        static let pinIdentifier = "pin"
    }
}

struct CustomMapView_Previews: PreviewProvider {
    static var previews: some View {
        CustomMapView(
            coordinateRegion: .constant(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 35, longitude: -110),
                    span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                )
            ),
            annotationItems: [
                GeoDatabase.shared.geoPlaceForId(66)!,
                GeoDatabase.shared.geoPlaceForId(166)!,
                GeoDatabase.shared.geoPlaceForId(266)!,
                GeoDatabase.shared.geoPlaceForId(366)!,
                GeoDatabase.shared.geoPlaceForId(1266)!
            ]
        ).edgesIgnoringSafeArea(.all)
    }
}
