//
//  BooksView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI

struct BooksView: View {
    var volumeId: Int
    
    var body: some View {
        List {
            Text("Genesis")
            NavigationLink("Show Map") {
                MapView(text: "From BooksView")
            }
        }
        .navigationTitle(GeoDatabase.shared.volumes()[volumeId - 1])
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    MapView(text: "From the NavBar")
                } label: {
                    Image(systemName: "map.circle")
                }
            }
        }
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitView {
            BooksView(volumeId: 1)
        } detail: {
            MapView(text: "Default")
        }
        
    }
}
