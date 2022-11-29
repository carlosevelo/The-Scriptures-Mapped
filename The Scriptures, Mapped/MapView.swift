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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text(text)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(text: "Default")
    }
}
