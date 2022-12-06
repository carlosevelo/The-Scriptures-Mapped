//
//  VolumeBooksView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI

struct VolumeBooksView: View {
    var volumeId: Int
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.green).opacity(0.5)
        }
        .navigationTitle("Old Testament")
//        List {
//            NavigationLink(GeoDatabase.shared.volumes()[volumeId - 1]) {
//                ChaptersView(volumeId: volumeId)
//            }
//            NavigationLink("Show Chapter") {
//                WebView(request: WebViewLoadRequest.htmlText(html: "<b>Hello</b> World"))
//            }
//        }
//        .navigationTitle(GeoDatabase.shared.volumes()[volumeId - 1])
//        .toolbar {
//            ToolbarItem {
//                NavigationLink {
//                    MapView(text: "From the NavBar")
//                } label: {
//                    Image(systemName: "map.circle")
//                }
//            }
//        }
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitView {
            VolumeBooksView(volumeId: 1)
        } detail: {
            MapView(text: "Default")
        }
        
    }
}
