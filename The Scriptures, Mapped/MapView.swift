//
//  MapView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI

struct MapView: View {
    var text: String
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.red).opacity(0.5)
            Text("Map")
        }
        .navigationTitle("Map")
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(text: "Default")
    }
}
