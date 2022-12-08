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

    var body: some View {
        CustomMapView(
            coordinateRegion: $viewModel.coordinateRegion,
            annotationItems: viewModel.displayedGeoplaces
        )
        .edgesIgnoringSafeArea([.horizontal, .bottom, .top])
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.mapViewTitle)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(ViewModel())
    }
}
