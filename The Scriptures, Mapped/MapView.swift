//
//  MapView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var viewModel: ViewModel

//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 35, longitude: 36),
//        span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
//    )

    var body: some View {
        CustomMapView(
            coordinateRegion: $viewModel.region,
            annotationItems: viewModel.displayedGeoplaces
        )
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Map")
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
